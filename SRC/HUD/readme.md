# HUD Module

The `HUD` module provides functions and classes for creating and managing Heads-Up Display (HUD) elements in VScripts. It simplifies the process of displaying text, hints, and other UI elements on the screen, allowing developers to easily create custom HUD elements for their game modes and mods.


## Table of Contents

1.  [HUD/init.nut](#hudinitnut)
2.  [HUD/ScreenText.nut](#hudscreentextnut)
    * [`HUD.ScreenText(position, message, holdtime, targetname)`](#hudscreentextposition-message-holdtime-targetname)
        * [`Enable(holdTime)`](#hudscreentextenableholdtime)
        * [`Disable()`](#hudscreentextdisable)
        * [`Update()`](#hudscreentextupdate)
        * [`SetText(message)`](#hudscreentextsettextmessage)
        * [`SetChannel(value)`](#hudscreentextsetchannelvalue)
        * [`SetColor(string_color)`](#hudscreentextsetcolorstring_color)
        * [`SetColor2(string_color)`](#hudscreentextsetcolor2string_color)
        * [`SetEffect(value)`](#hudscreentextseteffectvalue)
        * [`SetFadeIn(value)`](#hudscreentextsetfadeinvalue)
        * [`SetFadeOut(value)`](#hudscreentextsetfadeoutvalue)
        * [`SetHoldTime(time)`](#hudscreentextsetholdtimetime)
        * [`SetPos(Vector)`](#hudscreentextsetposvector)
    * [**HUD.ScreenText Builder Usage**](#hudscreentext-builder-usage)
3.  [HUD/hint_instructor.nut](#hudhintinstructornut)
    * [`HUD.HintInstructor(message, holdtime, icon, showOnHud, targetname)`](#hudhintinstructormessage-holdtime-icon-showonhud-targetname)
        * [`Enable()`](#hudhintinstructorenable)
        * [`Disable()`](#hudhintinstructordisable)
        * [`Update()`](#hudhintinstructorupdate)
        * [`SetText(message)`](#hudhintinstructorsettextmessage)
        * [`SetBind(bind)`](#hudhintinstructorsetbindbind)
        * [`SetPositioning(value, ent)`](#hudhintinstructorsetpositioningvalue-ent)
        * [`SetColor(string_color)`](#hudhintinstructorsetcolorstring_color)
        * [`SetIconOnScreen(icon)`](#hudhintinstructorseticononscreenicon)
        * [`SetIconOffScreen(icon)`](#hudhintinstructorseticonoffscreenicon)
        * [`SetHoldTime(time)`](#hudhintinstructorsetholdtimetime)
        * [`SetDistance(value)`](#hudhintinstructorsetdistancevalue)
        * [`SetEffects(sizePulsing, alphaPulsing, shaking)`](#hudhintinstructorseteffectssizepulsing-alphapulsing-shaking)
    * [**HUD.HintInstructor Builder Usage**](#hudhintinstructor-builder-usage)

## [HUD/init.nut](init.nut)

This file initializes the `HUD` module by declaring a global table `::HUD` which will store all HUD-related functions and classes.

## [HUD/game_text.nut](game_text.nut)

This file provides the `HUD.ScreenText` class for creating and managing on-screen text elements using the "game_text" entity.

### `HUD.ScreenText`

The `HUD.ScreenText` class represents an on-screen text element that can be displayed, hidden, and updated dynamically. It provides a convenient way to create and manage "game\_text" entities without writing extensive code.

#### `HUD.ScreenText(position, message, holdtime, targetname)`

**Constructor**

Creates a new `HUD.ScreenText` object with the specified position, message, hold time, and optional target name.

**Parameters:**

*   `position` (Vector): The position of the text on the screen (in screen coordinates).
*   `message` (string): The text message to display.
*   `holdtime` (number, optional): The duration in seconds to display the text (default is 10).
*   `targetname` (string, optional): The target name of the "game\_text" entity (default is an empty string).

**Example:**

```js
local textPos = Vector(0.5, 0.5, 0) // Center of the screen
local myText = HUD.ScreenText(textPos, "Hello, world!", 5, "my_text_element") // Display for 5 seconds with a target name
```

#### `HUD.ScreenText.Enable(holdTime)`

Displays the on-screen text.

**Parameters:**
*   `holdtime` (number, optional): The duration in seconds to display the text (default is 10).

**Example:**

```js
myText.Enable() // Make the text visible
myText2.Enable(2) // Make the text visible for 2 seconds
```

#### `HUD.ScreenText.Disable()`

Hides the on-screen text.

**Example:**

```js
myText.Disable() // Hide the text
```

#### `HUD.ScreenText.Update()`

Updates and redisplays the on-screen text. This can be used to refresh the text if its properties have been changed.

**Example:**

```js
myText.SetText("New message").Update() // Change the message and update the display
```

#### `HUD.ScreenText.SetText(message)`

Changes the message of the text display.

**Parameters:**

*   `message` (string): The new text message to display.

**Returns:**

*   (HUD.ScreenText): The `HUD.ScreenText` object itself, allowing for method chaining.

**Example:**

```js
myText.SetText("Updated message") // Change the text
```

#### `HUD.ScreenText.SetChannel(value)`

Sets the channel of the text display. The channel determines the rendering order of the text (higher channels are drawn on top of lower channels).

**Parameters:**

*   `value` (number): The channel to set.

**Returns:**

*   (HUD.ScreenText): The `HUD.ScreenText` object itself, allowing for method chaining.

**Example:**

```js
myText.SetChannel(3) // Set the channel to 3
```

#### `HUD.ScreenText.SetColor(string_color)`

Sets the primary color of the text display as a string.

**Parameters:**

*   `string_color` (string): The color string in the format "R G B" (e.g., "255 0 0" for red).

**Returns:**

*   (HUD.ScreenText): The `HUD.ScreenText` object itself, allowing for method chaining.

**Example:**

```js
myText.SetColor("0 255 0") // Set the color to green
```

#### `HUD.ScreenText.SetColor2(string_color)`

Sets the secondary color of the text display as a string. The secondary color is used for effects like outlines or shadows.

**Parameters:**

*   `string_color` (string): The color string in the format "R G B" (e.g., "0 0 0" for black).

**Returns:**

*   (HUD.ScreenText): The `HUD.ScreenText` object itself, allowing for method chaining.

**Example:**

```js
myText.SetColor2("0 0 0") // Set the secondary color to black
```

#### `HUD.ScreenText.SetEffect(value)`

Sets the effect of the text display.

**Parameters:**

*   `value` (number): The index of the effect to set (refer to the "game\_text" entity documentation for available effects).

**Returns:**

*   (HUD.ScreenText): The `HUD.ScreenText` object itself, allowing for method chaining.

**Example:**

```js
myText.SetEffect(1) // Set the effect to a specific index
```

#### `HUD.ScreenText.SetFadeIn(value)`

Sets the fade-in time of the text display.

**Parameters:**

*   `value` (number): The fade-in time in seconds.

**Returns:**

*   (HUD.ScreenText): The `HUD.ScreenText` object itself, allowing for method chaining.

**Example:**

```js
myText.SetFadeIn(1) // Fade in over 1 second
```

#### `HUD.ScreenText.SetFadeOut(value)`

Sets the fade-out time of the text display.

**Parameters:**

*   `value` (number): The fade-out time in seconds.

**Returns:**

*   (HUD.ScreenText): The `HUD.ScreenText` object itself, allowing for method chaining.

**Example:**

```js
myText.SetFadeOut(2) // Fade out over 2 seconds
```

#### `HUD.ScreenText.SetHoldTime(time)`

Sets the hold time (duration) of the text display.

**Parameters:**

*   `time` (number): The hold time in seconds.

**Returns:**

*   (HUD.ScreenText): The `HUD.ScreenText` object itself, allowing for method chaining.

**Example:**

```js
myText.SetHoldTime(8) // Display for 8 seconds
```

#### `HUD.ScreenText.SetPos(Vector)`

Sets the position of the text display.

**Parameters:**

*   `Vector` (Vector): The new position of the text on the screen (in screen coordinates).

**Returns:**

*   (HUD.ScreenText): The `HUD.ScreenText` object itself, allowing for method chaining.

**Example:**

```js
local newPos = Vector(0.25, 0.75, 0)
myText.SetPos(newPos) // Move the text to a new position
```

#### **HUD.ScreenText Builder Usage:**

The methods of `HUD.ScreenText` can be chained together using the builder pattern, allowing you to configure the text element in a concise and readable way. Each method returns the `HUD.ScreenText` object itself, so you can call multiple methods in sequence.

**Example:**

```js
HUD.ScreenText(Vector(0, 0.5, 0), "My Text", 999)
    .SetChannel(1)
    .SetEffect(2)
    .SetFadeIn(0.01)
    .SetColor("255 125 0")
    .SetColor2("100 100 100")
.Enable() // "Build" and display the text
```


## [HUD/hint_instructor.nut](hint_instructor.nut)

This file provides the `HUD.HintInstructor` class for creating and managing hints using the "env\_instructor\_hint" entity.

### `HUD.HintInstructor`

The `HUD.HintInstructor` class represents a hint element that can be displayed, hidden, and updated dynamically. It provides a convenient way to create and manage "env\_instructor\_hint" entities without writing extensive code.

#### `HUD.HintInstructor(message, holdtime, icon, showOnHud, targetname)`

**Constructor**

Creates a new `HUD.HintInstructor` object with the specified message, hold time, icon, positioning, and optional target name.

**Parameters:**

*   `message` (string): The hint message to display.
*   `holdtime` (number, optional): The duration in seconds to display the hint (default is 5).
*   `icon` (string, optional): The icon to display with the hint (default is "icon\_tip").
*   `showOnHud` (number, optional): Whether to display the hint on the HUD (1) or at the target entity's position (0) (default is 1).
*   `targetname` (string, optional): The target name of the "env\_instructor\_hint" entity (default is an empty string).

**Example:**

```js
local myHint = HUD.HintInstructor("Press E to interact", 3, "icon_interact", 1, "my_hint_element") // Display for 3 seconds with a custom icon and target name
```

#### `HUD.HintInstructor.Enable()`

Displays the hint.

**Example:**

```js
myHint.Enable() // Show the hint
```

#### `HUD.HintInstructor.Disable()`

Hides the hint.

**Example:**

```js
myHint.Disable() // Hide the hint
```

#### `HUD.HintInstructor.Update()`

Updates and redisplays the hint. This can be used to refresh the hint if its properties have been changed.

**Example:**

```js
myHint.SetText("New hint message").Update() // Change the message and update the display
```

#### `HUD.HintInstructor.SetText(message)`

Changes the message of the hint.

**Parameters:**

*   `message` (string): The new hint message to display.

**Returns:**

*   (HUD.HintInstructor): The `HUD.HintInstructor` object itself, allowing for method chaining.

**Example:**

```js
myHint.SetText("Updated hint message") // Change the text
```

#### `HUD.HintInstructor.SetBind(bind)`

Sets the bind to display with the hint icon and updates the icon to "use\_binding".

**Parameters:**

*   `bind` (string): The bind name to display (e.g., "+use").

**Returns:**

*   (HUD.HintInstructor): The `HUD.HintInstructor` object itself, allowing for method chaining.

**Example:**

```js
myHint.SetBind("+use") // Display the "+use" bind with the icon
```

#### `HUD.HintInstructor.SetPositioning(value, ent)`

Sets the positioning of the hint (on HUD or at target entity).

**Parameters:**

*   `value` (number): 1 to display the hint on the HUD, 0 to display it at the target entity's position.
*   `ent` (CBaseEntity, pcapEntity, or null, optional): The target entity to position the hint at (only used if `value` is 0).

**Returns:**

*   (HUD.HintInstructor): The `HUD.HintInstructor` object itself, allowing for method chaining.

**Example:**

```js
local targetEntity = Entities.FindByName(null, "my_target_entity")
myHint.SetPositioning(0, targetEntity) // Display the hint at the target entity's position
```

#### `HUD.HintInstructor.SetColor(string_color)`

Sets the color of the hint text as a string.

**Parameters:**

*   `string_color` (string): The color string in the format "R, G, B" (e.g., "255, 0, 0" for red).

**Returns:**

*   (HUD.HintInstructor): The `HUD.HintInstructor` object itself, allowing for method chaining.

**Example:**

```js
myHint.SetColor("0, 255, 0") // Set the color to green
```

#### `HUD.HintInstructor.SetIconOnScreen(icon)`

Sets the icon to display when the hint is on-screen.

**Parameters:**

*   `icon` (string): The icon name to display (e.g., "icon\_tip").

**Returns:**

*   (HUD.HintInstructor): The `HUD.HintInstructor` object itself, allowing for method chaining.

**Example:**

```js
myHint.SetIconOnScreen("icon_interact") // Set a custom icon
```

#### `HUD.HintInstructor.SetIconOffScreen(icon)`

Sets the icon to display when the hint is off-screen.

**Parameters:**

*   `icon` (string): The icon name to display (e.g., "icon\_tip").

**Returns:**

*   (HUD.HintInstructor): The `HUD.HintInstructor` object itself, allowing for method chaining.

**Example:**

```js
myHint.SetIconOffScreen("icon_arrow") // Set a custom off-screen icon
```

#### `HUD.HintInstructor.SetHoldTime(time)`

Sets the hold time (duration) of the hint.

**Parameters:**

*   `time` (number): The hold time in seconds.

**Returns:**

*   (HUD.HintInstructor): The `HUD.HintInstructor` object itself, allowing for method chaining.

**Example:**

```js
myHint.SetHoldTime(10) // Display for 10 seconds
```

#### `HUD.HintInstructor.SetDistance(value)`

Sets the distance at which the hint is visible.

**Parameters:**

*   `value` (number): The distance in units.

**Returns:**

*   (HUD.HintInstructor): The `HUD.HintInstructor` object itself, allowing for method chaining.

**Example:**

```js
myHint.SetDistance(500) // Make the hint visible within 500 units
```

#### `HUD.HintInstructor.SetEffects(sizePulsing, alphaPulsing, shaking)`

Sets the visual effects for the hint.

**Parameters:**

*   `sizePulsing` (number): The size pulsing option (0 for no pulsing, 1 for pulsing).
*   `alphaPulsing` (number): The alpha pulsing option (0 for no pulsing, 1 for pulsing).
*   `shaking` (number): The shaking option (0 for no shaking, 1 for shaking).

**Returns:**

*   (HUD.HintInstructor): The `HUD.HintInstructor` object itself, allowing for method chaining.

**Example:**

```js
myHint.SetEffects(1, 0, 1) // Enable size pulsing and shaking
```

#### **HUD.HintInstructor Builder Usage:**

Similar to `HUD.ScreenText`, the methods of `HUD.HintInstructor` can also be chained together using the builder pattern, providing a fluent way to configure hint elements.

**Example:**

```js
local targetEntity = Entities.FindByName(null, "my_target")

HUD.HintInstructor("Interact with this object", 5, "icon_interact", 0, "my_hint")
    .SetPositioning(0, targetEntity) // Display at the target entity's position
    .SetColor("255, 255, 0") // Set the color to yellow
    .SetDistance(200) // Make the hint visible within 200 units
.Enable() // "Build" and display the hint 
```