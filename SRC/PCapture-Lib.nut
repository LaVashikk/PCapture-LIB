/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik                                                      |
 +---------------------------------------------------------------------------------+
| pcapture-lib.nut                                                                  |
|       The main file in the library. initializes required parts of the library     |
|    GitHud repo: https://github.com/IaVashik/PCapture-LIB                          |
+----------------------------------------------------------------------------------+ */

local version = "PCapture-Lib 3.8 Candidate-Release"
local rootScope = getroottable()

// `Self` must be in any case, even if the script is run directly by the interpreter
if (!("self" in this)) {
    self <- Entities.First()
} else {
    getroottable()["self"] <- self
}

if("LIB_VERSION" in getroottable() && version.find("Debug") == null) {
    printl("\n")
    dev.warning("PCapture-Lib already initialized.")
    if(LIB_VERSION != version) {
        dev.error("Attempting to initialize different versions of the PCapture-Lib library!")
        dev.fprint("Version \"{}\" != \"{}\"", LIB_VERSION, version)
    }
    return
}

/*
 * Global Tables Initialization:
 *
 * This section initializes the fundamental global tables required for the PCapture Library.
 * These tables are essential for ensuring the correct functioning 
 * of the library's various components during runtime.
*/
::pcapEntityCache <- {}
::EntitiesScopes <- {}
::TracePlusIgnoreEnts <- {}

DoIncludeScript("PCapture-LIB/SRC/IDT/init.nut", rootScope)
DoIncludeScript("PCapture-LIB/SRC/Math/init.nut", rootScope)
DoIncludeScript("PCapture-LIB/SRC/ActionScheduler/init.nut", rootScope)
DoIncludeScript("PCapture-LIB/SRC/Utils/init.nut", rootScope)

::LibLogger <- LoggerLevels.Info
::MAX_PORTAL_CAST_DEPTH <- 4
::ALWAYS_PRECACHED_MODEL <- "models/weapons/w_portalgun.mdl" // needed for pcapEntity::EmitSoundEx

DoIncludeScript("PCapture-LIB/SRC/TracePlus/init.nut", rootScope)
DoIncludeScript("PCapture-LIB/SRC/Animations/init.nut", rootScope)
DoIncludeScript("PCapture-LIB/SRC/ScriptEvents/init.nut", rootScope)
DoIncludeScript("PCapture-LIB/SRC/HUD/init.nut", rootScope)

// Garbage collector for `PCapEntity::EntitiesScopes` 
ScheduleEvent.AddInterval("global", function() {
    foreach(ent, _ in EntitiesScopes) {
        if(!ent || !ent.IsValid()) {
            delete EntitiesScopes[ent]
        }
    }
}, 5, 0)


/*
 * Initializes eye tracking for all players, allowing retrieval of their coordinates and viewing directions.
 * This serves as a workaround for the absence of the EyeForward function in Portal 2.
 *
 * In multiplayer sessions, it reinitializes eye tracking after 1 second to ensure that players are set up 
 * correctly, as there is typically a slight delay (1-2 seconds) in player initialization.
 *
 * When running in the Portal 2 Multiplayer Mod (P2MM), it schedules repeated initialization every second 
 * to dynamically accommodate new players joining the session.
*/

TrackPlayerJoins()
ScheduleEvent.Add("global", TrackPlayerJoins, 0.4)
if(IsMultiplayer()) {
    ScheduleEvent.Add("global", TrackPlayerJoins, 2) // Thanks Volve for making it take so long for players to initialize
    ScheduleEvent.AddInterval("global", HandlePlayerEventsMP, 0.3)
    
    if("TEAM_SINGLEPLAYER" in getroottable()) 
        // This session is running in P2MM, actively monitoring players.
        ScheduleEvent.AddInterval("global", TrackPlayerJoins, 1, 2)
} 
else {
    ScheduleEvent.AddInterval("global", HandlePlayerEventsSP, 0.5, 0.5)
} 


// Global settings for the portals correct working
SetupLinkedPortals()
local globalDetector = _CreatePortalDetector("CheckAllIDs", true)
globalDetector.ConnectOutputEx("OnStartTouchPortal", function() {entLib.FromEntity(activator).SetTraceIgnore(false)})
globalDetector.ConnectOutputEx("OnEndTouchPortal", function() {entLib.FromEntity(activator).SetTraceIgnore(true)})


::LIB_VERSION <- version
::PCaptureLibInited <- true

/*
 * Prints information about the PCapture library upon initialization.
 *
 * This includes the library name, version, author, and a link to the GitHub repository.
*/
printl("\n----------------------------------------")
printl("Welcome to " + LIB_VERSION)
printl("Author: laVashik Production") // The God of VScripts :P
printl("GitHub: https://github.com/IaVashik/PCapture-LIB")
printl("----------------------------------------\n")
