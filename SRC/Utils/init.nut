/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Squirrel Whisperer - laVashik :>                                             |
+----------------------------------------------------------------------------------+
|       A toolbox of versatile utilities for script execution, debugging, file     |
|       operations, and entity manipulation, empowering VScripts developers.       | 
+----------------------------------------------------------------------------------+ */ 

IncludeScript("PCapture-LIB/SRC/Utils/debug")
IncludeScript("PCapture-LIB/SRC/Utils/file")
IncludeScript("PCapture-LIB/SRC/Utils/improvements")
IncludeScript("PCapture-LIB/SRC/Utils/portals")
IncludeScript("PCapture-LIB/SRC/Utils/macros")
IncludeScript("PCapture-LIB/SRC/Utils/const")
IncludeScript("PCapture-LIB/SRC/Utils/player_hooks")
ScheduleEvent.Add("global", function() {
IncludeScript("PCapture-LIB/SRC/Utils/console_commands")
}, 1, null, this)