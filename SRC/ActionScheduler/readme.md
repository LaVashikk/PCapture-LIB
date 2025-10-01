# ActionScheduler Module

The `ActionScheduler` module provides an enhanced system for creating and managing scheduled events in VScripts. It offers more flexibility and control compared to standard mechanisms like `EntFireByHandle`, allowing you to create complex sequences of actions, schedule them with precise timing, and cancel them as needed.

## Table of Contents

1.  [action.nut](#actionnut)
    * [`ScheduleAction(scope, action, timeDelay, args)`](#scheduleactionscope-action-timedelay-args)
    * [`run()`](#run)
2.  [action_scheduler.nut](#actionscheduleraction_schedulernut)
    * [`Add(eventName, action, timeDelay, args, scope)`](#scheduleeventaddeventname-action-timedelay-args-scope)
        *   [Using the `args` parameter](#using-the-args-parameter)
        *   [Using the `scope` parameter](#using-the-scope-parameter)
    * [`AddInterval(eventName, action, interval, initialDelay, args, scope)`](#scheduleeventaddintervaleventname-action-interval-initialdelay-args-scope)
    * [`AddActions(eventName, actions, noSort)`](#scheduleeventaddactionseventname-actions-nosort)
    * [`Cancel(eventName, delay)`](#scheduleeventcanceleventname-delay)
    * [`TryCancel(eventName, delay)`](#scheduleeventtrycanceleventname-delay)
    * [`CancelAll()`](#scheduleeventcancelall)
    * [`GetEvent(eventName)`](#scheduleeventgeteventeventname)
    * [`IsValid(eventName)`](#scheduleeventisvalideventname)
3.  [event_handler.nut](#event_handlernut)
    * [`ScheduledEventLoop()`](#scheduledeventloop)
4.  [Enhanced Scheduling Features](#enhanced-scheduling-features)
    * [Asynchronous Actions](#asynchronous-actions)
    * [Error Handling](#error-handling)

## [ActionScheduler/action.nut](action.nut)

This file defines the `ScheduleAction` class, which represents a single action scheduled for execution at a specific time.

### `ScheduleAction(scope, action, timeDelay, args)`

**Constructor** 

Creates a new `ScheduleAction` object representing a scheduled action.

**Parameters:**

* `scope` (pcapEntity): The entity that scheduled the action.
* `action` (string or function): The action to execute when the scheduled time arrives. This can be a string containing VScripts code or a function object.
* `timeDelay` (number): The delay in seconds before executing the action.
* `args` (array, optional): An optional array of arguments to pass to the action function.

**Example:**

```js
local myAction = ScheduleAction(myEntity, function() {
    printl("Action executed!")
}, 2)
```

### `run()`
Executes the scheduled action. If the action is a string, it is compiled into a function before execution. If arguments are provided, they are passed to the action function.

**Example:**

```js
myAction.run()
```

## [ActionScheduler/action_scheduler.nut](action_scheduler.nut)

This file provides functions for creating and managing scheduled events, including adding actions, creating intervals, and canceling events.

### `ScheduleEvent.Add(eventName, action, timeDelay, args, scope)`
Adds a single action to a scheduled event with the specified name. If the event does not exist, it is created.

**Parameters:**

* `eventName` (string): The name of the event to add the action to.
* `action` (string or function): The action to execute when the scheduled time arrives. This can be a string containing VScripts code or a function object.
* `timeDelay` (number): The delay in seconds before executing the action.
* `args` (array, optional): An optional array of arguments to pass to the action function.
* `scope` (object, optional): The scope in which to execute the action (default is `this`).  

**Example:**

```js
ScheduleEvent.Add("my_event", function() {
    printl("This is my scheduled event.")
}, 1)
```


#### Using the `args` parameter

The `args` parameter allows you to pass additional arguments to the scheduled action when it is executed. This can be useful for providing context or data that the action needs to perform its task. 

**Example:**

```js
// Schedule an event to print a message with a custom name after 2 seconds.
ScheduleEvent.Add("my_event", function(name) {
    printl("Hello, " + name + "!")
}, 2, ["Theta"])  // Pass an array containing the name "Theta" as the args parameter.
```

#### Using the `scope` parameter

The `scope` parameter is essential for correctly handling delayed events within classes.  It allows you to specify the context in which the scheduled action will be executed.  When you schedule an action within a class method, passing `this` as the `scope` ensures that the action has access to the class instance's properties and methods.

**Example:**

```js
class MyClass {
    something = 11

    function myMethod() { 
        // Schedule an event to call another method of this class after 1 second.
        ScheduleEvent.Add("my_event", function() {
            this.anotherMethod()  // Access another method of the class instance.
            printl(this.something)
        }, 1, null, this)  // Pass "this" as the scope. 

        // Alternative:
        // ScheduleEvent.Add("my_event", function(scope) {
        //     scope.anotherMethod() 
        //     printl(scope.something)
        // }, 1, [this]) 
    } 

    function anotherMethod() { 
        this.something = 15
        // ...
    }
}
```

### `ScheduleEvent.AddInterval(eventName, action, interval, initialDelay, args, scope)`
Adds an action to a scheduled event that will be executed repeatedly at a fixed interval.

**Parameters:**

* `eventName` (string): The name of the event to add the interval to.
* `action` (string or function): The action to execute at each interval.
* `interval` (number): The time interval in seconds between executions of the action.
* `initialDelay` (number, optional): The initial delay in seconds before the first execution of the action (default is 0).
* `args` (array, optional): An optional array of arguments to pass to the action function.
* `scope` (object, optional): The scope in which to execute the action (default is `this`).  

**Example:**

```js
ScheduleEvent.AddInterval("my_event", function() {
    // ... do something periodically
}, 1)
```

### `ScheduleEvent.AddActions(eventName, actions, noSort)`
Adds multiple actions to a scheduled event.

**Parameters:**

* `eventName` (string): The name of the event to add the actions to.
* `actions` (array or List): An array or List of `ScheduleAction` objects to add to the event.
* `noSort` (boolean, optional): If true, the actions will not be sorted by execution time (default is false).

**Example:**

```js
local actions = [
    ScheduleAction(myEntity, function() { ... }, 1),
    ScheduleAction(myEntity, function() { ... }, 3),
    ScheduleAction(myEntity, function() { ... }, 2)
]
ScheduleEvent.AddActions("my_event", actions) // Actions will be sorted by execution time
```

### `ScheduleEvent.Cancel(eventName, delay)`
Cancels all scheduled actions within an event with the given name.

**Parameters:**

* `eventName` (string): The name of the event to cancel.
* `delay` (number, optional): An optional delay in seconds before canceling the event.

**Example:**

```js
ScheduleEvent.Cancel("my_event") // Cancel the "my_event" event
```

### `ScheduleEvent.TryCancel(eventName, delay)`
The same as `ScheduleEvent.Cancel`, but does not cause an error if the event is not found.

**Parameters:**

* `eventName` (string): The name of the event to cancel.
* `delay` (number, optional): An optional delay in seconds before canceling the event.

**Returns:**

* (boolean): True if the event was found and canceled, false otherwise.

**Example:**

```js
ScheduleEvent.TryCancel("my_event") 
```

### `ScheduleEvent.CancelAll()`
Cancels all scheduled events and actions.

**Example:**

```js
ScheduleEvent.CancelAll() // Cancel all scheduled events and actions
```

### `ScheduleEvent.GetEvent(eventName)`
Retrieves a scheduled event by name as a `List` of `ScheduleAction` objects.

**Parameters:**

* `eventName` (string): The name of the event to retrieve.

**Returns:**

* (List or null): The `List` containing the scheduled actions for the event, or `null` if the event is not found.

**Example:**

```js
local eventActions = ScheduleEvent.GetEvent("my_event")
if (eventActions) {
    // ... process the actions in the event
}
```

### `ScheduleEvent.IsValid(eventName)`
Checks if a scheduled event with the given name exists and has scheduled actions.

**Parameters:**

* `eventName` (string): The name of the event to check.

**Returns:**

* (boolean): True if the event exists and has scheduled actions, false otherwise.

**Example:**

```js
if (ScheduleEvent.IsValid("my_event")) {
    // The event exists and has scheduled actions
}
```


## [ActionScheduler/event_handler.nut](event_handler.nut)

This file contains the `ScheduledEventLoop` function, which processes scheduled events and actions.


### `ScheduledEventLoop()`

This function iterates over all scheduled events and checks if the execution time for the first action in each event has arrived. If so, it executes the action and removes it from the event's list of actions. If an event has no more actions remaining, it is removed from the list of scheduled events. The function then schedules itself to run again after a short delay to continue processing events. **This function is called automatically by the ActionScheduler module**

## Enhanced Scheduling Features

### Asynchronous Actions

You can now introduce delays within your scheduled actions using the `yield` keyword. This allows you to create more dynamic and responsive sequences of actions without relying on nested callbacks or complex timing logic.

The `yield` keyword, when used within a scheduled action function, will pause the execution of that specific action for a specified number of seconds. Importantly, the state of the function is preserved, meaning that all variables and their values will remain intact when the function resumes execution after the delay.

**Example:**

```
ScheduleEvent.Add("global", function() {
    local player = GetPlayerEx(1)
    local first = player.GetOrigin()
    printl("Hello, world!")
    yield 2 // Wait for 2 seconds
    
    local second = player.GetOrigin()
    printl("How are you?")
    yield 1.1 // Wait for 1.1 seconds

    local result = second - first // some result
    printl("result: " + result)
}, 1)

ScheduleEvent.Add("async_loop", function() {
    local player = GetPlayerEx(1)
    while(true) { // asynchronous loop that can run forever!
        printl(player.GetOrigin())
        yield 0.2 // Wait for 0.2 seconds
    }
}, 0.2)
```

In this example, the `"global"` event demonstrates how `yield` can be used to create delays within a sequence of actions. The player's origin is recorded, a greeting is printed, and then the script pauses for 2 seconds. After the pause, the player's origin is recorded again, a question is printed, and the script pauses for 1.1 seconds. Finally, the difference between the two recorded origins is calculated and printed. 

The `"async_loop"` event showcases how you can leverage `yield` to create asynchronous loops. In this case, the loop continuously prints the player's origin every 0.2 seconds. The `yield 0.2` statement ensures that the loop doesn't block other scheduled events and allows for responsive execution.

### Error Handling

The `ScheduledEventLoop` now includes robust error handling for scheduled events. If an error occurs during the execution of a scheduled action, the following information will be printed to the console:

* **Error Message:**  The specific error message that occurred.
* **Callstack:**  A trace of the function calls that led to the error, allowing you to pinpoint the source of the problem.
* **Scheduled Event Info:** Details about the scheduled event that triggered the error, including the event name and any associated data.
* **Function Info:**  Information about the specific action function that caused the error.

This comprehensive error handling ensures that errors within scheduled events are caught and reported without crashing the entire system.  Other scheduled events will continue to execute as expected. To see this information, set the logger level to `Trace`.
