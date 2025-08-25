math["vector"] <- {}
local mVector = math["vector"]

/*
 * Checks if two vectors are equal based on their rounded components.
 *
 * @param {Vector} vector - The first vector.
 * @param {Vector} other - The second vector.
 * @returns {boolean} - True if the vectors are exactly equal, false otherwise.
*/
mVector["isEqually"] <- function(vector, other) {
    return ::abs(vector.x - other.x) == 0 && 
           ::abs(vector.y - other.y) == 0 && 
           ::abs(vector.z - other.z) == 0
}


/*
 * Checks if two vectors are approximately equal, within a certain precision.
 * This function rounds the components of both vectors before comparing them.
 *
 * @param {Vector} vector - The first vector.
 * @param {Vector} other - The second vector.
 * @param {int} precision - The precision factor (e.g., 1000 for rounding to three decimal places).
 * @returns {boolean} - True if the vectors are approximately equal, false otherwise.
*/
mVector["isEqually2"] <- function(vector, other, precision = 1000) {
    vector = math.vector.round(vector, precision)
    other = math.vector.round(other, precision)
    return vector.x == other.x && 
            vector.y == other.y && 
            vector.z == other.z
}


/*
 * Compares two vectors based on their lengths.
 *
 * @param {Vector} vector - The first vector.
 * @param {Vector} other - The second vector.
 * @returns {int} - 1 if the first vector is longer, -1 if the second vector is longer, and 0 if they have equal lengths.
*/mVector["cmp"] <- function(vector, other) {
    local l1 = vector.Length()
    local l2 = other.Length()
    if(l1 > l2) return 1
    if(l1 < l2) return -1
    return 0
}


/*
 * Performs element-wise multiplication of two vectors.
 *
 * @param {Vector} vector - The first vector.
 * @param {Vector} other - The second vector.
 * @returns {Vector} - A new vector with the result of the element-wise multiplication.
*/
mVector["mul"] <- function(vector, other) {
    return Vector(vector.x * other.x, vector.y * other.y, vector.z * other.z)
}

/*
 * Rotates a vector by a given angle.
 *
 * @param {Vector} vector - The vector to rotate.
 * @param {Vector} angle - The Euler angles in degrees (pitch, yaw, roll) representing the rotation.
 * @returns {Vector} - The rotated vector. 
*/
mVector["rotate"] <- function(vector, angle) {
    return math.Quaternion.fromEuler(angle).rotateVector(vector)
}

/*
 * Un-rotates a vector by a given angle.
 *
 * @param {Vector} vector - The vector to un-rotate.
 * @param {Vector} angle - The Euler angles in degrees (pitch, yaw, roll) representing the rotation to reverse.
 * @returns {Vector} - The un-rotated vector.
*/
mVector["unrotate"] <- function(vector, angle) {
    return math.Quaternion.fromEuler(angle).unrotateVector(vector)
}

/*
 * Generates a random vector within the specified range.
 *
 * If `min` and `max` are both vectors, each component of the resulting vector will be a random value between the corresponding components of `min` and `max`.
 * If `min` and `max` are numbers, all components of the resulting vector will be random values between `min` and `max`.
 *
 * @param {Vector|number} min - The minimum values for each component or a single minimum value for all components.
 * @param {Vector|number} max - The maximum values for each component or a single maximum value for all components.
 * @returns {Vector} - The generated random vector.
*/
mVector["random"] <- function(min, max) {
    if(typeof min == "Vector" && typeof max == "Vector") 
        return Vector(RandomFloat(min.x, max.x), RandomFloat(min.y, max.y), RandomFloat(min.z, max.z))
    return Vector(RandomFloat(min, max), RandomFloat(min, max), RandomFloat(min, max))
}

/*
 * Reflects a direction vector off a surface with a given normal.
 *
 * @param {Vector} dir - The direction vector to reflect.
 * @param {Vector} normal - The normal vector of the surface.
 * @returns {Vector} - The reflected direction vector.
*/
mVector["reflect"] <- function(dir, normal) {
    return dir - normal * (dir.Dot(normal) * 2)
}

/*
 * Clamps the components of a vector within the specified range.
 *
 * @param {Vector} vector - The vector to clamp.
 * @param {number} min - The minimum value for each component.
 * @param {number} max - The maximum value for each component.
 * @returns {Vector} - The clamped vector.
*/
mVector["clamp"] <- function(vector, min = 0, max = 255) {
    return Vector(math.clamp(vector.x, min, max), math.clamp(vector.y, min, max), math.clamp(vector.z, min, max)) 
}

/*
 * Resizes a vector to a new length while maintaining its direction.
 *
 * @param {Vector} vector - The vector to resize.
 * @param {number} newLength - The desired new length of the vector.
 * @returns {Vector} - The resized vector with the specified length.
*/
mVector["resize"] <- function(vector, newLength) {
    local currentLength = vector.Length()
    return vector * (newLength / currentLength)
}

/*
 * Rounds the elements of a vector to the specified precision.
 *
 * @param {Vector} vec - The vector to round.
 * @param {int} precision - The precision (e.g., 1000 for rounding to three decimal places).
 * @returns {Vector} - The rounded vector.
*/
mVector["round"] <- function(vec, precision = 1000) {
    vec.x = floor(vec.x * precision + 0.5) / precision
    vec.y = floor(vec.y * precision + 0.5) / precision
    vec.z = floor(vec.z * precision + 0.5) / precision
    return vec
}

/* 
 * Returns a vector with the signs (-1, 0, or 1) of each component of the input vector.
 * 
 * @param {Vector} vec - The input vector.
 * @returns {Vector} - A new vector with the signs of the input vector's components.
*/
mVector["sign"] <- function(vec) {
    return Vector(math.Sign(vec.x), math.Sign(vec.y), math.Sign(vec.z))
}

/* 
 * Calculates the absolute value of each component in a vector.
 *
 * @param {Vector} vector - The vector to calculate the absolute values for.
 * @returns {Vector} - A new vector with the absolute values of the original vector's components.
*/
mVector["abs"] <- function(vector) {
    return Vector(::abs(vector.x), ::abs(vector.y), ::abs(vector.z)) 
}
