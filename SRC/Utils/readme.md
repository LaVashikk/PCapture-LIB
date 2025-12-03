# Utils Module

The `Utils` module provides a collection of utility functions for script execution, debugging, file operations, and working with entities in VScripts. It aims to simplify common tasks and enhance the development experience.

## Table of Contents

* [`Utils/debug.nut`](#utilsdebugnut)
	* [`LoggerLevels`](#loggerlevels)
	* [`DrawEntityBBox(ent, color, time)`](#drawentitybboxent-color-time)
	* [`DrawEntityAABB(ent, color, time)`](#drawentityaabbent-color-time)
	* [`drawbox(vector, color, time)`](#drawboxvector-color-time)
	* [`trace(msg, ...)`](#tracemsg-)
	* [`debug(msg, ...)`](#debugmsg-)
	* [`info(msg, ...)`](#infomsg-)
	* [`warning(msg, ...)`](#warningmsg-)
	* [`error(msg, ...)`](#errormsg-)
* [`Utils/file.nut`](#utilsfilenut)
	* [`File(path)`](#filepath)
	* [`write(text)`](#writetext)
	* [`writeRawData(text)`](#writerawdatatext)
	* [`readlines()`](#readlines)
	* [`read()`](#read)
	* [`clear()`](#clear)
	* [`updateInfo()`](#updateinfo)
* [`Utils/improvements.nut`](#utilsimprovementsnut)
	* [`FrameTime()`](#frametime)
	* [`UniqueString(prefix)`](#uniquestringprefix)
	* [`EntFireByHandle(target, action, value, delay, activator, caller)`](#entfirebyhandletarget-action-value-delay-activator-caller)
	* [`GetPlayerEx(index)`](#getplayerexindex)
* [`ActionScheduler/player_hooks.nut`](#actionschedulerplayer_hooksnut)
	* [`GetPlayers()`](#getplayers)
	* [`TrackPlayerJoins()`](#trackplayerjoins)
	* [`HandlePlayerEventsMP()`](#handleplayereventsmp)
	* [`HandlePlayerEventsSP()`](#handleplayereventssp)
	* [`AttachEyeControl(player)`](#attacheyecontrolplayer)
	* [`Hooks List`](#hooks-customizable-functions)
		* [`OnPlayerJoined(player)`](#onplayerjoinedplayer)
		* [`OnPlayerLeft(player)`](#onplayerleftplayer)
		* [`OnPlayerDeath(player)`](#onplayerdeathplayer)
		* [`OnPlayerRespawn(player)`](#onplayerrespawnplayer)
* [`Utils/portals.nut`](#utilsportalsnut)
	* [`InitPortalPair(id)`](#initportalpairid)
	* [`IsBluePortal(ent)`](#isblueportalent)
	* [`FindPartnerForPropPortal(portal)`](#findpartnerforpropportalportal)
	* [`SetupLinkedPortals()`](#setuplinkedportals)
* [`Utils/macros.nut`](#utilsmacrosnut)
	* [`Precache(soundPath)`](#macrosprecachesoundpath)
	* [`GetSoundDuration(soundName)`](#macrosgetsounddurationsoundname)
	* [`CreateAlias(key, action)`](#macroscreatealiaskey-action)
	* [`CreateCommand(key, command)`](#macroscreatecommandkey-command)
	* [`format(msg, ...)`](#macrosformatmsg-)
	* [`fprint(msg, ...)`](#macrosfprintmsg-)
	* [`CompileFromStr(funcBody, ...)`](#macroscompilefromstrfuncbody-)
	* [`GetFromTable(table, key, defaultValue)`](#macrosgetfromtabletable-key-defaultvalue)
	* [`GetKeys(table)`](#macrosgetkeystable)
	* [`GetValues(table)`](#macrosgetvaluestable)
	* [`InvertTable(table)`](#macrosinverttabletable)
	* [`PrintIter(iterable)`](#macrosprintiteriterable)
	* [`MaskSearch(iter, match)`](#macrosmasksearchiter-match)
	* [`GetRectangle(v1, v2, v3, v4)`](#macrosgetrectanglev1-v2-v3-v4)
	* [`PointInBBox(point, bMin, bMax)`](#macrospointinbboxpoint-bmin-bmax)
	* [`PointInBounds(point)`](#macrospointinboundspoint)
	* [`Range(start, end, step)`](#macrosrangestart-end-step)
	* [`RangeIter(start, end, step)`](#macrosrangeiterstart-end-step)
	* [`GetDist(vec1, vec2)`](#macrosgetdistvec1-vec2)
	* [`StrToVec(str)`](#macrosstrtovecstr)
	* [`VecToStr(vec, sep)`](#macrosvectostrvecsep)
	* [`IsEqual(val1, val2)`](#macrosIsEqualval1-val2)
	* [`DeepCopy(container)`](#macrosdeepcopycontainer)
	* [`GetPrefix(name)`](#macrosgetprefixname)
	* [`GetPostfix(name)`](#macrosgetpostfixname)
	* [`GetEyeEndpos(player, distance)`](#macrosgeteyeendposplayer-distance)
	* [`GetVertex(x, y, z, ang)`](#macrosgetvertexx-y-z-ang)
	* [`GetTriangle()`](#macrosgettrianglev1-v2-v3)
	* [`BuildAnimateFunction(name, propertySetterFunc, valueCalculator)`](#macrosbuildanimatefunctionname-propertysetterfunc-valuecalculator)
	* [`BuildRTAnimateFunction(name, propertySetterFunc, valueCalculator)`](#macrosbuildrtanimatefunctionname-propertysetterfunc-valuecalculator)
* [`Utils/const.nut`](#utilsconstnut)


## [Utils/debug.nut](debug.nut)

This file contains functions for debugging and logging messages to the console, as well as visualizing entity bounding boxes.

### LoggerLevels
The `LoggerLevels` class defines different levels of logging. The available levels are:
- `Trace` (1)
- `Debug` (5)
- `Info` (10)
- `Warning` (30)
- `Error` (60)
- `Off` (1000)

To use these levels, you need to set the `LibLogger` variable after initializing the library. For example:
```js
LibLogger = LoggerLevels.Trace
```

All logging functions only work if the console command `developer` is set to a value higher than 0.

### `DrawEntityBBox(ent, color, time)`

This function draws the bounding box of an entity using `DebugDrawBox` for the specified duration. It is helpful for visualizing the extents of an entity and debugging collision issues.

**Parameters:**

* `ent` (CBaseEntity or pcapEntity): The entity to draw the bounding box for.
* `color` (Vector): The color of the box as a Vector with components (r, g, b).
* `time` (number): The duration in seconds to display the bounding box.

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
dev.DrawEntityBBox(myEntity, Vector(125, 0, 1255), 5) // Draw the bounding box for 5 seconds
```

### `DrawEntityAABB(ent, color, time)`

This function draws the AABB of an entity using `DebugDrawBox` for the specified duration.

**Parameters:**

* `ent` (CBaseEntity or pcapEntity): The entity to draw the bounding box for.
* `color` (Vector): The color of the box as a Vector with components (r, g, b).
* `time` (number): The duration in seconds to display the bounding box.

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
dev.DrawEntityAABB(myEntity, Vector(125, 0, 1255), 5) // Draw the bounding box for 5 seconds
```

#### `drawbox(vector, color, time)`

This function draws a box at the specified position with the given color and duration. It is useful for visualizing points or areas in the game world.

**Parameters:**

* `vector` (Vector): The position of the center of the box.
* `color` (Vector): The color of the box as a Vector with components (r, g, b).
* `time` (number, optional): The duration in seconds to display the box (default is 0.05 seconds).

**Example:**

```js
dev.drawbox(Vector(0, 0, 100), Vector(255, 0, 0), 2) // Draw a red box for 2 seconds
```

#### `trace(msg, ...)`

This function logs a trace message to the console if trace logging is enabled. It is intended for internal use within the PCapture-Lib and is not recommended for use outside the library.

**Parameters:**

* `msg` (string): The trace message string containing `{}` placeholders.
* `...` (any): Additional arguments to substitute into the placeholders.

**Example:**

```js
dev.trace("Trace message with value: {}", someValue)
```

#### `debug(msg, ...)`

This function logs a debug message to the console if debug logging is enabled.

**Parameters:**

* `msg` (string): The debug message string containing `{}` placeholders.
* `...` (any): Additional arguments to substitute into the placeholders.

**Example:**

```js
dev.debug("This is a {} message with value: {}", "debug", someValue)
```

#### `info(msg, ...)`

This function logs an info message to the console if info logging is enabled.

**Parameters:**

* `msg` (string): The info message string containing `{}` placeholders.
* `...` (any): Additional arguments to substitute into the placeholders.

**Example:**

```js
dev.info("Information message with value: {}", someValue)
```

#### `warning(msg, ...)`

This function displays a warning message in a specific format, including the function name and line number where the warning originated.

**Parameters:**

* `msg` (string): The warning message string containing `{}` placeholders.
* `...` (any): Additional arguments to substitute into the placeholders.

**Example:**

```js
if (someCondition) {
    dev.warning("Unexpected condition encountered! Value: {}", someValue)
}
```

#### `error(msg, ...)`

This function displays an error message in a specific format, including the function name and line number where the error occurred. It is used to indicate critical errors that prevent the script from functioning correctly.

**Parameters:**

* `msg` (string): The error message string containing `{}` placeholders.
* `...` (any): Additional arguments to substitute into the placeholders.

**Example:**

```js
if (!someEntity.IsValid()) {
    dev.error("Entity is invalid! Entity ID: {}", someEntity.GetID())
}
```
## [Utils/file.nut](file.nut)

This file defines the `File` class for reading from and writing to files.  This class simplifies file interactions by providing convenient methods for writing and reading data. It utilizes a global cache to store file contents, allowing for efficient data access after a one-tick delay.

### `File(path)`

**Constructor**

This creates a new `File` object for the specified file path. The file extension ".log" is automatically added if it is not already present in the path. A cache array is also created in the global scope using the file name as the key to store the lines of the file.

**Parameters:**

* `path` (string): The path to the file, relative to the `cfg` directory. The path should only contain the file name. Folders are not supported.

**Note:**

*   The file name cannot contain special characters, spaces, or forward slashes (/). Using such characters might lead to unexpected behavior or errors in file operations.
*   To include a double quote character (") within the text being written to the file using the `write` method, use double escaping (\\"). For example, to write the string `He said, "Hello!"`, use `myFile.write("He said, \\"Hello!\\"")`.

**Example:**

```js
local myFile = File("my_data") // Creates a File object for "cfg/my_data.log"
```

### `write(text)`

This method appends the given text to the end of the file. The text is automatically enclosed in double quotes and escaped for proper writing to the file.

**Parameters:**

* `text` (string): The text to append to the file. To include a double quote within the text, use double escaping (\\").

**Example:**

```js
myFile.write("This is some data to write to the file.")
```

### `writeRawData(text)`

This method appends the given text to the end of the file without any automatic escaping or quoting. This allows for writing raw data or commands to the file.

**Parameters:**

* `text` (string): The raw text to append to the file.

**Example:**

```js
myFile.writeRawData("script myVariable = \"This is a string!\";")
```

### `readlines()`

This method reads all lines from the file and returns them as an array of strings. The global cache array associated with the file name is updated with the contents of the file. **Call `updateInfo()` and wait for one tick using `yield` or `RunScriptCode.delay()` before using this method to ensure the data is available in the cache.**

**Returns:**

* (array): An array of strings, where each string is a line from the file.

**Example:**

```js
// ScheduleEvent environment
local file = File("MyFile")
file.updateInfo()
yield 0.01 // Wait for one tick
local lines = file.readlines()
foreach (line in lines) {
    printl(line)
}
```

### `read()`

This method reads the entire contents of the file and returns it as a single string. **Call `updateInfo()` and wait for one tick using `yield` or `RunScriptCode.delay()` before using this method to ensure the data is available in the cache.**

**Returns:**

* (string): The contents of the file as a string.

**Example:**

```js
// ScheduleEvent environment
local file = File("MyFile")
file.updateInfo()
yield 0.01 // Wait for one tick
local content = file.read()
printl(content)
```

### `clear()`

This method clears the contents of the file by emptying the global cache array associated with the file name and writing an empty array to the file.

**Example:**

```js
myFile.clear() // Clear the contents of the file
```

### `updateInfo()`

This method updates information about the file by executing it as a script. This is necessary to ensure that the global cache array is populated with the latest contents of the file before reading from it using `readlines()` or `read()`.

**Example:**

```js
local file = File("MyFile")
file.updateInfo() // Update the file information
```

**Usage Recommendations:**

Due to the asynchronous nature of file operations in VScripts, it's highly recommended to use the `File` class within a scheduled environment, such as a `ScheduleEvent` or a custom timer function, and incorporate a one-tick delay using `yield` after calling `updateInfo()`. This ensures that the file operations are performed sequentially and the data is properly synchronized. For example:

```js
function myScheduledFunction() {
    local file = File("MyFile")
    file.updateInfo()
    yield 0.1 // Wait
    local lines = file.readlines()
    // ... process file data
}

ScheduleEvent.Add("global", myScheduledFunction, 0) // Call myScheduledFunction
```

## [Utils/improvements.nut](improvements.nut)

This file overrides and improves existing VScripts functions to provide additional functionality or prevent potential issues.

### `FrameTime()`

This function overrides the standard `FrameTime` function to ensure that the returned frame time is never zero. This prevents issues that can arise from zero frame times in some situations. If the frame time is zero, it returns a small default value of 0.016 seconds.

**Returns:**

* (number): The current frame time in seconds.

**Example:**

```js
local deltaTime = FrameTime() // Get the current frame time, ensuring it is not zero
```

### `UniqueString(prefix)`

This function overrides the standard `UniqueString` function to include a prefix in the generated unique string. This can be useful for creating unique names for entities or other objects.

**Parameters:**

* `prefix` (string, optional): The prefix to use for the unique string (default is "u").

**Returns:**

* (string): The generated unique string with the specified prefix.

**Example:**

```js
local uniqueName = UniqueString("my_entity_") // Generates a unique name starting with "my_entity_"
```

### `EntFireByHandle(target, action, value, delay, activator, caller)`

This function overrides the standard `EntFireByHandle` function to handle `pcapEntity` objects and extract the underlying `CBaseEntity` objects. It also allows specifying an activator and caller entity, which can be useful for tracking the source of entity inputs.

**Parameters:**

* `target` (CBaseEntity or pcapEntity): The target entity to trigger the input on.
* `action` (string): The name of the input to trigger.
* `value` (string, optional): The value to pass to the input (default is an empty string).
* `delay` (number, optional): The delay in seconds before triggering the input (default is 0).
* `activator` (CBaseEntity or pcapEntity, optional): The activator entity (the entity that triggered the input).
* `caller` (CBaseEntity or pcapEntity, optional): The caller entity (the entity that called the function).

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
local triggerEntity = entLib.FindByClassname("trigger_once")
EntFireByHandle(myEntity, "Kill", "", 0, triggerEntity) // Kill the entity with the trigger as the activator
```

### `GetPlayerEx(index)`

This function retrieves a player entity with extended functionality as a `pcapEntity` object. It provides a more convenient way to access player information and methods compared to the standard `GetPlayer` function.

**Parameters:**

* `index` (number, optional): The index of the player (0-based, default is 0).

**Returns:**

* (pcapEntity): The `pcapEntity` object representing the player, or `null` if the player is not found.

**Example:**

```js
local player = GetPlayerEx()
printl(player.EyePosition()) // Print the player's eye position
```

## [ActionScheduler/player_hooks.nut](#actionschedulerplayer_hooksnut)

This module manages player-related events and provides hooks for custom logic. It maintains a list of all players in the game and offers functions to track player joins, departures, deaths, and respawns.

### `GetPlayers()`

This function returns an array of all players in the game as `pcapEntity` objects.

**Returns:**

* (array): An array of `pcapEntity` objects representing the players in the game.

**Example:**

```js
local players = GetPlayers()
foreach (player in players) {
    printl(player.GetName()) // Print the name of each player
}
```

### `TrackPlayerJoins()`

Tracks players joining the game. It iterates through all player entities, initializes their eye control, creates portal pairs (if applicable), adds them to the `AllPlayers` array, and triggers the `OnPlayerJoined` hook.

> [!NOTE]  
> This function is called automatically

### `HandlePlayerEventsMP()`

Handles player events in multiplayer mode, including health checks and death events. It iterates through the `AllPlayers` array, checks player validity, calls `OnDeath` and schedules respawn logic for dead players, and removes disconnected players from the `AllPlayers` array.  Sets player health to -999 to prevent repeated death triggers.

> [!NOTE]  
> This function is called automatically

### `HandlePlayerEventsSP()`

Handles player events in single-player mode, similar to `HandlePlayerEventsMP`, but simplified for a single player.  Sets player health to -999 to prevent repeated death triggers.

> [!NOTE]  
> This function is called automatically

### `_monitorRespawn(player)`

Internal function to monitor a player's respawn status.  This function is called by `ScheduleEvent.Add` within `HandlePlayerEventsMP`.  It continuously checks the player's health and triggers the `OnPlayerRespawn` hook upon successful respawn.

**Parameters:**

* `player` (pcapEntity): The player whose respawn status is being monitored.

> [!NOTE]  
> This function is called automatically by `HandlePlayerEventsMP`


### `AttachEyeControl(player)`

Attaches eye control entities to a player. This function creates `logic_measure_movement` and `info_target` entities to track the player's eye position and angles.

**Parameters:**

* `player` (pcapEntity): The player to attach the eye control to.

> [!NOTE]  
> This function is called automatically

## Hooks (Customizable Functions)

The following functions are provided as hooks for custom logic. They are initially empty and can be overridden by the user.

### `OnPlayerJoined(player)`

Called when a player joins the game.

**Parameters:**

* `player` (pcapEntity): The player who joined.

### `OnPlayerLeft(player)`

Called when a player leaves the game.

**Parameters:**

* `player` (pcapEntity): The player who left.

### `OnPlayerDeath(player)`

Called when a player dies.

**Parameters:**

* `player` (pcapEntity): The player who died.


### `OnPlayerRespawn(player)`

Called when a player respawns.

**Parameters:**

* `player` (pcapEntity): The player who respawned.

## [Utils/portals.nut](portals.nut)

### `InitPortalPair(id)`
Initializes a portal pair for portal casting (TracePlus Portal Casting). 

By default, this function automatically initializes pair IDs in multiplayer. However, if you are using portal frames with unique pair IDs or custom logic that adds multiple different pair IDs to the game (such as multiportals), you must manually initialize `InitPortalPair` for proper operation with TracePlus Portal Casting.

**Parameters:**

* `id` (number): The ID of the portal pair.

**Example:**

```js
// Initialize a portal pair with ID 1
InitPortalPair(1)
// Initialize a portal pair with ID 2
InitPortalPair(4)
```

### `IsBluePortal(ent)`
Checks if the given entity is a blue portal.

**Parameters:**

* `ent` (pcapEntity): The entity to check.

**Returns:**

* (boolean): `True` if the entity is a blue portal, `False` is a orange portal.

**Example:**

```js
local portal = entLib.FindByClassname("prop_portal")
if (IsBluePortal(portal)) {
    printl("This is a blue portal")
} else {
    printl("This is a orange portal")
}
```

### `FindPartnerForPropPortal(portal)`
Finds the partner portal for a given `prop_portal` entity.

**Parameters:**

* `portal` (pcapEntity): The `prop_portal` entity to find the partner for.

**Returns:**

* (pcapEntity|null): The partner portal entity, or `null` if no partner is found.

### `_CreatePortalDetector(extraKey, extraValue)`
Creates a `func_portal_detector` entity with specified key-value pairs and settings for portal detection.

**This function is not part of the public API.**

**Parameters:**

* `extraKey` (string): The key for the additional setting.
* `extraValue` (any): The value for the additional setting.

**Returns:**

* (entity): The created `func_portal_detector` entity.

### `SetupLinkedPortals()`
Initializes linked portal doors for portal tracing.

**This function is not part of the public API and called automatically at initialization.**

This function iterates through all entities of class `linked_portal_door` and performs the following actions:
1. Check if this entity has been processed before.
2. Extracts bounding box dimensions from the portal's model name (assuming a specific naming convention).
3. **Important:** For proper tracing, ensure that the `model` keyvalue of `linked_portal_door` contains `weight height`, as these values are used to calculate the bounding box.
4. Rotates the bounding box dimensions based on the portal's angles.
5. Sets the bounding box of the portal using the calculated dimensions.

## [Utils/macros.nut](macros.nut)

This file contains various macro functions that provide shortcuts for common operations, such as precaching sounds, retrieving values from tables, printing iterable objects, calculating distances, converting between strings and vectors, and getting entity name prefixes and postfixes. These macros aim to reduce code duplication and improve readability.

### `macros.Precache(soundPath)`

This macro precaches a sound script or a list of sound scripts for later use. Precaching ensures that the sounds are loaded into memory and can be played without delay.

**Parameters:**

* `soundPath` (string, array, or ArrayEx): The path to the sound script or a list of paths to sound scripts, relative to the `sound` directory.

**Example:**

```js
macros.Precache("my_sound.wav") // Precache a single sound
macros.Precache(["sound1.wav", "sound2.wav"]) // Precache multiple sounds
```

### `macros.GetSoundDuration(soundName)`

This function retrieves the duration of a sound by its name. It is useful for determining how long a sound will play, which can be used for synchronization or timing purposes in scripts.

**Parameters:**

* `soundName` (string): The name of the sound.

**Returns:**

* `number`: The duration of the sound in seconds.

**Example:**

```js
local duration = macros.GetSoundDuration("my_sound.wav")
printl("The duration of the sound is " + duration + " seconds.")
```

### `macros.CreateAlias(key, action)`

This function creates a simple console alias.

**Parameters:**

*   `key` (string): The alias name.
*   `action` (string): The command to be executed when the alias is called.

**Example:**

```js
macros.CreateAlias("my_alias", "echo Hello!") // Creates a console alias "my_alias" that prints "Hello!"
```

### `macros.CreateCommand(key, command)`

This function creates a console command using setinfo and an alias. This allows players to use the command by entering it into the console.

**Parameters:**

*   `key` (string): The name of the command.
*   `command` (string): The console command to be executed.

**Example:**

```js
macros.CreateCommand("my_command", "sv_cheats 1") // Creates a console command "my_command" that enables cheats
```


### `macros.format(msg, ...)`

This function formats a message string by replacing placeholders (`{}`) with values from the provided arguments. It is similar to the `string.format` function in other programming languages and is used for creating formatted output.

**Parameters:**

* `msg` (string): The message string containing placeholders (`{}`).
* `...` (any): Additional arguments to substitute into the placeholders.

**Example:**

```js
local name = "Vashik"
local age = 20
local message = macros.format("My name is {} and I am {} years old.", name, age)
printl(message) // Output: "My name is Vashik and I am 20 years old."
```

### `macros.fprint(msg, ...)`

This function combines the functionality of `macros.format` and `printl`. It formats a message string with placeholders and then prints the formatted message to the console.

**Parameters:**

* `msg` (string): The message string containing placeholders (`{}`).
* `...` (any): Additional arguments to substitute into the placeholders.

**Example:**

```js
local health = 100
macros.fprint("Player health: {}", health) // Output: "Player health: 100"
```

### `macros.CompileFromStr(funcBody, ...)`

This function compiles a function from a string representation. It's similar to `dev.format` but compiles the result as a function.

**Parameters:**

*   `funcBody` (string): The body of the function to be compiled. This string can contain placeholders `{}`.
*   `...` (any): Additional arguments to substitute into the placeholders in `funcBody`.

**Returns:**

*   (function): The compiled function.

**Example:**

```js
local a = 5
local b = 10
local result = macros.CompileFromStr("return {} + {}", a, b)() // result will be 15

hello <- macros.CompileFromStr("printl('Hello, {}!')", "World") 
hello() // Output "Hello, World!" to console
```

### `macros.GetFromTable(table, key, defaultValue)`

This macro retrieves a value from a table using the specified key. If the key is not found in the table, it returns a default value. This provides a concise way to access table values without having to check for key existence explicitly.

**Parameters:**

* `table` (table): The table to retrieve the value from.
* `key` (any): The key of the value to get.
* `defaultValue` (any, optional): The default value to return if the key is not found (defaults to `null`).

**Example:**

```js
local settings = {
    health = 100,
    speed = 500
}
local healthValue = macros.GetFromTable(settings, "health") // Get the "health" value (100)
local armorValue = macros.GetFromTable(settings, "ammo", 0) // Get the "ammo" value, defaulting to 0 if not found
```

### `macros.GetKeys(table)`

Returns a list of all keys from the provided table.

**Parameters:**

* `table` (object): The table from which to extract the keys.

**Returns:**

* `List`: A list containing all the keys from the provided table.

**Example:**

```js
local myTable = {a = 1, b = 2, c = 3}
local keys = macros.GetKeys(myTable)
printl(keys)  // Outputs: List of keys: ["a", "b", "c"]
```

### `macros.GetValues(table)`

Returns a list of all values from the provided table.

**Parameters:**

* `table` (object): The table from which to extract the values.

**Returns:**

* `List`: A list containing all the values from the provided table.

**Example:**

```js
local myTable = {a = 1, b = 2, c = 3}
local values = macros.GetValues(myTable)
printl(values)  // Outputs: List of values: [1, 2, 3]
```

### `macros.InvertTable(table)`
Inverts a table, swapping keys and values.

**Parameters:**

* `table` (table): The table to invert.

**Returns:**

* (table): A new table with keys and values swapped.

**Example:**

```js
local myTable = {"a": 1, "b": 2, "c": 3}
local invertedTable = macros.InvertTable(myTable)
printl(invertedTable) // Output: {1: "a", 2: "b", 3: "c"}
```


### `macros.PrintIter(iterable)`

This macro prints the keys and values of an iterable object to the console. It is useful for inspecting the contents of arrays, tables, and other iterable data structures.

**Parameters:**

* `iterable` (iterable): The iterable object to print.

**Example:**

```js
local myTable = {
    name = "Bob",
    age = 42
}
macros.PrintIter(myTable) // Output: "name: Bob", "age: 42"
```

### `macros.MaskSearch(iter, match)`

This macro checks if the `match` string contains any of the substrings (masks) defined in the `iter` array. It is useful for checking if a string matches any pattern in a blacklist or whitelist.

**Parameters:**

* `iter` (array or ArrayEx): The array of masks/patterns to search for.
* `match` (string): The string to check against the masks.

**Returns:**

* (int or null):
    * The index of the first element (mask) in the `iter` array that is found within the `match` string.
    * `null` if no mask from the array is found in the string.
    * `0` if the first element of `iter` is "*", indicating a wildcard match for any string.

**Example:**

```js
local bannedWords = ["admin", "root", "mod"]
local userName = "super_admin_123"
local matchIndex = macros.MaskSearch(bannedWords, userName) // matchIndex will be 0 (index of "admin") because "admin" is in "super_admin_123"

local whitelist = ["*", "safe"]
local wildcardIndex = macros.MaskSearch(whitelist, "unsafe_string") // wildcardIndex will be 0 (wildcard match)
```

### `macros.GetRectangle(v1, v2, v3, v4)`

This macro creates a rectangle object defined by four vertices.

**Parameters:**

* `v1` (Vector): The first vertex.
* `v2` (Vector): The second vertex.
* `v3` (Vector): The third vertex.
* `v4` (Vector): The fourth vertex.

**Returns:**

* (table): A table representing the rectangle, containing the following properties:
    * `origin` (Vector): The center point of the rectangle, calculated as the average of the four vertices.
    * `vertices` (array): An array containing the four vertices of the rectangle as Vector objects.

**Example:**

```js
local v1 = Vector(0, 0, 0)
local v2 = Vector(10, 0, 0)
local v3 = Vector(10, 10, 0)
local v4 = Vector(0, 10, 0)
local rectangle = macros.GetRectangle(v1, v2, v3, v4)
printl(rectangle.origin) // Output: Vector(5, 5, 0)
```

### `macros.PointInBBox(point, bMin, bMax)`

This macro checks if a point lies within a bounding box defined by its minimum and maximum corner points.

**Parameters:**

* `point` (Vector): The point to check.
* `bMin` (Vector): The minimum corner of the bounding box (smallest x, y, and z coordinates).
* `bMax` (Vector): The maximum corner of the bounding box (largest x, y, and z coordinates).

**Returns:**

* (boolean): `true` if the point is inside the bounding box, `false` otherwise.

**Example:**

```js
local point = Vector(5, 5, 5)
local bMin = Vector(0, 0, 0)
local bMax = Vector(10, 10, 10)
local isInside = macros.PointInBBox(point, bMin, bMax) // isInside will be true
```

### `macros.PointInBounds(point)`

This macro determines if a given point lies within the game world's boundaries. It achieves this by performing `TraceLine` calls in six directions (positive and negative X, Y, and Z) from the point, extending outwards by a large distance (`m = 64000`).

**Parameters:**

* `point` (Vector): The point to check.

**Returns:**

* (boolean): `true` if the point is considered to be inside the defined bounds, `false` otherwise.

**Example:**

```js
local pointInside = Vector(100, 200, 50)
local pointOutside = Vector(100000, 200, 50)
local isInside = macros.PointInBounds(pointInside) // isInside will be true
local isOutside = macros.PointInBounds(pointOutside) // isOutside will be false
```

### `macros.Range(start, end, step)`
Generates a list of numbers within a specified range.

**Parameters:**

* `start` (number): The starting value of the range.
* `end` (number): The ending value of the range.
* `step` (number, optional): The increment between each value in the range (default is 1).

**Returns:**

* (List): A list of numbers within the specified range.

**Example:**

```js
local rangeList = macros.Range(1, 5)
printl(rangeList) // Output: List[1, 2, 3, 4, 5]

local rangeListWithStep = macros.Range(1, 10, 2)
printl(rangeListWithStep) // Output: List[1, 3, 5, 7, 9]
```

### `macros.RangeIter(start, end, step)`
Generates an iterator that yields numbers within a specified range.

**Parameters:**

* `start` (number): The starting value of the range.
* `end` (number): The ending value of the range.
* `step` (number, optional): The increment between each value in the range (default is 1).

**Yields:**

* (number): The next number in the range.

**Example:**

```js
foreach(num in macros.RangeIter(1, 5)) {
    printl(num) // Output: 1 2 3 4 5
}

foreach(num in macros.RangeIter(1, 10, 2)) {
    printl(num) // Output: 1 3 5 7 9
}
```

### `macros.GetDist(vec1, vec2)`

This macro calculates the distance between two vectors.

**Parameters:**

* `vec1` (Vector): The first vector.
* `vec2` (Vector): The second vector.

**Returns:**

* (number): The distance between the two vectors.

**Example:**

```js
local startPos = Vector(0, 0, 0)
local endPos = Vector(10, 10, 0)
local distance = macros.GetDist(startPos, endPos) // Calculate the distance between the two points
```

### `macros.StrToVec(str)`

This macro converts a string representation of a vector (e.g., "x y z") to a `Vector` object.

**Parameters:**

* `str` (string): The string representation of the vector.
* `sep` (String): The separator string..

**Returns:**

* (Vector): The `Vector` object corresponding to the string representation.

**Example:**

```js
local colorString = "255 128 0"
local colorVector = macros.StrToVec(colorString) // Convert the color string to a Vector
```

### `macros.VecToStr(vec, sep)`

This macro converts a `Vector` object to a string representation (e.g., "x y z").

**Parameters:**

* `vec` (Vector): The `Vector` object to convert.
* `sep` (String): The separator string..

**Returns:**

* (string): The string representation of the vector.

**Example:**

```js
local position = Vector(10, 20, 30)
local positionString = macros.VecToStr(position, " | ") // Convert the position vector to a string
printl(positionString) // output: "10 | 20 | 30"
```

### `macros.IsEqual(val1, val2)`

This macro checks if two values are equal, handling different data types appropriately. It uses the appropriate equality comparison for each type, including using the `IsEqual` method for `Quaternion`, `Matrix`, and `pcapEntity` objects.

**Parameters:**

* `val1` (any): The first value to compare.
* `val2` (any): The second value to compare.

**Returns:**

* (boolean): True if the values are considered equal, false otherwise.

**Example:**

```js
// (TODO! more examples)
local vec1 = Vector(1, 2, 3)
local vec2 = Vector(1, 2, 3)
if (macros.IsEqual(vec1, vec2)) {
    // The vectors are equal
}
```

### `macros.DeepCopy(container)`

This function creates a deep copy of a container (table, array, `ArrayEx`, or `List`). It recursively copies nested containers, ensuring that changes to the copy do not affect the original.

**Note:** The container must not have circular references.

**Parameters:**

*   `container` (iter): The container to be copied.

**Returns:**

*   (clone of iter): A deep copy of the container.

**Example:**

```js
local originalTable = {a = 1, b = {c = 2}}
local copiedTable = macros.DeepCopy(originalTable)
copiedTable.b.c = 3 // Modifying the copied table

printl(originalTable.b.c) // Output: 2 (original table is unchanged)
printl(copiedTable.b.c) // Output: 3
```

### `macros.GetPrefix(name)`

This macro gets the prefix of an entity name, assuming the name is formatted with a "-" separator between the prefix and the rest of the name. If no "-" is found, it returns the original name.

**Parameters:**

* `name` (string): The entity name.

**Returns:**

* (string): The prefix of the entity name, or the original name if no "-" is found.

**Example:**

```js
local entityName = "my_prefix-123"
local prefix = macros.GetPrefix(entityName) // prefix will be "my_prefix-"
```

### `macros.GetPostfix(name)`

This macro gets the postfix of an entity name, assuming the name is formatted with a "-" separator between the prefix and the rest of the name. If no "-" is found, it returns the original name.

**Parameters:**

* `name` (string): The entity name.

**Returns:**

* (string): The postfix of the entity name, or the original name if no "-" is found.

**Example:**

```js
local entityName = "my_prefix-123"
local postfix = macros.GetPostfix(entityName) // postfix will be "-123"
```

### `macros.GetEyeEndpos(player, distance)`

This macro calculates the end position of a ray cast from the player's eyes based on the given distance.

**Parameters:**

* `player` (CBaseEntity or pcapEntity): The player entity.
* `distance` (number): The distance of the ray cast.

**Returns:**

* (Vector): The end position of the ray cast.

**Example:**

```js
local player = GetPlayerEx()
local endPos = macros.GetEyeEndpos(player, 100) // Calculate the end position of a ray cast 100 units in front of the player's eyes
```

### `macros.GetVertex(x, y, z, ang)`

This macro calculates the position of a vertex of a bounding box based on the provided x, y, z bounds and the rotation angles of the bounding box. It is used internally by the `pcapEntity.GetBBoxPoints()` method to retrieve the eight vertices of an entity's axis-aligned bounding box (AABB) in world coordinates.

**Parameters:**

* `x` (Vector): A Vector representing the minimum and maximum extents of the bounding box along the x-axis.
* `y` (Vector): A Vector representing the minimum and maximum extents of the bounding box along the y-axis.
* `z` (Vector): A Vector representing the minimum and maximum extents of the bounding box along the z-axis.
* `ang` (Vector): A Vector representing the Euler angles (pitch, yaw, roll) of the bounding box's rotation.

**Returns:**

* (Vector): The position of the vertex in world coordinates.

**Explanation:**

1. **Vertex Construction:** The macro first constructs a Vector using the x, y, and z components extracted from the input `x`, `y`, and `z` Vectors. This creates a Vector representing the vertex's position relative to the center of the bounding box, before any rotation is applied.
2. **Rotation:** The macro then uses the `math.vector.rotate` function to rotate the constructed vertex Vector by the specified `ang` Euler angles. This transforms the vertex's position from the bounding box's local coordinate system to world coordinates, taking into account the bounding box's rotation.
3. **Result:** The resulting Vector represents the final position of the vertex in the game world.

**Example:**

```js
// ... (assuming you have BBmin, BBmax, and angles for a bounding box)
local vertex = macros.GetVertex(BBmin, BBmin, BBmax, angles)
// This calculates the position of the vertex at the left-bottom-back corner of the bounding box in world coordinates.
```

### `macros.GetTriangle(v1, v2, v3)`

This macro function creates a representation of a triangle from three given vertices. It calculates the centroid (center of mass) of the triangle and returns a table containing the centroid and the three vertices.

**Parameters:**

* `v1` (Vector): The first vertex of the triangle.
* `v2` (Vector): The second vertex of the triangle.
* `v3` (Vector): The third vertex of the triangle.

**Returns:**

* (table): A table containing two properties:
* `origin` (Vector): The centroid (center of mass) of the triangle.
* `vertices` (array): An array containing the three vertices of the triangle as Vector objects.

**Example:**

```js
local triangle = macros.GetTriangle(v1, v2, v3)
printl("Triangle centroid:", triangle.origin)
printl("Triangle vertices:", triangle.vertices)
```


### `macros.BuildAnimateFunction(name, propertySetterFunc, valueCalculator)`

This function creates a new animation function for animating a property of one or more entities. It simplifies the creation of animations by providing a reusable and customizable animation function.

**Parameters:**

*   `name` (string): The name of the property to animate (e.g., "alpha", "color", "position").
*   `propertySetterFunc` (function): A function that sets the new value for the property on each entity. The function should take two arguments: the entity and the calculated value.
*   `valueCalculator` (function): A custom function that calculates the animated value for each step. (optional)

**Returns:**

*   (function): A new animation function that can be used to animate the specified property.

**Example:**

```js
animate["PitchTransition"] <- macros.BuildAnimateFunction("pitch", 
    function(ent, newPitch) {
        ent.SetKeyValue("pitch", newPitch)
        EntFireByHandle(ent, "pitch", newPitch.tostring())
    }
)
```

### `macros.BuildRTAnimateFunction(name, propertySetterFunc, valueCalculator)`

This function works identically to `macros.BuildAnimateFunction`, but creates a real-time animation function.  The generated function will use `applyRTAnimation` internally, allowing for interruptions and more dynamic behavior.  The parameters and return value are the same as `BuildAnimateFunction`.

## [Utils/const.nut](const.nut)

### Collision Groups

These constants define collision groups used by entities in the game. They determine what objects an entity will collide with.

* `COLLISION_GROUP_NONE` (0): Collides with nothing.
* `COLLISION_GROUP_DEBRIS` (1): Small objects, doesn't interfere with gameplay.
* `COLLISION_GROUP_DEBRIS_TRIGGER` (2): Like `DEBRIS`, but ignores `PUSHAWAY`.
* `COLLISION_GROUP_INTERACTIVE_DEBRIS` (3): Like `DEBRIS`, but doesn't collide with the same group.
* `COLLISION_GROUP_INTERACTIVE` (4): Interactive entities, ignores debris.
* `COLLISION_GROUP_PLAYER` (5): Used by players, ignores `PASSABLE_DOOR`.
* `COLLISION_GROUP_BREAKABLE_GLASS` (6): Breakable glass, ignores the same group and NPC line-of-sight.
* `COLLISION_GROUP_VEHICLE` (7): Driveable vehicles, always collides with `VEHICLE_CLIP`.
* `COLLISION_GROUP_PLAYER_MOVEMENT` (8): Player movement collision.
* `COLLISION_GROUP_NPC` (9): Used by NPCs, always collides with `DOOR_BLOCKER`.
* `COLLISION_GROUP_IN_VEHICLE` (10): Entities inside vehicles, no collisions.
* `COLLISION_GROUP_WEAPON` (11): Weapons, including dropped ones.
* `COLLISION_GROUP_VEHICLE_CLIP` (12): Only collides with `VEHICLE`.
* `COLLISION_GROUP_PROJECTILE` (13): Projectiles, ignore other projectiles.
* `COLLISION_GROUP_DOOR_BLOCKER` (14): Blocks NPCs, may collide with some projectiles.
* `COLLISION_GROUP_PASSABLE_DOOR` (15): Passable doors, allows players through.
* `COLLISION_GROUP_DISSOLVING` (16): Dissolved entities, only collide with `NONE`.
* `COLLISION_GROUP_PUSHAWAY` (17): Pushes props away from the player.
* `COLLISION_GROUP_NPC_ACTOR` (18): NPCs potentially stuck in a player.
* `COLLISION_GROUP_NPC_SCRIPTED` (19): NPCs in scripted sequences with collisions disabled.
* `COLLISION_GROUP_PZ_CLIP` (20): It doesn't seem to be used anywhere in the engine.
* `COLLISION_GROUP_CAMERA_SOLID` (21): Solid only to the camera's test trace (Outdated).
* `COLLISION_GROUP_PLACEMENT_SOLID` (22): Solid only to the placement tool's test trace (Outdated).
* `COLLISION_GROUP_PLAYER_HELD` (23): Held objects that shouldn't collide with players.
* `COLLISION_GROUP_WEIGHTED_CUBE` (24): Cubes need a collision group that acts roughly like COLLISION_GROUP_NONE but doesn't collide with debris or interactive.

### Solid Types

These constants define solid types, which determine how an entity's collision is handled.

* `SOLID_NONE` (0): No collision at all.
* `SOLID_BSP` (1): Uses the Quake physics engine.
* `SOLID_AABB` (2): Uses an axis-aligned bounding box (AABB).
* `SOLID_OBB` (3): Uses an oriented bounding box (OBB).
* `SOLID_OBB_YAW` (4): Uses an OBB constrained to yaw rotation.
* `SOLID_CUSTOM` (5): Custom/test solid type.
* `SOLID_VPHYSICS` (6): Uses the VPhysics engine for realistic physics.