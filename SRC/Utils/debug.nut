::LoggerLevels <- class {
    Trace = 1
    Debug = 5
    Info = 10
    Warning = 30
    Error = 60
    Off = 1000
}


/*
 * A collection of debugging utilities. 
*/
::dev <- {
    /*
     * Draws the bounding box of an entity for the specified time.
     * 
     * @param {CBaseEntity|pcapEntity} ent - The entity to draw the bounding box for.
     * @param {Vector} color - The color of the box.
     * @param {number} time - The duration of the display in seconds. 
    */
    DrawEntityBBox = function(ent, color, time) {
        if (developer() == 0) return
        DebugDrawBox(ent.GetOrigin(), ent.GetBoundingMins(), ent.GetBoundingMaxs(), color.x, color.y, color.z, 9, time)
    },

    /*
     * Draws the AABB of an entity for the specified time.
     * 
     * @param {CBaseEntity|pcapEntity} ent - The entity to draw the bounding box for.
     * @param {Vector} color - The color of the box.
     * @param {number} time - The duration of the display in seconds. 
    */
    DrawEntityAABB = function(ent, color, time) {
        if (developer() == 0) return
        DebugDrawBox(ent.GetOrigin(), ent.CreateAABB(0), ent.CreateAABB(7), color.x, color.y, color.z, 9, time)
    },

    /*
     * Draws a box at the specified vector position for the specified time.
     * 
     * @param {Vector} vector - The position of the box.
     * @param {Vector} color - The color of the box. (optional)
     * @param {number} time - The duration of the display in seconds. (optional)
    */
    drawbox = function(vector, color = Vector(125, 125, 125), time = 0.05) {
        if (developer() == 0) return
        DebugDrawBox(vector, Vector(-1,-1,-1), Vector(1,1,1), color.x, color.y, color.z, 100, time)
    },

    // only for PCapture-LIB debugging
    trace = function(msg, ...) {
        if (developer() == 0 || LibLogger > LoggerLevels.Trace) return
        // region - repeatable code, thanks to Squirrel
        local args = array(vargc + 2)
        args[0] = this
        args[1] = msg

        for(local i = 0; i< vargc; i++) {
            args[i + 2] = vargv[i]
        }
        // endregion

        local msg = macros.format.acall(args)
        printl("-- PCapture-Lib [" + Time().tostring() + "]: " + msg)
    },

    /*
     * Logs a debug message to the console if debug logging is enabled. 
     *
     * @param {string} msg - The debug message string containing `{}` placeholders. 
    */ 
    debug = function(msg, ...) {
        if (developer() == 0 || LibLogger > LoggerLevels.Debug) return
        // region - repeatable code, thanks to Squirrel
        local args = array(vargc + 2)
        args[0] = this
        args[1] = msg

        for(local i = 0; i< vargc; i++) {
            args[i + 2] = vargv[i]
        }
        // endregion

        local msg = macros.format.acall(args)
        printl("[VScripts Debug (" + Time().tostring() + ")]: " + msg)
    },


    /*
     * Logs a info message to the console only if developer mode is enabled.
     * 
     * @param {string} msg - The message to log string containing `{}` placeholders.
    */
    info = function(msg, ...) {
        if (developer() == 0 || LibLogger > LoggerLevels.Info) return
        // region - repeatable code, thanks to Squirrel
        local args = array(vargc + 2)
        args[0] = this
        args[1] = msg

        for(local i = 0; i< vargc; i++) {
            args[i + 2] = vargv[i]
        }
        // endregion

        local msg = macros.format.acall(args)
        printl("• " + msg)
    },

    /*
     * Displays a warning message in a specific format.
     * 
     * @param {string} msg - The warning message string containing `{}` placeholders. 
    */
    warning = function(msg, ...) {
        if (developer() == 0 || LibLogger > LoggerLevels.Warning) return
        local pattern = "► Warning ({} [{}]): " + msg
        // region - repeatable code, thanks to Squirrel
        local info = dev._getInfo()
        local args = array(vargc + 4)
        args[0] = this
        args[1] = pattern // pattern
        args[2] = info[0] // func name
        args[3] = info[1] // func line

        for(local i = 0; i< vargc; i++) {
            args[i + 4] = vargv[i]
        }
        // endregion
        printl(macros.format.acall(args))
    },

    /* 
     * Displays an error message in a specific format.
     * 
     * @param {string} msg - The error message string containing `{}` placeholders.
    */
    error = function(msg, ...) {
        if (developer() == 0 || LibLogger > LoggerLevels.Error) return
        local pattern = "▄▀ *ERROR*: [func = {}; line = {}] | " + msg
        // region - repeatable code, thanks to Squirrel
        local info = dev._getInfo()
        local args = array(vargc + 4)
        args[0] = this
        args[1] = pattern // pattern
        args[2] = info[0] // func name
        args[3] = info[1] // func line

        for(local i = 0; i< vargc; i++) {
            args[i + 4] = vargv[i]
        }
        // endregion
        printl(macros.format.acall(args))
        SendToConsole("playvol resource/warning.wav 1")
    },

    _getInfo = function() {
        local last_info
        for(local i = 0; getstackinfos(i); i++)
            last_info = i 
        local info = getstackinfos(last_info)
        
        local funcName = getstackinfos(last_info).func
        if (funcName == "main" || funcName == "unknown")
            funcName = "file " + info.src
            
        local line = info.line
        return [funcName, line]
    }
}