/*
 * Finds the minimum value among the given arguments.
 *
 * @param {...number} vargv - The numbers to compare.
 * @returns {number} - The minimum value.
*/
math["min"] <- function(...) {
    if (vargc == 0) throw("math.min: no arguments");
    local min = vargv[0]
    for(local i = 0; i< vargc; i++) {
        if(min > vargv[i])
            min = vargv[i]
    }
    
    return min
}


/*
 * Finds the maximum value among the given arguments.
 *
 * @param {...number} vargv - The numbers to compare.
 * @returns {number} - The maximum value.
*/
math["max"] <- function(...) {
    if (vargc == 0) throw("math.max: no arguments");
    local max = vargv[0]
    for(local i = 0; i< vargc; i++) {
        if(vargv[i] > max)
            max = vargv[i]
    }

    return max
}


/*
 * Clamps a number within the specified range.
 *
 * @param {number} number - The number to clamp.
 * @param {number} min - The minimum value.
 * @param {number} max - The maximum value (optional).
 * @returns {number} - The clamped value.
*/
math["clamp"] <- function(number, min, max = 99999) { 
    if ( number < min ) return min;
    if ( number > max ) return max;
    return number
}


/*
 * Rounds a number to the specified precision.
 *
 * @param {number} value - The number to round.
 * @param {int} precision - The precision (e.g., 1000 for rounding to three decimal places).
 * @returns {number} - The rounded value.
*/
math["round"] <- function(value, precision = 1) {
    return floor(value * precision + 0.5) / precision
}


/*
 * Returns the sign of a number.
 *
 * @param {number} x - The number.
 * @returns {number} - The sign of the number (-1, 0, or 1).
*/
math["Sign"] <- function(x) {
    if (x > 0) {
        return 1;
    } else if (x < 0) {
        return -1;
    } else {
        return 0;
    }
}


/*
 * Copies the sign of one value to another.
 *
 * @param {number} value - The value to copy the sign to.
 * @param {number} sign - The sign to copy.
 * @returns {number} - The value with the copied sign.
*/
math["copysign"] <- function(value, sign) {
    local mag = value < 0 ? -value : value;
    return (sign < 0) ? -mag : mag;
}


/*
 * Remaps a value from the range [A, B] to the range [C, D].
 *
 * If A is equal to B, the value will be clamped to C or D depending on its relationship to B.
 *
 * @param {number} value - The value to remap.
 * @param {number} A - The start of the input range.
 * @param {number} B - The end of the input range.
 * @param {number} C - The start of the output range.
 * @param {number} D - The end of the output range.
 * @returns {number} - The remapped value.
*/
math["RemapVal"] <- function( value, A, B, C, D )
{
    if ( A == B )
    {
        if ( value >= B )
            return D;
        return C;
    };
    return C + (D - C) * (value - A) / (B - A);
}   