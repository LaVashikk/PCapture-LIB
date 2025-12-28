// Utils Module Unit Tests
if(!("RunTests" in getroottable())) IncludeScript("PCapture-LIB/Tests/test_exec")

utils_tests <- {
    // --- Debug Tests ---
    function debug_draw_entity_bbox_test() {
        local ent = GetPlayerEx()
        dev.DrawEntityBBox(ent, Vector(125, 0, 0), 10.0)
    },

    function debug_log_test() {
        dev.info("This is a test log message.")
    },

    function debug_warning_test() {
        dev.warning("This is a test warning message.")
    },

    function debug_error_test() {
        dev.error("This is a test error message.")
    },

    function debug_format_test() {
        local formattedString = macros.format("Name: {}, Age: {}", "John", 30)
        return assert(formattedString == "Name: John, Age: 30")
    },

    // --- Macros Tests --- 
    function macros_get_from_table_test() {
        local table = {key1 = "value1", key2 = "value2"}
        return assert(macros.GetFromTable(table, "key1") == "value1" && macros.GetFromTable(table, "key3", "default") == "default")
    },

    function macros_get_dist_test() {
        local vec1 = Vector(0, 0, 0) 
        local vec2 = Vector(10, 0, 0)
        return assert(macros.GetDist(vec1, vec2) == 10)
    },

    function macros_strtovec_test() {
        local vec = macros.StrToVec("10 20 30")
        return assert(vec.x == 10 && vec.y == 20 && vec.z == 30)
    },

    function macros_get_prefix_test() {
        return assert(macros.GetPrefix("prefix-postfix") == "prefix-")
    },

    function macros_get_postfix_test() {
        return assert(macros.GetPostfix("prefix-postfix") == "-postfix")
    },

    function macros_IsEqual() {
        return assert(
            macros.IsEqual(11343, 11343) && 
            macros.IsEqual(1.543543, 1.54354) &&
            macros.IsEqual(Vector(1,2,3.43), Vector(1,2,3.43)) &&
            macros.IsEqual(GetPlayer(), GetPlayer()) && 
            macros.IsEqual(GetPlayerEx(), GetPlayer()) && 
            macros.IsEqual(math.Quaternion.fromEuler(Vector(0, 90, 0)), math.Quaternion.fromEuler(Vector(0, 90, 0))) && 
            macros.IsEqual(math.Matrix.fromEuler(Vector(0, 90, 0)), math.Matrix.fromEuler(Vector(0, 90, 0)))
        )
    }
}

// Run all tests
RunTests("Utils", utils_tests) 