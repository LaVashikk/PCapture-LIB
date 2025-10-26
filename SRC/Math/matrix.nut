math["Matrix"] <- class {
    a = 1; b = 0; c = 0;
    d = 0; e = 1; f = 0;
    g = 0; h = 0; k = 1;

    /*
     * Creates a new matrix.
     * 
     * @param {number} a - The value at row 1, column 1.
     * @param {number} b - The value at row 1, column 2.
     * @param {number} c - The value at row 1, column 3.
     * @param {number} d - The value at row 2, column 1.
     * @param {number} e - The value at row 2, column 2.
     * @param {number} f - The value at row 2, column 3.
     * @param {number} g - The value at row 3, column 1.
     * @param {number} h - The value at row 3, column 2.
     * @param {number} k - The value at row 3, column 3.
    */
    constructor(a = 1, b = 0, c = 0,
                d = 0, e = 1, f = 0,
                g = 0, h = 0, k = 1
        ) {
            this.a = a; this.b = b; this.c = c;
            this.d = d; this.e = e; this.f = f;
            this.g = g; this.h = h; this.k = k;
        }
    /*
     * Creates a rotation matrix from Euler angles.
     * 
     * @param {Vector} angles - Euler angles in degrees (pitch, yaw, roll).
     * @returns {Matrix} - The rotation matrix.
    */
    function fromEuler(angles) {
        local sinX = sin(-angles.z / 180 * PI);
        local cosX = cos(-angles.z / 180 * PI);
        local sinY = sin(-angles.x / 180 * PI);
        local cosY = cos(-angles.x / 180 * PI);
        local sinZ = sin(-angles.y / 180 * PI);
        local cosZ = cos(-angles.y / 180 * PI);
        return math.Matrix(
            cosY * cosZ, -sinX * -sinY * cosZ + cosX * sinZ, cosX * -sinY * cosZ + sinX * sinZ,
            cosY * -sinZ, -sinX * -sinY * -sinZ + cosX * cosZ, cosX * -sinY * -sinZ + sinX * cosZ,
            sinY, -sinX * cosY, cosX * cosY
        );
    }

    /*
     * Rotates a point using the matrix.
     * 
     * @param {Vector} point - The point to rotate.
     * @returns {Vector} - The rotated point.
    */
    function rotateVector(point) {
        return Vector(
            point.x * this.a + point.y * this.b + point.z * this.c,
            point.x * this.d + point.y * this.e + point.z * this.f,
            point.x * this.g + point.y * this.h + point.z * this.k
        );
    }

    /*
     * Unrotates a point using the matrix.
     * 
     * @param {Vector} point - The point to unrotate.
     * @returns {Vector} - The unrotated point.
    */
    function unrotateVector(point) {
        return Vector(
            point.x * this.a + point.y * this.d + point.z * this.g,
            point.x * this.b + point.y * this.e + point.z * this.h,
            point.x * this.c + point.y * this.f + point.z * this.k
        );
    }

    /*
     * Transposes the matrix.
     * 
     * @returns {Matrix} - The transposed matrix.
    */
    function transpose() {
        return math.Matrix(
            this.a, this.d, this.g,
            this.b, this.e, this.h,
            this.c, this.f, this.k
        );
    }

    /*
     * Calculates the inverse of the matrix.
     * 
     * @returns {Matrix} - The inverse matrix.
     * @throws {Error} - If the matrix is singular (determinant is zero).
    */
    function inverse() {
        local det = this.determinant();
        if (det == 0) {
            throw "Matrix is singular (determinant is zero)"
        }
        local invDet = 1 / det;
        return math.Matrix(
            (this.e * this.k - this.f * this.h) * invDet,
            (this.c * this.h - this.b * this.k) * invDet,
            (this.b * this.f - this.c * this.e) * invDet,
            (this.f * this.g - this.d * this.k) * invDet,
            (this.a * this.k - this.c * this.g) * invDet,
            (this.c * this.d - this.a * this.f) * invDet,
            (this.d * this.h - this.e * this.g) * invDet,
            (this.b * this.g - this.a * this.h) * invDet,
            (this.a * this.e - this.b * this.d) * invDet
        );
    }

    /*
     * Calculates the determinant of the matrix.
     * 
     * @returns {number} - The determinant of the matrix.
    */
    function determinant() {
        return this.a * (this.e * this.k - this.f * this.h) -
               this.b * (this.d * this.k - this.f * this.g) +
               this.c * (this.d * this.h - this.e * this.g);
    }

    /*
     * Scales the matrix by a given factor.
     * 
     * @param {number} factor - The scaling factor.
     * @returns {Matrix} - The scaled matrix.
    */
    function scale(factor) {
        return math.Matrix(
            this.a * factor, this.b * factor, this.c * factor,
            this.d * factor, this.e * factor, this.f * factor,
            this.g * factor, this.h * factor, this.k * factor
        );
    }

    /*
     * Rotates the matrix around the X axis by a given angle.
     * 
     * @param {number} angle - The angle of rotation in radians.
     * @returns {Matrix} - The rotated matrix.
    */
    function rotateX(angle) {
        local sinAngle = sin(angle);
        local cosAngle = cos(angle);
        return math.Matrix(
            1, 0, 0,
            0, cosAngle, -sinAngle,
            0, sinAngle, cosAngle
        ) * this;
    }

    /*
     * Multiplies two matrices.
     * 
     * @param {Matrix} other - The other matrix.
     * @returns {Matrix} - The result of the multiplication.
    */
    function _mul(other) {
        return math.Matrix(
            this.a * other.a + this.b * other.d + this.c * other.g,
            this.a * other.b + this.b * other.e + this.c * other.h,
            this.a * other.c + this.b * other.f + this.c * other.k,
            this.d * other.a + this.e * other.d + this.f * other.g,
            this.d * other.b + this.e * other.e + this.f * other.h,
            this.d * other.c + this.e * other.f + this.f * other.k,
            this.g * other.a + this.h * other.d + this.k * other.g,
            this.g * other.b + this.h * other.e + this.k * other.h,
            this.g * other.c + this.h * other.f + this.k * other.k
        );
    }

    /*
     * Adds two matrices.
     * 
     * @param {Matrix} other - The other matrix.
     * @returns {Matrix} - The result of the addition.
    */
    function _add(other) {
        return math.Matrix(
            this.a + other.a, this.b + other.b, this.c + other.c,
            this.d + other.d, this.e + other.e, this.f + other.f,
            this.g + other.g, this.h + other.h, this.k + other.k
        );
    }

    /*
     * Subtracts two matrices.
     * 
     * @param {Matrix} other - The other matrix.
     * @returns {Matrix} - The result of the subtraction.
    */
    function _sub(other) {
        return math.Matrix(
            this.a - other.a, this.b - other.b, this.c - other.c,
            this.d - other.d, this.e - other.e, this.f - other.f,
            this.g - other.g, this.h - other.h, this.k - other.k
        );
    }

    /*
     * Checks if two matrices are equal based on their components and sum.
     *
     * @param {Matrix} other - The other matrix to compare.
     * @returns {boolean} - True if the matrices are equal, false otherwise.
    */
    function IsEqual(other) {
        return this.cmp(other) == 0
    }

    /*
     * Compares two matrices based on the sum of their components.
     *
     * @param {Matrix} other - The other matrix to compare.
     * @returns {number} - 1 if this matrix's sum is greater, -1 if less, 0 if equal.
    */
    function cmp(other) {
        if (typeof other != "Matrix") {
            throw "Cannot compare matrix with non-matrix type";
        }
    
        local thisSum = a + b - c + d + e + f - g + h - k;
        local otherSum = other.a + other.b - other.c + other.d + other.e + other.f - other.g + other.h - other.k;
        
        if (thisSum > otherSum) {
            return 1;
        } else if (thisSum < otherSum) {
            return -1;
        } else {
            return 0;
        }
    }

    function _cmp(other) return this.cmp(other)

    function _tostring() {
        return "Matrix: {" + a + ", " + b + ", " + c + "\n\t " + d + ", " + e + ", " + f + "\n\t " + g + ", " + h + ", " + k + "}"
    }

    function _typeof() {
        return "Matrix"
    }
}