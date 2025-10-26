// Expensive/Precise TraceLine logic

// Class for storing object data, for optimization purposes
class BufferedEntity {
    entity = null;
    origin = null;
    bboxMax = null;
    bboxMin = null;
    ignoreChecksCalc = false;
    skipEntity = false;

    constructor(entity) {
        this.entity = entLib.FromEntity(entity)
        this.origin = entity.GetOrigin()
        
        // This is needed for optimization with avoiding a lot of quaternion rotations
        if(this.entity.IsSquareBbox()) { // bbox square
            this.bboxMax = entity.GetBoundingMaxs() + origin
            this.bboxMin = entity.GetBoundingMins() + origin
        }
        else { // bbox rectangular
            this.bboxMax = this.entity.CreateAABB(7) + origin
            this.bboxMin = this.entity.CreateAABB(0) + origin
        }
    }
    function IsValid() return this.entity.IsValid()
    function _tostring() return this.entity.tostring()
}

::EntBufferTable <- {} // To avoid repeated operations on objects that do not change their position.

/*
 * A class for performing precise trace line analysis. 
 * 
 * This class provides methods for tracing lines with more precision and considering entity priorities and ignore settings. 
*/
::TraceLineAnalyzer <- class {
    settings = null;
    hitpos = null;
    hitent = null;
    hitnormal = null;
    eqVecFunc = math.vector.IsEqual;

    /*
     * Constructor for TraceLineAnalyzer.
     *
     * @param {Vector} startpos - The start position of the trace.
     * @param {Vector} endpos - The end position of the trace.
     * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. 
     * @param {TraceSettings} settings - The settings to use for the trace. 
     * @param {string|null} note - An optional note associated with the trace. 
    */ 
    constructor(startpos, endpos, ignoreEntities, settings, note) {
        if(typeof settings != "TraceSettings") throw("Invalid trace settings provided. Expected an instance of TracePlus.Settings")
        this.settings = settings
        
        local result = this.Trace(startpos, endpos, ignoreEntities, note)
        this.hitpos = result[0]
        this.hitent = result[1]
        this.hitnormal = result[2]
    }

    /*
     * Gets the hit position of the trace. 
     *
     * @returns {Vector} - The hit position. 
    */
    function GetHitPos() { return this.hitpos }

    /* 
     * Gets the entity hit by the trace. 
     *
     * @returns {CBaseEntity|null} - The hit entity, or null if no entity was hit.
    */
    function GetEntity() { return this.hitent }

    /*
     * This returns a simplified normal for AABB (axis-aligned only).
     * For accurate normals on rotated entities, use CalculateImpactNormalFromBbox.
    */
    function GetCheapNormal() { return this.hitnormal }

    function Trace(startPos, endPos, ignoreEntities, note) array(hitPos, hitEnt, hitNormal) 
    
    function _isPriorityEntity() bool
    
    function _isIgnoredEntity() bool

    function shouldHitEntity() bool
}

/*
 * Performs a precise trace line analysis using analytical ray-AABB intersection. 
 *
 * This method subdivides the trace into segments and uses the slab method to find
 * exact intersection points with entity bounding boxes.
 * 
 * @param {Vector} startPos - The start position of the trace.
 * @param {Vector} endPos - The end position of the trace.
 * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. 
 * @param {string|null} note - An optional note associated with the trace. 
 * @returns {array} - An array containing [hitPos, hitEntity, hitNormal]. 
*/
function TraceLineAnalyzer::Trace(startPos, endPos, ignoreEntities, note = null) {
    // Preventing VScript errors and ensuring correct results even with a broken TraceLine
    if(macros.PointInBounds(startPos) == false) return [startPos, null, null]

    // Get the hit position from the fast trace
    local hitPos = startPos + (endPos - startPos) * TraceLine(startPos, endPos, null)
    local dist = hitPos - startPos

    const JumpPercent = 0.25
    local halfSegment = dist * JumpPercent * 0.5
    local searchRadius = halfSegment.Length()
    local entBuffer = List()

    for(local segment = 0.0; segment < 1.0; segment += JumpPercent) {
        //* "DIRTY" Search - collect candidate entities near the current segment
        local segmentCenter = startPos + dist * (segment + JumpPercent * 0.5)
        local segmentStart = segmentCenter - halfSegment
        local segmentEnd = segmentCenter + halfSegment

        for(local ent; ent = Entities.FindByClassnameWithin(ent, "*", segmentCenter, searchRadius);) {
            if(!ent || !this.shouldHitEntity(ent, ignoreEntities, note)) continue

            local idx = ent.entindex()
            local BEnt = null
            // Small cache system to avoid repeated bbox calculations
            if(idx in EntBufferTable && EntBufferTable[idx].IsValid() && this.eqVecFunc(EntBufferTable[idx].origin, ent.GetOrigin())) {
                BEnt = EntBufferTable[idx]
            } else {
                BEnt = BufferedEntity(ent)
                EntBufferTable[idx] <- BEnt
            }

            // This handles the specific case where the trace starts *inside* an entity's bounding box.
            // It's crucial for allowing traces to originate from within large volumes (e.g., a trigger_multiple)
            // without immediately hitting that volume itself. The entity is flagged and will be ignored
            // for the entire duration of this trace, allowing the ray to 'escape' and hit what's next.
            if(segment == 0.0 && macros.PointInBBox(startPos, BEnt.bboxMin, BEnt.bboxMax)) {
                BEnt.skipEntity = true
                continue
            }
            if(BEnt.skipEntity) continue

            // Quick broad-phase check: does ray potentially intersect this AABB?
            if(BEnt.ignoreChecksCalc || RayAabbHit(segmentStart, segmentEnd, BEnt.bboxMin, BEnt.bboxMax)[0]) {
                entBuffer.append(BEnt)
            } else {
                BEnt.ignoreChecksCalc = true
            }
        }

        // The "dirty search" didn't turn up anything? Check the next segment
        if(entBuffer.len() == 0) continue

        //* Analytic narrow-phase: compute exact hit using slab method
        local bestT = 999999999.9
        local bestEnt = null
        local bestNormal = null

        foreach (BEnt in entBuffer.iter()) {
            // Get precise intersection data: [hit, t_enter, t_exit, normal]
            local res = RayAabbHit(segmentStart, segmentEnd, BEnt.bboxMin, BEnt.bboxMax)
            if(!res[0]) continue

            // Clamp t_enter to valid range [0, 1]
            local tEnter = res[1] // todo!
            if(tEnter < 0.0) tEnter = 0.0
            if(tEnter > 1.0) tEnter = 1.0

            // Keep track of the closest hit
            if(tEnter < bestT) {
                bestT = tEnter
                bestEnt = BEnt
                bestNormal = res[3]
            }
        }

        // If we found a hit in this segment, return immediately
        if(bestEnt != null) {
            local hitPoint = segmentStart + (segmentEnd - segmentStart) * bestT

            // Optional: refine the hit point using binary search for extra precision
            if(this.settings.bynaryRefinement) {
                local refined = RefineAroundT(segmentStart, segmentEnd, bestEnt.bboxMin, bestEnt.bboxMax, bestT)
                if(refined != null) hitPoint = refined
            }
            return [hitPoint, bestEnt.entity, bestNormal]
        }
        
        // Cleanup buffer for next segment
        entBuffer.clear()
    }

    // No entity was hit; return world hit position
    return [hitPos, null, null]
}

/*
 * Analytical AABB intersection using the "slab" method.
 * 
 * This function treats an AABB as the intersection of three slabs (pairs of parallel planes)
 * and computes where a ray enters and exits this intersection.
 * 
 * @param {Vector} start - The start point of the ray segment.
 * @param {Vector} end - The end point of the ray segment. 
 * @param {Vector} bmin - The minimum corner of the AABB.
 * @param {Vector} bmax - The maximum corner of the AABB.
 * @returns {array} - [hit:boolean, t_enter:float, t_exit:float, normal:Vector|null]
 *                    where t values are in range [0,1] along the ray segment.
*/
function RayAabbHit(start, end, bmin, bmax) {
    local dir = end - start;
    const EPS = 0.000001;

    // Track the furthest entry point and nearest exit point across all slabs
    local tEnter = 0.0;
    local tExit  = 1.0;
    local nAxis = -1;  // Which axis the entry plane belongs to
    local nSign = 0.0; // Direction of the normal (+1 or -1)

    // Check intersection with each slab (X, Y, Z)
    foreach (axisIdx, axisName in ["x", "y", "z"]) {
        local s = start[axisName], d = dir[axisName], mn = bmin[axisName], mx = bmax[axisName];

        // Ray is parallel to slab - check if it's inside
        if(fabs(d) < EPS) {
            if(s < mn || s > mx) return [false, 0.0, 0.0, null];
            continue;
        }

        // Calculate intersection t values with the two planes of this slab
        local t1 = (mn - s) / d, t2 = (mx - s) / d;
        local enter = t1, exit = t2, enterIsMinPlane = true;
        if(t1 > t2) { 
            enter = t2; 
            exit = t1; 
            enterIsMinPlane = false; 
        }

        // Update the overall entry/exit interval
        if(enter > tEnter) {
            tEnter = enter;
            nAxis = axisIdx;
            nSign = enterIsMinPlane ? -1.0 : 1.0;
        }
        if(exit < tExit) tExit = exit;
        
        // Early exit: ray misses the AABB
        if(tEnter > tExit) return [false, 0.0, 0.0, null];
    }

    // Check if intersection is within valid range
    if(tExit < 0.0 || tEnter > 1.0) return [false, 0.0, 0.0, null];

    // Construct the normal vector (axis-aligned for AABB)
    local n = Vector(0, 0, 0);
    if(nAxis == 0)      n.x = nSign;
    else if(nAxis == 1) n.y = nSign;
    else if(nAxis == 2) n.z = nSign;

    return [true, tEnter, tExit, n];
}

/*
 * Refines the hit point around the analytically computed t_enter value.
 * This creates a small window around t_enter and uses binary search for extra precision.
 * 
 * @param {Vector} rayStart - The start of the ray segment.
 * @param {Vector} rayEnd - The end of the ray segment.
 * @param {Vector} bMin - The minimum corner of the AABB.
 * @param {Vector} bMax - The maximum corner of the AABB.
 * @param {float} tEnter - The analytically computed entry point (0-1).
 * @param {float} window - The search window size around tEnter (default 0.05).
 * @returns {Vector|null} - The refined hit point, or null if refinement fails.
*/
function RefineAroundT(rayStart, rayEnd, bMin, bMax, tEnter, window = 0.05) {
    local dir = rayEnd - rayStart;
    local leftT  = tEnter - window; if(leftT < 0.0) leftT = 0.0;
    local rightT = tEnter + window; if(rightT > 1.0) rightT = 1.0;
    return BinaryRefinementSearch(rayStart + dir * leftT, rayEnd + dir * rightT, bMin, bMax);
}

/*
 * Performs binary search to find the exact point where ray enters the AABB.
 * Used for extra precision when needed.
 * 
 * @param {Vector} rayStart - The start of the search segment.
 * @param {Vector} rayEnd - The end of the search segment.
 * @param {Vector} bMin - The minimum corner of the AABB.
 * @param {Vector} bMax - The maximum corner of the AABB.
 * @returns {Vector|null} - The refined hit point, or null if no hit found.
*/
function BinaryRefinementSearch(rayStart, rayEnd, bMin, bMax) {
    // Binary search between rayStart and rayEnd
    local closestHitPoint = null
    local left = 0.0
    local right = 1.0

    for(local i = 0; i < 10; i++) {
        local middle = (left + right) / 2.0
        local currentPoint = rayStart + (rayEnd - rayStart) * middle
        
        if(macros.PointInBBox(currentPoint, bMin, bMax)) {
            // If point is inside bbox, store it as potential hit point
            closestHitPoint = currentPoint
            // Keep searching closer to the beginning (left half of the segment)
            right = middle
        } 
        else {
            // If point is outside bbox, search in the right half
            left = middle
        }
    }
    return closestHitPoint
}

/*
 * Check if entity should be considered for hit detection.
 *
 * @param {CBaseEntity} ent - Entity to check.
 * @param {CBaseEntity|array} ignoreEntities - Entities to ignore. 
 * @param {string|null} note - Optional note for filter callbacks.
 * @returns {boolean} True if entity should be checked for hits.
*/
function TraceLineAnalyzer::shouldHitEntity(ent, ignoreEntities, note) { 
    if(ent in TracePlusIgnoreEnts && TracePlusIgnoreEnts[ent]) return false
    if(settings.ApplyIgnoreFilter(ent, note)) return false
    if(settings.ApplyCollisionFilter(ent, note)) return true

    if(ignoreEntities) {
        // Processing for arrays
        local type = typeof ignoreEntities 
        if(type == "array" || type == "ArrayEx") {
            foreach (mask in ignoreEntities) if(ent.entindex() == mask.entindex()) return false 
        } 
        else if(type == "List") {
            foreach (mask in ignoreEntities.iter()) if(ent.entindex() == mask.entindex()) return false
        }
        // Single entity check
        else if(ent.entindex() == ignoreEntities.entindex()) return false
    }

    local classname = ent.GetClassname()
    if(_isIgnoredEntity(classname) && !_isPriorityEntity(classname)) return false
    if(_isIgnoredModels(ent.GetModelName())) return false

    return true
}

/*
 * Check if entity class is in the priority list.
 *
 * @param {string} entityClass - Entity class name to check.
 * @returns {boolean} True if entity class is prioritized.
*/
function TraceLineAnalyzer::_isPriorityEntity(entityClass) {
    if(settings.GetPriorityClasses().len() == 0) return false
    return settings.GetPriorityClasses().search(function(v) : (entityClass) { 
        return entityClass.find(v) >= 0 
    }) != null
}

/* 
 * Check if entity class should be ignored.
 *
 * @param {string} entityClass - Entity class name to check.
 * @returns {boolean} True if entity class should be ignored.
*/
function TraceLineAnalyzer::_isIgnoredEntity(entityClass) {
    if(settings.GetIgnoreClasses().len() == 0) return false
    if(settings.GetIgnoreClasses().contains("*")) return true
    return settings.GetIgnoreClasses().search(function(v) : (entityClass) { 
        return entityClass.find(v) >= 0 
    }) != null
}

/* 
 * Check if entity model is in the ignored models list.
 *
 * @param {string} entityModel - The model name of the entity.
 * @returns {boolean} True if the model should be ignored.
*/
function TraceLineAnalyzer::_isIgnoredModels(entityModel) {
    if(settings.GetIgnoredModels().len() == 0 || entityModel == "") return false
    return settings.GetIgnoredModels().search(function(v) : (entityModel) { 
        return entityModel.find(v) >= 0 
    }) != null
}