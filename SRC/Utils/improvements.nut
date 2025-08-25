if("GetPlayerEx" in getroottable()) {
    return
}

/*
* Limits frametime to avoid zero values.
*
* @returns {number} Clamped frametime
*/
::_frametime <- FrameTime
/*
 * Returns the current frame time, ensuring it is never zero. 
 * 
 * This function overrides the standard FrameTime function to prevent issues that can arise from zero frame times. 
 * If the frame time is zero, it returns a small default value (0.016). 
 *
 * @returns {number} - The current frame time. 
*/
::FrameTime <- function() {
    local tick = _frametime()
    if(tick == 0)
        return 0.016
    return tick
}

::_uniquestring <- UniqueString
/*
 * Generates a unique string with the specified prefix. 
 * 
 * This function overrides the standard UniqueString function to include a prefix in the generated string. 
 *
 * @param {string} prefix - The prefix to use for the unique string. (optional, default="u") 
 * @returns {string} - The generated unique string. 
*/ 
::UniqueString <- function(prefix = "u") {
    return prefix + "_" + _uniquestring().slice(0, -1)
}

::_EntFireByHandle <- EntFireByHandle
/*
 * Wrapper for EntFireByHandle to handle PCapLib objects.
 *
 * This function overrides the standard EntFireByHandle function to handle pcapEntity objects and extract the underlying CBaseEntity objects. 
 * It also allows specifying an activator and caller entity. 
 *
 * @param {CBaseEntity|pcapEntity} target - The target entity to trigger the input on. 
 * @param {string} action - The name of the input to trigger. 
 * @param {string} value - The value to pass to the input. (optional)
 * @param {number} delay - The delay in seconds before triggering the input. (optional)
 * @param {CBaseEntity|pcapEntity} activator - The activator entity (the entity that triggered the input). (optional)
 * @param {CBaseEntity|pcapEntity} caller - The caller entity (the entity that called the function). (optional) 
*/
::EntFireByHandle <- function(target, action, value = "", delay = 0, activator = null, caller = null, eventName = null) {
    // Extract the underlying entity from the pcapEntity wrapper 
    if (typeof target == "pcapEntity") 
        target = target.CBaseEntity
    if (typeof activator == "pcapEntity")
        activator = activator.CBaseEntity
    if (typeof caller == "pcapEntity")
        caller = target.CBaseEntity

    if(!eventName) 
        return _EntFireByHandle(target, action, value, delay, activator, caller)
    ScheduleEvent.Add(eventName, _EntFireByHandle, delay, [target, action, value, 0, activator, caller])
}

/*
* Retrieves a player entity with extended functionality.
*
* @param {int} index - The index of the player (0-based).
* @returns {pcapEntity} - An extended player entity with additional methods.
*/
::GetPlayerEx <- function(index = 0) {
    if(!IsMultiplayer()) 
        return entLib.FromEntity(GetPlayer())

    if(index >= AllPlayers.len()) return null
    return AllPlayers[index]
}