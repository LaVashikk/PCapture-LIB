# Math Module

The `Math` module provides various mathematical functions and objects for use in VScripts, including those for linear interpolation, quaternions, vectors, and matrices. It aims to extend the standard mathematical capabilities of VScripts and simplify common mathematical operations.

## Table of Contents

- [Math/algebraic.nut](#mathalgebraicnut)
	- [`min(...)`](#mathmin)
	- [`max(...)`](#mathmax)
	- [`clamp(number, min, max)`](#mathclampnumber-min-max)
	- [`round(value, precision)`](#mathroundvalue-precision)
	- [`Sign(x)`](#mathsignx)
	- [`copysign(value, sign)`](#mathcopysignvalue-sign)
	- [`RemapVal(val, A, B, C, D)`](#mathremapvalval-a-b-c-d)
- [Math/utils\_vector.nut](#mathutils_vectornut)
	- [`vector.IsEqual(vec1, vec2, precision)`](#mathvectorIsEqualvec1-vec2-precision)
	- [`vector.mul(vec1, vec2)`](#mathvectormulvec1-vec2)
	- [`vector.rotate(vec, angle)`](#mathvectorrotatevec-angle)
	- [`vector.unrotate(vec, angle)`](#mathvectorunrotatevec-angle)
	- [`vector.random(min, max)`](#mathvectorrandommin-max)
	- [`vector.reflect(dir, normal)`](#mathvectorreflectdir-normal)
	- [`vector.clamp(vec, min, max)`](#mathvectorclampvec-min-max)
	- [`vector.resize(vec, newLength)`](#mathvectorresizevec-newlength)
	- [`vector.round(vec, precision)`](#mathvectorroundvec-precision)
	- [`vector.sign(vec)`](#mathvectorsignvec)
	- [`vector.abs(vector)`](#mathvectorabsvector)
- [Math/lerp.nut](#mathlerpnut)
	- [`lerp.number(start, end, t)`](#mathlerpnumberstart-end-t)
	- [`lerp.vector(start, end, t)`](#mathlerpvectorstart-end-t)
	- [`lerp.color(start, end, t)`](#mathlerpcolorstart-end-t)
	- [`lerp.sVector(start, end, t)`](#mathlerpsvectorstart-end-t)
	- [`lerp.SmoothStep(edge0, edge1, x)`](#mathlerpsmoothstepedge0-edge1-x)
	- [`lerp.FLerp(f1, f2, i1, i2, x)`](#mathlerpflerpf1-f2-i1-i2-x)
- [Math/easing_equation.nut](#easingequationnut)
	- [`ease.InSine(t)`](#matheaseinsinet)
	- [`ease.OutSine(t)`](#matheaseoutsinet)
	- [`ease.InOutSine(t)`](#matheaseinoutsinet)
	- [`ease.InQuad(t)`](#matheaseinquadt)
	- [`ease.OutQuad(t)`](#matheaseoutquadt)
	- [`ease.InOutQuad(t)`](#matheaseinoutquadt)
	- [`ease.InCubic(t)`](#matheaseincubict)
	- [`ease.OutCubic(t)`](#matheaseoutcubict)
	- [`ease.InOutCubic(t)`](#matheaseinoutcubict)
	- [`ease.InQuart(t)`](#matheaseinquartt)
	- [`ease.OutQuart(t)`](#matheaseoutquartt)
	- [`ease.InOutQuart(t)`](#matheaseinoutquartt)
	- [`ease.InQuint(t)`](#matheaseinquintt)
	- [`ease.OutQuint(t)`](#matheaseoutquintt)
	- [`ease.InOutQuint(t)`](#matheaseinoutquintt)
	- [`ease.InExpo(t)`](#matheaseinexpot)
	- [`ease.OutExpo(t)`](#matheaseoutexpot)
	- [`ease.InOutExpo(t)`](#matheaseinoutexpot)
	- [`ease.InCirc(t)`](#matheaseincirct)
	- [`ease.OutCirc(t)`](#matheaseoutcirct)
	- [`ease.InOutCirc(t)`](#matheaseinoutcirct)
	- [`ease.InBack(t)`](#matheaseinbackt)
	- [`ease.OutBack(t)`](#matheaseoutbackt)
	- [`ease.InOutBack(t)`](#matheaseinoutbackt)
	- [`ease.InElastic(t)`](#matheaseinelastict)
	- [`ease.OutElastic(t)`](#matheaseoutelastict)
	- [`ease.InOutElastic(t)`](#matheaseinoutelastict)
	- [`ease.InBounce(t)`](#matheaseinbouncet)
	- [`ease.OutBounce(t)`](#matheaseoutbouncet)
	- [`ease.InOutBounce(t)`](#matheaseinoutbouncet)
- [Math/quaternion.nut](#mathquaternionnut)
	- [`Quaternion(x, y, z, w)`](#quaternionx-y-z-w)
		- [`fromEuler(angles)`](#fromeulerangles)
		- [`fromVector(vector)`](#fromvectorvector)
		- [`rotateVector(vector)`](#rotatevectorvector)
		- [`unrotateVector(vector)`](#unrotatevectorvector)
		- [`slerp(targetQuaternion, t)`](#slerptargetquaternion-t)
		- [`normalize()`](#normalize)
		- [`dot(other)`](#dotother)
		- [`length()`](#length)
		- [`inverse()`](#inverse)
		- [`fromAxisAngle(axis, angle)`](#fromaxisangleaxis-angle)
		- [`toAxisAngle()`](#toaxisangle)
		- [`toVector()`](#tovector)
		- [`IsEqual(other)`](#IsEqualother)
		- [`cmp(other)`](#cmpother)
- [Math/matrix.nut](#mathmatrixnut)
	- [`Matrix(a, b, c, d, e, f, g, h, k)`](#matrixa-b-c-d-e-f-g-h-k)
		- [`fromEuler(angles)`](#fromeulerangles-1)
		- [`rotateVector(point)`](#rotatevectorpoint)
		- [`unrotateVector(point)`](#unrotatevectorpoint)
		- [`transpose()`](#transpose)
		- [`inverse()`](#inverse-1)
		- [`determinant()`](#determinant)
		- [`scale(factor)`](#scalefactor)
		- [`rotateX(angle)`](#rotatexangle)
		- [`_mul(other)`](#_mulother)
		- [`_add(other)`](#_addother)
		- [`_sub(other)`](#_subother)
		- [`IsEqual(other)`](#IsEqualother-1)
		- [`cmp(other)`](#cmpother-1)
  
## [Math/algebraic.nut](algebraic.nut)

This file contains basic algebraic functions such as finding minimum and maximum values, clamping numbers, rounding, and remapping values.

### `math.min(...)`

This function finds the minimum value among the given arguments.

**Parameters:**

* `...` (number): A variable number of numerical arguments to compare.

**Returns:**

* (number): The minimum value among the provided arguments.

**Example:**

```js
local smallestValue = math.min(10, 5, 20, -3) // smallestValue will be -3
```

### `math.max(...)`

This function finds the maximum value among the given arguments.

**Parameters:**

* `...` (number): A variable number of numerical arguments to compare.

**Returns:**

* (number): The maximum value among the provided arguments.

**Example:**

```js
local largestValue = math.max(10, 5, 20, -3) // largestValue will be 20
```

### `math.clamp(number, min, max)`

This function clamps a number within the specified range, ensuring that the returned value is between the minimum and maximum values (inclusive).

**Parameters:**

* `number` (number): The number to clamp.
* `min` (number): The minimum value of the range.
* `max` (number, optional): The maximum value of the range (defaults to a very large number).

**Returns:**

* (number): The clamped value within the specified range.

**Example:**

```js
local clampedValue = math.clamp(15, 10, 20) // clampedValue will be 15 (within the range)
local clampedValue2 = math.clamp(25, 10, 20) // clampedValue2 will be 20 (clamped to the maximum)
```

### `math.round(value, precision)`

This function rounds a number to the specified precision.

**Parameters:**

* `value` (number): The number to round.
* `precision` (number, optional): The precision to round to (e.g., 1000 for rounding to three decimal places, default is 1000).

**Returns:**

* (number): The rounded value.

**Example:**

```js
local roundedValue = math.round(3.14159, 100) // roundedValue will be 3.14 (rounded to two decimal places)
```

### `math.Sign(x)`

This function returns the sign of a number as -1, 0, or 1.

**Parameters:**

* `x` (number): The number to get the sign of.

**Returns:**

* (number): The sign of the number:
    * -1 if the number is negative.
    * 0 if the number is zero.
    * 1 if the number is positive.

**Example:**

```js
local sign = math.Sign(-5) // sign will be -1
local sign2 = math.Sign(0) // sign2 will be 0
local sign3 = math.Sign(10) // sign3 will be 1
```

### `math.copysign(value, sign)`

This function copies the sign of one number to another.

**Parameters:**

* `value` (number): The value to copy the sign to.
* `sign` (number): The number whose sign to copy (should be -1, 0, or 1).

**Returns:**

* (number): The value with the copied sign.

**Example:**

```js
local result = math.copysign(5, -1) // result will be -5
```

### `math.RemapVal(val, A, B, C, D)`

This function remaps a value from one range to another. It takes a value `val` within the range [A, B] and maps it to a corresponding value within the range [C, D].

**Parameters:**

* `val` (number): The value to remap.
* `A` (number): The start of the input range.
* `B` (number): The end of the input range.
* `C` (number): The start of the output range.
* `D` (number): The end of the output range.

**Returns:**

* (number): The remapped value within the range [C, D].

**Example:**

```js
local remappedValue = math.RemapVal(50, 0, 100, -1, 1) // remappedValue will be 0 (middle of the new range)
```

## [Math/utils_vector.nut](utils_vector.nut)

This file contains utility functions for working with vectors, including checking equality, rotating and un-rotating, generating random vectors, reflecting vectors, clamping components, and resizing vectors.

### `math.vector.IsEqual(vec1, vec2, precision)`

This function checks if two vectors are approximately equal by rounding their components to a specified precision before comparing them. This is useful when dealing with floating-point numbers that might have minor discrepancies due to precision limitations.

**Parameters:**

* `vec1` (Vector): The first vector.
* `vec2` (Vector): The second vector.
* `precision` (int): The precision factor. For example, a precision of 1000 rounds to three decimal places (default: 1000).

**Returns:**

* (boolean): True if the vectors are approximately equal after rounding, false otherwise.

### `math.vector.mul(vec1, vec2)`

Performs element-wise multiplication of two vectors.

**Parameters:**

* `vec1` (Vector): The first vector.
* `vec2` (Vector): The second vector. 

**Returns:**

* (Vector): A new vector with the result of the element-wise multiplication.

**Example:**

```js
local vec1 = Vector(1, 2, 3)
local vec2 = Vector(4, 5, 6)
local result = math.vector.mul(vec1, vec2)  // result will be Vector(4, 10, 18) 
```

### `math.vector.rotate(vec, angle)`

This function rotates a vector by a given angle represented as Euler angles (pitch, yaw, roll). It uses quaternion operations to perform the rotation.

**Parameters:**

* `vec` (Vector): The vector to rotate.
* `angle` (Vector): The Euler angles in degrees (pitch, yaw, roll) representing the rotation.

**Returns:**

* (Vector): The rotated vector.

**Example:**

```js
local rotatedVec = math.vector.rotate(Vector(1, 0, 0), Vector(0, 45, 0)) // Rotate the vector by 45 degrees around the Y axis
```

### `math.vector.unrotate(vec, angle)`

This function un-rotates a vector by a given angle represented as Euler angles. It reverses the rotation that would be applied by `math.vector.rotate`.

**Parameters:**

* `vec` (Vector): The vector to un-rotate.
* `angle` (Vector): The Euler angles in degrees (pitch, yaw, roll) representing the rotation to reverse.

**Returns:**

* (Vector): The un-rotated vector.

**Example:**

```js
local originalVec = math.vector.unrotate(rotatedVec, Vector(0, 45, 0)) // Un-rotate the vector back to its original orientation
```

### `math.vector.random(min, max)`

This function generates a random vector within the specified range. The range can be defined either by two vectors or by two numbers.

**Parameters:**

* `min` (Vector or number): If a vector, the minimum values for each component of the generated vector. If a number, the minimum value for all components.
* `max` (Vector or number): If a vector, the maximum values for each component of the generated vector. If a number, the maximum value for all components.

**Returns:**

* (Vector): The generated random vector.

**Example:**

```js
local randVec = math.vector.random(Vector(-10, -10, -10), Vector(10, 10, 10)) // Generate a random vector between (-10, -10, -10) and (10, 10, 10)
local randVec2 = math.vector.random(-1, 1) // Generate a random vector with components between -1 and 1
```

### `math.vector.reflect(dir, normal)`

This function reflects a direction vector off a surface with a given normal vector.

**Parameters:**

* `dir` (Vector): The direction vector to reflect.
* `normal` (Vector): The normal vector of the surface.

**Returns:**

* (Vector): The reflected direction vector.

**Example:**

```js
local incomingDir = Vector(1, 0, 0)
local surfaceNormal = Vector(0, 1, 0)
local reflectedDir = math.vector.reflect(incomingDir, surfaceNormal) // Reflect the incoming direction off the surface
```

### `math.vector.clamp(vec, min, max)`

This function clamps the components of a vector within the specified range.

**Parameters:**

* `vec` (Vector): The vector to clamp.
* `min` (number): The minimum value for each component.
* `max` (number): The maximum value for each component.

**Returns:**

* (Vector): The clamped vector.

**Example:**

```js
local clampedVec = math.vector.clamp(Vector(255, 512, -10), 0, 255) // clampedVec will be Vector(255, 255, 0)
```

### `math.vector.resize(vec, newLength)`

This function resizes a vector to a new length while maintaining its direction.

**Parameters:**

* `vec` (Vector): The vector to resize.
* `newLength` (number): The desired new length of the vector.

**Returns:**

* (Vector): The resized vector with the specified length.

**Example:**

```js
local resizedVec = math.vector.resize(Vector(1, 2, 3), 5) // Resize the vector to have a length of 5
```

### `math.vector.round(vec, precision)`

This function rounds the components of a vector to the specified precision.

**Parameters:**

* `vec` (Vector): The vector to round.
* `precision` (number, optional): The precision to round to (e.g., 1000 for rounding to three decimal places, default is 1).

**Returns:**

* (Vector): The rounded vector.

**Example:**

```js
local roundedVec = math.vector.round(Vector(1.234, 5.678, 9.101), 100) // Round the vector components to two decimal places
```

### `math.vector.sign(vec)` 

This function returns a new vector where each component represents the sign of the corresponding component in the input vector. The sign is determined using the `math.Sign` function, which returns -1 for negative values, 0 for zero, and 1 for positive values.

**Parameters:**

* `vec` (Vector): The input vector.

**Returns:**

* (Vector): A new vector with the signs of the input vector's components.

**Example:**

```js
local vec = Vector(-14, 0, 2)
local signVec = math.vector.sign(vec) // signVec will be Vector(-1, 0, 1)
```

### `math.vector.abs(vector)`

This function calculates the absolute value of each component in a vector and returns a new vector with the absolute values.

**Parameters:**

* `vector` (Vector): The input vector.

**Returns:**

* (Vector): A new vector with the absolute values of the original vector's components.

**Example:**

```js
local vec = Vector(-3, 4, -5)
local absVec = math.vector.abs(vec) // absVec will be Vector(3, 4, 5)
```


## [Math/lerp.nut](lerp.nut)

This file provides functions for linear interpolation (lerp) between different data types, including numbers, vectors, and colors. It also includes functions for spline interpolation, smoothstep interpolation, and other interpolation techniques.

### `math.lerp.number(start, end, t)`

This function performs linear interpolation between two numbers. It calculates a value between `start` and `end` based on the interpolation parameter `t`.

**Parameters:**

* `start` (number): The starting value.
* `end` (number): The ending value.
* `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**

* (number): The interpolated value between `start` and `end`.

**Example:**

```js
local interpolatedValue = math.lerp.number(10, 20, 0.5) // interpolatedValue will be 15 (halfway between 10 and 20)
```

### `math.lerp.vector(start, end, t)`

This function performs linear interpolation between two vectors. It calculates a new vector that lies on the line segment between `start` and `end`, with the position determined by the interpolation parameter `t`.

**Parameters:**

* `start` (Vector): The starting vector.
* `end` (Vector): The ending vector.
* `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**

* (Vector): The interpolated vector between `start` and `end`.

**Example:**

```js
local startPos = Vector(0, 0, 0)
local endPos = Vector(10, 10, 0)
local interpolatedPos = math.lerp.vector(startPos, endPos, 0.25) // interpolatedPos will be Vector(2.5, 2.5, 0)
```

### `math.lerp.color(start, end, t)`

This function performs linear interpolation between two colors. The colors can be represented as strings (e.g., "255 0 0" for red) or as vectors with components (r, g, b).

**Parameters:**

* `start` (string or Vector): The starting color.
* `end` (string or Vector): The ending color.
* `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**

* (string): The interpolated color as a string.

**Example:**

```js
local startColor = "255 0 0" // Red
local endColor = "0 0 255" // Blue
local interpolatedColor = math.lerp.color(startColor, endColor, 0.5) // interpolatedColor will be "128 0 128" (purple)
```

### `math.lerp.sVector(start, end, t)`

This function performs spherical linear interpolation (slerp) between two vectors. Slerp is a more sophisticated interpolation technique that results in a smoother transition between orientations compared to linear interpolation.

**Parameters:**

* `start` (Vector): The starting vector.
* `end` (Vector): The ending vector.
* `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**

* (Vector): The interpolated vector using slerp.

**Example:**

```js
local startDir = Vector(1, 0, 0) // Facing right
local endDir = Vector(0, 1, 0) // Facing forward
local interpolatedDir = math.lerp.sVector(startDir, endDir, 0.5) // Interpolate between the two directions using slerp
```

### `math.lerp.SmoothStep(edge0, edge1, x)`

This function performs smooth interpolation between two values using a smoothstep function. The smoothstep function provides a smooth transition between the two edges, avoiding sudden jumps or discontinuities.

**Parameters:**

* `edge0` (number): The lower edge of the interpolation range.
* `edge1` (number): The upper edge of the interpolation range.
* `x` (number): The value to interpolate.

**Returns:**

* (number): The interpolated value between `edge0` and `edge1`.

**Example:**

```js
local smoothedValue = math.lerp.SmoothStep(0, 10, 5) // Smoothly interpolate between 0 and 10 at x=5
```

### `math.lerp.FLerp(f1, f2, i1, i2, x)`

This function performs linear interpolation between two values with custom interpolation parameters. It allows you to define the start and end values, as well as the corresponding interpolation parameters, for more control over the interpolation behavior.

**Parameters:**

* `f1` (number): The start value.
* `f2` (number): The end value.
* `i1` (number): The start interpolation parameter.
* `i2` (number): The end interpolation parameter.
* `x` (number): The interpolation parameter for the current value.

**Returns:**

* (number): The interpolated value.

**Example:**

```js
local result = math.lerp.FLerp(10, 20, 0, 10, 5) // result will be 15 (linear interpolation with custom parameters)
```

## [Math/easing_equation.nut](easing_equation.nut)

More info about `easing` lerp function you can found here: https://gizma.com/easing/

### `math.ease.InSine(t)`

This function applies an ease-in sine interpolation to a value.  The animation starts slowly and accelerates towards the end. 

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1). 

**Returns:**
*   (number): The interpolated value using the ease-in sine function. 

**Example:**
```js
local value = math.ease.InSine(0.5)  // Returns a value around 0.29 
```

### `math.ease.OutSine(t)`

This function applies an ease-out sine interpolation to a value.  The animation starts quickly and decelerates towards the end.

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**
*   (number): The interpolated value using the ease-out sine function.

**Example:**
```js
local value = math.ease.OutSine(0.5)  // Returns a value around 0.71
```

### `math.ease.InOutSine(t)`

This function applies an ease-in-out sine interpolation to a value. The animation starts slowly, accelerates in the middle, and decelerates again towards the end.

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1). 

**Returns:**
*   (number): The interpolated value using the ease-in-out sine function. 

**Example:** 

```js
local value = math.ease.InOutSine(0.5) // Returns 0.5
```

### `math.ease.InQuad(t)`

This function applies an ease-in quadratic interpolation to a value. The animation starts slowly and accelerates gradually towards the end.

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**
*   (number): The interpolated value using the ease-in quadratic function. 

**Example:** 

```js
local value = math.ease.InQuad(0.5) // Returns 0.25
```

### `math.ease.OutQuad(t)`

This function applies an ease-out quadratic interpolation to a value. The animation starts quickly and decelerates gradually towards the end.

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1). 

**Returns:**
*   (number): The interpolated value using the ease-out quadratic function.

**Example:** 

```js
local value = math.ease.OutQuad(0.5) // Returns 0.75 
```

### `math.ease.InOutQuad(t)`

This function applies an ease-in-out quadratic interpolation to a value.  The animation starts slowly, accelerates in the middle, and then decelerates towards the end. 

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**
*   (number): The interpolated value using the ease-in-out quadratic function. 

**Example:**
```js 
local value = math.ease.InOutQuad(0.5) // Returns 0.5
```

### `math.ease.InCubic(t)`

This function applies an ease-in cubic interpolation to a value.  The animation starts even slower than the quadratic ease-in and accelerates more dramatically towards the end. 

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**
*   (number): The interpolated value using the ease-in cubic function. 

**Example:** 

```js
local value = math.ease.InCubic(0.5) // Returns 0.125
```

### `math.ease.OutCubic(t)`

This function applies an ease-out cubic interpolation to a value.  The animation starts quickly and decelerates more gradually than the quadratic ease-out towards the end. 

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1). 

**Returns:**
*   (number): The interpolated value using the ease-out cubic function.

**Example:**
```js
local value = math.ease.OutCubic(0.5) // Returns 0.875
```

### `math.ease.InOutCubic(t)`

This function applies an ease-in-out cubic interpolation to a value. The animation starts slowly, accelerates in the middle, and then decelerates smoothly towards the end. 

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:** 

*   (number): The interpolated value using the ease-in-out cubic function.

**Example:**
```js
local value = math.ease.InOutCubic(0.5) // Returns 0.5
```

### `math.ease.InQuart(t)`

This function applies an ease-in quartic (fourth power) interpolation to a value. This creates an even more pronounced acceleration than the cubic ease-in, starting very slowly and then quickly ramping up in speed. 

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:** 

*   (number): The interpolated value using the ease-in quartic function.

**Example:**
```js
local value = math.ease.InQuart(0.5) // Returns 0.0625
```

### `math.ease.OutQuart(t)` 

This function applies an ease-out quartic (fourth power) interpolation to a value. This creates a very smooth deceleration, starting quickly and then slowly easing to a stop. 

**Parameters:** 

*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:** 

*   (number): The interpolated value using the ease-out quartic function.

**Example:**
```js 
local value = math.ease.OutQuart(0.5) // Returns 0.9375
```

### `math.ease.InOutQuart(t)`

This function applies an ease-in-out quartic (fourth power) interpolation to a value.  The animation begins slowly, speeds up in the middle, and then gracefully slows down as it approaches the end value.

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1). 

**Returns:**
*   (number): The interpolated value using the ease-in-out quartic function.

**Example:** 

```js
local value = math.ease.InOutQuart(0.5) // Returns 0.5
```

### `math.ease.InQuint(t)`

This function applies an ease-in quintic (fifth power) interpolation to a value. This is the most extreme of the power-based ease-in functions, with a very slow start and a very rapid acceleration towards the end.

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**
*   (number): The interpolated value using the ease-in quintic function. 

**Example:**
```js
local value = math.ease.InQuint(0.5) // Returns 0.03125
```

### `math.ease.OutQuint(t)`

This function applies an ease-out quintic (fifth power) interpolation to a value. This provides the smoothest deceleration of the power-based ease-out functions, starting quickly and very gradually coming to a halt.

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**
*   (number): The interpolated value using the ease-out quintic function. 

**Example:**
```js
local value = math.ease.OutQuint(0.5) // Returns 0.96875
```

### `math.ease.InOutQuint(t)`

This function applies an ease-in-out quintic (fifth power) interpolation to a value.  The animation starts gently, accelerates significantly in the middle, and then smoothly decelerates as it reaches the final value.

**Parameters:** 

*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:** 

*   (number): The interpolated value using the ease-in-out quintic function.

**Example:**
```js
local value = math.ease.InOutQuint(0.5) // Returns 0.5 
``` 

### `math.ease.InExpo(t)`

This function applies an ease-in exponential interpolation to a value. The animation starts slowly and then accelerates rapidly towards the end.

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1). 

**Returns:**
*   (number): The interpolated value using the ease-in exponential function.

**Example:**
```js
local value = math.ease.InExpo(0.5) // Returns a value close to 0.03
```

### `math.ease.OutExpo(t)`

This function applies an ease-out exponential interpolation to a value. The animation starts quickly and then decelerates rapidly towards the end. 

**Parameters:** 

*   `t` (number): The interpolation parameter (between 0 and 1). 

**Returns:**
*   (number): The interpolated value using the ease-out exponential function.

**Example:**
```js
local value = math.ease.OutExpo(0.5) // Returns a value close to 0.97
```

### `math.ease.InOutExpo(t)`

This function applies an ease-in-out exponential interpolation to a value.  The animation starts and ends slowly, with a sharp acceleration and deceleration in the middle.

**Parameters:** 

*   `t` (number): The interpolation parameter (between 0 and 1). 

**Returns:**
*   (number): The interpolated value using the ease-in-out exponential function.

**Example:** 

```js
local value = math.ease.InOutExpo(0.5) // Returns 0.5
```

### `math.ease.InCirc(t)` 

This function applies an ease-in circular interpolation to a value.  The animation starts slowly with a subtle curve and gradually accelerates towards the end. 

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:** 

*   (number): The interpolated value using the ease-in circular function.

**Example:**
```js
local value = math.ease.InCirc(0.5) // Returns a value close to 0.13
``` 

### `math.ease.OutCirc(t)` 

This function applies an ease-out circular interpolation to a value.  The animation starts quickly and decelerates with a subtle curve, ending smoothly.

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**
*   (number): The interpolated value using the ease-out circular function. 

**Example:**
```js
local value = math.ease.OutCirc(0.5) // Returns a value close to 0.87 
```

### `math.ease.InOutCirc(t)`

This function applies an ease-in-out circular interpolation to a value.  The animation starts and ends slowly, with a smooth, rounded acceleration and deceleration in the middle. 

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1). 

**Returns:**
*   (number): The interpolated value using the ease-in-out circular function.

**Example:**
```js
local value = math.ease.InOutCirc(0.5) // Returns 0.5 
```

### `math.ease.InBack(t)` 

This function applies an ease-in back interpolation to a value.  The animation starts by briefly going back slightly before moving forward, creating an \"anticipation\" or \"overshoot\" effect at the beginning.

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1). 

**Returns:**
*   (number): The interpolated value using the ease-in back function.

**Example:** 

```js
local value = math.ease.InBack(0.5) // Returns a value close to -0.13
``` 

### `math.ease.OutBack(t)`

This function applies an ease-out back interpolation to a value. The animation ends by briefly overshooting the final value before settling, creating an \"overshoot\" effect at the end.

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:** 

*   (number): The interpolated value using the ease-out back function. 

**Example:**
```js 
local value = math.ease.OutBack(0.5) // Returns a value close to 1.13
```

### `math.ease.InOutBack(t)` 

This function applies an ease-in-out back interpolation to a value.  The animation starts and ends with a slight \"overshoot\" effect, creating a more dramatic and bouncy movement.

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**
*   (number): The interpolated value using the ease-in-out back function. 

**Example:** 

```js 
local value = math.ease.InOutBack(0.5) // Returns 0.5 
```

### `math.ease.InElastic(t)`

This function applies an ease-in elastic interpolation to a value. The animation starts with a \"winding up\" or \"stretching\" effect before moving forward, creating a bouncy, springy feel. 

**Parameters:** 

*   `t` (number): The interpolation parameter (between 0 and 1). 

**Returns:** 

*   (number): The interpolated value using the ease-in elastic function.

**Example:**
```js
local value = math.ease.InElastic(0.5) // Returns a value close to -0.05 
```

### `math.ease.OutElastic(t)`

This function applies an ease-out elastic interpolation to a value.  The animation ends with a \"springy\" overshoot effect, as if the value bounces back slightly before settling at its final position.

**Parameters:** 

*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**
*   (number): The interpolated value using the ease-out elastic function. 

**Example:** 

```js
local value = math.ease.OutElastic(0.5) // Returns a value close to 1.05
```

### `math.ease.InOutElastic(t)` 

This function applies an ease-in-out elastic interpolation to a value.  The animation combines the \"winding up\" effect of ease-in elastic with the \"springy\" overshoot of ease-out elastic, creating a more pronounced bouncy movement. 

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:** 

*   (number): The interpolated value using the ease-in-out elastic function. 

**Example:**
```js
local value = math.ease.InOutElastic(0.5) // Returns 0.5 
``` 

### `math.ease.InBounce(t)` 

This function applies an ease-in bounce interpolation to a value. The animation starts with a series of bounces, gradually increasing in size until it reaches the final value.

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**
*   (number): The interpolated value using the ease-in bounce function. 

**Example:**
```js 
local value = math.ease.InBounce(0.5) // Returns a value close to 0.72 
``` 

### `math.ease.OutBounce(t)`

This function applies an ease-out bounce interpolation to a value. The animation ends with a series of bounces, gradually decreasing in size until it settles at the final value.

**Parameters:**
*   `t` (number): The interpolation parameter (between 0 and 1). 

**Returns:**
*   (number): The interpolated value using the ease-out bounce function. 

**Example:**
```js
local value = math.ease.OutBounce(0.5) // Returns a value close to 0.28 
```

### `math.ease.InOutBounce(t)`

This function applies an ease-in-out bounce interpolation to a value.  The animation combines the bouncing effect of both ease-in and ease-out bounce, creating a symmetrical bouncing movement.

**Parameters:** 

*   `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**
*   (number): The interpolated value using the ease-in-out bounce function. 

**Example:** 

```js
local value = math.ease.InOutBounce(0.5) // Returns 0.5 
```

## [Math/quaternion.nut](quaternion.nut)

This file defines the `math.Quaternion` class, which represents a quaternion (a mathematical object used for rotations in 3D space). The class provides methods for creating quaternions from Euler angles or vectors, rotating and un-rotating vectors, performing spherical linear interpolation, normalization, and conversion to other representations (axis-angle and Euler angles).

### `Quaternion(x, y, z, w)`

**Constructor**

This creates a new quaternion with the specified components.

**Parameters:**

* `x` (number): The x component of the quaternion.
* `y` (number): The y component of the quaternion.
* `z` (number): The z component of the quaternion.
* `w` (number): The w component of the quaternion.

**Example:**

```js
local q = math.Quaternion(0, 0, 0, 1) // Create an identity quaternion (no rotation)
```

### `fromEuler(angles)`

This method creates a quaternion from Euler angles (pitch, yaw, roll).

**Parameters:**

* `angles` (Vector): The Euler angles in degrees (pitch, yaw, roll).

**Returns:**

* (Quaternion): The quaternion corresponding to the given Euler angles.

**Example:**

```js
local q = math.Quaternion.fromEuler(Vector(30, 45, 60)) // Create a quaternion from Euler angles
```

### `fromVector(vector)`

This method creates a quaternion from a vector, with the w component of the quaternion set to 0.

**Parameters:**

* `vector` (Vector): The vector to create the quaternion from.

**Returns:**

* (Quaternion): The quaternion with the vector's components as x, y, and z, and w set to 0.

**Example:**

```js
local v = Vector(1, 2, 3)
local q = math.Quaternion.fromVector(v) // Create a quaternion from the vector
```

### `rotateVector(vector)`

This method rotates a vector by the quaternion.

**Parameters:**

* `vector` (Vector): The vector to rotate.

**Returns:**

* (Vector): The rotated vector.

**Example:**

```js
local rotatedVec = q.rotateVector(Vector(1, 0, 0)) // Rotate the vector (1, 0, 0) by the quaternion q
```

### `unrotateVector(vector)`

This method un-rotates a vector by the quaternion, reversing the rotation that would be applied by `rotateVector`.

**Parameters:**

* `vector` (Vector): The vector to un-rotate.

**Returns:**

* (Vector): The un-rotated vector.

**Example:**

```js
local originalVec = q.unrotateVector(rotatedVec) // Un-rotate the vector back to its original orientation
```

### `slerp(targetQuaternion, t)`

This method performs spherical linear interpolation (slerp) between this quaternion and the target quaternion. Slerp is a more sophisticated interpolation technique than linear interpolation, resulting in a smoother transition between orientations.

**Parameters:**

* `targetQuaternion` (Quaternion): The target quaternion to interpolate towards.
* `t` (number): The interpolation parameter between 0 and 1.

**Returns:**

* (Quaternion): The interpolated quaternion.

**Example:**

```js
local q1 = math.Quaternion.fromEuler(Vector(0, 0, 0)) // Starting orientation
local q2 = math.Quaternion.fromEuler(Vector(0, 90, 0)) // Ending orientation
local interpolatedQ = q1.slerp(q2, 0.5) // Interpolate halfway between the two orientations
```

### `normalize()`

This method normalizes the quaternion, scaling its components so that its length (magnitude) is 1. Normalization is often necessary for quaternion operations to work correctly.

**Returns:**

* (Quaternion): The normalized quaternion.

**Example:**

```js
local normalizedQ = q.normalize() // Normalize the quaternion q
```

### `dot(other)`

This method calculates the dot product of this quaternion and another quaternion.

**Parameters:**

* `other` (Quaternion): The other quaternion to calculate the dot product with.

**Returns:**

* (number): The dot product of the two quaternions.

**Example:**

```js
local dotProduct = q1.dot(q2) // Calculate the dot product of q1 and q2
```

### `length()`

This method calculates the length (magnitude) of the quaternion.

**Returns:**

* (number): The length of the quaternion.

**Example:**

```js
local quaternionLength = q.length() // Get the length of the quaternion q
```

### `inverse()`

This method calculates the inverse of the quaternion. The inverse of a quaternion is the quaternion that, when multiplied by the original quaternion, results in the identity quaternion (no rotation).

**Returns:**

* (Quaternion): The inverse of the quaternion.

**Example:**

```js
local inverseQ = q.inverse() // Calculate the inverse of the quaternion q
```

### `fromAxisAngle(axis, angle)`

This method creates a quaternion from an axis and an angle of rotation around that axis.

**Parameters:**

* `axis` (Vector): The axis of rotation (should be a normalized vector).
* `angle` (number): The angle of rotation in radians.

**Returns:**

* (Quaternion): The quaternion representing the rotation around the given axis.

**Example:**

```js
local axis = Vector(0, 1, 0) // Rotate around the Y axis
local angle = math.rad(45) // Rotate 45 degrees
local q = math.Quaternion.fromAxisAngle(axis, angle) // Create a quaternion for the rotation
```

### `toAxisAngle()`

This method converts the quaternion to an axis and an angle of rotation around that axis.

**Returns:**

* (table): A table with two keys:
* `axis` (Vector): The axis of rotation.
* `angle` (number): The angle of rotation in radians.

**Example:**

```js
local axisAngle = q.toAxisAngle()
printl("Axis:" + axisAngle.axis)
printl("Angle:" + math.deg(axisAngle.angle))
```

### `toVector()`

This method converts the quaternion to a vector representing Euler angles (pitch, yaw, roll) in degrees.

**Returns:**

* (Vector): The Euler angles corresponding to the quaternion's rotation.

**Example:**

```js
local eulerAngles = q.toVector() // Convert the quaternion to Euler angles
```

### `IsEqual(other)`

This method checks if this quaternion is equal to another quaternion based on their components and length. It uses a more precise comparison than simply checking for exact equality of the components due to potential floating-point precision errors.

**Parameters:**

* `other` (Quaternion): The other quaternion to compare.

**Returns:**

* (boolean): True if the quaternions are considered equal, false otherwise.

**Example:**

```js
local q1 = math.Quaternion.fromEuler(Vector(0, 45, 0))
local q2 = math.Quaternion.fromAxisAngle(Vector(0, 1, 0), math.rad(45))
if (q1.IsEqual(q2)) {
    // The quaternions represent the same rotation
}
```

### `cmp(other)`

This method compares this quaternion to another quaternion based on their magnitudes. It is used for sorting quaternions.

**Parameters:**

* `other` (Quaternion): The other quaternion to compare.

**Returns:**

* (number):
* 1 if this quaternion's magnitude is greater than the other quaternion's magnitude.
* -1 if this quaternion's magnitude is less than the other quaternion's magnitude.
* 0 if the magnitudes are equal.

**Example:**

```js
local q1 = math.Quaternion(1, 2, 3, 4)
local q2 = math.Quaternion(2, 3, 4, 5)
local comparisonResult = q1.cmp(q2) // comparisonResult will be -1 (q1's magnitude is less than q2's magnitude)
```

## [Math/matrix.nut](matrix.nut)

This file defines the `math.Matrix` class, which represents a 3x3 matrix (a mathematical object used for transformations in 3D space). The class provides methods for creating matrices from Euler angles, rotating and un-rotating vectors, transposing, inverting, calculating the determinant, scaling, rotating around the X axis, and performing matrix operations (multiplication, addition, and subtraction).

### `Matrix(a, b, c, d, e, f, g, h, k)`

**Constructor**

This creates a new matrix with the specified components.

**Parameters:**

* `a` (number): The value at row 1, column 1 of the matrix.
* `b` (number): The value at row 1, column 2 of the matrix.
* `c` (number): The value at row 1, column 3 of the matrix.
* `d` (number): The value at row 2, column 1 of the matrix.
* `e` (number): The value at row 2, column 2 of the matrix.
* `f` (number): The value at row 2, column 3 of the matrix.
* `g` (number): The value at row 3, column 1 of the matrix.
* `h` (number): The value at row 3, column 2 of the matrix.
* `k` (number): The value at row 3, column 3 of the matrix.

**Example:**

```js
local identityMatrix = math.Matrix(1, 0, 0, 0, 1, 0, 0, 0, 1) // Create an identity matrix
```

### `fromEuler(angles)`

This method creates a rotation matrix from Euler angles (pitch, yaw, roll).

**Parameters:**

* `angles` (Vector): The Euler angles in degrees (pitch, yaw, roll).

**Returns:**

* (Matrix): The rotation matrix corresponding to the given Euler angles.

**Example:**

```js
local rotationMatrix = math.Matrix.fromEuler(Vector(30, 45, 0)) // Create a rotation matrix from Euler angles
```

### `rotateVector(point)`

This method rotates a point using the matrix.

**Parameters:**

* `point` (Vector): The point to rotate.

**Returns:**

* (Vector): The rotated point.

**Example:**

```js
local rotatedPoint = rotationMatrix.rotateVector(Vector(1, 0, 0)) // Rotate the point (1, 0, 0) using the rotation matrix
```

### `unrotateVector(point)`

This method un-rotates a point using the matrix, reversing the rotation that would be applied by `rotateVector`.

**Parameters:**

* `point` (Vector): The point to un-rotate.

**Returns:**

* (Vector): The un-rotated point.

**Example:**

```js
local originalPoint = rotationMatrix.unrotateVector(rotatedPoint) // Un-rotate the point back to its original position
```

### `transpose()`

This method transposes the matrix, swapping its rows and columns.

**Returns:**

* (Matrix): The transposed matrix.

**Example:**

```js
local transposedMatrix = rotationMatrix.transpose() // Transpose the rotation matrix
```

### `inverse()`

This method calculates the inverse of the matrix. The inverse of a matrix is the matrix that, when multiplied by the original matrix, results in the identity matrix.

**Returns:**

* (Matrix): The inverse of the matrix.
* Throws an error if the matrix is singular (its determinant is zero).

**Example:**

```js
local inverseMatrix = rotationMatrix.inverse() // Calculate the inverse of the rotation matrix
```

### `determinant()`

This method calculates the determinant of the matrix. The determinant is a scalar value that can be used to determine properties of the matrix, such as whether it is invertible.

**Returns:**

* (number): The determinant of the matrix.

**Example:**

```js
local det = rotationMatrix.determinant() // Calculate the determinant of the rotation matrix
```

### `scale(factor)`

This method scales the matrix by a given factor. This multiplies each component of the matrix by the scaling factor.

**Parameters:**

* `factor` (number): The scaling factor.

**Returns:**

* (Matrix): The scaled matrix.

**Example:**

```js
local scaledMatrix = rotationMatrix.scale(2) // Scale the rotation matrix by a factor of 2
```

### `rotateX(angle)`

This method rotates the matrix around the X axis by a given angle. This is equivalent to pre-multiplying the matrix by a rotation matrix that rotates around the X axis.

**Parameters:**

* `angle` (number): The angle of rotation in radians.

**Returns:**

* (Matrix): The rotated matrix.

**Example:**

```js
local rotatedMatrixX = rotationMatrix.rotateX(math.rad(45)) // Rotate the matrix 45 degrees around the X axis
```

### `_mul(other)`

This method multiplies this matrix by another matrix. Matrix multiplication is not commutative, so the order of the matrices matters.

**Parameters:**

* `other` (Matrix): The other matrix to multiply by.

**Returns:**

* (Matrix): The result of the matrix multiplication.

**Example:**

```js
local resultMatrix = matrix1 * matrix2 // Multiply matrix1 by matrix2
```

### `_add(other)`

This method adds this matrix to another matrix. Matrix addition is commutative, so the order of the matrices does not matter.

**Parameters:**

* `other` (Matrix): The other matrix to add.

**Returns:**

* (Matrix): The result of the matrix addition.

**Example:**

```js
local resultMatrix = matrix1 + matrix2 // Add matrix1 and matrix2
```

### `_sub(other)`

This method subtracts another matrix from this matrix.

**Parameters:**

* `other` (Matrix): The matrix to subtract.

**Returns:**

* (Matrix): The result of the matrix subtraction.

**Example:**

```js
local resultMatrix = matrix1 - matrix2 // Subtract matrix2 from matrix1
```

### `IsEqual(other)`

This method checks if this matrix is equal to another matrix based on their components and sum. It uses a more precise comparison than simply checking for exact equality of the components due to potential floating-point precision errors.

**Parameters:**

* `other` (Matrix): The other matrix to compare.

**Returns:**

* (boolean): True if the matrices are considered equal, false otherwise.

**Example:**

```js
local matrix1 = math.Matrix(1, 2, 3, 4, 5, 6, 7, 8, 9)
local matrix2 = math.Matrix(1, 2, 3, 4, 5, 6, 7, 8, 9)
if (matrix1.IsEqual(matrix2)) {
    // The matrices are considered equal
}
```

### `cmp(other)`

This method compares this matrix to another matrix based on the sum of their components. It is used for sorting matrices.

**Parameters:**

* `other` (Matrix): The other matrix to compare.

**Returns:**

* (number):
* 1 if this matrix's sum is greater than the other matrix's sum.
* -1 if this matrix's sum is less than the other matrix's sum.
* 0 if the sums are equal.

**Example:**
```js
local matrix1 = math.Matrix(1, 2, 3, 4, 5, 6, 7, 8, 9)
local matrix2 = math.Matrix(2, 3, 4, 5, 6, 7, 8, 9, 10)
local comparisonResult = matrix1.cmp(matrix2)  // comparisonResult will be -1 (matrix1's sum is less than matrix2's sum)
```