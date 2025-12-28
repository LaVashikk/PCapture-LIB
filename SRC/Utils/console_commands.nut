commands_separator <- ",\n"

// Basic information
macros.CreateCommand("PCapLib_version", "script printl(::LIB_VERSION)")

// Logger level control commands
macros.CreateCommand("PCapLib_level_trace", "script ::LibLogger = LoggerLevels.Trace")
macros.CreateCommand("PCapLib_level_debug", "script ::LibLogger = LoggerLevels.Debug")
macros.CreateCommand("PCapLib_level_info", "script ::LibLogger = LoggerLevels.Info")
macros.CreateCommand("PCapLib_level_warn", "script ::LibLogger = LoggerLevels.Warning")
macros.CreateCommand("PCapLib_level_error", "script ::LibLogger = LoggerLevels.Error")
macros.CreateCommand("PCapLib_level_off", "script ::LibLogger = LoggerLevels.Off")

// Schedule event control commands
macros.CreateCommand("PCapLib_schedule_list", "script printl(macros.GetKeys(ScheduleEvent.eventsList).join(commands_separator))")
macros.CreateCommand("PCapLib_schedule_clear", "script ScheduleEvent.CancelAll()")

// Information dump commands
macros.CreateCommand("PCapLib_vscript_event_list", "script printl(macros.GetKeys(::AllScriptEvents).join(commands_separator))")
macros.CreateCommand("PCapLib_players_list", "script printl(AllPlayers.join(commands_separator))")

// Simple debug commands
macros.CreateCommand("script_FrameTime", "script printl(FrameTime())")