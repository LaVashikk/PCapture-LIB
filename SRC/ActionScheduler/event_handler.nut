/*
 * Executes scheduled events when their time is up. 
 * 
 * This function iterates over all scheduled events and checks if their scheduled execution time has arrived. 
 * If so, it executes the event's action and removes it from the list of scheduled events. 
 * The function then schedules itself to run again after a short delay to continue processing events.
*/
::ScheduledEventLoop <- function() {
    local time = Time() + 0.0001
    local eventsToDelete = List() // Buffer for safe deletion

    // Iterate over each event name and its corresponding event list. 
    foreach(eventName, eventInfo in ScheduleEvent.eventsList) {
        local event 
        // Process events until the list is empty or the next event's time hasn't arrived yet.  
        while(eventInfo.length > 0 && time >= (event = eventInfo.first()).executionTime) {
            eventInfo.remove(0)
            try {
                local gtor = event.action
                if(typeof event.action == "generator" || typeof (gtor = event.run()) == "generator") {
                    event.processGenerator(gtor, eventName)
                }
            }
            catch(exception) {
                //* Stack unwinding
                macros.fprint("AN ERROR HAS OCCURED IN ScheduleEvent [{}]", exception)
                printl("\nCALLSTACK")
                local stack
                for(local i = 1; stack = getstackinfos(i); i++)
                    macros.fprint("*FUNCTION [{}()] {} line [{}]", stack.func, stack.src, stack.line)

                macros.fprint("\nSCHEDULED EVENT\n[Name] {}\n{}\n[Exception] {}\n[Event Action List] {}", eventName, event.GetInfo(), exception, ScheduleEvent.eventsList[eventName])

                if(type(event.action) == "function" || type(event.action) == "native function") {
                    printl("\nFUNCTION INFO")
                    foreach(key, val in event.action.getinfos()) {
                        if(type(val) == "array") val = ArrayEx.FromArray(val)
                        macros.fprint("[{}] {}", key.toupper(), val)
                    }
                }

                SendToConsole("playvol resource/warning.wav 1")
            }
        }
        if(eventName != "global" && eventInfo.length == 0) {
            eventsToDelete.append(eventName) 
        }
    }

    // Safely delete events after completion of the main loop.
    foreach (eventName in eventsToDelete.iter()) {
        if (eventName in ScheduleEvent.eventsList) {
            ScheduleEvent.eventsList.rawdelete(eventName)
            if(developer() > 0) dev.trace("Event {} closed.", eventName)
        }
    }
}