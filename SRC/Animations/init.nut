/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Animation Alchemist - laVashik ¬_¬                                           |
+----------------------------------------------------------------------------------+ 
|       The Animations module, simplifying the creation of smooth and dynamic      |
|       animations for alpha, color, and object movement in your VScripts.         |
+----------------------------------------------------------------------------------+ */

::animate <- {
    RT = {}
}

::AnimEvent <- class {
    animName = null;
    eventName = null
    delay = 0
    globalDelay = 0
    frameInterval = 0
    maxFrames = 60.0
    autoOptimization = true
    output = null
    entities = []
    easeFunc = null;
    filterCallback = null;
    scope = null;

    /*
     * Constructor for an AnimEvent object. 
     *
     * @param {string} name - A name of type animation
     * @param {table} settings - A table containing animation settings.
     * @param {array} entities - An array of entities to animate.
     * @param {number} time - The duration of the animation in seconds.
    */
    constructor(name, table, ents, time = 0) {
        this.animName = name
        this.entities = _GetEntities(ents, name)
        this.delay = time
        
        this.eventName = macros.GetFromTable(table, "eventName", UniqueString(name + "_anim"))
        this.globalDelay = macros.GetFromTable(table, "globalDelay", 0)
        this.output = macros.GetFromTable(table, "output", null)
        this.scope = macros.GetFromTable(table, "scope", null)
        this.easeFunc = macros.GetFromTable(table, "ease", function(t) return t)
        this.filterCallback = macros.GetFromTable(table, "filterCallback", function(a,b,c,d,e) return null)
        this.frameInterval = macros.GetFromTable(table, "frameInterval", FrameTime()) 
        this.maxFrames = macros.GetFromTable(table, "fps", 60.0)
        this.autoOptimization = macros.GetFromTable(table, "optimization", true)

        // If the class points to the root table, it will result in a circular reference. This fixed here
        if(this.scope == getroottable()) {
            this.scope = null
        }
    } 

    /* 
     * Calls the output associated with the animation event. 
    */
    function CallOutput() {
        if(this.output)
            ScheduleEvent.Add(this.eventName, this.output, this.delay + this.globalDelay, null, this.scope)
    }

    function _GetEntities(entities, actionName) {
        local type_of = typeof entities;
        if (type_of == "string") {
            local foundEnts = List(); // todo or array?
            if(entities.find("*") == null) {
                local ent = entLib.FindByName(entities);
                if (!ent) dev.warning(actionName + " AnimEvent: Could not find entity with name '" + entities + "'");
                else foundEnts.push(ent);
            }
            else {
                for(local ent; ent = entLib.FindByName(entities, ent);)
                    foundEnts.push(ent)
                if (foundEnts.len() == 0) dev.warning(actionName + " AnimEvent: Could not find any entities matching name pattern '" + entities + "'");
            }
            return foundEnts;
        }
                
        
        if (type_of == "array" || type_of == "ArrayEx" || type_of == "List") {
            foreach(idx, entity in entities) {
                if (!entity || !entity.IsValid()) {
                    dev.warning(actionName + " AnimEvent: An invalid or null entity was found in the 'entities' list at index " + idx);
                    continue;
                }
                if(typeof entity != "pcapEntity") 
                    entities[idx] = entLib.FromEntity(entity)
            }
            return entities
        }

        if (!entities || !entities.IsValid()) throw("AnimEvent: The provided 'entities' argument is not a valid entity.");

        if (type_of != "pcapEntity")
            return [entLib.FromEntity(entities)]
        
        return [entities]
    } 
}

/*
 * Applies an animation over a specified duration, calculating and setting new values for a property at each frame.
 * 
 * This function is used internally by the various animation functions to handle the animation process.
 * It calculates the new value for the property at each frame using the provided `valueCalculator` function and applies it to each entity using the `propertySetter` function.
 *
 * @param {AnimEvent} animInfo - The AnimEvent object containing the animation settings and entities.
 * @param {function} valueCalculator - A function that calculates the new value for the property at each frame.
 *    This function should take three arguments:
 *        * `step`: The current frame number (starting from 0).
 *        * `transitionFrames`: The total number of frames in the animation.
 *        * `vars`: Optional variables passed through the `vars` parameter.
 * @param {function} propertySetter - A function that sets the new value for the property on each entity.
 *    This function should take two arguments:
 *        * `entity`: The entity to apply the value to.
 *        * `newValue`: The calculated new value for the property.
 * @param {any} vars - Optional variable to pass to the `valueCalculator` function.
 *    This can be used to customize the animation behavior.
 * @param {number} transitionFrames - The total number of frames in the animation.
 *    If 0, it's calculated based on `animInfo.delay` and `animInfo.frameInterval`. (default: 0)
*/
animate["applyAnimation"] <- function(animInfo, valueCalculator, propertySetter, vars = null, transitionFrames = 0) {
    if(transitionFrames == 0) {
        if (animInfo.autoOptimization && animInfo.delay / animInfo.frameInterval > animInfo.maxFrames)  
            animInfo.frameInterval = animInfo.delay / animInfo.maxFrames
        
        transitionFrames = animInfo.delay / animInfo.frameInterval;
    }

    transitionFrames = ceil(transitionFrames) 
    local actionsList = List()

    for(local step = 0; step <= transitionFrames; step++) {
        local elapsed = (animInfo.frameInterval * step) + animInfo.globalDelay

        local newValue = valueCalculator(step, transitionFrames, vars)
        
        foreach(ent in animInfo.entities) {
            local action = ScheduleAction(this, propertySetter, elapsed, [ent, newValue])
            actionsList.append(action)
        }
    }

    ScheduleEvent.AddActions(animInfo.eventName, actionsList, true)
    animInfo.delay = animInfo.frameInterval * transitionFrames
    animInfo.CallOutput()

    if(developer() > 0) dev.trace("Created {} animation ({}) for {} actions", animInfo.animName, animInfo.eventName, actionsList.len())
}

/*
 * Facade function for applying real-time animations in an asynchronous environment.
 * 
 * This function schedules the real-time animation to be processed using `_applyRTAnimation`.
 * The actual animation is executed without pre-calculating all the frames, 
 * which allows for more flexibility, especially when handling long animations or situations where the animation might need to be interrupted.
 *
 * The arguments are the same as those for `applyAnimation`.
*/
animate["applyRTAnimation"] <- function(animInfo, valueCalculator, propertySetter, vars = null, transitionFrames = 0) {
    if(transitionFrames == 0) {
        if (animInfo.maxFrames * 10 != 600)  
            animInfo.frameInterval = animInfo.delay / animInfo.maxFrames
        
        transitionFrames = animInfo.delay / animInfo.frameInterval;
    }

    ScheduleEvent.Add(
        animInfo.eventName, 
        animate._applyRTAnimation, 
        animInfo.globalDelay, 
        [animInfo, valueCalculator, propertySetter, vars, transitionFrames], 
        this
    )

    // calc delay
    animInfo.delay = animInfo.frameInterval * transitionFrames
}

/*
 * Applies the animation in real-time, evaluating each frame as it occurs without pre-calculating.
 * 
 * This function works similarly to `applyAnimation`, but rather than calculating all the steps in advance,
 * it applies `propertySetter` in real-time for each frame. This is useful in cases where you might need
 * to interrupt or alter the animation at runtime using `filterCallback`, or if the animation is too long
 * for VSquirrel to process upfront.
*/
animate["_applyRTAnimation"] <- function(animInfo, valueCalculator, propertySetter, vars, transitionFrames) {
    // Round up the number of transition frames
    transitionFrames = ceil(transitionFrames);
    if (developer() > 0) dev.trace("Started {} realtime animation ({})", animInfo.animName, animInfo.eventName);

    // Helper function to process each animation step
    function processStep(step, animInfo, valueCalculator, propertySetter, vars, transitionFrames) {
    // Stop if all frames are processed
    if (step > transitionFrames) {
        animInfo.delay = 0;
        animInfo.globalDelay = 0;
        animInfo.CallOutput();
        return;
    }

    // Calculate the new property value
    local newValue = valueCalculator(step, transitionFrames, vars);

    // Stop if the filter callback signals to cancel the animation
    if (animInfo.filterCallback(animInfo, newValue, transitionFrames, step, vars)) {
        return;
    }

    // Apply the new value to all entities
    foreach(ent in animInfo.entities)
        propertySetter(ent, newValue)

    // Move to the next step
    ScheduleEvent.Add(
        animInfo.eventName,
        processStep,
        animInfo.frameInterval,
        [++step, animInfo, valueCalculator, propertySetter, vars, transitionFrames],
        this  
    );
}

    // Start the animation
    processStep(0, animInfo, valueCalculator, propertySetter, vars, transitionFrames);
};



IncludeScript("PCapture-LIB/SRC/Animations/alpha")
IncludeScript("PCapture-LIB/SRC/Animations/color")
IncludeScript("PCapture-LIB/SRC/Animations/position")
IncludeScript("PCapture-LIB/SRC/Animations/angles")
// IncludeScript("PCapture-LIB/SRC/Animations/forward")