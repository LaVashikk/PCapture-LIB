/*
 * Calculates the normal vector of a triangle.
 * * @param {Vector} v1 - The first vertex. 
 * @param {Vector} v2 - The second vertex.
 * @param {Vector} v3 - The third vertex. 
 * @returns {Vector} - The normal vector of the triangle. 
*/
::_calculateNormal <- function(v1, v2, v3) {
    // Calculate two edge vectors of the triangle. 
    local edge1 = v2 - v1
    local edge2 = v3 - v1

    // Calculate the normal vector using the cross product of the edge vectors.
    local normal = edge1.Cross(edge2)
    normal.Norm()

    return normal 
}

// Fast coordinate system transformations
function _worldToLocal(entity, worldPoint, R) {
    local origin = entity.GetOrigin()
    return R.unrotateVector(worldPoint - origin)
}
function _localDirToWorld(localDir, R) {
    // For normal/direction: rotation only, no translation
    return R.rotateVector(localDir)
}


/* * Calculates the impact normal of a surface hit by a trace. 
 *
 * @param {Vector} startPos - The start position of the trace.
 * @param {Vector} hitPos - The hit position of the trace.
 * @returns {Vector} - The calculated impact normal vector. 
*/
::CalculateImpactNormal <- function(startPos, hitPos) {
    const offset = 5.0;
    local dir = hitPos - startPos; dir.Norm()

    // Ortho Basis
    local up = abs(dir.z) < 0.99 ? Vector(0,0,1) : Vector(0,1,0)
    local right = dir.Cross(up); right.Norm()
    local up2 = right.Cross(dir); up2.Norm()

    local newStart1 = startPos + right * offset
    local newStart2 = startPos + up2 * offset
    local endPos1   = newStart1 + dir * 8000
    local endPos2   = newStart2 + dir * 8000

    local fraction1 = TraceLine(newStart1, endPos1, null)
    local fraction2 = TraceLine(newStart2, endPos2, null)
    local point1    = newStart1 + (endPos1 - newStart1) * fraction1
    local point2    = newStart2 + (endPos2 - newStart2) * fraction2

    local normal = _calculateNormal(hitPos, point1, point2)
    if (normal.Dot(dir) > 0) normal = normal * -1.0
    return normal
}

::CalculateImpactNormalFromBbox <- function(startPos, hitPos, hitEntity) {
    // Construct rotation matrix
    local angles = hitEntity.GetAngles()
    local R = math.Matrix().fromEuler(angles)  // local -> world

    // Transform hit point to local space
    local localHit = _worldToLocal(hitEntity, hitPos, R)

    // Get local AABB bounds (engine always stores them in local space)
    local bmin = hitEntity.GetBoundingMins()
    local bmax = hitEntity.GetBoundingMaxs()

    // Find the nearest plane
    local distXmin = fabs(localHit.x - bmin.x)
    local distXmax = fabs(bmax.x - localHit.x)
    local distYmin = fabs(localHit.y - bmin.y)
    local distYmax = fabs(bmax.y - localHit.y)
    local distZmin = fabs(localHit.z - bmin.z)
    local distZmax = fabs(bmax.z - localHit.z)

    local axis = 0   // 0=X,1=Y,2=Z
    local sign = -1.0
    local best = distXmin

    if (distXmax < best) { best = distXmax; axis = 0; sign =  1.0 }
    if (distYmin < best) { best = distYmin; axis = 1; sign = -1.0 }
    if (distYmax < best) { best = distYmax; axis = 1; sign =  1.0 }
    if (distZmin < best) { best = distZmin; axis = 2; sign = -1.0 }
    if (distZmax < best) { best = distZmax; axis = 2; sign =  1.0 }

    // Local normal of that plane
    local nLocal = Vector(0,0,0)
    if (axis == 0) nLocal.x = sign
    else if (axis == 1) nLocal.y = sign
    else nLocal.z = sign

    // Rotate normal back to world space
    local nWorld = _localDirToWorld(nLocal, R)
    nWorld.Norm()

    // Ensure the normal points AGAINST the trace direction
    local traceDir = (hitPos - startPos); traceDir.Norm()
    if (nWorld.Dot(traceDir) > 0) nWorld = nWorld * -1.0

    return nWorld
}

// todo inline all