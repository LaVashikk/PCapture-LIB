if(!("RunTests" in getroottable())) IncludeScript("PCapture-LIB/Tests/test_exec")

// Math module unit tests
math_tests <- {
    // Test the lerp function for integers
    function lerp_int() {
        local result = math.lerp.number(0, 100, 0.5)
        return assert(result == 50)
    },

    // Test the lerp function for vectors
    function lerp_vector() {
        local start = Vector(0, 0, 0)
        local end = Vector(10, 10, 10)
        local result = math.lerp.vector(start, end, 0.5)
        return assert(math.vector.IsEqual(result, Vector(5, 5, 5)))
    },

    // Test the lerp function for colors
    function lerp_color() {
        local start = "0 0 0"
        local end = "255 255 255"
        local result = math.lerp.color(start, end, 0.5)
        return assert(result == "127 127 127") // todo mb 128?
    },

    // Test the slerp function for vectors
    function slerp_vector() {
        local start = Vector(1, 0, 0)
        local end = Vector(0, 1, 0)
        local result = math.lerp.sVector(start, end, 0.5)
        local expected = Vector(0.5, 0.5, 0) //? why i get 0.500000, 0.500019, {0.002182}? 
        return assert(math.vector.IsEqual(result, expected))
    },

    // function ang2quad2vector() { 
    //     local vec = Vector(124, 92.2, 0)
    //     local q = math.Quaternion.fromEuler(vec)
    //     local result = q.toVector()
    //     return assert(math.vector.IsEqual(result, vec))
    // },

    // Test the SmoothStep function
    function SmoothStep() {
        local result = math.lerp.SmoothStep(0, 1, 0.5)
        return assert(result == 0.5)
    },

    // Test the FLerp function
    function FLerp() {
        local result = math.lerp.FLerp(0, 10, 0, 1, 0.5)
        return assert(result == 5)
    },

    /* InSine tests */ 
    function lerp_InSine_0() {
        local result = math.ease.InSine(0)
        return assert(result == 0) 
    }, 
    function lerp_InSine_0_5() {
        local result = math.ease.InSine(0.5) 
        return assert(math.round(result, 100) == 0.29)
    },
    function lerp_InSine_1() {
        local result = math.ease.InSine(1) 
        return assert(result == 1)
    },

    /* OutSine tests */
    function lerp_OutSine_0() {
        local result = math.ease.OutSine(0)
        return assert(result == 0)
    },
    function lerp_OutSine_0_5() {
        local result = math.ease.OutSine(0.5)
        return assert(math.round(result, 100) == 0.71)
    },
    function lerp_OutSine_1() {
        local result = math.ease.OutSine(1)
        return assert(result == 1)
    },

    /* InOutSine tests */
    function lerp_InOutSine_0() {
        local result = math.ease.InOutSine(0) 
        return assert(result == 0)
    },
    function lerp_InOutSine_0_5() {
        local result = math.ease.InOutSine(0.5)
        return assert(result == 0.5)
    },
    function lerp_InOutSine_1() {
        local result = math.ease.InOutSine(1)
        return assert(result == 1)
    },

    /* InQuad tests */
    function lerp_InQuad_0() {
        local result = math.ease.InQuad(0)
        return assert(result == 0)
    },
    function lerp_InQuad_0_5() {
        local result = math.ease.InQuad(0.5)
        return assert(result == 0.25)
    },
    function lerp_InQuad_1() {
        local result = math.ease.InQuad(1)
        return assert(result == 1)
    }, 

    /* OutQuad tests */
    function lerp_OutQuad_0() {
        local result = math.ease.OutQuad(0)
        return assert(result == 0)
    },
    function lerp_OutQuad_0_5() {
        local result = math.ease.OutQuad(0.5)
        return assert(result == 0.75)
    },
    function lerp_OutQuad_1() {
        local result = math.ease.OutQuad(1)
        return assert(result == 1)
    },

    /* InOutQuad tests */
    function lerp_InOutQuad_0() {
        local result = math.ease.InOutQuad(0)
        return assert(result == 0) 
    },
    function lerp_InOutQuad_0_5() {
        local result = math.ease.InOutQuad(0.5)
        return assert(result == 0.5) 
    },
    function lerp_InOutQuad_1() {
        local result = math.ease.InOutQuad(1)
        return assert(result == 1)
    },

    /* InCubic tests */
    function lerp_InCubic_0() {
        local result = math.ease.InCubic(0)
        return assert(result == 0)
    },
    function lerp_InCubic_0_5() {
        local result = math.ease.InCubic(0.5)
        return assert(result == 0.125)
    },
    function lerp_InCubic_1() {
        local result = math.ease.InCubic(1)
        return assert(result == 1)
    }, 

    /* OutCubic tests */ 
    function lerp_OutCubic_0() { 
        local result = math.ease.OutCubic(0)
        return assert(result == 0)
    },
    function lerp_OutCubic_0_5() {
        local result = math.ease.OutCubic(0.5) 
        return assert(result == 0.875)
    }, 
    function lerp_OutCubic_1() {
        local result = math.ease.OutCubic(1)
        return assert(result == 1)
    },

    /* InOutCubic tests */ 
    function lerp_InOutCubic_0() {
        local result = math.ease.InOutCubic(0)
        return assert(result == 0)
    }, 
    function lerp_InOutCubic_0_5() {
        local result = math.ease.InOutCubic(0.5) 
        return assert(result == 0.5)
    }, 
    function lerp_InOutCubic_1() {
        local result = math.ease.InOutCubic(1)
        return assert(result == 1)
    }, 

    /* InQuart tests */
    function lerp_InQuart_0() {
        local result = math.ease.InQuart(0) 
        return assert(result == 0) 
    }, 
    function lerp_InQuart_0_5() {
        local result = math.ease.InQuart(0.5) 
        return assert(result == 0.0625)
    },
    function lerp_InQuart_1() { 
        local result = math.ease.InQuart(1) 
        return assert(result == 1)
    }, 

    /* OutQuart tests */ 
    function lerp_OutQuart_0() {
        local result = math.ease.OutQuart(0) 
        return assert(result == 0)
    }, 
    function lerp_OutQuart_0_5() { 
        local result = math.ease.OutQuart(0.5) 
        return assert(result == 0.9375)
    },
    function lerp_OutQuart_1() { 
        local result = math.ease.OutQuart(1) 
        return assert(result == 1)
    }, 

    /* InOutQuart tests */
    function lerp_InOutQuart_0() { 
        local result = math.ease.InOutQuart(0) 
        return assert(result == 0) 
    },
    function lerp_InOutQuart_0_5() {
        local result = math.ease.InOutQuart(0.5) 
        return assert(result == 0.5) 
    },
    function lerp_InOutQuart_1() {
        local result = math.ease.InOutQuart(1) 
        return assert(result == 1)
    },

    /* InQuint tests */
    function lerp_InQuint_0() { 
        local result = math.ease.InQuint(0) 
        return assert(result == 0)
    }, 
    function lerp_InQuint_0_5() { 
        local result = math.ease.InQuint(0.5) 
        return assert(result == 0.03125) 
    },
    function lerp_InQuint_1() {
        local result = math.ease.InQuint(1) 
        return assert(result == 1) 
    }, 

    /* OutQuint tests */
    function lerp_OutQuint_0() { 
        local result = math.ease.OutQuint(0) 
        return assert(result == 0) 
    }, 
    function lerp_OutQuint_0_5() { 
        local result = math.ease.OutQuint(0.5) 
        return assert(result == 0.96875)
    },
    function lerp_OutQuint_1() { 
        local result = math.ease.OutQuint(1) 
        return assert(result == 1)
    },

    /* InOutQuint tests */
    function lerp_InOutQuint_0() { 
        local result = math.ease.InOutQuint(0) 
        return assert(result == 0)
    }, 
    function lerp_InOutQuint_0_5() {
        local result = math.ease.InOutQuint(0.5)
        return assert(result == 0.5)
    }, 
    function lerp_InOutQuint_1() {
        local result = math.ease.InOutQuint(1)
        return assert(result == 1)
    }, 

    /* InExpo tests */
    function lerp_InExpo_0() {
        local result = math.ease.InExpo(0) 
        return assert(result == 0)
    }, 
    function lerp_InExpo_0_5() { 
        local result = math.ease.InExpo(0.5)
        return assert(math.round(result, 100) == 0.03)
    }, 
    function lerp_InExpo_1() {
        local result = math.ease.InExpo(1) 
        return assert(result == 1) 
    },

    /* OutExpo tests */ 
    function lerp_OutExpo_0() {
        local result = math.ease.OutExpo(0) 
        return assert(result == 0)
    }, 
    function lerp_OutExpo_0_5() {
        local result = math.ease.OutExpo(0.5) 
        return assert(math.round(result, 100) == 0.97)
    }, 
    function lerp_OutExpo_1() {
        local result = math.ease.OutExpo(1) 
        return assert(result == 1)
    }, 

    /* InOutExpo tests */
    function lerp_InOutExpo_0() {
        local result = math.ease.InOutExpo(0)
        return assert(result == 0) 
    }, 
    function lerp_InOutExpo_0_5() {
        local result = math.ease.InOutExpo(0.5)
        return assert(result == 0.5)
    }, 
    function lerp_InOutExpo_1() {
        local result = math.ease.InOutExpo(1) 
        return assert(result == 1)
    }, 

    /* InCirc tests */
    function lerp_InCirc_0() {
        local result = math.ease.InCirc(0) 
        return assert(result == 0) 
    },
    function lerp_InCirc_0_5() {
        local result = math.ease.InCirc(0.5)
        return assert(math.round(result, 100) == 0.13) 
    }, 
    function lerp_InCirc_1() {
        local result = math.ease.InCirc(1) 
        return assert(result == 1)
    }, 

    /* OutCirc tests */
    function lerp_OutCirc_0() { 
        local result = math.ease.OutCirc(0) 
        return assert(result == 0)
    }, 
    function lerp_OutCirc_0_5() { 
        local result = math.ease.OutCirc(0.5)
        return assert(math.round(result, 100) == 0.87)
    }, 
    function lerp_OutCirc_1() { 
        local result = math.ease.OutCirc(1)
        return assert(result == 1)
    }, 

    /* InOutCirc tests */
    function lerp_InOutCirc_0() {
        local result = math.ease.InOutCirc(0)
        return assert(result == 0)
    },
    function lerp_InOutCirc_0_5() {
        local result = math.ease.InOutCirc(0.5)
        return assert(result == 0.5)
    }, 
    function lerp_InOutCirc_1() { 
        local result = math.ease.InOutCirc(1)
        return assert(result == 1)
    },

    /* InBack tests */
    function lerp_InBack_0() { 
        local result = math.ease.InBack(0)
        return assert(result == 0) 
    }, 
    function lerp_InBack_1() { 
        local result = math.ease.InBack(1) 
        return assert(result == 1)
    },

    /* OutBack tests */
    function lerp_OutBack_0() {
        local result = math.ease.OutBack(0) 
        return assert(result == 0)
    },
    function lerp_OutBack_1() {
        local result = math.ease.OutBack(1)
        return assert(result == 1) 
    },

    /* InOutBack tests */
    function lerp_InOutBack_0() { 
        local result = math.ease.InOutBack(0)
        return assert(result == 0) 
    }, 
    function lerp_InOutBack_1() {
        local result = math.ease.InOutBack(1) 
        return assert(result == 1)
    }, 

    /* InElastic tests */
    function lerp_InElastic_0() {
        local result = math.ease.InElastic(0) 
        return assert(result == 0) 
    }, 
    function lerp_InElastic_1() { 
        local result = math.ease.InElastic(1)
        return assert(result == 1) 
    }, 

    /* OutElastic tests */
    function lerp_OutElastic_0() {
        local result = math.ease.OutElastic(0)
        return assert(result == 0) 
    }, 
    function lerp_OutElastic_1() {
        local result = math.ease.OutElastic(1) 
        return assert(result == 1)
    },

    /* InOutElastic tests */
    function lerp_InOutElastic_0() {
        local result = math.ease.InOutElastic(0) 
        return assert(result == 0) 
    }, 
    function lerp_InOutElastic_1() { 
        local result = math.ease.InOutElastic(1)
        return assert(result == 1) 
    }, 

    /* InBounce tests */
    function lerp_InBounce_0() {
        local result = math.ease.InBounce(0)
        return assert(result == 0)
    }, 
    function lerp_InBounce_1() { 
        local result = math.ease.InBounce(1)
        return assert(result == 1)
    },

    /* OutBounce tests */
    function lerp_OutBounce_0() {
        local result = math.ease.OutBounce(0) 
        return assert(result == 0) 
    },
    function lerp_OutBounce_1() {
        local result = math.ease.OutBounce(1)
        return assert(result == 1)
    }, 

    /* InOutBounce tests */
    function lerp_InOutBounce_0() {
        local result = math.ease.InOutBounce(0)
        return assert(result == 0)
    },
    function lerp_InOutBounce_1() { 
        local result = math.ease.InOutBounce(1)
        return assert(result == 1) 
    },

    // Test the min function
    function min() {
        local result = math.min(1, 2, 3, 0, -1)
        return assert(result == -1)
    },

    // Test the max function
    function max() {
        local result = math.max(1, 2, 3, 0, -1)
        return assert(result == 3)
    },

    // Test the clamp function
    function clamp() {
        local result1 = math.clamp(5, 0, 10)
        local result2 = math.clamp(-1, 0, 10)
        local result3 = math.clamp(11, 0, 10)
        return assert(result1 == 5 && result2 == 0 && result3 == 10)
    },

    // Test the vector clamp function
    function vector_clamp() {
        local result = math.vector.clamp(Vector(15,3,-5), 0, 10)
        return assert(result.x == 10 && result.y == 3 && result.z == 0)
    },

    function vector_abs() {
        local result = math.vector.abs(Vector(15,-3,-5))
        return assert(result.x == 15 && result.y == 3 && result.z == 5)
    },

    // Test the vector.round function
    function roundVector() {
        local vector = Vector(1.2345, 6.7890, -0.1234)
        local result = math.vector.round(vector, 1000)
        return assert(math.vector.IsEqual(result, Vector(1.235, 6.789, -0.123)))
    },

    // Test the Sign function
    function Sign() {
        local result1 = math.Sign(10)
        local result2 = math.Sign(-5)
        local result3 = math.Sign(0)
        return assert(result1 == 1 && result2 == -1 && result3 == 0)
    },

    // Test the copysign function
    function copysign() {
        local result1 = math.copysign(5, -1)
        local result2 = math.copysign(-3, 1)
        return assert(result1 == -5 && result2 == 3)
    },

    // Test the RemapVal function
    function RemapVal() {
        local result1 = math.RemapVal(5, 0, 10, 0, 100)
        local result2 = math.RemapVal(2.5, 0, 5, 10, 20)
        return assert(result1 == 50 && result2 == 15)
    },
    
    // Test the rotateVector function
    function rotateVector() {
        local vector = Vector(1, 0, 0)
        local angle = Vector(0, 90, 0)
        local result = math.vector.rotate(vector, angle)
        local expected = Vector(0, 1, 0)
        return assert(math.vector.IsEqual(result, expected))
    },

    // Test the unrotateVector function
    function unrotateVector() {
        local vector = Vector(0, 1, 0)
        local angle = Vector(0, 90, 0)
        local result = math.vector.unrotate(vector, angle)
        local expected = Vector(1, 0, 0)
        return assert(math.vector.IsEqual(result, expected))
    },

    // Test the random function
    function random() {
        local result = math.vector.random(0, 10)
        return assert(result.x >= 0 && result.x <= 10 && 
                      result.y >= 0 && result.y <= 10 &&
                      result.z >= 0 && result.z <= 10) 
    },

    // Test the reflect function
    function reflect() { 
        local dir = Vector(1, 0, 0)
        local normal = Vector(0, 1, 0)
        local result = math.vector.reflect(dir, normal)
        local expected = Vector(1, 0, 0) 
        return assert(math.vector.IsEqual(result, expected)) 
    },

    // Test the resize function
    function resize() { 
        local vector = Vector(2, 4, 6)
        local result = math.vector.resize(vector, 10)
        
        vector.Norm() 
        local expected = vector * 10  

        return assert(math.vector.IsEqual(result, expected))
    },

    // Quaternion tests
    function Quaternion_fromEuler() {
        local angles = Vector(0, 90, 0)
        local quat = math.Quaternion.fromEuler(angles)
        local expected = math.Quaternion(0, 0, 0.707107, 0.707107)
        
        return assert(quat.IsEqual(expected))
    },

    function Quaternion_fromVector() {
        local vector = Vector(1, 2, 3)
        local quat = math.Quaternion.fromVector(vector)
        return assert(quat.x == 1 && quat.y == 2 && quat.z == 3 && quat.w == 0)
    },

    function Quaternion_rotateVector() {
        local vector = Vector(1, 0, 0)
        local angle = Vector(0, 90, 0)
        local quat = math.Quaternion.fromEuler(angle)
        local result = quat.rotateVector(vector)
        local expected = Vector(0, 1, 0)
        return assert(math.vector.IsEqual(result, expected))
    },

    function Quaternion_unrotateVector() {
        local vector = Vector(0, 1, 0)
        local angle = Vector(0, 90, 0)
        local quat = math.Quaternion.fromEuler(angle) 
        local result = quat.unrotateVector(vector)
        local expected = Vector(1, 0, 0)
        return assert(math.vector.IsEqual(result, expected))
    },

    function Quaternion_slerp() {
        local start = math.Quaternion.fromEuler(Vector(0, 0, 0))
        local end = math.Quaternion.fromEuler(Vector(0, 90, 0))
        local result = start.slerp(end, 0.5) 
        local expected = math.Quaternion.fromEuler(Vector(0, 45, 0))
        return assert(result.IsEqual(expected))
    },

    function Quaternion_normalize() {
        local quat = math.Quaternion(1, 2, 3, 4)
        local result = quat.normalize()
        return assert(math.round(result.length(), 10000) == 1)
    },

    function Quaternion_dot() {
        local q1 = math.Quaternion(1, 2, 3, 4)
        local q2 = math.Quaternion(5, 6, 7, 8)
        local result = q1.dot(q2)
        return assert(result == 70)
    },

    function Quaternion_length() {
        local quat = math.Quaternion(1, 2, 3, 4)
        local result = quat.length()
        return assert(math.round(result, 10000) == 5.4772)
    },

    function Quaternion_inverse() {
        local quat = math.Quaternion(1, 2, 3, 4)
        local result = quat.inverse()
        return assert(math.round(result.length(), 100) == 0.18) 
    },

    function Quaternion_toAxisAngle() { 
        local quat = math.Quaternion(0.7071, 0, 0, 0.7071) 
        local result = quat.toAxisAngle() 
        local expectedAxis = Vector(1, 0, 0) 
        local expectedAngle = 1.57082 // 90 * PI / 180 
        return assert(math.vector.IsEqual(result.axis, expectedAxis) && math.round(result.angle, 1000) == math.round(expectedAngle, 1000)) 
    },

    // Matrix tests 
    function Matrix_fromEuler() {
        local angles = Vector(0, 90, 0)
        local matrix = math.Matrix.fromEuler(angles)
        local expected = math.Matrix(
            0, -1, 0,
            1, 0, 0,
            0, 0, 1
        )
        return assert(matrix.IsEqual(expected))
    },
    
    function Matrix_rotateVector() {
        local vector = Vector(1, 0, 0)
        local angle = Vector(0, 90, 0)
        local matrix = math.Matrix.fromEuler(angle)
        local result = matrix.rotateVector(vector)
        local expected = Vector(0, 1, 0)
        return assert(math.vector.IsEqual(result, expected))
    },

    function Matrix_unrotateVector() { 
        local vector = Vector(0, 1, 0) 
        local angle = Vector(0, 90, 0) 
        local matrix = math.Matrix.fromEuler(angle) 
        local result = matrix.unrotateVector(vector) 
        local expected = Vector(1, 0, 0) 
        return assert(math.vector.IsEqual(result, expected)) 
    },

    function Matrix_transpose() { 
        local matrix = math.Matrix( 
            1, 2, 3, 
            4, 5, 6, 
            7, 8, 9 
        ) 
        local result = matrix.transpose() 
        local expected = math.Matrix( 
            1, 4, 7, 
            2, 5, 8, 
            3, 6, 9 
        ) 
        return assert(result.IsEqual(expected)) 
    }, 
 
    function Matrix_inverse() { 
        local matrix = math.Matrix( 
            1, 2, 3, 
            0, 1, 4, 
            5, 6, 0 
        ) 
        local result = matrix.inverse() 
        local expected = math.Matrix( 
            -24, 18, 5, 
            20, -15, -4, 
            -5, 4, 1 
        ) 
        return assert(result.IsEqual(expected))
    }, 

    function Matrix_determinant() { 
        local matrix = math.Matrix( 
            1, 2, 3, 
            0, 1, 4, 
            5, 6, 0 
        ) 
        local result = matrix.determinant() 
        return assert(result == 1) 
    }, 

    function Matrix_scale() { 
        local matrix = math.Matrix( 
            1, 2, 3, 
            4, 5, 6, 
            7, 8, 9 
        ) 
        local result = matrix.scale(2) 
        local expected = math.Matrix( 
            2, 4, 6, 
            8, 10, 12, 
            14, 16, 18 
        ) 
        return assert(result.IsEqual(expected)) 
    }, 
}

// Run all tests
RunTests("Math", math_tests)