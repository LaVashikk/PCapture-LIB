/*
 * Represents a scheduled action.
 *
 * This class encapsulates information about an action that is scheduled to be executed at a specific time.
*/
::ScheduleAction <- class {
    // The entity that created the event. 
    scope = null;
    // The action to execute when the scheduled time arrives.  
    action = null;
    // The time at which the action is scheduled to be executed. 
    executionTime = null;
    // Optional arguments to pass to the action function.  
    args = null;

    /*
     * Constructor for a ScheduleAction object.
     *
     * @param {pcapEntity} scope - The entity that created the event.
     * @param {string|function} action - The action to execute when the event is triggered.
     * @param {number} delay - The time at which the event is scheduled to be executed.
     * @param {array|null} args - Optional arguments to pass to the action function. 
    */
    constructor(scope, action, delay, args = null) {
        this.scope = scope
        this.action = action
        this.executionTime = delay + Time()

        this.args = args
    }

    /* 
     * Executes the scheduled action. 
     *
     * If the action is a string, it is compiled into a function before execution.
     * If arguments are provided, they are passed to the action function. 
     *
     * @returns {any} - The result of the action function. 
    */
    function run() {
        if(type(this.action) == "string")
            this.action = compilestring(action)

        if(this.args == null) {
            return this.action.call(scope)
        }
        
        // SAFETY: checks are now in action_scheluder
        // if(typeof this.args != "array" && typeof this.args != "ArrayEx" && typeof this.args != "List") {
        //     // throw("Invalid arguments for ScheduleEvent! The argument must be itterable, not (" + args + ")")
        // }

        local actionArgs = [this.scope]
        actionArgs.extend(this.args)
        return action.acall(actionArgs)
    }

    /*
     * Processes a generator action.
     * 
     * @param {Generator} generator - The generator to be processed.
     * @returns {any} - The result of processing the generator.
    */
    function processGenerator(generator, eventName) {
        if(generator.getstatus() == "dead") return
        local delay = resume generator
        if(delay == null) return
        
        try {delay = delay.tofloat()} 
        catch(err) {throw "Invalid value for sleep. " + err}
        
        // todo Optimization: can edit this, change its time, and move in queue
        if(eventName in ScheduleEvent.eventsList)
            ScheduleEvent.Add(eventName, generator, delay, null, this.scope)
    }

    function GetInfo() return "[Scope] " + scope + "\n[Action] " + action + "\n[executionTime] " + executionTime
    function _typeof() return "ScheduleAction"
    function _tostring() return "ScheduleAction: (" + this.executionTime + ")"
    function _cmp(other) {    
        if (this.executionTime > other.executionTime) return 1;
        else if (this.executionTime < other.executionTime) return -1;
        return 0; 
    }
}