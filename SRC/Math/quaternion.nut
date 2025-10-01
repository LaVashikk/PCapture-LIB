math["Quaternion"] <- class {
    x = null;
    y = null;
    z = null;
    w = null;
    
    /*
     * Creates a new quaternion.
     *
     * @param {number} x - The x component.
     * @param {number} y - The y component.
     * @param {number} z - The z component.
     * @param {number} w - The w component.
    */
    constructor(x,y,z,w) {
        this.x = x
        this.y = y
        this.z = z
        this.w = w
    }

    /*
     * Creates a new quaternion from Euler angles.
     *
     * @param {Vector} angles - The Euler angles in degrees (pitch, yaw, roll).
     * @returns {Quaternion} - The new quaternion.
    */
    function fromEuler(angles) {
        // Convert angles to radians
        local pitch = angles.z * 0.5 / 180 * PI
        local yaw = angles.y * 0.5 / 180 * PI
        local roll = angles.x * 0.5 / 180 * PI

        // Calculate sine and cosine values
        local sRoll = sin(roll);
        local cRoll = cos(roll);
        local sPitch = sin(pitch);
        local cPitch = cos(pitch);
        local sYaw = sin(yaw);
        local cYaw = cos(yaw);

        // Calculate quaternion components
        return math.Quaternion(
            cYaw * cRoll * sPitch - sYaw * sRoll * cPitch,
            cYaw * sRoll * cPitch + sYaw * cRoll * sPitch,
            sYaw * cRoll * cPitch - cYaw * sRoll * sPitch,
            cYaw * cRoll * cPitch + sYaw * sRoll * sPitch
        )
    }

    /*
     * Creates a new quaternion from a vector.
     *
     * @param {Vector} vector - The vector.
     * @returns {Quaternion} - The new quaternion with the vector's components as x, y, z, and w set to 0.
    */
    function fromVector(vector) {
        return math.Quaternion(vector.x, vector.y, vector.z, 0)
    }


    /*
     * Rotates a vector by the quaternion.
     *
     * @param {Vector} vector - The vector to rotate.
     * @returns {Vector} - The rotated vector.
    */
    function rotateVector(vector) {
        // Convert vector to quaternion
        local vecQuaternion = this.fromVector(vector)
    
        // Find the inverse quaternion
        local inverse = math.Quaternion(
            -this.x,
            -this.y,
            -this.z,
            this.w
        )
    
        // Apply quaternion rotations to the vector
        local rotatedQuaternion = this * vecQuaternion * inverse;
    
        // Return the result as a rotated vector
        return Vector(rotatedQuaternion.x, rotatedQuaternion.y, rotatedQuaternion.z);
    }
    
    /*
     * Un-rotates a vector by the quaternion.
     *
     * @param {Vector} vector - The vector to un-rotate.
     * @returns {Vector} - The un-rotated vector.
    */
    function unrotateVector(vector) {
        local vecQuaternion = this.fromVector(vector)

        // Find the conjugate quaternion
        local conjugateQuaternion = math.Quaternion(
            -this.x,
            -this.y,
            -this.z,
            this.w
        );
        
        // Apply quaternion rotations to the vector with inverse rotation angles
        local unrotatedQuaternion = conjugateQuaternion * vecQuaternion * this;
    
        // Return the result as an un-rotated vector
        return Vector(unrotatedQuaternion.x, unrotatedQuaternion.y, unrotatedQuaternion.z);
    }

    /*
     * Performs spherical linear interpolation (slerp) between two quaternions.
     *
     * @param {Quaternion} targetQuaternion - The target quaternion to interpolate towards.
     * @param {Number} t - The interpolation parameter between 0 and 1.
     * @returns {Quaternion} - The interpolated quaternion.
    */
    function slerp(targetQuaternion, t) {
        // Normalize quaternions
        local quaternion1 = this.normalize()
        local quaternion2 = targetQuaternion.normalize()

        // Calculate angle between quaternions
        local cosTheta = quaternion1.x * quaternion2.x + quaternion1.y * quaternion2.y + quaternion1.z * quaternion2.z + quaternion1.w * quaternion2.w;

        // If angle is negative, invert the second quaternion
        if (cosTheta < 0) {
            quaternion2.x *= -1;
            quaternion2.y *= -1;
            quaternion2.z *= -1;
            quaternion2.w *= -1;
            cosTheta *= -1;
        }

        // Calculate interpolation values
        local theta = acos(cosTheta);
        local sinTheta = sin(theta);
        local weight1 = sin((1 - t) * theta) / sinTheta;
        local weight2 = sin(t * theta) / sinTheta;

        // Interpolate quaternions
        local resultQuaternion = math.Quaternion(
            weight1 * quaternion1.x + weight2 * quaternion2.x,
            weight1 * quaternion1.y + weight2 * quaternion2.y,
            weight1 * quaternion1.z + weight2 * quaternion2.z,
            weight1 * quaternion1.w + weight2 * quaternion2.w
        );

        return resultQuaternion.normalize()
    }

    /*
     * Normalizes the quaternion.
     *
     * @returns {Quaternion} - The normalized quaternion.
    */
    function normalize() {
        local magnitude = this.length()
        if(magnitude == 0) throw "Quaternion.normalize: zero length"

        return math.Quaternion(
            this.x / magnitude,
            this.y / magnitude,
            this.z / magnitude,
            this.w / magnitude
        )
    }

    /*
     * Calculates the dot product of two quaternions.
     * 
     * @param {Quaternion} other - The other quaternion.
     * @returns {number} - The dot product.
    */
    function dot(other) {
        return this.x * other.x + this.y * other.y + this.z * other.z + this.w * other.w;
    }

    /*
     * Calculates the length (magnitude) of the quaternion.
     * 
     * @returns {number} - The length of the quaternion.
    */
    function length() {
        return sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
    }

    /*
     * Calculates the inverse of the quaternion.
     * 
     * @returns {Quaternion} - The inverse quaternion.
    */
    function inverse() {
        local len2 = this.length() * this.length();
        if (len2 == 0) throw "Quaternion.inverse: zero length";
        return math.Quaternion(-this.x / len2, -this.y / len2, -this.z / len2, this.w / len2);
    }

    /*
     * Creates a quaternion from an axis and an angle.
     * 
     * @param {Vector} axis - The axis of rotation (normalized vector).
     * @param {number} angle - The angle of rotation in radians.
     * @returns {Quaternion} - The quaternion.
    */
    function fromAxisAngle(axis, angle) {
        local halfAngle = angle * 0.5;
        local sinHalfAngle = sin(halfAngle);
        return math.Quaternion(axis.x * sinHalfAngle, axis.y * sinHalfAngle, axis.z * sinHalfAngle, cos(halfAngle));
    }

    /*
     * Converts the quaternion to an axis and an angle.
     * 
     * @returns {table} - A table with keys "axis" (Vector) and "angle" (number).
    */
    function toAxisAngle() {
        local scale = sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
        if (scale < 0.001) {
            return { axis = Vector(1, 0, 0), angle = 0 };
        }
        return { 
            axis = Vector(this.x / scale, this.y / scale, this.z / scale), 
            angle = 2 * acos(this.w) 
        };
    }


    /*
     * Converts the quaternion to a vector representing Euler angles.
     *
     * @returns {Vector} - The vector representing Euler angles in degrees.
    */
    function toVector() {
        local sinr_cosp = 2 * (this.w * this.x + this.y * this.z);
        local cosr_cosp = 1 - 2 * (this.x * this.x + this.y * this.y);
        local roll = atan2(sinr_cosp, cosr_cosp);

        local sinp = 2 * (this.w * this.y - this.z * this.x);
        local pitch;
        if (abs(sinp) >= 1) {
            pitch = math.copysign(PI / 2, sinp); // PI/2 or -PI/2
        } else {
            pitch = asin(sinp);
        }

        local siny_cosp = 2 * (this.w * this.z + this.x * this.y);
        local cosy_cosp = 1 - 2 * (this.y * this.y + this.z * this.z);
        local yaw = atan2(siny_cosp, cosy_cosp);

        // Convert angles to degrees
        local x = pitch * 180 / PI;
        local y = yaw * 180 / PI;
        local z = roll * 180 / PI;

        return Vector( x, y, z )
    }

    /* 
     * Checks if two quaternions are equal based on their components and length.
     *
     * @param {Quaternion} other - The other quaternion to compare.
     * @returns {boolean} - True if the quaternions are equal, false otherwise.
    */
    function isEqually(other) {
        return this.cmp(other) == 0
    }

    /*
     * Compares two quaternions based on their magnitudes.
     *
     * @param {Quaternion} other - The other quaternion to compare.
     * @returns {number} - 1 if this quaternion's magnitude is greater, -1 if less, 0 if equal.
    */
    function cmp(other) {
        if (typeof other != "Quaternion") {
            throw "Cannot compare quaternion with non-quaternion type";
        }
    
        local thisMagnitude = math.round(this.length(), 10000);
        local otherMagnitude = math.round(other.length(), 10000);

        if (thisMagnitude > otherMagnitude) {
            return 1;
        } else if (thisMagnitude < otherMagnitude) {
            return -1;
        } else {
            return 0; 
        }
    }

    function _cmp(other) return this.cmp(other)


    function _add(other) {
        return math.Quaternion(
            this.x + other.x,
            this.y + other.y,
            this.z + other.z,
            this.w + other.w
        )
    }


    function _sub(other) {
        return math.Quaternion(
            this.x - other.x,
            this.y - other.y,
            this.z - other.z,
            this.w - other.w
        )
    }
    
    /*
     * Multiplies two quaternions.
     *
     * @param {Quaternion} other - The other quaternion.
     * @returns {Quaternion} - The multiplication result.
    */
    function _mul(other) {
        if(typeof other == "Quaternion") {
            return math.Quaternion(
                this.w * other.x + this.x * other.w + this.y * other.z - this.z * other.y,
                this.w * other.y - this.x * other.z + this.y * other.w + this.z * other.x,
                this.w * other.z + this.x * other.y - this.y * other.x + this.z * other.w,
                this.w * other.w - this.x * other.x - this.y * other.y - this.z * other.z
            )
        }

        return math.Quaternion( 
            this.x * other,
            this.y * other,
            this.z * other,
            this.w * other
        )
    }

    function _tostring() {
        return "Quaternion: (" + x + ", " + y + ", " + z + ", " + w + ")"
    }

    function _typeof() {
        return "Quaternion"
    }
}