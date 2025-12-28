# Animations Module

The `Animations` module provides functions for creating various animations in VScripts, such as fading objects in or out, changing their colors, and moving them along paths. It simplifies the process of creating smooth and visually appealing animations.  It also supports real-time animations for more complex scenarios.

## Table of Contents

1.  [init.nut](#initnut)
    *   [`AnimEvent`](#animeventname-settings-entities-time0)
    *   [Animation Settings Table (propertySetter)](#animation-settings-table)
    *   [`applyAnimation`](#animateapplyanimationaniminfo-valuecalculator-propertysetter-vars-transitionframes)
    *   [`applyRTAnimation`](#animateapplyrtanimationaniminfo-valuecalculator-propertysetter-vars-transitionframes)
2.  [alpha.nut](#animationsalphanut)
    *   [`AlphaTransition`](#animatealphatransitionentities-startopacity-endopacity-time-animsetting)
3.  [color.nut](#animationscolornut)
    *   [`ColorTransition`](#animatecolortransitionentities-startcolor-endcolor-time-animsetting)
4.  [position.nut](#animationspositionnut)
    *   [`PositionTransitionByTime`](#animatepositiontransitionbytimeentities-startpos-endpos-time-animsetting)
    *   [`PositionTransitionBySpeed`](#animatepositiontransitionbyspeedentities-startpos-endpos-speed-animsetting)
5.  [angles.nut](#animationsanglesnut)
    *   [`AnglesTransitionByTime`](#animateanglestransitionbytimeentities-startangles-endangles-time-animsetting)
6. [Custom Animation Functions](#custom-animation-functions)

## [Animations/init.nut](init.nut)

This file initializes the `Animations` module, defines the `AnimEvent` class for managing animation events, and includes the necessary script files for the module's functionality.

### `AnimEvent(name, settings, entities, time)`

The `AnimEvent` class is used internally by the animation functions to store and manage information about an animation event. It is not intended for direct use in your scripts.

**Constructor**

Creates a new `AnimEvent` object with the specified name, settings, entities, and animation duration. 

**Parameters:**

*   `name` (string): The name of the animation type.
*   `settings` (table): A table containing optional settings for the animation event. See the **Animation Settings Table** section below for details.
*   `entities` (array, CBaseEntity, or pcapEntity): An array of entities, a single entity, or a pcapEntity to animate.
*   `time` (number, optional): The duration of the animation in seconds (default is 0).

### Animation Settings Table

The `settings` table in the `AnimEvent` constructor can contain the following optional properties:

*   `eventName` (string, optional): The name of the event (default is a unique string based on the animation name).
*   `globalDelay` (number, optional): A global delay in seconds before the animation starts (default is 0).
*   `output` (string or function, optional): A script or function to execute when the animation finishes.
*   `scope` (object, optional): The scope in which to execute the action (default is the `AnimEvent` object itself).
*   `ease` (function, optional): A custom ease function to use for interpolation. If not provided, a linear interpolation function is used.
*   `frameInterval` (number, optional): The time interval between frames in seconds (default is the engine's frame time).
*   `fps` (number, optional): The desired frames per second for the animation, used to calculate `frameInterval` if it's not explicitly set (default is 60, maximum 60).
*   `optimization` (bool, optional): Enables or disables automatic optimization. When enabled, the animation will automatically adjust the frame interval to ensure a maximum of `maxFrames` frames are used, improving performance for longer animations. (default is true).
*   `filterCallback` (function, optional): A callback function that is called before each frame of a real-time animation.  It receives `animInfo`, `newValue`, `transitionFrames`, `currentStep`, and `vars` as arguments. If it returns `true`, the animation is interrupted. (Used only with real-time animations).


### `animate.applyAnimation(animInfo, valueCalculator, propertySetter, vars, transitionFrames)`

This function applies an animation over a specified duration, calculating and setting new values for a property at each frame. It is used internally by the various animation functions to handle the animation process, and can also be used to create custom animation functions.

**Parameters:**

*   `animInfo` (AnimEvent): The `AnimEvent` object containing the animation settings and entities.
*   `valueCalculator` (function): A function that calculates the new value for the property at each frame. The function should take three arguments: current step, total steps, and optional variables (`vars`).
*   `propertySetter` (function): A function that sets the new value for the property on each entity. The function should take two arguments: the entity and the calculated value.
*   `vars` (any, optional): Optional variables to pass to the `valueCalculator` function. Can be used for your custom animations.
*   `transitionFrames` (number, optional): The total number of frames in the animation. If 0, it's calculated based on `animInfo.delay` and `animInfo.frameInterval`. Otherwise, the provided value is used.

**Example:**

```js
// ... (assuming you have animInfo, valueCalculator, and propertySetter defined)
animate.applyAnimation(animInfo, valueCalculator, propertySetter) // Apply the animation
```


### `animate.applyRTAnimation(animInfo, valueCalculator, propertySetter, vars, transitionFrames)`

Facade function for applying real-time animations in an asynchronous environment. This function schedules the real-time animation to be processed using `_applyRTAnimation`. The actual animation is executed without pre-calculating all the frames, which allows for more flexibility, especially when handling long animations or situations where the animation might need to be interrupted using a `filterCallback`.  The arguments are the same as those for `applyAnimation`.


**Example:**

```js
// ... (assuming you have animInfo, valueCalculator, and propertySetter defined)
animate.applyRTAnimation(animInfo, valueCalculator, propertySetter) // Apply the animation in real-time
```


### `animate._applyRTAnimation(animInfo, valueCalculator, propertySetter, vars, transitionFrames)`





Applies the animation in real-time, evaluating each frame as it occurs without pre-calculating. This function works similarly to `applyAnimation`, but rather than calculating all the steps in advance, it applies `propertySetter` in real-time for each frame. This is useful in cases where you might need to interrupt or alter the animation at runtime using `filterCallback`, or if the animation is too long for VSquirrel to process upfront. This function is intended for internal use and is called by `animate.applyRTAnimation`. Its arguments are managed internally.



## [Animations/alpha.nut](alpha.nut)

This file provides the `animate.AlphaTransition` function for creating animations that transition the alpha (opacity) of entities over time.  A real-time version is available as `animate.RT.AlphaTransition`.

### `animate.AlphaTransition(entities, startOpacity, endOpacity, time, animSetting)`

This function creates an animation that smoothly transitions the alpha (opacity) of entities from the starting value to the ending value over a specified time.

**Parameters:**

*   `entities` (array, CBaseEntity, or pcapEntity): The entities to animate.
*   `startOpacity` (number): The starting opacity value (0-255).
*   `endOpacity` (number): The ending opacity value (0-255).
*   `time` (number): The duration of the animation in seconds.
*   `animSetting` (table, optional): A table containing additional animation settings (see **Animation Settings Table** in the `AnimEvent` constructor section for details).

**Returns:**

*   (number): The duration of the animation in seconds. 

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
animate.AlphaTransition(myEntity, 255, 0, 2) // Fade out the entity over 2 seconds
```

**Real-time Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
animate.RT.AlphaTransition(myEntity, 255, 0, 50) // Fade out the entity over 50 seconds in real-time
```


## [Animations/color.nut](color.nut)

This file provides the `animate.ColorTransition` function for creating animations that transition the color of entities over time. A real-time version is available as `animate.RT.ColorTransition`.

### `animate.ColorTransition(entities, startColor, endColor, time, animSetting)`

This function creates an animation that smoothly transitions the color of entities from the starting color to the ending color over a specified time.

**Parameters:**

*   `entities` (array, CBaseEntity, or pcapEntity): The entities to animate.
*   `startColor` (string or Vector): The starting color as a string (e.g., "255 0 0" for red) or a Vector with components (r, g, b).
*   `endColor` (string or Vector): The ending color as a string or a Vector.
*   `time` (number): The duration of the animation in seconds.
*   `animSetting` (table, optional): A table containing additional animation settings (see `AnimEvent` constructor for details).

**Returns:**

*   (number): The duration of the animation in seconds. 

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
animate.ColorTransition(myEntity, "255 0 0", "0 255 0", 3) // Change the entity's color from red to green over 3 seconds
```

**Real-time Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
animate.RT.ColorTransition(myEntity, "255 0 0", "0 255 0", 17) // Change the entity's color from red to green over 17 seconds in real-time
```



## [Animations/position.nut](position.nut)

This file provides the `animate.PositionTransitionByTime` and `animate.PositionTransitionBySpeed` functions for creating animations that transition the position of entities over time. Real-time versions are available as `animate.RT.PositionTransitionByTime` and `animate.RT.PositionTransitionBySpeed`.


### `animate.PositionTransitionByTime(entities, startPos, endPos, time, animSetting)`

This function creates an animation that moves entities from the starting position to the ending position over a specified time based on increments of time.

**Parameters:**

*   `entities` (array, CBaseEntity, or pcapEntity): The entities to animate.
*   `startPos` (Vector): The starting position of the entities.
*   `endPos` (Vector): The ending position of the entities.
*   `time` (number): The duration of the animation in seconds.
*   `animSetting` (table, optional): A table containing additional animation settings (see `AnimEvent` constructor for details).

**Returns:**

*   (number): The duration of the animation in seconds. 

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
local startPos = myEntity.GetOrigin()
local endPos = startPos + Vector(0, 100, 0) // Move 100 units along the Y axis
animate.PositionTransitionByTime(myEntity, startPos, endPos, 5) // Move the entity over 5 seconds
```

**Real-time Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
local startPos = myEntity.GetOrigin()
local endPos = startPos + Vector(0, 100, 0) // Move 100 units along the Y axis

local animSettings = {
    filterCallback = function(animInfo, _, _, _) {
        local ent = animInfo.entities[0]
        if (macros.GetDist(GetPlayer().GetOrigin(), ent.GetOrigin()) < 15) {
            printl("Animation interrupted! Player is too close.")  // Example output
            return true // Interrupt the animation
        }
        return false // Continue the animation
    }
}

animate.RT.PositionTransitionByTime(myEntity, startPos, endPos, 5, animSettings) // Move the entity over 5 seconds in real-time, with interrupt logic
```


### `animate.PositionTransitionBySpeed(entities, startPos, endPos, speed, animSetting)`

This function creates an animation that transitions the position of entities over time based on a specified speed. The animation calculates the time it takes to travel from the start position to the end position based on the provided speed and creates a smooth transition of the entities' positions over that duration.

**Parameters:**

*   `entities` (array, CBaseEntity, or pcapEntity): The entities to animate.
*   `startPos` (Vector): The starting position of the entities.
*   `endPos` (Vector): The ending position of the entities.
*   `speed` (number): The speed of the animation in units per tick.
*   `animSetting` (table, optional): A table containing additional animation settings (see the `AnimEvent` constructor for details).

**Returns:**

*   (number): The duration of the animation in seconds. 

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
local startPos = myEntity.GetOrigin()
local endPos = startPos + Vector(100, 0, 0) // Move 100 units to the right
animate.PositionTransitionBySpeed(myEntity, startPos, endPos, 50) // Animate the movement over time with a speed of 50 units per tick
```

**Real-time Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
local startPos = myEntity.GetOrigin()
local endPos = startPos + Vector(100, 0, 0) // Move 100 units to the right
animate.RT.PositionTransitionBySpeed(myEntity, startPos, endPos, 50) // Animate the movement over time with a speed of 50 units per tick in real-time
```




## [Animations/angles.nut](angles.nut)

This file provides the `animate.AnglesTransitionByTime` function for creating animations that transition the angles of entities over time.  A real-time version is available as `animate.RT.AnglesTransitionByTime`.

### `animate.AnglesTransitionByTime(entities, startAngles, endAngles, time, animSetting)`

This function creates an animation that smoothly changes the angles of entities from the starting angles to the ending angles over a specified time.

**Parameters:**

*   `entities` (array, CBaseEntity, or pcapEntity): The entities to animate.
*   `startAngles` (Vector): The starting angles of the entities (pitch, yaw, roll).
*   `endAngles` (Vector): The ending angles of the entities (pitch, yaw, roll).
*   `time` (number): The duration of the animation in seconds.
*   `animSetting` (table, optional): A table containing additional animation settings (see `AnimEvent` constructor for details).

**Returns:**

*   (number): The duration of the animation in seconds. 

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
local startAngles = myEntity.GetAngles()
local endAngles = startAngles + Vector(0, 90, 0) // Rotate 90 degrees around the Y axis
animate.AnglesTransitionByTime(myEntity, startAngles, endAngles, 2) // Rotate the entity over 2 seconds
```

**Real-time Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
local startAngles = myEntity.GetAngles()
local endAngles = startAngles + Vector(0, 90, 0) // Rotate 90 degrees around the Y axis
animate.RT.AnglesTransitionByTime(myEntity, startAngles, endAngles, 2) // Rotate the entity over 2 seconds in real-time
```


## Custom Animation Functions

You can create your own custom animation functions using `animate.applyAnimation`. Real-time versions of custom animations can be created by using `animate.applyRTAnimation`.

### `animate.applyAnimation(animInfo, valueCalculator, propertySetter, vars, transitionFrames)` | `animate.applyRTAnimation(animInfo, valueCalculator, propertySetter, vars, transitionFrames)`


These functions can be used directly to create more complex custom animation functions with unique logic.  Use `applyAnimation` for standard animations and `applyRTAnimation` for real-time animations.

**Example (Standard Animation):**

```js
animate["SkinTransition"] <- function(entities, startSkin, endSkin, time, animSetting = {}) {
    local vars = {
        start = startSkin,
        delta = endSkin - startSkin,
        mut = (endSkin - startSkin) < 0 ? -1 : 1 
    }
    if(vars.delta == 0) return 0

    animSetting["frameInterval"] <- time / abs(vars.delta)
    local animInfo = AnimEvent("skin", animSetting, entities, time)

    animate.applyAnimation( 
        animInfo, 
        function(step, steps, v) {return v.start + step * v.mut},
        function(ent, newSkin) {ent.SetSkin(newSkin)},
        vars,
        abs(vars.delta)
    )
    
    animInfo.CallOutput()
    return animInfo.delay
}
```

**Example (Real-time Animation):**

```js
animate.RT["SkinTransition"] <- function(entities, startSkin, endSkin, time, animSetting = {}) {
    local vars = {
        start = startSkin,
        delta = endSkin - startSkin,
        mut = (endSkin - startSkin) < 0 ? -1 : 1 
    }
    if(vars.delta == 0) return 0

    animSetting["frameInterval"] <- time / abs(vars.delta)
    local animInfo = AnimEvent("skin", animSetting, entities, time)

    animate.applyRTAnimation( 
        animInfo, 
        function(step, steps, v) {return v.start + step * v.mut},
        function(ent, newSkin) {ent.SetSkin(newSkin)},
        vars,
        abs(vars.delta)
    )
    
    animInfo.CallOutput()
    return animInfo.delay   
}
```