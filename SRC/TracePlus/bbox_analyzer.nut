// Enhanced entity cache with aggressive caching
class BufferedEntity {
    // todo: if this well be global and bbox will be changed, stuff broke
    entity = null;
    origin = null;
    bboxMax = null;
    bboxMin = null;

    // Cached rounded origin
    roundedOriginX = null;
    roundedOriginY = null;
    roundedOriginZ = null;
    
    // Cached expensive C++ calls
    classname = null;
    modelname = null;
    entindex = null;
    
    // Optimization flags
    ignoreChecksCalc = false;
    skipEntity = false;
    
    // Cache for shouldHitEntity
    cachedShouldHit = null;
    cachedTraceId = null;  // ID of last trace
    // cachedSettingsId = null; // todo: maybe for future improvements

    constructor(entity) { 
        this.entity = entLib.FromEntity(entity)
        this.entindex = entity.entindex()  // Cache once!
        this.origin = entity.GetOrigin()
        this.classname = entity.GetClassname()  // Cache once!
        this.modelname = entity.GetModelName()  // Cache once!

        // round and CACHE!
        this.roundedOriginX = floor(this.origin.x * 1000.0 + 0.5)
        this.roundedOriginY = floor(this.origin.y * 1000.0 + 0.5)
        this.roundedOriginZ = floor(this.origin.z * 1000.0 + 0.5)

        // perhaps for future improvements
        // cachedSettingsId = id
        
        // This is needed for optimization with avoiding a lot of quaternion rotations
        if(this.entity.IsSquareBbox()) {
            this.bboxMax = entity.GetBoundingMaxs() + origin
            this.bboxMin = entity.GetBoundingMins() + origin
        }
        else {
            this.bboxMax = this.entity.CreateAABB(7) + origin
            this.bboxMin = this.entity.CreateAABB(0) + origin
        }
    }
    
    function _tostring() return this.entity.tostring()
}

::EntBufferTable <- {} // To avoid repeated operations on objects that do not change their position.
::_traceIdCounter <- 0 

/*
 * A class for performing precise trace line analysis. 
 * 
 * This class provides methods for tracing lines with more precision and considering entity priorities and ignore settings. 
*/
::BboxTraceAnalyzer <- class {
    settings = null;
    hitpos = null;
    hitent = null;
    hitnormal = null; // todo: this is cheap normal, but only for axis-box. How can i use it? no clue
    traceId = null;  

    /*
     * Constructor for BboxTraceAnalyzer.
     *
     * @param {Vector} startpos - The start position of the trace.
     * @param {Vector} endpos - The end position of the trace.
     * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. 
     * @param {TraceSettings} settings - The settings to use for the trace. 
    */ 
    constructor(startpos, endpos, ignoreEntities, settings) {
        if(typeof settings != "TraceSettings") throw("Invalid trace settings provided. Expected an instance of TracePlus.Settings")
        this.settings = settings
        this.traceId = _traceIdCounter++
        
        local result = this.Trace(startpos, endpos, ignoreEntities)
        this.hitpos = result[0]
        this.hitent = result[1]
        // this.hitnormal = result[2]
    }

    function Trace(startPos, endPos, ignoreEntities) array(hitPos, hitEnt, hitNormal) 
    function shouldHitEntityCached(BEnt, ignoreEntities) bool
    function _isPriorityEntity(classname) bool
    function _isIgnoredEntity(classname) bool
    function _isIgnoredModels(modelname) bool
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
 * @returns {array} - An array containing [hitPos, hitEntity, hitNormal]. 
*/
function BboxTraceAnalyzer::Trace(startPos, endPos, ignoreEntities) {
    // Preventing VScript errors and ensuring correct results even with a broken TraceLine
    if(macros.PointInBounds(startPos) == false) return [startPos, null, null]

    // Get the hit position from the fast trace
    local hitPos = startPos + (endPos - startPos) * TraceLine(startPos, endPos, null)
    local dist = hitPos - startPos

    const JumpPercent = 0.25
    const HalfJump = 0.125
    local halfSegment = dist * HalfJump
    local searchRadius = halfSegment.Length()
    
    // Use array instead of List for better performance [// todo: maybe create with some capacity, or use global one with shadowing indecies? \\]
    local entBuffer = [] 
    
    // Pre-compute for quick ignore checks
    local ignoreType = ignoreEntities ? typeof ignoreEntities : null
    local singleIgnoreIdx = null
    if(ignoreType && ignoreType != "array" && ignoreType != "ArrayEx" && ignoreType != "List") {
        // if(ignoreType == "instance" || ignoreType == "pcapEntity") { 
        try {
            singleIgnoreIdx = ignoreEntities.entindex()
        } catch(e) {}
    }

    // Pre-compute ignoreIdxSet for O(1) lookup
    local ignoreIdxSet = {}
    if(ignoreType == "array" || ignoreType == "ArrayEx") {
        foreach(mask in ignoreEntities) ignoreIdxSet[mask.entindex()] <- true
    } else if(ignoreType == "List") {
        foreach(mask in ignoreEntities.iter()) ignoreIdxSet[mask.entindex()] <- true
    }

    dev.debug("========================= TRACE START =========================")
    for(local segment = 0.0; segment < 1.0; segment += JumpPercent) {
        //* "DIRTY" Search - collect candidate entities near the current segment
        local segmentCenter = startPos + dist * (segment + HalfJump)
        local segmentStart = segmentCenter - halfSegment
        local segmentEnd = segmentCenter + halfSegment

        for(local ent; ent = Entities.FindByClassnameWithin(ent, "*", segmentCenter, searchRadius);) {
            local idx = ent.entindex()
            
            // == Avoid expensive shouldHitEntity == 
            // 1. Quick single-entity ignore check
            if(singleIgnoreIdx != null && idx == singleIgnoreIdx) continue
            // 2.Entity should 'Ignore Trace' check // todo change comment
            if((ent in TracePlusIgnoreEnts) && TracePlusIgnoreEnts[ent] == true) continue
            // 3. Ignore entities set check
            if(idx in ignoreIdxSet) continue

            local BEnt = null
            
            // Optimized cache check with inline Vector comparison :p
            if(idx in EntBufferTable) { 
                BEnt = EntBufferTable[idx]
                if(BEnt.entity.IsValid()) {
                    local cachedOrigin = BEnt.origin
                    local currentOrigin = ent.GetOrigin()
                    
                    // Inline rounded comparison
                    local rx = floor(currentOrigin.x * 1000.0 + 0.5)
                    local ry = floor(currentOrigin.y * 1000.0 + 0.5)
                    local rz = floor(currentOrigin.z * 1000.0 + 0.5)
                    if(BEnt.roundedOriginX == rx && 
                        BEnt.roundedOriginY == ry && 
                        BEnt.roundedOriginZ == rz) {
                        // Cache hit - entity hasn't moved
                    } else {
                        // Position changed - rebuild cache
                        BEnt = BufferedEntity(ent)
                        BEnt.cachedTraceId = this.traceId
                        EntBufferTable[idx] <- BEnt
                    }
                } else {
                    // Weird... Invalid/outdated entity with same id - let's rebuild
                    BEnt = BufferedEntity(ent)
                    BEnt.cachedTraceId = this.traceId
                    // BEnt.cachedSettingsId = this.settings.id
                    EntBufferTable[idx] <- BEnt
                }
            } else {
                // Not in cache - create new
                BEnt = BufferedEntity(ent)
                BEnt.cachedTraceId = this.traceId
                EntBufferTable[idx] <- BEnt
            }
            
            // Check shouldHitEntity, now with caching :}
            if(!this.shouldHitEntityCached(BEnt)) continue
            

            // This handles the specific case where the trace starts *inside* an entity's bounding box.
            if(segment == 0.0 && macros.PointInBBox(startPos, BEnt.bboxMin, BEnt.bboxMax)) {
                BEnt.skipEntity = true
                continue
            }
            if(BEnt.skipEntity) continue

            // Quick broad-phase check
            if(BEnt.ignoreChecksCalc || RayAabbIntersectFast(segmentStart, segmentEnd, BEnt.bboxMin, BEnt.bboxMax)) {
                dev.debug("Added {}", BEnt.entity) // DEBUG
                entBuffer.append(BEnt)
            } else {
                BEnt.ignoreChecksCalc = true
            }
        }

        // The "dirty search" didn't turn up anything? Check the next segment
        if(entBuffer.len() == 0) continue

        //* Analytic narrow-phase: compute exact hit using 'slab method'
        local bestT = 999999999.9
        local bestEnt = null
        local bestNormal = null

        foreach(BEnt in entBuffer) {
            // Get precise intersection data using optimized slab method [i actually unrolled loop, lol]
            local res = RayAabbHitOptimized(segmentStart, segmentEnd, BEnt.bboxMin, BEnt.bboxMax)
            if(!res[0]) continue

            local tEnter = res[1]
            // Clamp to valid range [0, 1]
            if(tEnter < 0.0) tEnter = 0.0
            else if(tEnter > 1.0) tEnter = 1.0

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

            // Optional: refine the hit point (only if needed and worth the cost)
            if(this.settings.bynaryRefinement && bestT > 0.01 && bestT < 0.99) {
                local refined = BinaryRefinementSearchFast(segmentStart, segmentEnd, bestEnt.bboxMin, bestEnt.bboxMax, bestT)
                if(refined != null) hitPoint = refined
            }
            
            return [hitPoint, bestEnt.entity, bestNormal]
        }
        
        // Clear buffer for next segment
        entBuffer.clear()
    }

    // No entity was hit; return world hit position
    return [hitPos, null, null]
}

/*
 * Optimized AABB intersection - unrolled loop, fewer operations.
 * 
 * @param {Vector} start - The start point of the ray segment.
 * @param {Vector} end - The end point of the ray segment. 
 * @param {Vector} bmin - The minimum corner of the AABB.
 * @param {Vector} bmax - The maximum corner of the AABB.
 * @returns {array} - [hit:boolean, t_enter:float, t_exit:float, normal:Vector|null]
*/
function RayAabbHitOptimized(start, end, bmin, bmax) {
    // Pre-compute direction once
    local dx = end.x - start.x
    local dy = end.y - start.y  
    local dz = end.z - start.z
    const EPS = 0.000001

    local tEnter = 0.0
    local tExit = 1.0
    local nAxis = -1
    local nSign = 0.0

    // Unrolled X axis
    local adx = fabs(dx)
    if(adx < EPS) {
        if(start.x < bmin.x || start.x > bmax.x) return [false, 0, 0, null]
    } else {
        local invDx = 1.0 / dx
        local t1 = (bmin.x - start.x) * invDx
        local t2 = (bmax.x - start.x) * invDx
        
        if(t1 > t2) {
            if(t2 > tEnter) { tEnter = t2; nAxis = 0; nSign = 1.0 }
            if(t1 < tExit) tExit = t1
        } else {
            if(t1 > tEnter) { tEnter = t1; nAxis = 0; nSign = -1.0 }
            if(t2 < tExit) tExit = t2
        }
        if(tEnter > tExit) return [false, 0, 0, null]
    }

    // Unrolled Y axis
    local ady = fabs(dy)
    if(ady < EPS) {
        if(start.y < bmin.y || start.y > bmax.y) return [false, 0, 0, null]
    } else {
        local invDy = 1.0 / dy
        local t1 = (bmin.y - start.y) * invDy
        local t2 = (bmax.y - start.y) * invDy
        
        if(t1 > t2) {
            if(t2 > tEnter) { tEnter = t2; nAxis = 1; nSign = 1.0 }
            if(t1 < tExit) tExit = t1
        } else {
            if(t1 > tEnter) { tEnter = t1; nAxis = 1; nSign = -1.0 }
            if(t2 < tExit) tExit = t2
        }
        if(tEnter > tExit) return [false, 0, 0, null]
    }

    // Unrolled Z axis
    local adz = fabs(dz)
    if(adz < EPS) {
        if(start.z < bmin.z || start.z > bmax.z) return [false, 0, 0, null]
    } else {
        local invDz = 1.0 / dz
        local t1 = (bmin.z - start.z) * invDz
        local t2 = (bmax.z - start.z) * invDz
        
        if(t1 > t2) {
            if(t2 > tEnter) { tEnter = t2; nAxis = 2; nSign = 1.0 }
            if(t1 < tExit) tExit = t1
        } else {
            if(t1 > tEnter) { tEnter = t1; nAxis = 2; nSign = -1.0 }
            if(t2 < tExit) tExit = t2
        }
        if(tEnter > tExit) return [false, 0, 0, null]
    }

    // Final range check
    if(tExit < 0.0 || tEnter > 1.0) return [false, 0, 0, null]

    // todo; Build cheap normal vector - only if we have a hit
    // local n = Vector(0, 0, 0) 
    // if(nAxis == 0) n.x = nSign
    // else if(nAxis == 1) n.y = nSign
    // else n.z = nSign

    return [true, tEnter, tExit, null]
}

/*
 * Fast AABB intersection check for broad phase (no normal calculation).
 * 
 * @param {Vector} start - Ray start point.
 * @param {Vector} end - Ray end point.
 * @param {Vector} bmin - AABB minimum.
 * @param {Vector} bmax - AABB maximum.
 * @returns {boolean} - True if intersection exists.
*/
function RayAabbIntersectFast(start, end, bmin, bmax) {
    local dx = end.x - start.x
    local dy = end.y - start.y
    local dz = end.z - start.z
    
    local tmin = 0.0
    local tmax = 1.0
    
    // X axis - optimized with early exit
    if(dx != 0.0) {
        local invDx = 1.0 / dx
        local t1 = (bmin.x - start.x) * invDx
        local t2 = (bmax.x - start.x) * invDx
        if(t1 > t2) { local tmp = t1; t1 = t2; t2 = tmp }
        if(t1 > tmin) tmin = t1
        if(t2 < tmax) tmax = t2
        if(tmin > tmax) return false
    } else if(start.x < bmin.x || start.x > bmax.x) return false
    
    // Y axis
    if(dy != 0.0) {
        local invDy = 1.0 / dy
        local t1 = (bmin.y - start.y) * invDy
        local t2 = (bmax.y - start.y) * invDy
        if(t1 > t2) { local tmp = t1; t1 = t2; t2 = tmp }
        if(t1 > tmin) tmin = t1
        if(t2 < tmax) tmax = t2
        if(tmin > tmax) return false
    } else if(start.y < bmin.y || start.y > bmax.y) return false
    
    // Z axis
    if(dz != 0.0) {
        local invDz = 1.0 / dz
        local t1 = (bmin.z - start.z) * invDz
        local t2 = (bmax.z - start.z) * invDz
        if(t1 > t2) { local tmp = t1; t1 = t2; t2 = tmp }
        if(t1 > tmin) tmin = t1
        if(t2 < tmax) tmax = t2
        if(tmin > tmax) return false
    } else if(start.z < bmin.z || start.z > bmax.z) return false
    
    return true
}

/*
 * Optimized binary refinement - fewer iterations, smarter window.
 * 
 * @param {Vector} rayStart - Ray segment start.
 * @param {Vector} rayEnd - Ray segment end.
 * @param {Vector} bMin - AABB minimum.
 * @param {Vector} bMax - AABB maximum.
 * @param {float} tEnter - Approximate entry point.
 * @returns {Vector|null} - Refined hit point or null.
*/
function BinaryRefinementSearchFast(rayStart, rayEnd, bMin, bMax, tEnter) {
    // Narrow window around tEnter
    local dir = rayEnd - rayStart
    local window = 0.03  // Smaller window = fewer checks
    local leftT = tEnter - window
    local rightT = tEnter + window
    if(leftT < 0.0) leftT = 0.0
    if(rightT > 1.0) rightT = 1.0
    
    local searchStart = rayStart + dir * leftT
    local searchEnd = rayStart + dir * rightT
    local searchDir = searchEnd - searchStart
    
    local closestHitPoint = null
    local left = 0.0
    local right = 1.0

    // Reduced iterations: 6 instead of 10 (good enough precision)
    for(local i = 0; i < 6; i++) {
        local middle = (left + right) * 0.5  // Avoid division
        local currentPoint = searchStart + searchDir * middle
        
        // Inline PointInBBox for speed
        if(currentPoint.x >= bMin.x && currentPoint.x <= bMax.x &&
           currentPoint.y >= bMin.y && currentPoint.y <= bMax.y &&
           currentPoint.z >= bMin.z && currentPoint.z <= bMax.z) {
            closestHitPoint = currentPoint
            right = middle
        } else {
            left = middle
        }
    }
    
    return closestHitPoint
}

/*
 * Cached version of shouldHitEntity to avoid redundant checks.
 * 
 * @param {BufferedEntity} BEnt - Buffered entity with cache.
 * @returns {boolean} - True if should check for hit.
*/
function BboxTraceAnalyzer::shouldHitEntityCached(BEnt) {
    // Try use cached result
    if(BEnt.cachedTraceId == this.traceId && BEnt.cachedShouldHit != null) {
        return BEnt.cachedShouldHit
    }
    
    local ent = BEnt.entity.CBaseEntity
    
    // Settings filters
    if(settings.ApplyIgnoreFilter(ent)) {
        dev.debug("- {} IgnoreFilter", ent)
        BEnt.cachedShouldHit = false
        return false
    }
    
    if(settings.ApplyCollisionFilter(ent)) {
        dev.debug("- {} CollisionFilter", ent)
        BEnt.cachedShouldHit = true
        return true
    }

    // Use cached classname and modelname (no C++ calls!)
    if(_isIgnoredEntity(BEnt.classname) && !_isPriorityEntity(BEnt.classname)) {
        dev.debug("- {} _isIgnoredEntity", ent)
        BEnt.cachedShouldHit = false
        return false
    }
    
    if(_isIgnoredModels(BEnt.modelname)) {
        dev.debug("- {} _isIgnoredModels", ent)
        BEnt.cachedShouldHit = false
        return false
    }

    dev.debug("- {} none of all, then should!", ent)
    BEnt.cachedShouldHit = true
    return true
}

/*
 * Check if entity class is in the priority list.
 *
 * @param {string} entityClass - Entity class name to check.
 * @returns {boolean} True if entity class is prioritized.
*/
function BboxTraceAnalyzer::_isPriorityEntity(entityClass) {
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
function BboxTraceAnalyzer::_isIgnoredEntity(entityClass) {
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
function BboxTraceAnalyzer::_isIgnoredModels(entityModel) {
    if(settings.GetIgnoredModels().len() == 0 || entityModel == "") return false
    return settings.GetIgnoredModels().search(function(v) : (entityModel) { 
        return entityModel.find(v) >= 0 
    }) != null
}