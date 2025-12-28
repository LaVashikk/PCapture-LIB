if(!("RunTests" in getroottable())) IncludeScript("PCapture-Lib/Tests/test_exec")

tracePlusTests <- {
    function cheapTraceTest() {
        local startPos = Vector(0, 0, 0)
        local endPos = Vector(100, 0, 0)
        local traceResult = TracePlus.Cheap(startPos, endPos)
        return assert(traceResult.GetStartPos() == startPos && traceResult.GetEndPos() == endPos)
    },

    function cheapTraceFromEyesTest() {
        local player = GetPlayerEx()
        local distance = 100
        local traceResult = TracePlus.FromEyes.Cheap(distance, player)
        return assert(macros.IsEqual(traceResult.GetStartPos(), player.EyePosition()))
    },

    function bboxTraceTest() {
        local startPos = Vector(0, 0, 0)
        local endPos = Vector(100, 0, 0)
        local traceResult = TracePlus.Bbox(startPos, endPos)
        return assert(macros.IsEqual(traceResult.GetStartPos(), startPos) && macros.IsEqual(traceResult.GetEndPos(), endPos))
    },

    function bboxTraceFromEyesTest() {
        local player = GetPlayerEx()
        local distance = 100
        local traceResult = TracePlus.FromEyes.Bbox(distance, player)
        return assert(macros.IsEqual(traceResult.GetStartPos(), player.EyePosition()))
    },

    function portalCheapTraceTest() {
        local startPos = Vector(0, 0, 0)
        local endPos = Vector(100, 0, 0)
        local traceResult = TracePlus.PortalCheap(startPos, endPos)
        return assert(traceResult.GetStartPos() == startPos && traceResult.GetEndPos() == endPos)
    },

    function portalCheapTraceFromEyesTest() {
        local player = GetPlayerEx()
        local distance = 100
        local traceResult = TracePlus.FromEyes.PortalCheap(distance, player)
        return assert(macros.IsEqual(traceResult.GetStartPos(), player.EyePosition()))
    },

    function portalBboxTraceTest() {
        local startPos = Vector(0, 0, 0)
        local endPos = Vector(100, 0, 0)
        local traceResult = TracePlus.PortalBbox(startPos, endPos)
        return assert(traceResult.GetStartPos() == startPos && traceResult.GetEndPos() == endPos)
    },

    function portalBboxTraceFromEyesTest() {
        local player = GetPlayerEx()
        local distance = 100
        local traceResult = TracePlus.FromEyes.PortalBbox(distance, player)
        return assert(macros.IsEqual(traceResult.GetStartPos(), player.EyePosition()))
    },

    function traceSettingsNewTest() {
        local settings = TracePlus.Settings.new()
        return assert(typeof settings == "TraceSettings")
    },

    function traceSettingsSetIgnoredClassesTest() {
        local settings = TracePlus.Settings.new()
        local ignoredClasses = ArrayEx("prop_physics")
        settings.SetIgnoredClasses(ignoredClasses)
        return assert(settings.GetIgnoreClasses() == ignoredClasses)
    },

    function traceSettingsSetPriorityClassesTest() {
        local settings = TracePlus.Settings.new()
        local priorityClasses = ArrayEx("player")
        settings.SetPriorityClasses(priorityClasses)
        return assert(settings.GetPriorityClasses() == priorityClasses)
    },

    function traceSettingsSetIgnoredModelsTest() {
        local settings = TracePlus.Settings.new()
        local ignoredModels = ArrayEx("models/editor/info_player_start.mdl")
        settings.SetIgnoredModels(ignoredModels)
        return assert(settings.GetIgnoredModels() == ignoredModels)
    },

    function traceSettingsSetDepthAccuracyTest() {
        local settings = TracePlus.Settings.new()
        settings.SetDepthAccuracy(10)
        return assert(settings.depthAccuracy == 10)
    },

    function traceSettingsSetBinaryRefinementTest() {
        local settings = TracePlus.Settings.new()
        settings.SetBynaryRefinement(true)
        return assert(settings.bynaryRefinement == true)
    },

    function traceSettingsAppendIgnoredClassTest() {
        local settings = TracePlus.Settings.new()
        settings.AppendIgnoredClass("prop_physics")
        return assert(settings.GetIgnoreClasses().contains("prop_physics"))
    },

    function traceSettingsAppendPriorityClassesTest() {
        local settings = TracePlus.Settings.new()
        settings.AppendPriorityClasses("player")
        return assert(settings.GetPriorityClasses().contains("player"))
    },

    function traceSettingsAppendIgnoredModelTest() {
        local settings = TracePlus.Settings.new()
        settings.AppendIgnoredModel("models/editor/info_player_start.mdl")
        return assert(settings.GetIgnoredModels().contains("models/editor/info_player_start.mdl"))
    },

    function traceSettingsSetCollisionFilterTest() {
        local settings = TracePlus.Settings.new()
        local filterFunction = function() { return true }
        settings.SetCollisionFilter(filterFunction)
        return assert(settings.GetCollisionFilter() == filterFunction)
    },

    function traceSettingsSetIgnoreFilterTest() {
        local settings = TracePlus.Settings.new()
        local filterFunction = function() { return false }
        settings.SetIgnoreFilter(filterFunction)
        return assert(settings.GetIgnoreFilter() == filterFunction)
    },

    function traceSettingsApplyCollisionFilterTest() {
        local settings = TracePlus.Settings.new()
        local filterFunction = function(_ent) { return 1708 }
        settings.SetCollisionFilter(filterFunction)
        return assert(settings.ApplyCollisionFilter(GetPlayerEx()) == 1708)
    },

    function traceSettingsApplyIgnoreFilterTest() {
        local settings = TracePlus.Settings.new()
        local filterFunction = function(_ent) { return false }
        settings.SetIgnoreFilter(filterFunction)
        return assert(settings.ApplyIgnoreFilter(GetPlayerEx()) == false)
    },

    function traceSettingsUpdateIgnoreEntitiesTest() {
        local settings = TracePlus.Settings.new()
        local ignoreEntities = ArrayEx()
        local updatedIgnoreEntities = settings.UpdateIgnoreEntities(ignoreEntities, GetPlayerEx())
        return assert(updatedIgnoreEntities.len() == 1)
    },
}

// Run all tests
RunTests("TracePlus", tracePlusTests)