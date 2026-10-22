# Script Events Module

A global event bus: one part of your scripts emits an event by its name, other parts subscribe to that name and react, without knowing about each other. Nothing has to be created beforehand: subscribing to a name is enough, and emitting a name nobody listens to does nothing.

## Table of Contents

* [Functions](#functions)
	* [`ScriptEvents.On(eventName, action, scope)`](#scripteventsoneventname-action-scope)
	* [`ScriptEvents.Once(eventName, action, scope)`](#scripteventsonceeventname-action-scope)
	* [`ScriptEvents.Off(id)`](#scripteventsoffid)
	* [`ScriptEvents.Emit(eventName, ...)`](#scripteventsemiteventname-)
* [How actions are called](#how-actions-are-called)
* [Examples](#examples)

## Functions

### `ScriptEvents.On(eventName, action, scope)`

Subscribes an action to an event.

**Parameters:**

* `eventName` (string): The name of the event.
* `action` (function): Called with the arguments of every `Emit` of the event.
* `scope` (object, optional): `this` inside the action (default is the root table).

**Returns:**

* (integer): The subscription id, for `Off`.

```js
ScriptEvents.On("cube_dissolved", function(cube) {
    printl("Dissolved: " + cube)
})
```

### `ScriptEvents.Once(eventName, action, scope)`

Same as `On`, but the action runs on the next `Emit` only: it unsubscribes right before it runs.

```js
ScriptEvents.Once("boss_died", function(boss) {
    printl("The boss is gone, for good")
})
```

### `ScriptEvents.Off(id)`

Removes a subscription.

**Parameters:**

* `id` (integer): The id returned by `On` or `Once`.

**Returns:**

* (boolean): `true` if it was subscribed, `false` if it was removed before (or it was a `Once` that already ran).

```js
local id = ScriptEvents.On("cube_dissolved", function(cube) { printl(cube) })
// later
ScriptEvents.Off(id)
```

### `ScriptEvents.Emit(eventName, ...)`

Emits an event: runs its actions with the given arguments, in the order they were subscribed.

**Parameters:**

* `eventName` (string): The name of the event.
* `...` (any): Arguments passed to each action, as they are: an array stays one argument.

**Returns:**

* (boolean): `true` if any action ran, `false` if nothing is subscribed to the event.

```js
ScriptEvents.Emit("cube_dissolved", cube)
```

## How actions are called

* An action gets exactly the arguments given to `Emit`, so it must accept as many: `Emit("x", a, b)` calls `action(a, b)`.
* `this` inside the action is the `scope` given to `On`/`Once`, or the root table. In a class, pass `this` to keep it: `ScriptEvents.On("x", this.OnX, this)`.
* An action subscribed while the event is being emitted runs from the next `Emit` on. An action removed while the event is being emitted doesn't run.
* An error in an action is not caught: the remaining actions of that `Emit` don't run, and the error points to the line in the action.
* There are no filters: check the conditions inside the action.

## Examples

**An object announces itself.** The emitter passes itself as the first argument, so a subscriber that only cares about one object checks it:

```js
class LaserGun {
    function Shoot(target) {
        ScriptEvents.Emit("laser_shoot", this, target)
    }
}
local myGun = LaserGun()

// Anywhere else
ScriptEvents.On("laser_shoot", function(gun, target) : (myGun) {
    if(gun != myGun) return
    printl("My laser hit " + target)
})
```

**Methods as actions.** `scope` makes `this` the object, and the id lets the object unsubscribe later:

```js
class Door {
    subscription = null

    constructor() {
        this.subscription = ScriptEvents.On("power_changed", this.OnPower, this)
    }

    function OnPower(enabled) {
        // `this` is the door
    }

    function Destroy() {
        ScriptEvents.Off(this.subscription)
    }
}
```

**Event names in one place.** Names are plain strings, so a typo makes a separate event. A table of names keeps them in one place:

```js
GameEvents <- {
    CameraPicked = "camera_picked_up",  // args: camera, owner
    MemoryFlushed = "memory_flushed",   // args: camera
}

ScriptEvents.On(GameEvents.MemoryFlushed, function(camera) { printl(camera) })
ScriptEvents.Emit(GameEvents.MemoryFlushed, camera)
```

The console command `PCore_vs_events` lists the events that have subscriptions right now.

**Events the library emits itself.** `event_player_joined`, `event_player_death`, `event_player_respawn` and `event_player_left`, each with the player (`pcapEntity`). The player hooks in [Utils](../Utils/readme.md#player-events) are shortcuts for subscribing to them.
