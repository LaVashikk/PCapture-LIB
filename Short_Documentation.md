# PCapture-LIB v3.8 Short Documentation

This document provides a concise overview of PCapture-Lib's modules and their key functionalities. 

Each module's section below links to the corresponding `readme.md` within the module directory for detailed information and examples. You can also navigate to specific sections within each module's documentation by clicking on the header or the function/method.

**Table of Contents**

* [0. Console Commands](#0-console-commands)
* [1. TracePlus](#1-traceplus)
    * [`TracePlus/settings.nut`](#traceplussettingsnut)
    * [`TracePlus/results.nut`](#traceplusresultsnut)
    * [`TracePlus/cheap_trace.nut`](#tracepluscheap_tracenut)
    * [`TracePlus/bboxcast.nut`](#traceplusbboxcastnut)
    * [`TracePlus/portal_casting.nut`](#traceplusportal_castingnut)
    * [`TracePlus/bbox_analyzer.nut`](#traceplusbbox_analyzernut)
    * [`TracePlus/calculate_normal.nut`](#tracepluscalculate_normalnut)
* [2. IDT (Improved Data Types)](#2-idt)
    * [`IDT/array.nut`](#idtarraynut)
    * [`IDT/list.nut`](#idtlistnut)
    * [`IDT/tree_sort.nut`](#idttree_sortnut) 
    * [`IDT/entity_creator.nut`](#idtentity_creatornut)
    * [`IDT/entity.nut`](#idtentitynut)
* [3. Utils](#3-utils)
    * [`Utils/debug.nut`](#utilsdebugnut)
    * [`Utils/file.nut`](#utilsfilenut)
    * [`Utils/improvements.nut`](#utilsimprovementsnut)
    * [`ActionScheduler/player_hooks.nut`](#actionschedulerplayer_hooksnut)
    * [`Utils/portals.nut`](#utilsportalsnut)
    * [`Utils/macros.nut`](#utilsmacrosnut)
* [4. ActionScheduler](#4-actionscheduler)
    * [`ActionScheduler/action.nut`](#actionscheduleractionnut)
    * [`ActionScheduler/action_scheduler.nut`](#actionscheduleraction_schedulernut)
    * [`ActionScheduler/event_handler.nut`](#actionschedulerevent_handlernut)
* [5. Animations](#5-animations)
    * [`Animations/init.nut`](#animationsinitnut)
    * [`Animations/alpha.nut`, `color.nut`, `position.nut`, `angles.nut`](#animationsalphanut-colornut-positionnut-anglesnut)
* [6. Script Events](#6-script-events)
    * [`ScriptEvents/game_event.nut`](#scripteventsgame_eventnut)
    * [`ScriptEvents/event_listener.nut`](#scripteventsevent_listenernut)
* [7. HUD](#7-hud)
    * [`HUD/ScreenText.nut`](#hudscreentextnut)
    * [`HUD/HintInstructor.nut`](#hudhintinstructornut)
* [8. Math](#8-math)
    * [`Math/algebraic.nut`](#mathalgebraicnut)
    * [`Math/utils_vector.nut`](#mathutils_vectornut)
    * [`Math/lerp.nut`](#mathlerpnut)
    * [`Math/easing_equation.nut`](#matheasing_equationnut)
    * [`Math/quaternion.nut`](#mathquaternionnut)
    * [`Math/matrix.nut`](#mathmatrixnut)


## 0. Console Commands

The following console commands are available for debugging and managing the library during runtime:

*   `PCapLib_version`: Prints the current library version.
*   `PCapLib_level_trace`: Sets the logger level to `Trace`.
*   `PCapLib_level_debug`: Sets the logger level to `Debug`.
*   `PCapLib_level_info`: Sets the logger level to `Info`.
*   `PCapLib_level_warn`: Sets the logger level to `Warning`.
*   `PCapLib_level_error`: Sets the logger level to `Error`.
*   `PCapLib_level_off`: Sets the logger level to `Off`.
*   `PCapLib_schedule_list`: Lists all currently scheduled events.
*   `PCapLib_schedule_clear`: Cancels all currently scheduled events.
*   `PCapLib_vscript_event_list`: Lists all registered script events.
*   `PCapLib_players_list`: Lists all current players.

## 1. [TracePlus](SRC/TracePlus/readme.md#traceplus-module)

Enhances ray tracing capabilities, including portal and custom trace settings.

### [`TracePlus/settings.nut`](SRC/TracePlus/readme.md#traceplussettingsnut)

| Class/Type/Method | Description |
|---|---|
| [`TracePlus.Settings`](SRC/TracePlus/readme.md#traceplussettings) | Encapsulates trace settings. |
| `new(settingsTable: table)` | Creates a [`TracePlus.Settings`](SRC/TracePlus/readme.md#traceplussettings) object. |
| `SetIgnoredClasses(ignoreClassesArray: ArrayEx)` | Sets ignored classes.  |
| `SetPriorityClasses(priorityClassesArray: ArrayEx)` | Sets priority classes. |
| `SetIgnoredModels(ignoredModelsArray: ArrayEx)` | Sets ignored models. |
| `SetDepthAccuracy(value: number)` | Sets depth accuracy. |
| `SetBynaryRefinement(bool: bool)` | Sets binary refinement. |
| `AppendIgnoredClass(className: string)` | Appends ignored class. |
| `AppendPriorityClasses(className: string)` | Appends to priority classes. |
| `AppendIgnoredModel(modelName: string)` | Appends ignored model. |
| `SetCollisionFilter(filterFunction: function)` | Sets collision filter.  |
| `SetIgnoreFilter(filterFunction: function)` | Sets ignore filter.  |
| `GetIgnoreClasses() -> ArrayEx` | Returns ignored classes.  |
| `GetPriorityClasses() -> ArrayEx` | Returns priority classes.  |
| `GetIgnoredModels() -> ArrayEx` | Returns ignored models.  |
| `GetCollisionFilter() -> function` | Returns collision filter function. |
| `GetIgnoreFilter() -> function` | Returns ignore filter function.  |
| `ApplyCollisionFilter(entity: pcapEntity, note: string)` | Applies collision filter. |
| `ApplyIgnoreFilter(entity: pcapEntity, note: string)` | Applies ignore filter.  |
| `UpdateIgnoreEntities(ignoreEntities: table, newEnt: pcapEntity)` | Updates ignored entities. |

### [`TracePlus/results.nut`](SRC/TracePlus/readme.md#traceplusresultsnut)

| Class/Method | Description |
|---|---|
| `CheapTraceResult` | Result of a cheap trace. |
| `GetStartPos() -> Vector` | Returns start position. |
| `GetEndPos() -> Vector` | Returns end position. |
| `GetHitpos() -> Vector` | Returns hit position. |
| `GetFraction() -> number` | Returns hit fraction. |
| `DidHit() -> bool` | Returns true if hit. |
| `GetDir() -> Vector` | Returns trace direction. |
| `GetPortalEntryInfo() -> CheapTraceResult` | Returns portal entry info. |
| `GetAggregatedPortalEntryInfo() -> ArrayEx` | Returns all portal entry info.  |
| `GetImpactNormal() -> Vector` | Returns impact normal.  |
| `BboxTraceResult` | Result of a bbox cast. |
| `GetEntity() -> pcapEntity` | Returns hit entity.  |
| `GetEntityClassname() -> string` | Returns hit entity classname.  |
| `GetIngoreEntities() -> table` | Returns ignored entities. |
| `GetTraceSettings() -> TraceSettings` | Returns trace settings. |
| `GetNote() -> string` | Returns trace note.  |
| `DidHitWorld() -> bool` | Returns true if hit world geometry. |


### [`TracePlus/cheap_trace.nut`](SRC/TracePlus/readme.md#tracepluscheap_tracenut)

| Function | Description |
|---|---|
| [`TracePlus.Cheap(startPos: Vector, endPos: Vector) -> CheapTraceResult`](SRC/TracePlus/readme.md#tracepluscheapstartpos-endpos) | Performs a cheap trace. |
| [`TracePlus.FromEyes.Cheap(distance: number, player: pcapEntity) -> CheapTraceResult`](SRC/TracePlus/readme.md#traceplusfromeyescheapdistance-player) | Cheap trace from player's eyes. |

### [`TracePlus/bboxcast.nut`](SRC/TracePlus/readme.md#traceplusbboxcastnut)

| Function | Description |
|---|---|
| [`TracePlus.Bbox(startPos: Vector, endPos: Vector, ignoreEntities: table, settings: TraceSettings, note: string) -> BboxTraceResult`](SRC/TracePlus/readme.md#traceplusbboxstartpos-endpos-ignoreentities-settings-note) | Performs a bbox cast. |
| [`TracePlus.FromEyes.Bbox(distance: number, player: pcapEntity, ignoreEntities: table, settings: TraceSettings) -> BboxTraceResult`](SRC/TracePlus/readme.md#traceplusfromeyesbboxdistance-player-ignoreentities-settings) | Bbox cast from player's eyes. |

### [`TracePlus/portal_casting.nut`](SRC/TracePlus/readme.md#traceplusportal_castingnut)

| Function | Description |
|---|---|
| [`TracePlus.PortalCheap(startPos: Vector, endPos: Vector) -> CheapTraceResult`](SRC/TracePlus/readme.md#traceplusportalcheapstartpos-endpos) | Cheap trace with portals. |
| [`TracePlus.FromEyes.PortalCheap(distance: number, player: pcapEntity) -> CheapTraceResult`](SRC/TracePlus/readme.md#traceplusfromeyesportalcheapdistance-player) | Cheap trace from player's eyes with portals. |
| [`TracePlus.PortalBbox(startPos: Vector, endPos: Vector, ignoreEntities: table, settings: TraceSettings, note: string) -> BboxTraceResult`](SRC/TracePlus/readme.md#traceplusportalbboxstartpos-endpos-ignoreentities-settings-note) | Bbox cast with portals. |
| [`TracePlus.FromEyes.PortalBbox(distance: number, player: pcapEntity, ignoreEntities: table, settings: TraceSettings) -> BboxTraceResult`](SRC/TracePlus/readme.md#traceplusfromeyesportalbboxdistance-player-ignoreentities-settings) | Bbox cast from player's eyes with portals. |

### [`TracePlus/bbox_analyzer.nut`](SRC/TracePlus/readme.md#traceplusbbox_analyzernut)

| Class/Method | Description |
|---|---|
| [`TraceLineAnalyzer`](SRC/TracePlus/readme.md#tracelineanalyzer) | Precise trace line analysis. |

### [`TracePlus/calculate_normal.nut`](SRC/TracePlus/readme.md#tracepluscalculate_normalnut)

| Function | Description |
|---|---|
| `CalculateImpactNormal(startPos: Vector, hitPos: Vector) -> Vector` | Impact normal for world geometry. |
| `CalculateImpactNormalFromBbox(startPos: Vector, hitPos: Vector, hitEntity: pcapEntity) -> Vector` | Impact normal from bounding box. |
| `CalculateImpactNormalFromBbox2(startPos: Vector, hitPos: Vector, hitEntity: pcapEntity) -> Vector` | Fallback bounding box normal. |


## 2. [IDT](SRC/IDT/readme.md#idt-module-improved-data-types)

Provides enhanced data structures.

### [`IDT/array.nut`](SRC/IDT/readme.md#idtarraynut)

| Function/Method | Description |
|---|---|
| [`ArrayEx(...)`](SRC/IDT/readme.md#arrayex) | Creates an [`ArrayEx`](SRC/IDT/readme.md#arrayex). |
| [`FromArray(array: array) -> ArrayEx`](SRC/IDT/readme.md#fromarrayarray) | [`ArrayEx`](SRC/IDT/readme.md#arrayex) from array. |
| [`append(value: any) -> ArrayEx`](SRC/IDT/readme.md#appendvalue) | Appends a value. |
| [`apply(func: function) -> ArrayEx`](SRC/IDT/readme.md#applyfunc) | Applies a function to each element. |
| [`clear() -> ArrayEx`](SRC/IDT/readme.md#clear) | Clears the array. |
| [`extend(other: array\|ArrayEx) -> ArrayEx`](SRC/IDT/readme.md#extendother) | Extends the array. |
| [`filter(func: function) -> ArrayEx`](SRC/IDT/readme.md#filterfunc) | Filters the array. |
| [`contains(value: any) -> bool`](SRC/IDT/readme.md#containsvalue) | Checks for value. |
| [`search(value: any) -> number`](SRC/IDT/readme.md#searchvalue) | Search by value or predicate.  |
| [`insert(index: number, value: any)`](SRC/IDT/readme.md#insertindex-value) | Inserts a value.  |
| [`len() -> number`](SRC/IDT/readme.md#len) | Returns length.  |
| [`map(func: function) -> ArrayEx`](SRC/IDT/readme.md#mapfunc) | Maps values. |
| [`reduce(func: Function, initial: any) -> any`](SRC/IDT/readme.md#reducefunc-initial) | Reduces the array. |
| [`unique() -> ArrayEx`](SRC/IDT/readme.md#unique) | Returns unique elements. |
| [`pop() -> any`](SRC/IDT/readme.md#pop) | Removes last element. |
| [`push(value: any)`](SRC/IDT/readme.md#pushvalue) | Adds to the end. |
| [`remove(index: number) -> any`](SRC/IDT/readme.md#removeindex) | Removes at index. |
| [`resize(size: number, fill: any)`](SRC/IDT/readme.md#resizesize-fill) | Resizes the array. |
| [`reverse() -> ArrayEx`](SRC/IDT/readme.md#reverse) | Reverses the array. |
| [`slice(start: number, end: number) -> ArrayEx`](SRC/IDT/readme.md#slicestart-end) | Creates a slice. |
| [`sort(func: function) -> ArrayEx`](SRC/IDT/readme.md#sortfunc) | Sorts the array.  |
| [`top() -> any`](SRC/IDT/readme.md#top) | Returns last element.  |
| [`join(separator: string) -> string`](SRC/IDT/readme.md#joinseparator) | Joins to string.  |
| [`get(index: number, default: any) -> any`](SRC/IDT/readme.md#getindex-default) | Gets element at index. |
| [`totable(recreate: bool) -> table`](SRC/IDT/readme.md#totablerecreate) | Converts to table. |
| [`tolist() -> List`](SRC/IDT/readme.md#tolist) | Converts to List.  |


### [`IDT/list.nut`](SRC/IDT/readme.md#idtlistnut)

| Function/Method | Description |
|---|---|
| [`List(...)`](SRC/IDT/readme.md#list) | Creates a [`List`](SRC/IDT/readme.md#list).  |
| [`FromArray(array: array) -> List`](SRC/IDT/readme.md#fromarrayarray) | Creates [`List`](SRC/IDT/readme.md#list) from array.  |
| [`len() -> number`](SRC/IDT/readme.md#len) | Returns length. |
| [`iter() -> iterator`](SRC/IDT/readme.md#iter) | Returns efficient iterator.  |
| [`rawIter() -> iterator`](SRC/IDT/readme.md#rawiter) | Returns raw node iterator.  |
| [`append(value: any)`](SRC/IDT/readme.md#appendvalue) | Appends a value. |
| [`insert(index: number, value: any)`](SRC/IDT/readme.md#insertindex-value) | Inserts a value. |
| [`getNode(index: number) -> ListNode`](SRC/IDT/readme.md#getnodeindex) | Gets node at index. |
| [`get(index: number, defaultValue: any) -> any`](SRC/IDT/readme.md#getindex-defaultvalue) | Gets value at index. |
| [`remove(index: number) -> any`](SRC/IDT/readme.md#removeindex) | Removes at index. |
| [`pop() -> any`](SRC/IDT/readme.md#pop) | Removes last element. |
| [`top() -> any`](SRC/IDT/readme.md#top) | Gets last element. |
| [`reverse()`](SRC/IDT/readme.md#reverse) | Reverses the list.  |
| [`unique() -> List`](SRC/IDT/readme.md#unique) | Returns unique elements list. |
| [`clear()`](SRC/IDT/readme.md#clear) | Clears the list. |
| [`join(separator: string) -> string`](SRC/IDT/readme.md#joinseparator) | Joins to string. |
| [`apply(func: function) -> List`](SRC/IDT/readme.md#applyfunc) | Applies a function. |
| [`extend(other: iterable) -> List`](SRC/IDT/readme.md#extendother) | Extends the list.  |
| [`search(value: any\|function) -> number`](SRC/IDT/readme.md#searchvalue) | Search by value or predicate. |
| [`map(func: function) -> List`](SRC/IDT/readme.md#mapfunc) | Maps values.  |
| [`filter(condition: function) -> List`](SRC/IDT/readme.md#filtercondition) | Filters the list. |
| [`reduce(func: function, initial: any) -> any`](SRC/IDT/readme.md#reducefunc-initial) | Reduces the list. |
| [`totable() -> table`](SRC/IDT/readme.md#totable) | Converts to table. |
| [`toarray() -> array`](SRC/IDT/readme.md#toarray) | Converts to array. |
| [`SwapNode(node1: ListNode, node2: ListNode)`](SRC/IDT/readme.md#swapnodenode1-node2) | Swaps nodes. |


### [`IDT/tree_sort.nut`](SRC/IDT/readme.md#idttree_sortnut)

| Function/Method | Description |
|---|---|
| [`AVLTree(...)`](SRC/IDT/readme.md#avltree) | Creates an AVL tree. |
| [`FromArray(array: array) -> AVLTree`](SRC/IDT/readme.md#fromarrayarray) | AVL tree from array. |
| [`len() -> number`](SRC/IDT/readme.md#len) | Number of nodes. |
| [`toarray() -> ArrayEx`](SRC/IDT/readme.md#toarray) | Converts to array (inorder). |
| [`tolist() -> List`](SRC/IDT/readme.md#tolist) | Converts to list (inorder). |
| [`insert(key: any)`](SRC/IDT/readme.md#insertkey) | Inserts a node. |
| [`search(value: any) -> treeNode`](SRC/IDT/readme.md#searchvalue) | Searches for a node. |
| [`remove(value: any)`](SRC/IDT/readme.md#removevalue) | Removes a node. |
| [`GetMin() -> any`](SRC/IDT/readme.md#getmin) | Gets minimum value. |
| [`GetMax() -> any`](SRC/IDT/readme.md#getmax) | Gets maximum value. |
| [`inorderTraversal() -> ArrayEx`](SRC/IDT/readme.md#inordertraversal) | Inorder traversal. |
| [`printTree()`](SRC/IDT/readme.md#printtree) | Prints tree structure. |



### [`IDT/entity_creator.nut`](SRC/IDT/readme.md#idtentity_creatornut)

| Function | Description |
|---|---|
| [`CreateByClassname(classname: string, keyvalues: table) -> pcapEntity`](SRC/IDT/readme.md#createbyclassnameclassname-keyvalues) | Creates entity. |
| [`CreateProp(classname: string, origin: Vector, modelname: string, activity: number, keyvalues: table) -> pcapEntity`](SRC/IDT/readme.md#createpropclassname-origin-modelname-activity-keyvalues) | Creates prop. |
| [`FromEntity(CBaseEntity: CBaseEntity) -> pcapEntity`](SRC/IDT/readme.md#fromentitycbaseentity) | [`pcapEntity`](SRC/IDT/readme.md#idtentitynut) from `CBaseEntity`. |
| [`FindByClassname(classname: string, start_ent: CBaseEntity\|pcapEntity) -> pcapEntity`](SRC/IDT/readme.md#findbyclassnameclassname-start_ent) | Finds entity by classname. |
| [`FindByClassnameWithin(classname: string, origin: Vector, radius: number, start_ent: CBaseEntity\|pcapEntity) -> pcapEntity`](SRC/IDT/readme.md#findbyclassnamewithinclassname-origin-radius-start_ent) | Finds entity within radius. |
| [`FindByName(targetname: string, start_ent: CBaseEntity\|pcapEntity) -> pcapEntity`](SRC/IDT/readme.md#findbynametargetname-start_ent) | Finds entity by name.  |
| [`FindByNameWithin(targetname: string, origin: Vector, radius: number, start_ent: CBaseEntity\|pcapEntity) -> pcapEntity`](SRC/IDT/readme.md#findbynamewithintargetname-origin-radius-start_ent) | Finds entity by name within radius.  |
| [`FindByModel(model: string, start_ent: CBaseEntity\|pcapEntity) -> pcapEntity`](SRC/IDT/readme.md#findbymodelmodel-start_ent) | Finds entity by model. |
| [`FindByModelWithin(model: string, origin: Vector, radius: number, start_ent: CBaseEntity\|pcapEntity) -> pcapEntity`](SRC/IDT/readme.md#findbymodelwithinmodel-origin-radius-start_ent) | Finds entity by model within radius.  |
| [`FindInSphere(origin: Vector, radius: number, start_ent: CBaseEntity\|pcapEntity) -> pcapEntity`](SRC/IDT/readme.md#findinsphereorigin-radius-start_ent) | Finds entities in sphere. |


### [`IDT/entity.nut`](SRC/IDT/readme.md#idtentitynut)

Provides the [`pcapEntity`](SRC/IDT/readme.md#idtentitynut) class, extending `CBaseEntity` functionality.

| Category | Methods |
|---|---|
| **State/Lifecycle** | [`GetIndex() -> number`](SRC/IDT/readme.md#getindex), [`IsValid() -> bool`](SRC/IDT/readme.md#isvalid), [`IsPlayer() -> bool`](SRC/IDT/readme.md#isplayer), [`isEqually(other: pcapEntity\|CBaseEntity) -> bool`](SRC/IDT/readme.md#isequallyother), [`Destroy(fireDelay: number, eventName: string)`](SRC/IDT/readme.md#destroyfiredelay-eventname), [`Kill(fireDelay: number, eventName: string)`](SRC/IDT/readme.md#killfiredelay-eventname), [`Dissolve(fireDelay: number, eventName: string)`](SRC/IDT/readme.md#dissolvefiredelay-eventname), [`Disable(fireDelay: number, eventName: string)`](SRC/IDT/readme.md#disablefiredelay-eventname), [`Enable(fireDelay: number, eventName: string)`](SRC/IDT/readme.md#enablefiredelay-eventname), [`IsDrawEnabled() -> bool`](SRC/IDT/readme.md#isdrawenabled) |
| **Naming** | [`SetName(name: string, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#setnamename-firedelay-eventname), [`SetUniqueName(prefix: string, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#setuniquenameprefix-firedelay-eventname), [`GetNamePrefix() -> string`](SRC/IDT/readme.md#getnameprefix), [`GetNamePostfix() -> string`](SRC/IDT/readme.md#getnamepostfix) |
| **Player** | [`EyePosition() -> Vector`](SRC/IDT/readme.md#eyeposition), [`EyeAngles() -> Vector`](SRC/IDT/readme.md#eyeangles), [`EyeForwardVector() -> Vector`](SRC/IDT/readme.md#eyeforwardvector) |
| **Transform** | [`SetAngles(x: number, y: number, z: number)`](SRC/IDT/readme.md#setanglesx-y-z), [`SetAbsAngles(angles: Vector)`](SRC/IDT/readme.md#setabsanglesangles), [`SetCenter(vector: Vector)`](SRC/IDT/readme.md#setcentervector), [`SetAbsCenter(vector: Vector)`](SRC/IDT/readme.md#setabscentervector), [`SetParent(parentEnt: string\|CBaseEntity\|pcapEntity, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#setparentparentent-firedelay-eventname), [`GetParent() -> pcapEntity`](SRC/IDT/readme.md#getparent), [`SetModelScale(scaleValue: number, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#setmodelscalescalevalue-firedelay-eventname), [`GetModelScale() -> number`](SRC/IDT/readme.md#getmodelscale) |
| **Appearance** | [`SetAlpha(opacity: number, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#setalphaopacity-firedelay-eventname), [`SetColor(colorValue: string\|Vector, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#setcolorcolorvalue-firedelay-eventname), [`SetSkin(skin: number, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#setskinskin-firedelay-eventname), [`SetDrawEnabled(isEnabled: bool, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#setdrawenabledisenabled-firedelay-eventname), [`SetAnimation(animationName: string, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#setanimationanimationname-firedelay-eventname), [`GetAlpha() -> number`](SRC/IDT/readme.md#getalpha), [`GetColor() -> string`](SRC/IDT/readme.md#getcolor), [`GetSkin() -> number`](SRC/IDT/readme.md#getskin), [`GetPartnerInstance() -> pcapEntity`](SRC/IDT/readme.md#getpartnerinstance) |
| **KeyValues/Data** | [`SetKeyValue(key: string, value: any, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#setkeyvaluekey-value-firedelay-eventname), [`SetUserData(name: string, value: any)`](SRC/IDT/readme.md#setuserdataname-value), [`GetUserData(name: string) -> any`](SRC/IDT/readme.md#getuserdataname), [`GetKeyValue(key: string) -> any`](SRC/IDT/readme.md#getkeyvaluekey), [`SetContext(name: string, value: any, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#setcontextname-value-firedelay-eventname) |
| **Collision** | [`SetCollision(solidType: number, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#setcollisionsolidtype-firedelay-eventname), [`SetCollisionGroup(collisionGroup: number, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#setcollisiongroupcollisiongroup-firedelay-eventname), [`SetTraceIgnore(isEnabled: bool, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#settraceignoreisenabled-firedelay-eventname), [`SetSpawnflags(flag: number, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#setspawnflagsflag-firedelay-eventname), [`GetSpawnflags() -> number`](SRC/IDT/readme.md#getspawnflags) |
| **Sound** | [`EmitSound(soundName: string, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#emitsoundsoundname-firedelay-eventname), [`EmitSoundEx(soundName: string, volume: number, looped: bool, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#emitsoundexsoundname-volume-looped-firedelay-eventname), [`StopSoundEx(soundName: string, fireDelay: number, eventName: string)`](SRC/IDT/readme.md#stopsoundexsoundname-firedelay-eventname) |
| **Outputs/Inputs** | [`AddOutput(outputName: string, target: string\|CBaseEntity\|pcapEntity, input: string, param: string, delay: number, fires: number)`](SRC/IDT/readme.md#addoutputoutputname-target-input-param-delay-fires), [`ConnectOutputEx(outputName: string\|function, script: string, delay: number, fires: number)`](SRC/IDT/readme.md#connectoutputexoutputname-script-delay-fires), [`SetInputHook(inputName: string, closure: function)`](SRC/IDT/readme.md#setinputhookinputname-closure) |
| **BBox/Position** | [`SetBBox(minBounds: Vector\|string, maxBounds: Vector\|string)`](SRC/IDT/readme.md#setbboxminbounds-maxbounds), [`GetBBox() -> table`](SRC/IDT/readme.md#getbbox), [`IsSquareBbox() -> bool`](SRC/IDT/readme.md#issquarebbox), [`GetAABB() -> table`](SRC/IDT/readme.md#getaabb), [`CreateAABB(stat: number) -> Vector`](SRC/IDT/readme.md#createaabbstat), [`getBBoxPoints() -> array`](SRC/IDT/readme.md#getbboxpoints), [`getBBoxFaces() -> array`](SRC/IDT/readme.md#getbboxfaces) |


## 3. [Utils](SRC/Utils/readme.md#utils-module)

Provides utility functions.

### [`Utils/debug.nut`](SRC/Utils/readme.md#utilsdebugnut)

| Function | Description |
|---|---|
| [`DrawEntityBBox(ent: pcapEntity\|CBaseEntity, color: Vector, time: number)`](SRC/Utils/readme.md#drawentitybboxent-color-time) | Draws bounding box. |
| [`DrawEntityAABB(ent: pcapEntity\|CBaseEntity, color: Vector, time: number)`](SRC/Utils/readme.md#drawentityaabbent-color-time) | Draws AABB. |
| [`drawbox(vector: Vector, color: Vector, time: number)`](SRC/Utils/readme.md#drawboxvector-color-time) | Draws a box.  |
| [`trace(msg: string, ...)`](SRC/Utils/readme.md#tracemsg-) | Trace log. |
| [`debug(msg: string, ...)`](SRC/Utils/readme.md#debugmsg-) | Debug log.  |
| [`info(msg: string, ...)`](SRC/Utils/readme.md#infomsg-) | Info log. |
| [`warning(msg: string, ...)`](SRC/Utils/readme.md#warningmsg-) | Warning log. |
| [`error(msg: string, ...)`](SRC/Utils/readme.md#errormsg-) | Error log.  |


### [`Utils/file.nut`](SRC/Utils/readme.md#utilsfilenut)

| Class/Method | Description |
|---|---|
| [`File(path: string)`](SRC/Utils/readme.md#filepath) | Creates a [`File`](SRC/Utils/readme.md#filepath) object. |
| [`write(text: string)`](SRC/Utils/readme.md#writetext) | Writes text. |
| [`writeRawData(text: string)`](SRC/Utils/readme.md#writerawdatatext) | Writes raw data.  |
| [`readlines() -> array`](SRC/Utils/readme.md#readlines) | Reads all lines. |
| [`read() -> string`](SRC/Utils/readme.md#read) | Reads entire content. |
| [`clear()`](SRC/Utils/readme.md#clear) | Clears file content. |
| [`updateInfo()`](SRC/Utils/readme.md#updateinfo) | Updates file info. |

### [`Utils/improvements.nut`](SRC/Utils/readme.md#utilsimprovementsnut)

| Function | Description |
|---|---|
| [`FrameTime() -> number`](SRC/Utils/readme.md#frametime) | Improved [`FrameTime`](SRC/Utils/readme.md#frametime). |
| [`UniqueString(prefix: string) -> string`](SRC/Utils/readme.md#uniquestringprefix) | Unique string with prefix.  |
| [`EntFireByHandle(target: CBaseEntity\|pcapEntity, action: string, value: string, delay: number, activator: CBaseEntity\|pcapEntity, caller: CBaseEntity\|pcapEntity)`](SRC/Utils/readme.md#entfirebyhandletarget-action-value-delay-activator-caller) | Improved [`EntFireByHandle`](SRC/Utils/readme.md#entfirebyhandle). |
| [`GetPlayerEx(index: number) -> pcapEntity`](SRC/Utils/readme.md#getplayerexindex) | Returns [`pcapEntity`](SRC/IDT/readme.md#idtentitynut) for player. |


### [`Utils/player_hooks.nut`](SRC/Utils/readme.md#utilsplayer_hooksnut)

| Function | Description |
|---|---|
| [`GetPlayers() -> array`](SRC/Utils/readme.md#getplayers) | Array of players. |
| [`TrackPlayerJoins()`](SRC/Utils/readme.md#trackplayerjoins) | Tracks player joins. |
| [`HandlePlayerEventsMP()`](SRC/Utils/readme.md#handleplayereventsmp) | Handles MP events. |
| [`HandlePlayerEventsSP()`](SRC/Utils/readme.md#handleplayereventssp) | Handles SP events. |
| [`_monitorRespawn(player: pcapEntity)`](SRC/Utils/readme.md#_monitorrespawnplayer) | Monitors respawns. |
| [`AttachEyeControl(player: pcapEntity)`](SRC/Utils/readme.md#attacheyecontrolplayer) | Attaches eye control. |
| [`OnPlayerJoined(player: pcapEntity)`](SRC/Utils/readme.md#onplayerjoinedplayer) | Player joined hook. |
| [`OnPlayerLeft(player: pcapEntity)`](SRC/Utils/readme.md#onplayerleftplayer) | Player left hook. |
| [`OnPlayerDeath(player: pcapEntity)`](SRC/Utils/readme.md#onplayerdeathplayer) | Player death hook. |
| [`OnPlayerRespawn(player: pcapEntity)`](SRC/Utils/readme.md#onplayerrespawnplayer) | Player respawn hook. |


### [`Utils/portals.nut`](SRC/Utils/readme.md#utilsportalsnut)

| Function | Description |
|---|---|
| [`InitPortalPair(id: number)`](SRC/Utils/readme.md#initportalpairid) | Initialize portal pair. |
| [`IsBluePortal(ent: pcapEntity) -> bool`](SRC/Utils/readme.md#isblueportalent) | Checks for blue portal.  |
| [`FindPartnerForPropPortal(portal: pcapEntity) -> pcapEntity`](SRC/Utils/readme.md#findpartnerforpropportalportal) | Finds portal partner. |
| [`_CreatePortalDetector(extraKey: string, extraValue: any) -> entity`](SRC/Utils/readme.md#_createportaldetectorextrakey-extravalue) | Internal function |
| [`SetupLinkedPortals()`](SRC/Utils/readme.md#setuplinkedportals) | Setups up linked portals. |


### [`Utils/macros.nut`](SRC/Utils/readme.md#utilsmacrosnut)

| Macro | Description |
|---|---|
| [`Precache(soundPath: string\|array\|ArrayEx)`](SRC/Utils/readme.md#macrosprecachesoundpath) | Precaches sound(s). |
| [`GetSoundDuration(soundName: string) -> number`](SRC/Utils/readme.md#macrosgetsounddurationsoundname) | Gets sound duration. |
| [`CreateAlias(key: string, action: string)`](SRC/Utils/readme.md#macroscreatealiaskey-action) | Creates a simple console alias. |
| [`CreateCommand(key: string, command: string)`](SRC/Utils/readme.md#macroscreatecommandkey-command) | Creates a console command. |
| [`format(msg: string, ...) -> string`](SRC/Utils/readme.md#macrosformatmsg-) | Formats message string. |
| [`fprint(msg: string, ...)`](SRC/Utils/readme.md#macrosfprintmsg-) | Formats and prints. |
| [`CompileFromStr(funcBody: string, ...)`](SRC/Utils/readme.md#macroscompilefromstrfuncbody-) | Compiles a function from a string representation. |
| [`GetFromTable(table: table, key: any, defaultValue: any) -> any`](SRC/Utils/readme.md#macrosgetfromtabletable-key-defaultvalue) | Gets from table with default. |
| [`GetKeys(table: object) -> List`](SRC/Utils/readme.md#macrosgetkeystable) | Returns keys from table as List. |
| [`GetValues(table: object) -> List`](SRC/Utils/readme.md#macrosgetvaluestable) | Returns values from table as List. |
| [`InvertTable(table: table) -> table`](SRC/Utils/readme.md#macrosinverttabletable) | Inverts table. |
| [`PrintIter(iterable: iterable)`](SRC/Utils/readme.md#macrosprintiteriterable) | Prints iterable. |
| [`MaskSearch(iter: array\|ArrayEx, match: string) -> number`](SRC/Utils/readme.md#macrosmasksearchiter-match) | Mask search in array. |
| [`GetRectangle(v1: Vector, v2: Vector, v3: Vector, v4: Vector) -> table`](SRC/Utils/readme.md#macrosgetrectanglev1-v2-v3-v4) | Creates rectangle object.  |
| [`PointInBBox(point: Vector, bMin: Vector, bMax: Vector) -> bool`](SRC/Utils/readme.md#macrospointinbboxpoint-bmin-bmax) | Point in bbox check. |
| [`PointInBounds(point: Vector) -> bool`](SRC/Utils/readme.md#macrospointinboundspoint) | Point in world's bounds check. |
| [`Range(start: number, end: number, step: number) -> List`](SRC/Utils/readme.md#macrosrangestart-end-step) | Creates number range as List.  |
| [`RangeIter(start: number, end: number, step: number) -> iterator`](SRC/Utils/readme.md#macrosrangeiterstart-end-step) | Creates number range iterator. |
| [`GetDist(vec1: Vector, vec2: Vector) -> number`](SRC/Utils/readme.md#macrosgetdistvec1-vec2) | Distance between vectors.  |
| [`StrToVec(str: string) -> Vector`](SRC/Utils/readme.md#macrosstrtovecstr) | String to vector. |
| [`VecToStr(vec: Vector, sep: String) -> string`](SRC/Utils/readme.md#macrosvectostrvec-sep) | Vector to string.  |
| [`isEqually(val1: any, val2: any) -> bool`](SRC/Utils/readme.md#macrosisequallyval1-val2) | Equality check. |
| [`DeepCopy(container: iter) -> iter`](SRC/Utils/readme.md#macrosdeepcopycontainer) | Deep copy of a container. |
| [`GetPrefix(name: string) -> string`](SRC/Utils/readme.md#macrosgetprefixname) | Name prefix. |
| [`GetPostfix(name: string) -> string`](SRC/Utils/readme.md#macrosgetpostfixname) | Name postfix. |
| [`GetEyeEndpos(player: CBaseEntity\|pcapEntity, distance: number) -> Vector`](SRC/Utils/readme.md#macrosgeteyeendposplayer-distance) | Eye raycast endpoint. |
| [`GetVertex(x: Vector, y: Vector, z: Vector, ang: Vector) -> Vector`](SRC/Utils/readme.md#macrosgetvertexx-y-z-ang) | BBox vertex position. |
| [`GetTriangle(v1: Vector, v2: Vector, v3: Vector) -> table`](SRC/Utils/readme.md#macrosgettrianglev1-v2-v3) | Creates triangle representation. |
| [`BuildAnimateFunction(name: string, propertySetterFunc: function, valueCalculator: function) -> function`](SRC/Utils/readme.md#macrosbuildanimatefunctionname-propertysetterfunc-valuecalculator) | Creates a new animation function. |
| [`BuildRTAnimateFunction(name: string, propertySetterFunc: function, valueCalculator: function) -> function`](SRC/Utils/readme.md#macrosbuildrtanimatefunctionname-propertysetterfunc-valuecalculator) | Creates a new real-time animation function. |


## 4. [ActionScheduler](SRC/ActionScheduler/readme.md#actionscheduler-module)

Provides enhanced event scheduling.


### [`ActionScheduler/action.nut`](SRC/ActionScheduler/readme.md#actionnut)

| Class/Method | Description |
|---|---|
| [`ScheduleAction(scope: any, action: string\|function, timeDelay: number, args: array)`](SRC/ActionScheduler/readme.md#scheduleactionscope-action-timedelay-args) | Creates scheduled action. |
| [`run()`](SRC/ActionScheduler/readme.md#run) | Executes the action.  |

### [`ActionScheduler/action_scheduler.nut`](SRC/ActionScheduler/readme.md#action_schedulernut)

| Function | Description |
|---|---|
| [`Add(eventName: string, action: string\|function, timeDelay: number, args: array, scope: object)`](SRC/ActionScheduler/readme.md#scheduleeventaddeventname-action-timedelay-args-scope) | Adds scheduled event.  |
| [`AddInterval(eventName: string, action: string\|function, interval: number, initialDelay: number, args: array, scope: any)`](SRC/ActionScheduler/readme.md#scheduleeventaddintervaleventname-action-interval-initialdelay-args-scope) | Adds interval event. |
| [`AddActions(eventName: string, actions: array\|List, noSort: bool)`](SRC/ActionScheduler/readme.md#scheduleeventaddactionseventname-actions-nosort) | Adds multiple actions. |
| [`Cancel(eventName: string, delay: number)`](SRC/ActionScheduler/readme.md#scheduleeventcanceleventname-delay) | Cancels event.  |
| [`TryCancel(eventName: string, delay: number) -> bool`](SRC/ActionScheduler/readme.md#scheduleeventtrycanceleventname-delay) | Tries to cancel event. |
| [`CancelByAction(action: string\|function, delay: number)`](SRC/ActionScheduler/readme.md#scheduleeventcancelbyactionaction-delay) | Cancels by action. |
| [`CancelAll()`](SRC/ActionScheduler/readme.md#scheduleeventcancelall) | Cancels all events. |
| [`GetEvent(eventName: string) -> List`](SRC/ActionScheduler/readme.md#scheduleeventgeteventeventname) | Gets event actions. |
| [`IsValid(eventName: string) -> bool`](SRC/ActionScheduler/readme.md#scheduleeventisvalideventname) | Checks event validity. |


## 5. [Animations](SRC/Animations/readme.md#animations-module)

Provides animation functions.

### [`Animations/init.nut`](SRC/Animations/readme.md#initnut)

| Class/Function | Description |
|---|---|
| [`AnimEvent(name: string, settings: table, entities: array\|CBaseEntity\|pcapEntity, time: number)`](SRC/Animations/readme.md#animeventname-settings-entities-time0) | Animation event data.  |
| [`applyAnimation(animInfo: AnimEvent, valueCalculator: function, propertySetter: function, vars: any, transitionFrames: number)`](SRC/Animations/readme.md#animateapplyanimationaniminfo-valuecalculator-propertysetter-vars-transitionframes) | Applies animation.  |
| [`applyRTAnimation(animInfo: AnimEvent, valueCalculator: function, propertySetter: function, vars: any, transitionFrames: number)`](SRC/Animations/readme.md#animateapplyrtanimationaniminfo-valuecalculator-propertysetter-vars-transitionframes) | Applies real-time animation. |
| [`_applyRTAnimation(animInfo: AnimEvent, valueCalculator: function, propertySetter: function, vars: any, transitionFrames: number)`](SRC/Animations/readme.md#animate_applyrtanimationaniminfo-valuecalculator-propertysetter-vars-transitionframes) | Internal function for real-time animation. |


### [`Animations/alpha.nut`, `color.nut`, `position.nut`, `angles.nut`](SRC/Animations/readme.md#animationsalphanut)

| Function | Description |
|---|---|
| [`AlphaTransition(entities: array\|CBaseEntity\|pcapEntity, startOpacity: number, endOpacity: number, time: number, animSetting: table) -> number`](SRC/Animations/readme.md#animatealphatransitionentities-startopacity-endopacity-time-animsetting) | Animates alpha. |
| [`ColorTransition(entities: array\|CBaseEntity\|pcapEntity, startColor: string\|Vector, endColor: string\|Vector, time: number, animSetting: table) -> number`](SRC/Animations/readme.md#animatecolortransitionentities-startcolor-endcolor-time-animsetting) | Animates color.  |
| [`PositionTransitionByTime(entities: array\|CBaseEntity\|pcapEntity, startPos: Vector, endPos: Vector, time: number, animSetting: table) -> number`](SRC/Animations/readme.md#animatepositiontransitionbytimeentities-startpos-endpos-time-animsetting) | Animates position by time. |
| [`PositionTransitionBySpeed(entities: array\|CBaseEntity\|pcapEntity, startPos: Vector, endPos: Vector, speed: number, animSetting: table) -> number`](SRC/Animations/readme.md#animatepositiontransitionbyspeedentities-startpos-endpos-speed-animsetting) | Animates position by speed. |
| [`AnglesTransitionByTime(entities: array\|CBaseEntity\|pcapEntity, startAngles: Vector, endAngles: Vector, time: number, animSetting: table) -> number`](SRC/Animations/readme.md#animateanglestransitionbytimeentities-startangles-endangles-time-animsetting) | Animates angles. |


## 6. [Script Events](SRC/ScriptEvents/readme.md#script-events-module)


### [`ScriptEvents/game_event.nut`](SRC/ScriptEvents/readme.md#scripteventsgame_eventnut)

| Class/Method | Description |
|---|---|
| [`VGameEvent(eventName: string, triggerCount: number, actionsList: function)`](SRC/ScriptEvents/readme.md#vgameeventeventname-triggercount---1-actionslist--null) | Creates a VGameEvent. |
| [`AddAction(actionFunction: function)`](SRC/ScriptEvents/readme.md#addactionactionfunction) | Adds action to event. |
| [`ClearActions()`](SRC/ScriptEvents/readme.md#clearactions) | Clears actions. |
| [`SetFilter(filterFunc: function)`](SRC/ScriptEvents/readme.md#setfilterfilterfunc) | Sets filter function. |
| [`Trigger(args: any)`](SRC/ScriptEvents/readme.md#triggerargs--null) | Triggers event. |
| [`ForceTrigger(args: any)`](SRC/ScriptEvents/readme.md#forcetriggerargs--null) | Forces trigger.  |

### [`ScriptEvents/event_listener.nut`](SRC/ScriptEvents/readme.md#scripteventsevent_listenernut)

| Function | Description |
|---|---|
| [`Notify(eventName: string, ...)`](SRC/ScriptEvents/readme.md#notifyeventname-) | Triggers event by name. |
| [`GetEvent(EventName: string) -> VGameEvent`](SRC/ScriptEvents/readme.md#geteventeventname) | Gets VGameEvent object. |


## 7. [HUD](SRC/HUD/readme.md#hud-module)

### [`HUD/ScreenText.nut`](SRC/HUD/readme.md#hudscreentextnut)

| Class/Method | Description |
|---|---|
| [`ScreenText(position: Vector, message: string, holdtime: number, targetname: string)`](SRC/HUD/readme.md#hudscreentextposition-message-holdtime-targetname) | Creates screen text. |
| [`Enable(holdTime: number)`](SRC/HUD/readme.md#hudscreentextenableholdtime) | Shows the text.  |
| [`Disable()`](SRC/HUD/readme.md#hudscreentextdisable) | Hides the text. |
| [`Update()`](SRC/HUD/readme.md#hudscreentextupdate) | Updates the text. |
| [`SetText(message: string) -> ScreenText`](SRC/HUD/readme.md#hudscreentextsettextmessage) | Sets text message. |
| [`SetChannel(value: number) -> ScreenText`](SRC/HUD/readme.md#hudscreentextsetchannelvalue) | Sets channel. |
| [`SetColor(string_color: string) -> ScreenText`](SRC/HUD/readme.md#hudscreentextsetcolorstring_color) | Sets color. |
| [`SetColor2(string_color: string) -> ScreenText`](SRC/HUD/readme.md#hudscreentextsetcolor2string_color) | Sets secondary color. |
| [`SetEffect(value: number) -> ScreenText`](SRC/HUD/readme.md#hudscreentextseteffectvalue) | Sets effect. |
| [`SetFadeIn(value: number) -> ScreenText`](SRC/HUD/readme.md#hudscreentextsetfadeinvalue) | Sets fade-in.  |
| [`SetFadeOut(value: number) -> ScreenText`](SRC/HUD/readme.md#hudscreentextsetfadeoutvalue) | Sets fade-out.  |
| [`SetHoldTime(time: number) -> ScreenText`](SRC/HUD/readme.md#hudscreentextsetholdtimetime) | Sets hold time. |
| [`SetPos(Vector: Vector) -> ScreenText`](SRC/HUD/readme.md#hudscreentextsetposvector) | Sets position. |


### [`HUD/HintInstructor.nut`](SRC/HUD/readme.md#hudhintinstructornut)

| Class/Method | Description |
|---|---|
| [`HintInstructor(message: string, holdtime: number, icon: string, showOnHud: number, targetname: string)`](SRC/HUD/readme.md#hudhintinstructormessage-holdtime-icon-showonhud-targetname) | Creates hint. |
| [`Enable()`](SRC/HUD/readme.md#hudhintinstructorenable) | Shows the hint.  |
| [`Disable()`](SRC/HUD/readme.md#hudhintinstructordisable) | Hides the hint.  |
| [`Update()`](SRC/HUD/readme.md#hudhintinstructorupdate) | Updates the hint. |
| [`SetText(message: string) -> HintInstructor`](SRC/HUD/readme.md#hudhintinstructorsettextmessage) | Sets hint message. |
| [`SetBind(bind: string) -> HintInstructor`](SRC/HUD/readme.md#hudhintinstructorsetbindbind) | Sets bind.  |
| [`SetPositioning(value: number, ent: CBaseEntity\|pcapEntity) -> HintInstructor`](SRC/HUD/readme.md#hudhintinstructorsetpositioningvalue-ent) | Sets positioning. |
| [`SetColor(string_color: string) -> HintInstructor`](SRC/HUD/readme.md#hudhintinstructorsetcolorstring_color) | Sets color.  |
| [`SetIconOnScreen(icon: string) -> HintInstructor`](SRC/HUD/readme.md#hudhintinstructorseticononscreenicon) | Sets on-screen icon. |
| [`SetIconOffScreen(screen: string) -> HintInstructor`](SRC/HUD/readme.md#hudhintinstructorseticonoffscreenscreen) | Sets off-screen icon. |
| [`SetHoldTime(time: number) -> HintInstructor`](SRC/HUD/readme.md#hudhintinstructorsetholdtimetime) | Sets hold time.  |
| [`SetDistance(value: number) -> HintInstructor`](SRC/HUD/readme.md#hudhintinstructorsetdistancevalue) | Sets distance.  |
| [`SetEffects(sizePulsing: number, alphaPulsing: number, shaking: number) -> HintInstructor`](SRC/HUD/readme.md#hudhintinstructorseteffectssizepulsing-alphapulsing-shaking) | Sets effects. |


## 8. [Math](SRC/Math/readme.md#math-module)

Provides various mathematical functions and objects.

### [`Math/algebraic.nut`](SRC/Math/readme.md#mathalgebraicnut)
Provides basic algebraic functions.

| Function | Description |
|---|---|
| [`min(...)`](SRC/Math/readme.md#mathmin) | Finds minimum value. |
| [`max(...)`](SRC/Math/readme.md#mathmax) | Finds maximum value. |
| [`clamp(number: number, min: number, max: number)`](SRC/Math/readme.md#mathclampnumber-min-max) | Clamps a number. |
| [`round(value: number, precision: number)`](SRC/Math/readme.md#mathroundvalue-precision) | Rounds a number. |
| [`Sign(x: number)`](SRC/Math/readme.md#mathsignx) | Sign of number (-1, 0, or 1) |
| [`copysign(value: number, sign: number)`](SRC/Math/readme.md#mathcopysignvalue-sign) | Copies sign to value. |
| [`RemapVal(val: number, A: number, B: number, C: number, D: number)`](SRC/Math/readme.md#mathremapvalval-a-b-c-d) | Remaps value between ranges. |

### [`Math/utils_vector.nut`](SRC/Math/readme.md#mathutils_vectornut)
Provides utility functions for working with vectors.

| Function | Description |
|---|---|
| [`vector.isEqually(vec1: Vector, vec2: Vector)`](SRC/Math/readme.md#mathvectorisequallyvec1-vec2) | Vector equality check (integers). |
| [`vector.isEqually2(vec1: Vector, vec2: Vector, precision: number)`](SRC/Math/readme.md#mathvectorisequally2vec1-vec2-precision) | Vector approximate equality. |
| [`vector.mul(vec1: Vector, vec2: Vector)`](SRC/Math/readme.md#mathvectormulvec1-vec2) | Element-wise multiplication. |
| [`vector.rotate(vec: Vector, angle: Vector)`](SRC/Math/readme.md#mathvectorrotatevec-angle) | Vector rotation. |
| [`vector.unrotate(vec: Vector, angle: Vector)`](SRC/Math/readme.md#mathvectorunrotatevec-angle) | Vector unrotation. |
| [`vector.random(min: Vector\|number, max: Vector\|number)`](SRC/Math/readme.md#mathvectorrandommin-max) | Random vector generation. |
| [`vector.reflect(dir: Vector, normal: Vector)`](SRC/Math/readme.md#mathvectorreflectdir-normal) | Reflects vector off normal. |
| [`vector.clamp(vec: Vector, min: number, max: number)`](SRC/Math/readme.md#mathvectorclampvec-min-max) | Clamps vector components. |
| [`vector.resize(vec: Vector, newLength: number)`](SRC/Math/readme.md#mathvectorresizevec-newlength) | Resizes vector to new length. |
| [`vector.round(vec: Vector, precision: number)`](SRC/Math/readme.md#mathvectorroundvec-precision) | Rounds vector components. |
| [`vector.sign(vec: Vector)`](SRC/Math/readme.md#mathvectorsignvec) | Returns vector of component signs. |
| [`vector.abs(vector: Vector)`](SRC/Math/readme.md#mathvectorabsvector) | Returns vector with absolute components. |

### [`Math/lerp.nut`](SRC/Math/readme.md#mathlerpnut)
Provides linear interpolation functions.

| Function | Description |
|---|---|math
| [`lerp.number(start: number, end: number, t: number)`](SRC/Math/readme.md#mathlerpnumberstart-end-t) | Number interpolation. |
| [`lerp.vector(start: Vector, end: Vector, t: number)`](SRC/Math/readme.md#mathlerpvectorstart-end-t) | Vector interpolation. |
| [`lerp.color(start: string\|Vector, end: string\|Vector, t: number)`](SRC/Math/readme.md#mathlerpcolorstart-end-t) | Color interpolation. |
| [`lerp.sVector(start: Vector, end: Vector, t: number)`](SRC/Math/readme.md#mathlerpsvectorstart-end-t) | Spherical vector interpolation. |
| [`lerp.SmoothStep(edge0: number, edge1: number, x: number)`](SRC/Math/readme.md#mathlerpsmoothstepedge0-edge1-x) | Smoothstep interpolation. |
| [`lerp.FLerp(f1: number, f2: number, i1: number, i2: number, x: number)`](SRC/Math/readme.md#mathlerpflerpf1-f2-i1-i2-x) | Custom parameter interpolation. |

### [`Math/easing_equation.nut`](SRC/Math/readme.md#matheasincirc)
Provides various easing functions.

| Function | Description |
|---|---|
| [`ease.InSine(t: number)`](SRC/Math/readme.md#matheaseinsinet), [`ease.OutSine(t: number)`](SRC/Math/readme.md#matheaseoutsinet), [`ease.InOutSine(t: number)`](SRC/Math/readme.md#matheaseinoutsinet) | Sine easing functions. |
| [`ease.InQuad(t: number)`](SRC/Math/readme.md#matheaseinquadt), [`ease.OutQuad(t: number)`](SRC/Math/readme.md#matheaseoutquadt), [`ease.InOutQuad(t: number)`](SRC/Math/readme.md#matheaseinoutquadt) | Quadratic easing functions. |
| [`ease.InCubic(t: number)`](SRC/Math/readme.md#matheaseincubict), [`ease.OutCubic(t: number)`](SRC/Math/readme.md#matheaseoutcubict), [`ease.InOutCubic(t: number)`](SRC/Math/readme.md#matheaseinoutcubict) | Cubic easing functions. |
| [`ease.InQuart(t: number)`](SRC/Math/readme.md#matheaseinquartt), [`ease.OutQuart(t: number)`](SRC/Math/readme.md#matheaseoutquartt), [`ease.InOutQuart(t: number)`](SRC/Math/readme.md#matheaseinoutquartt) | Quartic easing functions. |
| [`ease.InQuint(t: number)`](SRC/Math/readme.md#matheaseinquintt), [`ease.OutQuint(t: number)`](SRC/Math/readme.md#matheaseoutquintt), [`ease.InOutQuint(t: number)`](SRC/Math/readme.md#matheaseinoutquintt) | Quintic easing functions. |
| [`ease.InExpo(t: number)`](SRC/Math/readme.md#matheaseinexpot), [`ease.OutExpo(t: number)`](SRC/Math/readme.md#matheaseoutexpot), [`ease.InOutExpo(t: number)`](SRC/Math/readme.md#matheaseinoutexpot) | Exponential easing functions. |
| [`ease.InCirc(t: number)`](SRC/Math/readme.md#matheaseincirct), [`ease.OutCirc(t: number)`](SRC/Math/readme.md#matheaseoutcirct), [`ease.InOutCirc(t: number)`](SRC/Math/readme.md#matheaseinoutcirct) | Circular easing functions. |
| [`ease.InBack(t: number)`](SRC/Math/readme.md#matheaseinbackt), [`ease.OutBack(t: number)`](SRC/Math/readme.md#matheaseoutbackt), [`ease.InOutBack(t: number)`](SRC/Math/readme.md#matheaseinoutbackt) | Back easing functions. |
| [`ease.InElastic(t: number)`](SRC/Math/readme.md#matheaseinelastict), [`ease.OutElastic(t: number)`](SRC/Math/readme.md#matheaseoutelastict), [`ease.InOutElastic(t: number)`](SRC/Math/readme.md#matheaseinoutelastict) | Elastic easing functions. |
| [`ease.InBounce(t: number)`](SRC/Math/readme.md#matheaseinbouncet), [`ease.OutBounce(t: number)`](SRC/Math/readme.md#matheaseoutbouncet), [`ease.InOutBounce(t: number)`](SRC/Math/readme.md#matheaseinoutbouncet) | Bounce easing functions. |


### [`Math/quaternion.nut`](SRC/Math/readme.md#mathquaternionnut)
Provides quaternion operations.

| Function/Method | Description |
|---|---|
| [`Quaternion(x: number, y: number, z: number, w: number)`](SRC/Math/readme.md#quaternionx-y-z-w) | Creates a quaternion. |
| [`fromEuler(angles: Vector) -> Quaternion`](SRC/Math/readme.md#fromeulerangles) | Quaternion from Euler angles. |
| [`fromVector(vector: Vector) -> Quaternion`](SRC/Math/readme.md#fromvectorvector) | Quaternion from vector. |
| [`rotateVector(vector: Vector) -> Vector`](SRC/Math/readme.md#rotatevectorvector) | Rotates vector by quaternion. |
| [`unrotateVector(vector: Vector) -> Vector`](SRC/Math/readme.md#unrotatevectorvector) | Unrotates vector by quaternion. |
| [`slerp(targetQuaternion: Quaternion, t: number) -> Quaternion`](SRC/Math/readme.md#slerptargetquaternion-t) | Spherical linear interpolation. |
| [`normalize() -> Quaternion`](SRC/Math/readme.md#normalize) | Normalizes quaternion. |
| [`dot(other: Quaternion) -> number`](SRC/Math/readme.md#dotother) | Dot product of quaternions. |
| [`length() -> number`](SRC/Math/readme.md#length) | Quaternion length. |
| [`inverse() -> Quaternion`](SRC/Math/readme.md#inverse) | Inverse of quaternion. |
| [`fromAxisAngle(axis: Vector, angle: number) -> Quaternion`](SRC/Math/readme.md#fromaxisangleaxis-angle) | Quaternion from axis-angle. |
| [`toAxisAngle() -> table`](SRC/Math/readme.md#toaxisangle) | Converts to axis-angle. |
| [`toVector() -> Vector`](SRC/Math/readme.md#tovector) | Converts to Euler angles. |
| [`isEqually(other: Quaternion) -> bool`](SRC/Math/readme.md#isequallyother) | Quaternion equality check. |
| [`cmp(other: Quaternion) -> number`](SRC/Math/readme.md#cmpother) | Compares quaternion magnitudes. |


### [`Math/matrix.nut`](SRC/Math/readme.md#mathmatrixnut)
Provides matrix operations.

| Function/Method | Description |
|---|---| 
| [`Matrix(...)`](SRC/Math/readme.md#matrixa-b-c-d-e-f-g-h-k) | Creates a matrix (see full docs for arguments). |
| [`fromEuler(angles: Vector) -> Matrix`](SRC/Math/readme.md#fromeulerangles) | Matrix from Euler angles. |
| [`rotateVector(point: Vector) -> Vector`](SRC/Math/readme.md#rotatevectorpoint) | Rotates vector by matrix. |
| [`unrotateVector(point: Vector) -> Vector`](SRC/Math/readme.md#unrotatevectorpoint) | Unrotates vector by matrix. |
| [`transpose() -> Matrix`](SRC/Math/readme.md#transpose) | Transposes matrix. |
| [`inverse() -> Matrix`](SRC/Math/readme.md#inverse) | Inverts matrix. |
| [`determinant() -> number`](SRC/Math/readme.md#determinant) | Matrix determinant. |
| [`scale(factor: number) -> Matrix`](SRC/Math/readme.md#scalefactor) | Scales matrix. |
| [`rotateX(angle: number) -> Matrix`](SRC/Math/readme.md#rotatexangle) | Rotates matrix around X axis. |
| [`_mul(other: Matrix) -> Matrix`](SRC/Math/readme.md#_mulother) | Matrix multiplication. |
| [`_add(other: Matrix) -> Matrix`](SRC/Math/readme.md#_addother) | Matrix addition. |
| [`_sub(other: Matrix) -> Matrix`](SRC/Math/readme.md#_subother) | Matrix subtraction. |
| [`isEqually(other: Matrix) -> bool`](SRC/Math/readme.md#isequallyother) | Matrix equality check. |
| [`cmp(other: Matrix) -> number`](SRC/Math/readme.md#cmpother) | Compares matrix component sums. |