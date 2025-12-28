/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Ray Tracing Virtuoso - laVashik ˙▿˙                                          |
+----------------------------------------------------------------------------------+
|       The TracePlus module, taking ray tracing to the next level with advanced   |
|       features like portal support and precise collision detection algorithms.   |
+----------------------------------------------------------------------------------+ */

::TracePlus <- {
    Result = {},
    Portals = {},
    FromEyes = {},

    Settings = null,
    defaultSettings = null,

    Cheap = null,
    Bbox = null,
}

::USE_LEGACY_BBOXCAST_ANALYZER <- false

function TracePlus::InvalidateEntity(ent) {
    local idx = ent.entindex()
    if(idx in EntBufferTable) {
        EntBufferTable[idx].lastFrameTime = -1
    }
}

IncludeScript("PCapture-LIB/SRC/TracePlus/results")
IncludeScript("PCapture-LIB/SRC/TracePlus/trace_settings")
TracePlus.defaultSettings = TracePlus.Settings.new()

IncludeScript("PCapture-LIB/SRC/TracePlus/cheap_trace")
IncludeScript("PCapture-LIB/SRC/TracePlus/bboxcast")
IncludeScript("PCapture-LIB/SRC/TracePlus/portal_casting")

IncludeScript("PCapture-LIB/SRC/TracePlus/bbox_analyzer")
IncludeScript("PCapture-LIB/SRC/TracePlus/legacy_bbox_analyzer")
IncludeScript("PCapture-LIB/SRC/TracePlus/calculate_normal")