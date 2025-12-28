math["lerp"] <- {}
local lerp = math["lerp"]


/*
 * Performs linear interpolation (lerp) between start and end based on the parameter t.
 *
 * @param {number} start - The starting value.
 * @param {number} end - The ending value.
 * @param {number} t - The interpolation parameter.
 * @returns {number} - The interpolated value.
*/
lerp["number"] <- function(start, end, t) {
    return start * (1 - t) + end * t;
}


/*
 * Performs linear interpolation (lerp) between two vectors.
 *
 * @param {Vector} start - The starting vector.
 * @param {Vector} end - The ending vector.
 * @param {number} t - The interpolation parameter.
 * @returns {Vector} - The interpolated vector.
*/
lerp["vector"] <- function(start, end, t) {
    return Vector(math.lerp.number(start.x, end.x, t), math.lerp.number(start.y, end.y, t), math.lerp.number(start.z, end.z, t));
}


/*
 * Performs linear interpolation (lerp) between two colors.
 *
 * @param {Vector|string} start - The starting color vector or string representation (e.g., "255 0 0").
 * @param {Vector|string} end - The ending color vector or string representation.
 * @param {number} t - The interpolation parameter.
 * @returns {string} - The interpolated color string representation (e.g., "128 64 0").
*/
lerp["color"] <- function(start, end, t) {
    if (type(start) == "string") {
        start = macros.StrToVec(start)
    }
    if (type(end) == "string") {
        end = macros.StrToVec(end)
    }

    return floor(math.lerp.number(start.x, end.x, t)) + " " + floor(math.lerp.number(start.y, end.y, t)) + " " + floor(math.lerp.number(start.z, end.z, t))
}

// SLERP for vector 
lerp["sVector"] <- function(start, end, t) {
    local q1 = math.Quaternion.fromEuler(start)
    local q2 = math.Quaternion.fromEuler(end)
    return q1.slerp(q2, t).toVector()
}

/*
 * Performs smooth interpolation between two values using a smoothstep function.
 *
 * @param {number} edge0 - The lower edge of the interpolation range.
 * @param {number} edge1 - The upper edge of the interpolation range.
 * @param {number} value - The interpolation parameter.
 * @returns {number} - The interpolated value.
*/
lerp["SmoothStep"] <- function(edge0, edge1, value) {
    if(edge0 == edge1) return 0
    local t = math.clamp((value - edge0) / (edge1 - edge0), 0.0, 1.0);
    return t * t * (3.0 - 2.0 * t)
}


/*
 * Performs linear interpolation between two values.
 *
 * @param {number} f1 - The start value.
 * @param {number} f2 - The end value.
 * @param {number} i1 - The start interpolation parameter.
 * @param {number} i2 - The end interpolation parameter.
 * @param {number} value - The interpolation parameter.
 * @returns {number} - The interpolated value.
*/
lerp["FLerp"] <- function( f1, f2, i1, i2, value ) {
    if(i1 == i2) return f2
    return f1 + (f2 - f1) * (value - i1) / (i2 - i1);
}