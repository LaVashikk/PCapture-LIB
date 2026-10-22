# PCapture-Lib 5.0 Cheat Sheet

Everything on one page, one line each. Every heading leads to the module's readme with recipes, explanations and common mistakes.

* [Entities: pcapEntity and entLib](#entities-pcapentity-and-entlib)
* [Containers: ArrayEx, List, AVLTree](#containers-arrayex-list-avltree)
* [TracePlus](#traceplus)
* [ActionScheduler](#actionscheduler)
* [Animations](#animations)
* [ScriptEvents](#scriptevents)
* [HUD](#hud)
* [Math](#math)
* [Utils](#utils)
* [Console commands](#console-commands)

## [Entities: pcapEntity and entLib](SRC/IDT/readme.md#entities)

| | |
|---|---|
| `entLib.FromEntity(handle)` | The `pcapEntity` of a native handle |
| `entLib.CreateByClassname(classname, keyvalues)` | A new entity |
| `entLib.CreateProp(classname, origin, model)` | A new prop |
| `entLib.FindByName/Classname/Model(value, start_ent)` | The next match, loop with `for(local e; e = entLib.FindBy...(x, e);)` |
| `entLib.FindBy...Within(value, origin, radius, start_ent)`, `FindInSphere` | The same, within a radius |
| `Kill()`, `Destroy()`, `Dissolve()` | Remove the entity |
| `SetAbsOrigin`, `SetCenter`, `SetAngles2` | Teleport, center on a point, rotate with a Vector |
| `SetAlpha`, `SetColor`, `SetSkin`, `SetDrawEnabled`, `SetModelScale` | Looks |
| `SetKeyValue`, `SetUserData` / `GetUserData` | Keyvalues, your own data on the entity |
| `ConnectOutputEx(output, func)`, `SetInputHook(input, func)` | React to outputs, intercept inputs |
| `EmitSoundEx(sound, volume, looped)`, `StopSoundEx` | Sounds with volume and looping |
| `SetParent`, `GetChildren`, `GetAllChildrenRecursively` | Hierarchy |
| `SetTraceIgnore(bool)` | Hide it from TracePlus |
| `EyePosition`, `EyeAngles`, `EyeForwardVector` | Where a player looks |
| `GetBBoxPoints`, `GetBBoxFaces`, `GetAABB`, `GetHalfSize` | Rotated bounds |

Most setters take `fireDelay, eventName` at the end. [All methods](SRC/IDT/readme.md#pcapentity)

## [Containers: ArrayEx, List, AVLTree](SRC/IDT/readme.md#containers)

| | |
|---|---|
| `ArrayEx(...)`, `ArrayEx.FromArray(arr)` | An array with chainable methods |
| `List(...)` | A linked list, iterate with `.iter()` |
| `AVLTree(...)` | A collection that stays sorted |
| `map`, `filter`, `reduce`, `search`, `unique`, `join`, `slice`... | Shared by all three. `filter` gets `(index, value, newArray)` |

[ArrayEx](SRC/IDT/readme.md#arrayex-methods), [List](SRC/IDT/readme.md#list-methods), [AVLTree](SRC/IDT/readme.md#avltree-methods)

## [TracePlus](SRC/TracePlus/readme.md)

| | |
|---|---|
| `TracePlus.Cheap(start, end)` | World geometry only, fast |
| `TracePlus.Bbox(start, end, ignoreEntities, settings)` | Hits entities too |
| `TracePlus.PortalCheap` / `PortalBbox` | Through portals |
| `TracePlus.FromEyes.Cheap/Bbox/PortalCheap/PortalBbox(distance, player, ...)` | From where a player looks |
| `TracePlus.Settings()` | What a bbox trace hits: `IgnoreClasses`, `ExceptClasses`, `IgnoreAllClasses`, `IgnoreModels`, `SetIgnoreFilter`, `SetHitFilter` |
| `DidHit()`, `DidHitWorld()`, `GetEntity()`, `GetHitPos()`, `GetImpactNormal()` | Reading the result |

[Recipes for settings](SRC/TracePlus/readme.md#choosing-what-to-hit-recipes), [Portals](SRC/TracePlus/readme.md#tracing-through-portals)

## [ActionScheduler](SRC/ActionScheduler/readme.md)

| | |
|---|---|
| `ScheduleEvent.Add(event, action, delay, args, scope)` | Run once, later |
| `ScheduleEvent.AddInterval(event, action, interval, initialDelay, args, scope)` | Run every N seconds |
| A function with `yield <seconds>` | A sequence with pauses |
| `ScheduleEvent.Cancel(event)`, `TryCancel(event)` | Stop everything under an event name |
| `ScheduleEvent.IsValid(event)`, `CancelAll()` | Check, cancel all but `"global"` |

## [Animations](SRC/Animations/readme.md)

| | |
|---|---|
| `animate.AlphaTransition(entities, from, to, time, settings)` | Opacity |
| `animate.ColorTransition(...)` | Color |
| `animate.PositionTransitionByTime(...)`, `PositionTransitionBySpeed(...)` | Position |
| `animate.AnglesTransitionByTime(...)` | Angles |
| `animate.RT.*` | Real-time versions, stoppable with `filterCallback` |
| `macros.BuildAnimateFunction(name, setter)` | Your own animation |

[Settings: ease, globalDelay, output, eventName, fps](SRC/Animations/readme.md#settings)

## [ScriptEvents](SRC/ScriptEvents/readme.md)

| | |
|---|---|
| `ScriptEvents.On(name, action, scope)` | Subscribe, returns an id |
| `ScriptEvents.Once(name, action, scope)` | Subscribe to the next emit |
| `ScriptEvents.Off(id)` | Unsubscribe |
| `ScriptEvents.Emit(name, ...)` | Run the subscribers with these arguments |

## [HUD](SRC/HUD/readme.md)

| | |
|---|---|
| `HUD.ScreenText(text, x, y)` | On-screen text, `-1` centers. `SetChannel`, `SetColor`, `SetHoldTime`, `SetEffect`... |
| `HUD.HintInstructor(text)` | Instructor hint. `SetBind`, `SetIcon`, `AttachTo`, `SetHoldTime`... |
| `Enable(player)`, `Disable()` | Show (to everyone, or one player), hide |

## [Math](SRC/Math/readme.md)

| | |
|---|---|
| `math.min`, `max`, `clamp`, `round`, `Sign`, `copysign`, `RemapVal` | [Numbers](SRC/Math/readme.md#numbers) |
| `math.vector.rotate`, `unrotate`, `reflect`, `resize`, `random`, `IsEqual`... | [Vectors](SRC/Math/readme.md#vectors) |
| `math.lerp.number`, `vector`, `color`, `sVector`, `SmoothStep`, `FLerp` | [Interpolation](SRC/Math/readme.md#interpolation) |
| `math.ease.InOutSine` and 29 more | [Easing curves](SRC/Math/readme.md#easing) |
| `math.Quaternion`, `math.Matrix` | [Rotations](SRC/Math/readme.md#rotations-quaternion-and-matrix) |

## [Utils](SRC/Utils/readme.md)

| | |
|---|---|
| `dev.info`, `debug`, `warning`, `error` | [Logging](SRC/Utils/readme.md#logging) with `{}` placeholders, developer mode only |
| `dev.drawbox`, `DrawEntityBBox`, `DrawEntityAABB` | [Debug drawing](SRC/Utils/readme.md#drawing) |
| `GetPlayerEx(index)`, `GetPlayers()`, `RunWhenPlayerExists(func)` | [Players](SRC/Utils/readme.md#players) |
| `AddPlayerJoinHook`, `AddPlayerDeathHook`, `AddPlayerRespawnHook`, `AddPlayerLeaveHook` | [Player events](SRC/Utils/readme.md#player-events) |
| `File(name)` | [Text files](SRC/Utils/readme.md#files) in `cfg/` |
| `EntFireByHandle(..., eventName)`, `UniqueString`, `FrameTime` | [Improved engine functions](SRC/Utils/readme.md#fixed-engine-functions) |
| `COLLISION_GROUP_*`, `SOLID_*` | [Constants](SRC/Utils/readme.md#constants) |
| `macros.*` | [Tables, strings, ranges, comparing, geometry, sounds](SRC/Utils/readme.md#macros) |

## [Console commands](SRC/Utils/readme.md#console-commands)

`PCore_ver`, `PCore_schedule_list`, `PCore_schedule_clear`, `PCore_vs_events`, `PCore_players`, `PCore_log_off`, and with `developer` on: `PCore_log_info`, `PCore_log_debug`, `PCore_level_trace`.
