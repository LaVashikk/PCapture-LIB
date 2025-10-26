/*
 * Calculates two new start positions for additional traces used in impact normal calculation. 
 * 
 * @param {Vector} startPos - The original start position of the trace. 
 * @param {Vector} dir - The direction vector of the trace. 
 * @returns {array} - An array containing two new start positions as Vectors. 
*/
function _getNewStartsPos(startPos, dir) {
    // Calculate offset vectors perpendicular to the trace direction
    local perpDir = Vector(-dir.y, dir.x, 0)
    local offset1 = perpDir
    local offset2 = dir.Cross(offset1)

    // Calculate new start positions for two additional traces
    local newStart1 = startPos + offset1
    local newStart2 = startPos + offset2

    return [
        newStart1, 
        newStart2
    ]
}

/*
 * Performs a cheap trace from a new start position to find an intersection point.
 *
 * @param {Vector} newStart - The new start position for the trace. 
 * @param {Vector} dir - The direction vector of the trace. 
 * @returns {Vector} - The hit position of the trace.
*/
function _getIntPoint(newStart, dir) {    
    return TracePlus.Cheap(newStart, (newStart + dir * 8000)).GetHitpos()
}

/*
 * Calculates the normal vector of a triangle .
 * 
 * @param {Vector} v1 - The first . 
 * @param {Vector} v2 - The second .
 * @param {Vector} v3 - The third . 
 * @returns {Vector} - The normal vector of the triangle. 
*/
function _calculateNormal(v1, v2, v3) {
    // Calculate two edge vectors of the triangle. 
    local edge1 = v2 - v1
    local edge2 = v3 - v1

    // Calculate the normal vector using the cross product of the edge vectors.
    local normal = edge1.Cross(edge2)
    normal.Norm()

    return normal 
}

/*
 * Finds the three closest vertices to a given point from a list of vertices. 
 *
 * @param {Vector} point - The point to find the closest vertices to.
 * @param {array} vertices - An array of Vector objects representing the vertices. 
 * @returns {array} - An array containing the three closest vertices as Vector objects.
*/ 
function _findClosestVertices(point, vertices) {
    // Sort the vertices based on their distance to the point.
    vertices.sort(function(a, b):(point) {
        return (a - point).LengthSqr() - (b - point).LengthSqr() 
    })

    // Return the three closest vertices.
    return vertices.slice(0, 3)  
}

function _numberIsCloseTo(num1, num2, tolerance = 1) {
    return abs(num1 - num2) <= tolerance;
}

/*
  Gets the proper vertices of a face (4 of them), regarding the hitPoint
  allVertices - Array of Vectors, where each vector represents the position of a vertex point of the bounding box
  hitPoint - vector of the position where the ray hit
*/
function _getFaceVertices(allVertices, hitPoint, origin) {
    local resultX = []
    local resultY = []
    local resultZ = []
    hitPoint -= origin

    foreach(vertexPoint in allVertices) {
        if(_numberIsCloseTo(vertexPoint.x, hitPoint.x)) resultX.append(vertexPoint)
        else if(_numberIsCloseTo(vertexPoint.y, hitPoint.y)) resultY.append(vertexPoint)
        else if(_numberIsCloseTo(vertexPoint.z, hitPoint.z)) resultZ.append(vertexPoint)
        if(3 in resultX || 3 in resultY || 3 in resultZ) break
    }

    if(3 in resultX) return resultX
    if(3 in resultY) return resultY
    if(3 in resultZ) return resultZ

    return null
}


/* 
 * Calculates the impact normal of a surface hit by a trace. 
 *
 * @param {Vector} startPos - The start position of the trace.
 * @param {Vector} hitPos - The hit position of the trace.
 * @returns {Vector} - The calculated impact normal vector. 
*/
::CalculateImpactNormal <- function(startPos, hitPos) {
    // Calculate the normalized direction vector from startpos to hitpos
    local dir = hitPos - startPos
    dir.Norm()

    // Get two new start positions for additional traces.
    local newStartsPos = _getNewStartsPos(startPos, dir)
    
    // Perform cheap traces from the new start positions to find intersection points.
    local point1 = _getIntPoint(newStartsPos[0], dir)
    local point2 = _getIntPoint(newStartsPos[1], dir)
    
    return _calculateNormal(hitPos, point2, point1)
}

::CalculateImpactNormalFromBbox <- function(startPos, hitPos, hitEntity) {
    // The algorithm proposed by Enderek
    local closestVertices = _getFaceVertices(hitEntity.GetBBoxPoints(), hitPos, hitEntity.GetOrigin())
    if(!closestVertices)
        return CalculateImpactNormalFromBbox2(startPos, hitPos, hitEntity)
    
    local faceNormal = _calculateNormal(closestVertices[0], closestVertices[1], closestVertices[2])

    local traceDir = (hitPos - startPos)
    traceDir.Norm()
    if (faceNormal.Dot(traceDir) > 0) 
        return faceNormal * -1

    return faceNormal 
}

/*
 * Calculates the impact normal of a surface hit by a trace using the bounding box of the hit entity.
 *
 * @param {Vector} startPos - The start position of the trace.
 * @param {Vector} hitPos - The hit position of the trace.
 * @param {BboxTraceResult} traceResult - The trace result object.
 * @returns {Vector} - The calculated impact normal vector. 
*/
::CalculateImpactNormalFromBbox2 <- function(startPos, hitPos, hitEntity) {
    // Get the entity bounding box vertices.
    local bboxVertices = hitEntity.GetBBoxPoints()

    // Find the three closest vertices to the hit position.
    local closestVertices = _findClosestVertices(hitPos - hitEntity.GetOrigin(), bboxVertices)

    // Calculate the normal vector of the face formed by the three closest vertices.
    local faceNormal = _calculateNormal(closestVertices[0], closestVertices[1], closestVertices[2])

    // Ensure the normal vector points away from the trace direction.
    local traceDir = (hitPos - startPos)
    traceDir.Norm()
    if (faceNormal.Dot(traceDir) > 0)
        return faceNormal * -1

    return faceNormal 
}