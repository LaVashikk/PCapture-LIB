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

const JumpPercent = 0.25
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
    eqVecFunc = math.vector.isEqually2;

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
    }

    /*
     * Gets the hit position of the trace. 
     *
     * @returns {Vector} - The hit position. 
    */
    function GetHitpos() {
        return this.hitpos
    }

    /* 
     * Gets the entity hit by the trace. 
     *
     * @returns {CBaseEntity|null} - The hit entity, or null if no entity was hit.
    */
    function GetEntity() {
        return this.hitent
    }

    /* 
     * Performs a precise trace line analysis. 
     *
     * This method subdivides the trace into smaller segments and checks for entity collisions along the way, 
     * considering entity priorities and ignore settings.
     * 
     * @param {Vector} startPos - The start position of the trace.
     * @param {Vector} endPos - The end position of the trace.
     * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. 
     * @param {string|null} note - An optional note associated with the trace. 
     * @returns {array} - An array containing the hit position and the hit entity (or null). 
    */
    function Trace(startPos, endPos, ignoreEntities, note) array(hitPos, hitEnt) 
    /* 
     * Checks if an entity is a priority entity based on the trace settings.
     *
     * @param {string} entityClass - The classname of the entity. 
     * @returns {boolean} - True if the entity is a priority entity, false otherwise. 
    */
    function _isPriorityEntity() bool
    /* 
     * Checks if an entity should be ignored based on the trace settings. 
     *
     * @param {string} entityClass - The classname of the entity. 
     * @returns {boolean} - True if the entity should be ignored, false otherwise. 
    */
    function _isIgnoredEntity() bool
    /* 
     * Checks if the trace should consider a hit with the given entity.
     * 
     * @param {CBaseEntity} ent - The entity to check.
     * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. 
     * @param {string|null} note - An optional note associated with the trace. 
     * @returns {boolean} - True if the trace should consider the hit, false otherwise. 
    */
    function shouldHitEntity() bool
}

/*
 * Performs a precise trace line analysis. 
 *
 * This method subdivides the trace into smaller segments and checks for entity collisions along the way, 
 * considering entity priorities and ignore settings.
 * 
 * @param {Vector} startPos - The start position of the trace.
 * @param {Vector} endPos - The end position of the trace.
 * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. 
 * @param {string|null} note - An optional note associated with the trace. 
 * @returns {array} - An array containing the hit position and the hit entity (or null). 
*/
function TraceLineAnalyzer::Trace(startPos, endPos, ignoreEntities, note = null) {
    // Preventing VScript errors and ensuring correct results even with a broken TraceLine
    if(macros.PointInBounds(startPos) == false) return [startPos, null]
    
    // Get the hit position from the fast trace
    local hitPos = startPos + (endPos - startPos) * TraceLine(startPos, endPos, null)
    local dist = hitPos - startPos
    local entBuffer = List()

    local halfSegment = dist * JumpPercent * 0.5
    local segmentsLenght = halfSegment * 2
    local searchRadius = halfSegment.Length()
    local searchSteps = searchRadius / this.settings.depthAccuracy
   
    for(local segment = 0; segment < 1; segment += JumpPercent) {

        //* "DIRTY" Search
        local segmentCenter = startPos + dist * (segment + JumpPercent * 0.5)
        // dev.drawbox(segmentCenter, Vector(255,0,0), 6)
        for (local ent; ent = Entities.FindByClassnameWithin(ent, "*", segmentCenter, searchRadius);) {
            if (!ent || !this.shouldHitEntity(ent, ignoreEntities, note)) continue

            local idx = ent.entindex()
            local BEnt = null
            // small cache system
            if(idx in EntBufferTable && EntBufferTable[idx].IsValid() && this.eqVecFunc(EntBufferTable[idx].origin, ent.GetOrigin())) {
                BEnt = EntBufferTable[idx]
            }
            else {
                BEnt = BufferedEntity(ent)
                EntBufferTable[idx] <- BEnt
            }

            // This handles the specific case where the trace starts *inside* an entity's bounding box.
            // It's crucial for allowing traces to originate from within large volumes (e.g., a trigger_multiple)
            // without immediately hitting that volume itself. The entity is flagged and will be ignored
            // for the entire duration of this trace, allowing the ray to 'escape' and hit what's next.
            if(segment==0 && macros.PointInBBox(startPos, BEnt.bboxMin, BEnt.bboxMax)) {
                BEnt.skipEntity = true
                continue
            }

            if(BEnt.skipEntity) {
                continue
            }
            
            if(BEnt.ignoreChecksCalc || RayAabbIntersect(startPos, endPos, BEnt.bboxMin, BEnt.bboxMax)) 
                entBuffer.append(BEnt)
            else BEnt.ignoreChecksCalc = true

        }

        // The "dirty search" didn't turn up anything? Check the next segment
        if(entBuffer.len() == 0) continue
        
        //* Deep Search
        local segmentStart = segmentCenter - halfSegment
        for (local i = 0.0; i <= searchSteps; i++) {
            local rayPart = segmentStart + segmentsLenght * (i / searchSteps)
            
            foreach(ent in entBuffer) {
                if(macros.PointInBBox(rayPart, ent.bboxMin, ent.bboxMax)) {
                    if(this.settings.bynaryRefinement) 
                        return [BinaryRefinementSearch(rayPart - halfSegment * 0.5, rayPart + halfSegment * 0.5, ent.bboxMin, ent.bboxMax), ent.entity]
                    return [rayPart, ent.entity] // VSquirrel doesn't support tuples, so i use arrays
                }
            }

        }
        

        // Cleanup buffer
        entBuffer.clear()
    }

    // Is entiti not found? Returning hitpos
    return [hitPos, null]
}

function RayAabbIntersect(start, end, min, max) {
    local dir = end - start;

    local tEnter = -999999.0;
    local tExit = 999999.0;

    foreach(axis in ["x", "y", "z"]) {
        local startVal = start[axis];
        local minVal = min[axis];
        local maxVal = max[axis];
        local dirVal = dir[axis];

        if (fabs(dirVal) < 0.000001) {
            if (startVal < minVal || startVal > maxVal) {
                return false;
            }
        } else {
            local tMin = (minVal - startVal) / dirVal;
            local tMax = (maxVal - startVal) / dirVal;

            if (tMin > tMax) {
                local temp = tMin;
                tMin = tMax;
                tMax = temp;
            }

            if (tMin > tEnter)
                tEnter = tMin;
            
            if (tMax < tExit)
                tExit = tMax;

            if (tEnter > tExit)
                return false;
        }
    }

    return tExit >= 0.0 && tEnter <= 1.0;
}


function BinaryRefinementSearch(rayStart, rayEnd, bMin, bMax) {
    // Binary search between rayStart and rayEnd
    local closestHitPoint = null
    local left = 0.0
    local right = 1.0

    for(local i = 0; i < 10; i++) {
        local middle = (left + right) / 2.0
        local currentPoint = rayStart + (rayEnd - rayStart) * middle

        if(macros.PointInBBox(currentPoint, bMin, bMax)) {
            // If a point is inside bbox, we store it as a potential hit point
            closestHitPoint = currentPoint
            // Keep searching closer to the beginning (left half of the segment)
            right = middle
        } 
        // If the point is outside bbox, continue searching near the end (right half of the segment)
        else left = middle
        
    }

    return closestHitPoint
}

/*
* Check if entity should be ignored.
*
* @param {Entity} ent - Entity to check.
* @param {Entity|array} ignoreEntities - Entities being ignored. 
* @returns {boolean} True if should ignore.
*/
function TraceLineAnalyzer::shouldHitEntity(ent, ignoreEntities, note) { 
    if(ent in TracePlusIgnoreEnts && TracePlusIgnoreEnts[ent])
        return false
    
    if(settings.ApplyIgnoreFilter(ent, note))
        return false

    if(settings.ApplyCollisionFilter(ent, note))
        return true

    if(ignoreEntities) {
        // Processing for arrays
        local type = typeof ignoreEntities 
        if (type == "array" || type == "ArrayEx") {
            foreach (mask in ignoreEntities) {
                if(ent.entindex() == mask.entindex()) return false 
            }
        } 
        else if(type == "List") {
            foreach (mask in ignoreEntities.iter()) {
                if(ent.entindex() == mask.entindex()) return false 
            }
        }
        // (ignoreEntities instanceof CBaseEntity || type == "pcapEntity") 
        else if(ent.entindex() == ignoreEntities.entindex()) return false
    }

    local classname = ent.GetClassname()
    if (_isIgnoredEntity(classname) && !_isPriorityEntity(classname)) {
        return false
    }
    
    if(_isIgnoredModels(ent.GetModelName())) {
        return false
    }

    return true
}

/*
* Check if entity is a priority class.
*
* @param {string} entityClass - Entity class name.
* @returns {boolean} True if priority.
*/
function TraceLineAnalyzer::_isPriorityEntity(entityClass) {
    if(settings.GetPriorityClasses().len() == 0) 
        return false
    return settings.GetPriorityClasses().search(function(val):(entityClass) {
        return entityClass.find(val) >= 0
    }) != null
}

/* 
* Check if entity is an ignored class.
*
* @param {string} entityClass - Entity class name.
* @returns {boolean} True if ignored.
*/
function TraceLineAnalyzer::_isIgnoredEntity(entityClass) {
    if(settings.GetIgnoreClasses().len() == 0) 
        return false
    if(settings.GetIgnoreClasses().contains("*"))
        return true
    return settings.GetIgnoreClasses().search(function(val):(entityClass) {
        return entityClass.find(val) >= 0
    }) != null
}

/* 
* Check if the entity model is in the list of ignored models.
*
* @param {string} entityModel - The model name of the entity.
* @returns {boolean} True if the model is ignored, false otherwise. 
*/
function TraceLineAnalyzer::_isIgnoredModels(entityModel) {
    if(settings.GetIgnoredModels().len() == 0 || entityModel == "") 
        return false
    return settings.GetIgnoredModels().search(function(val):(entityModel) {
        return entityModel.find(val) >= 0
    }) != null
}