# TracePlus Module

The `TracePlus` module enhances the ray tracing capabilities in VScripts by providing more precise and feature-rich tracing functions, including support for portals and custom trace settings. It aims to improve the accuracy and flexibility of ray tracing operations in VScripts development.

## Table of Contents

1. [TracePlus/settings.nut](#traceplussettingsnut)
   * [`TracePlus.Settings`](#traceplussettings)
2. [TracePlus/results.nut](#traceplusresultsnut)
   * [`CheapTraceResult`](#cheaptraceresult)
   * [`BboxTraceResult`](#bboxtraceresult)
3. [TracePlus/cheap\_trace.nut](#tracepluscheap_tracenut)
   * [`TracePlus.Cheap(startPos, endPos)`](#tracepluscheapstartpos-endpos)
   * [`TracePlus.FromEyes.Cheap(distance, player)`](#traceplusfromeyescheapdistance-player)
4. [TracePlus/bboxcast.nut](#traceplusbboxcastnut)
   * [`TracePlus.Bbox(startPos, endPos, ignoreEntities, settings, note)`](#traceplusbboxstartpos-endpos-ignoreentities-settings-note)
   * [`TracePlus.FromEyes.Bbox(distance, player, ignoreEntities, settings)`](#traceplusfromeyesbboxdistance-player-ignoreentities-settings)
5. [Portal Castings - How to Use](#portal-castings---how-to-use)
   * [`prop_portal`](#prop_portal)
   * [`linked_portal_door`](#linked_portal_door)
   * [Disabling Portals](#disabling-portals)
6. [TracePlus/portal\_casting.nut](#traceplusportal_castingnut)
   * [`TracePlus.PortalCheap(startPos, endPos)`](#traceplusportalcheapstartpos-endpos)
   * [`TracePlus.FromEyes.PortalCheap(distance, player)`](#traceplusfromeyesportalcheapdistance-player)
   * [`TracePlus.PortalBbox(startPos, endPos, ignoreEntities, settings, note)`](#traceplusportalbboxstartpos-endpos-ignoreentities-settings-note)
   * [`TracePlus.FromEyes.PortalBbox(distance, player, ignoreEntities, settings)`](#traceplusfromeyesportalbboxdistance-player-ignoreentities-settings)
7. [TracePlus/bbox\_analyzer.nut](#traceplusbbox_analyzernut)
   * [`TraceLineAnalyzer`](#tracelineanalyzer)
8. [TracePlus/calculate\_normal.nut](#tracepluscalculate_normalnut)
   * [Global Functions:](#global-functions)


## [TracePlus/settings.nut](#traceplussettingsnut)

This file defines the `TracePlus.Settings` class, which encapsulates settings for ray traces, including options for entity filtering, model filtering, custom collision and ignore filters, and parameters for precise trace line analysis in the `TraceLineAnalyzer` class. 

### [`TracePlus.Settings`](#traceplussettings)

This class stores various settings that control the behavior of traces, such as which entities and models to ignore, custom filter functions, and parameters for precise trace line analysis.

**Properties:**

*   `ignoreClasses` (ArrayEx): An array of entity classnames to ignore during traces. Supports masks, e.g., `["trigger_"]` will ignore all entities with "trigger\_" in their classnames.
*   `priorityClasses` (ArrayEx): An array of entity classnames to prioritize during traces. Supports masks.
*   `ignoredModels` (ArrayEx): An array of entity model names to ignore during traces. Supports masks.
*   `shouldRayHitEntity` (function or null): A custom function to determine if a ray should hit an entity. This function is used as a collision filter.
*   `shouldIgnoreEntity` (function or null): A custom function to determine if an entity should be ignored during a trace. This function is used as an ignore filter.
*   `depthAccuracy` (number): Controls the step size in the deep search algorithm of the `TraceLineAnalyzer` for bbox casts. Lower values increase precision but may impact performance. It's useful when the ray needs to hit very thin objects. (Default: 5, clamped between 0.3 and 15)
*   `bynaryRefinement` (boolean): Enables an additional search level in the `TraceLineAnalyzer` for bbox casts to further improve the accuracy of the hit point. It's crucial when precise hit point calculation is needed, especially for accurate surface normal calculation. (Default: false)

**Methods:**

*   `new(settingsTable)`: Creates a new `TracePlus.Settings` object with default values or initializes it from a table of settings.
*   `SetIgnoredClasses(ignoreClassesArray)`: Sets the list of entity classnames to ignore during traces. **(Builder)**
*   `SetPriorityClasses(priorityClassesArray)`: Sets the list of entity classnames to prioritize during traces. **(Builder)**
*   `SetIgnoredModels(ignoredModelsArray)`: Sets the list of entity model names to ignore during traces. **(Builder)**
*   `SetDepthAccuracy(value)`: Sets the depth accuracy value for the `TraceLineAnalyzer`. **(Builder)**
*   `SetBynaryRefinement(bool)`: Enables or disables binary refinement for the `TraceLineAnalyzer`. **(Builder)**
*   `AppendIgnoredClass(className)`: Appends an entity classname to the list of ignored classes. **(Builder)**
*   `AppendPriorityClasses(className)`: Appends an entity classname to the list of priority classes. **(Builder)**
*   `AppendIgnoredModel(modelName)`: Appends an entity model name to the list of ignored models. **(Builder)**
*   `SetCollisionFilter(filterFunction)`: Sets a custom function to determine if a ray should hit an entity (collision filter). **(Builder)**
*   `SetIgnoreFilter(filterFunction)`: Sets a custom function to determine if an entity should be ignored during a trace (ignore filter). **(Builder)**
*   `GetIgnoreClasses()`: Returns the list of entity classnames to ignore during traces.
*   `GetPriorityClasses()`: Returns the list of entity classnames to prioritize during traces.
*   `GetIgnoredModels()`: Returns the list of entity model names to ignore during traces.
*   `GetCollisionFilter()`: Returns the custom collision filter function.
*   `GetIgnoreFilter()`: Returns the custom ignore filter function.
*   `ApplyCollisionFilter(entity, note)`: Applies the custom collision filter function to an entity.
*   `ApplyIgnoreFilter(entity, note)`: Applies the custom ignore filter function to an entity.
*   `UpdateIgnoreEntities(ignoreEntities, newEnt)`: Updates the list of entities to ignore during a trace, including the player entity.

**Examples:**

**1. Creating `TracePlus.Settings` with specific settings using `new`:**

```js
local s = TracePlus.Settings.new({
    ignoreClasses = ArrayEx("trigger_multiple", "func_brush"),
}) 
```

**2. Creating `TracePlus.Settings` and setting properties with methods:**

```js
local s = TracePlus.Settings.new()
s.SetIgnoredClasses(["trigger_"])
s.AppendPriorityClasses(["player"])
s.SetDepthAccuracy(2) // Increase depth accuracy for hitting thin objects 
s.SetBynaryRefinement(true) // Enable binary refinement for precise hit point calculation
```

**3. Using builder-style chained calls:**

```js
local s = TracePlus.Settings
    .SetIgnoredClasses(ArrayEx("trigger_multiple", "func_brush"))
    .AppendPriorityClasses(List("player"))
    .SetDepthAccuracy(10) 
    .SetBynaryRefinement(false)
```

## [TracePlus/results.nut](#traceplusresultsnut)

This file defines classes representing the results of different types of traces, providing methods for accessing information about the trace and its outcome.

### [`CheapTraceResult`](#cheaptraceresult)

This class represents the result of a cheap (fast but less accurate) trace. It stores information about the trace, such as the start and end positions, hit position, hit fraction, and portal entry information.

**Properties:**

* `traceHandler` (table): The trace handler object containing trace information.
* `hitPos` (Vector): The hit position of the trace.
* `surfaceNormal` (Vector, optional): The impact normal of the surface hit by the trace (calculated on demand).
* `portalEntryInfo` (CheapTraceResult or null): Information about the portal the trace entered, if applicable.

**Methods:**

* `GetStartPos()`: Returns the start position of the trace as a Vector.
* `GetEndPos()`: Returns the end position of the trace as a Vector.
* `GetHitPos()`: Returns the hit position of the trace as a Vector.
* `GetFraction()`: Returns the fraction of the trace distance where the hit occurred (between 0 and 1).
* `DidHit()`: Returns `true` if the trace hit something, `false` otherwise.
* `GetDir()`: Returns the normalized direction vector of the trace as a Vector.
* `GetPortalEntryInfo()`: Returns the portal entry information as a `CheapTraceResult` object, or `null` if no portal was entered.
* `GetAggregatedPortalEntryInfo()`: Returns an `ArrayEx` containing all portal entry information for the trace, including nested portals, as `CheapTraceResult` objects.
* `GetImpactNormal()`: Calculates and returns the impact normal of the surface hit by the trace as a Vector.

**Example:**

```js
local startPos = Vector(0, 0, 0)
local endPos = Vector(100, 0, 0)
local traceResult = TracePlus.Cheap(startPos, endPos)

if (traceResult.DidHit()) {
    printl("Trace hit something at:" + traceResult.GetHitPos())
    local normal = traceResult.GetImpactNormal()
    // ... do something with the normal
}
```

### `BboxTraceResult`

This class represents the result of a bbox cast (trace with a bounding box). It extends the `CheapTraceResult` class and adds information about the hit entity and trace settings.

**Additional Properties:**

* `hitEnt` (CBaseEntity): The entity hit by the trace, or `null` if no entity was hit.

**Additional Methods:**

* `GetEntity()`: Returns the hit entity as a `pcapEntity` object, or `null` if no entity was hit.
* `GetEntityClassname()`: Returns the classname of the hit entity, or `null` if no entity was hit.
* `GetIngoreEntities()`: Returns the list of entities that were ignored during the trace.
* `GetTraceSettings()`: Returns the settings used for the trace as a `TraceSettings` object.
* `GetNote()`: Returns the optional note associated with the trace.
* `DidHitWorld()`: Returns `true` if the trace hit the world geometry (not an entity), `false` otherwise.

**Example:**

```js
local traceResult = TracePlus.Bbox(startPos, endPos)

if (traceResult.DidHit()) {
    local hitEntity = traceResult.GetEntity()
if (hitEntity) {
    printl("Trace hit entity:" + hitEntity.GetClassname())
} else {
    printl("Trace hit the world.")
}
}
```

## [TracePlus/cheap\_trace.nut](#tracepluscheap_tracenut)

This file provides functions for performing cheap (fast but less accurate) traces.

### [`TracePlus.Cheap(startPos, endPos)`](#tracepluscheapstartpos-endpos)

This function performs a cheap trace from the specified start and end positions. It uses the standard `TraceLine` function internally but returns a `CheapTraceResult` object with additional information.

**Parameters:**

* `startPos` (Vector): The start position of the trace.
* `endPos` (Vector): The end position of the trace.

**Returns:**

* (CheapTraceResult): The trace result object.

**Example:**

```js
local traceResult = TracePlus.Cheap(startPos, endPos)
if (traceResult.DidHit()) {
    // ...
}
```

### [`TracePlus.FromEyes.Cheap(distance, player)`](#traceplusfromeyescheapdistance-player)

This function performs a cheap trace from the player's eyes in the direction they are looking.

**Parameters:**

* `distance` (number): The distance of the trace.
* `player` (CBaseEntity or pcapEntity): The player entity.

**Returns:**

* (CheapTraceResult): The trace result object.

**Example:**

```js
local player = GetPlayerEx()
local traceResult = TracePlus.FromEyes.Cheap(100, player) // Trace 100 units in front of the player
```

## [TracePlus/bboxcast.nut](#traceplusbboxcastnut)

This file provides functions for performing bbox casts (traces with bounding boxes).

### [`TracePlus.Bbox(startPos, endPos, ignoreEntities, settings, note)`](#traceplusbboxstartpos-endpos-ignoreentities-settings-note)

This function performs a bbox cast from the specified start and end positions. It uses a more precise algorithm than `TraceLine` to check for collisions with entities' bounding boxes.

**Parameters:**

* `startPos` (Vector): The start position of the trace.
* `endPos` (Vector): The end position of the trace.
* `ignoreEntities` (array, CBaseEntity, or null, optional): A list of entities or a single entity to ignore during the trace.
* `settings` (TraceSettings, optional): The settings to use for the trace (defaults to `TracePlus.defaultSettings`).
* `note` (string, optional): An optional note associated with the trace.

**Returns:**

* (BboxTraceResult): The trace result object.

**Example:**

```js
local traceResult = TracePlus.Bbox(startPos, endPos, ignoreEntities, traceSettings)
if (traceResult.DidHit()) {
    // ...
}
```

### [`TracePlus.FromEyes.Bbox(distance, player, ignoreEntities, settings)`](#traceplusfromeyesbboxdistance-player-ignoreentities-settings)

This function performs a bbox cast from the player's eyes in the direction they are looking.

**Parameters:**

* `distance` (number): The distance of the trace.
* `player` (CBaseEntity or pcapEntity): The player entity.
* `ignoreEntities` (array, CBaseEntity, or null, optional): A list of entities or a single entity to ignore during the trace.
* `settings` (TraceSettings, optional): The settings to use for the trace (defaults to `TracePlus.defaultSettings`).

**Returns:**

* (BboxTraceResult): The trace result object.

**Example:**

```js
local traceResult = TracePlus.FromEyes.Bbox(100, player, ignoreEntities)
if (traceResult.DidHit()) {
    // ...
}
```


## [Portal Castings - How to Use](#portal-castings---how-to-use)

To ensure the correct functionality of portal casting, it's crucial to follow these guidelines:

### [`prop_portal`](#prop_portal)

If `prop_portal` is created manually and has a non-zero `paidId`, you need to add the keyvalue `health` with a value matching the `paidId`. This is necessary for more accurate partner portal detection.

todo: add photo

### [`linked_portal_door`](#linked_portal_door)

For correct operation, you need to create the keyvalue `model` with the portal's `width height` values. For example: `128 64`. The `model` keyvalue is used by the `TracePlus` module to calculate the bounding box of the portal.

todo: add photo

### [Disabling Portals](#disabling-portals)

* To correctly disable portals for a `pcapEntity` portal, you need to call the `SetTraceIgnore` method. You can achieve this by adding the `OnUser1` output to the portal entity and connecting it to a script that calls `SetTraceIgnore`.

todo: add photo

**Alternatively, you can automate this process using the `func_portal_detector` entity on your map.** This entity can detect when a portal is opened or closed and automatically trigger the appropriate script to enable or disable the portal for tracing.

**Note:**
* For advanced scenarios, you can create custom filter functions for `TracePlus.Settings` to define specific rules for ray tracing collisions and entity ignoring.


## [TracePlus/portal\_casting.nut](#traceplusportal_castingnut)

This file contains functions for handling portal interactions during traces.

### [`TracePlus.PortalCheap(startPos, endPos)`](#traceplusportalcheapstartpos-endpos)

This function performs a cheap trace with portal support. It takes into account portal entities and adjusts the trace path accordingly.

**Parameters:**

* `startPos` (Vector): The start position of the trace.
* `endPos` (Vector): The end position of the trace.

**Returns:**

* (CheapTraceResult): The trace result object, including information about portal entries.

**Example:**

```js
local traceResult = TracePlus.PortalCheap(startPos, endPos)
if (traceResult.DidHit()) {
    // ...
}
```

### [`TracePlus.FromEyes.PortalCheap(distance, player)`](#traceplusfromeyesportalcheapdistance-player)

This function performs a cheap trace with portal support from the player's eyes. It takes into account portal entities and adjusts the trace path accordingly.

**Parameters:**

* `distance` (number): The distance of the trace.
* `player` (CBaseEntity or pcapEntity): The player entity.

**Returns:**

* (CheapTraceResult): The trace result object, including information about portal entries.

**Example:**

```js
local traceResult = TracePlus.FromEyes.PortalCheap(1000, player)
if (traceResult.DidHit()) {
    local portalEntries = traceResult.GetAggregatedPortalEntryInfo()
    // ... process portal entry information
}
```


### [`TracePlus.PortalBbox(startPos, endPos, ignoreEntities, settings, note)`](#traceplusportalbboxstartpos-endpos-ignoreentities-settings-note)

This function performs a bbox cast with portal support. It takes into account portal entities and adjusts the trace path accordingly.

**Parameters:**

* `startPos` (Vector): The start position of the trace.
* `endPos` (Vector): The end position of the trace.
* `ignoreEntities` (array, CBaseEntity, or null, optional): A list of entities or a single entity to ignore during the trace.
* `settings` (TraceSettings, optional): The settings to use for the trace (defaults to `TracePlus.defaultSettings`).
* `note` (string, optional): An optional note associated with the trace.

**Returns:**

* (BboxTraceResult): The trace result object, including information about portal entries.

**Example:**

```js
local traceResult = TracePlus.PortalBbox(startPos, endPos, ignoreEntities, traceSettings)
if (traceResult.DidHit()) {
    // ...
}
```

### [`TracePlus.FromEyes.PortalBbox(distance, player, ignoreEntities, settings)`](#traceplusfromeyesportalbboxdistance-player-ignoreentities-settings)

This function performs a bbox cast with portal support from the player's eyes.

**Parameters:**

* `distance` (number): The distance of the trace.
* `player` (CBaseEntity or pcapEntity): The player entity.
* `ignoreEntities` (array, CBaseEntity, or null, optional): A list of entities or a single entity to ignore during the trace.
* `settings` (TraceSettings, optional): The settings to use for the trace (defaults to `TracePlus.defaultSettings`).

**Returns:**

* (BboxTraceResult): The trace result object, including information about portal entries.

**Example:**

```js
local traceResult = TracePlus.FromEyes.PortalBbox(1000, player, ignoreEntities)
if (traceResult.DidHit()) {
    // ...
}
```

## [TracePlus/bbox\_analyzer.nut](#traceplusbbox_analyzernut)

This file defines the `TraceLineAnalyzer` class for precise trace line analysis, which is a core component of the BBox Casting algorithm.

### [`TraceLineAnalyzer`](#tracelineanalyzer)

This class provides methods for tracing lines with more precision and considering entity priorities and ignore settings. It subdivides the trace into smaller segments and checks for entity collisions along the way, taking into account the trace settings. **It's required for the Bboxcast**

**Properties:**

* `settings` (TraceSettings): The settings to use for the trace.
* `hitPos` (Vector): The hit position of the trace.
* `hitEnt` (CBaseEntity): The entity hit by the trace, or `null` if no entity was hit.

**Methods:**

* `Trace(startPos, endPos, ignoreEntities, note)`: Performs a precise trace line analysis.
* `_isPriorityEntity(entityClass)`: Checks if an entity is a priority entity based on the trace settings.
* `_isIgnoredEntity(entityClass)`: Checks if an entity should be ignored based on the trace settings.
* `_hitEntity(ent, ignoreEntities, note)`: Checks if the trace should consider a hit with the given entity, taking into account the trace settings and ignore list.

**BBox Casting Algorithm:**

The `TraceLineAnalyzer` class implements a sophisticated BBox Casting algorithm for accurate and efficient collision detection. A detailed description of the algorithm, including its steps, optimizations, and code examples, can be found in the [bbox\_analyzer.md](bbox_analyzer.md) file.

## [TracePlus/calculate\_normal.nut](#tracepluscalculate_normalnut)

This file provides functions for calculating the impact normal of a surface hit by a trace. It offers three distinct algorithms to address different scenarios, ensuring both accuracy and efficiency in determining the surface orientation at the hit point.

### [Global Functions:](#global-functions)

*   **`CalculateImpactNormal(startPos, hitPos)`:**
    Calculates the impact normal of a surface hit by a trace, primarily for world geometry. It utilizes the "three-ray method" to determine the surface orientation. This method involves performing three cheap traces – one from the original hit position and two from slightly offset positions – to create a triangle. The normal of this triangle represents the surface normal. This approach is efficient but might not be suitable for dynamic entities.
    
*   **`CalculateImpactNormalFromBbox(startPos, hitPos, hitEntity)`:**
    Calculates the impact normal of a surface for dynamic entities, utilizing the hit entity's bounding box. It employs an optimized algorithm that assumes one of the hit point's coordinates is shared by at least four vertices of the bounding box. This assumption allows for efficient identification of the hit face and calculation of its normal. If this optimized method fails to find a suitable face, it falls back to `CalculateImpactNormalFromBbox2`.
    
*   **`CalculateImpactNormalFromBbox2(startPos, hitPos, hitEntity)`:**
    Calculates the impact normal of a surface for dynamic entities as a fallback method when `CalculateImpactNormalFromBbox` cannot determine a reliable normal. It identifies the three closest vertices of the bounding box to the hit point and uses them to form a triangle. The normal of this triangle is then used as an approximation of the surface normal. This method is less precise than `CalculateImpactNormalFromBbox` but is more robust in handling inaccurate hit points.
    
**Impact Normal Calculation Algorithms:**

A detailed description of the algorithms used in `calculate_normal.nut`, including their steps, limitations, and considerations, can be found in the [calculate\_normal.md](calculate_normal.md) file.
