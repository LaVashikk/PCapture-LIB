/*
 * Represents a custom "game event". 
 * 
 * This class allows you to create and manage custom "game events" with triggers, filters, and actions. 
*/
::VGameEvent <- class {
    // The name of the event.  
    eventName = null; 
    // The number of times the event can be triggered before it becomes inactive (-1 for unlimited triggers). 
    triggerCount = null; 
    // The actions to be performed when the event is triggered. 
    actions = null; 
    // A filter function to check conditions before triggering the event.  
    filterFunction = null; 

    // Constructor for initializing the VGameEvent
    /*
     * Constructor for a VGameEvent object.
     *
     * @param {string} eventName - The name of the event.
     * @param {number} triggerCount - The number of times the event can be triggered (-1 for unlimited). (optional, default=-1) 
     * @param {function} actionsList - The action to be performed when the event is triggered. (optional) 
    */
    constructor(eventName, triggerCount = -1, actionsList = null) {
        this.eventName = eventName
        this.triggerCount = triggerCount
        this.actions = List()
        
        if(actionsList) this.actions.append(actionsList)
        
        AllScriptEvents[eventName] <- this
    }

    /* 
     * Adds the action function for the event. 
     *
     * @param {function} actionFunction - The function to execute when the event is triggered. 
    */
    function AddAction(actionFunction) null

    function ClearActions() null

    /* 
     * Sets the filter function for the event. 
     *
     * The filter function should return true if the event should be triggered, false otherwise. 
     *
     * @param {function} filterFunction - The function to use for filtering trigger conditions. 
    */
    function SetFilter(filterFunc) null
    
    /* 
     * Triggers the event if the trigger count allows and the filter function (if set) returns true. 
     *
     * @param {any} args - Optional arguments to pass to the actions function. 
    */
    function Trigger(args = null) null
    
    /*
     * Forces the event to trigger, ignoring the filter function and trigger count. 
     * 
     * @param {any} args - Optional arguments to pass to the actions function. 
    */
    function ForceTrigger(args = null) null
}



/*
 * Add the action function for the event. 
 *
 * @param {function} actionFunction - The function to execute when the event is triggered. 
*/
function VGameEvent::AddAction(actionFunction) {
    this.actions.append(actionFunction)
}

function VGameEvent::ClearActions() {
    this.actions.clear()
}

/* 
 * Sets the filter function for the event. 
 *
 * The filter function should return true if the event should be triggered, false otherwise. 
 *
 * @param {function} filterFunction - The function to use for filtering trigger conditions. 
*/
function VGameEvent::SetFilter(filterFunc) {
    this.filterFunction = filterFunc
}


/* 
 * Triggers the event if the trigger count allows and the filter function (if set) returns true. 
 *
 * @param {array} args - Optional arguments to pass to the actions function. 
*/
function VGameEvent::Trigger(args) {
    if(this.actions.len() == 0) {
        dev.trace("Attempt to run {}, which has no actions", this.eventName)
        return
    }

    if (this.triggerCount != 0 && (this.filterFunction == null || this.filterFunction(args))) {
        if (this.triggerCount > 0) {
            // Decrement the trigger count if it is not unlimited
            this.triggerCount-- 
        }

        return this.ForceTrigger(args)
    }
}


/*
 * Forces the event to trigger, ignoring the filter function and trigger count. 
 * 
 * @param {array} args - Optional arguments to pass to the actions function. 
*/
function VGameEvent::ForceTrigger(args) {
    args.insert(0, this)
    foreach(action in this.actions.iter()) {
        try {
            action.acall(args)
        } catch(err) {
            throw("VGameEvent Error: " + this.eventName + " has accured: " + err )
        }
    }
    dev.trace("VScript Event Fired - " + this.eventName)
    return true // todo: what ._.
}