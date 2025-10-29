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
    return abs(num1 - num2) <= tolerance
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
    if (normal.Dot(dir) > 0) normal = normal * -1.0;
    return normal
}

::CalculateImpactNormalFromBbox <- function(startPos, hitPos, hitEntity) {
    //* This algorithm proposed by Enderek (Lead of Portal: Singularity Collapse)! Code developed by laVashik
    
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