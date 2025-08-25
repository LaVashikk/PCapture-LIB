::pcapEntity <- class {
    CBaseEntity = null;

    /* 
     * Constructor for the entity object.
     *
     * @param {CBaseEntity} entity - The entity object.
    */
    constructor(entity = null) { 
        if(typeof entity == "pcapEntity")
            entity = entity.CBaseEntity

        this.CBaseEntity = entity
        EntitiesScopes[this.CBaseEntity] <- {}
        entity.ValidateScriptScope()
        entity.GetScriptScope().selfEx <- this // todo: no docs about it
    }


    function SetAngles(x, y, z) {
        x = x >= 360 ? 0 : x
        y = y >= 360 ? 0 : y
        z = z >= 360 ? 0 : z
        this.CBaseEntity.SetAngles(x, y, z)
    }

    /*
     * Sets the angles of the entity.
     *
     * @param {Vector} angles - The angle vector.
    */
    function SetAbsAngles(angles) {
        this.CBaseEntity.SetAngles(angles.x, angles.y, angles.z)
    }


    // Destroys the entity. 
    function Destroy(fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.Destroy, fireDelay, null, this)
        
        if(!this.CBaseEntity || !this.CBaseEntity.IsValid()) return
        this.CBaseEntity.Destroy()
        this.CBaseEntity = null
    }


    /*
     * Kills the entity.
     *
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function Kill(fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.Kill, fireDelay, null, this)

        EntFireByHandle(CBaseEntity, "kill")
        this.CBaseEntity = null
    }


    /*
     * Dissolves the entity using an env_entity_dissolver entity, creating a visual effect of the entity dissolving away.
     *
     * This method utilizes an env_entity_dissolver entity to create the dissolve effect. If the entity doesn't have a targetname, 
     * a unique targetname is assigned to it before initiating the dissolve process. 
    */
    function Dissolve(fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.Dissolve, fireDelay, null, this)

        if(this.GetName() == "")
            this.SetUniqueName("targetname")
        dissolver.SetKeyValue("target", this.GetName())
        EntFireByHandle(dissolver, "dissolve")

        this.SetUserData("Dissolved", true)
    }


    /*
     * Checks if the entity is valid.
     *
     * @returns {bool} - True if the entity is valid, false otherwise.
    */
    function IsValid() {
        return this.CBaseEntity && this.CBaseEntity.IsValid() && !this.GetUserData("Dissolved")
    }


    /*
     * Checks if this entity is the player entity.
     * 
     * @returns {bool} - True if this entity is the player, false otherwise.
    */
    function IsPlayer() {
        return this.CBaseEntity.GetClassname() == "player"
    }

    /*
     * Gets the eye position of the player entity.
     *
     * @returns {Vector|null} - The eye position as a Vector, or null if the entity is not a player.
     * 
     * This method retrieves the position from which the player's view is rendered. It is important to note that this method only works with player entities.
     * For non-player entities, it returns GetCenter. 
    */
     function EyePosition() {
        if(this.IsPlayer()) return this.CBaseEntity.EyePosition()
        return this.GetCenter()
    }

    /*
     * Gets the eye angles of the player entity. 
     *
     * @returns {Vector|null} - The eye angles as a Vector representing pitch, yaw, and roll, or null if the entity is not a player.
     *
     * This method retrieves the orientation of the player's view. It is important to note that this method only works with player entities.
     * For non-player entities, it returns GetAngles. 
    */
    function EyeAngles() {
        if(this.IsPlayer()) return this.GetUserData("Eye").GetAngles()
        return this.GetAngles()
    }

    /* 
     * Gets the forward vector from the player entity's eye position, indicating the direction the player is looking. 
     *
     * @returns {Vector|null} - The forward vector as a Vector, or null if the entity is not a player.
     *
     * This method retrieves the direction in which the player is facing. It is important to note that this method only works with player entities.
     * For non-player entities, it returns GetForwardVector.
    */
    function EyeForwardVector() {
        if(this.IsPlayer()) return this.GetUserData("Eye").GetForwardVector()
        return this.GetForwardVector()
    }

    /*
     * Sets the key-value pair of the entity.  
     *
     * @param {string} key - The key of the key-value pair.
     * @param {int|float|Vector|string} value - The value of the key-value pair.
    */
    function SetKeyValue(key, value, fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.SetKeyValue, fireDelay, [key, value], this)

        this.SetUserData(key, value)

        switch (typeof value) {
            case "integer":
                return this.CBaseEntity.__KeyValueFromInt(key, value);
            case "float":
                return this.CBaseEntity.__KeyValueFromFloat(key, value);
            case "Vector":
                return this.CBaseEntity.__KeyValueFromVector(key, value);
            case "string":
                return this.CBaseEntity.__KeyValueFromString(key, value);
        }
        
        return this.CBaseEntity.__KeyValueFromString(key, value.tostring());
    }


    /*
     * Connects an output of the entity to a target entity and input, allowing for parameter overrides, delays, and limited trigger counts.
     *
     * @param {string} outputName - The name of the output to connect.
     * @param {string|CBaseEntity|pcapEntity} target - The target entity or its targetname to connect the output to.
     * @param {string} input - The name of the input on the target entity to connect to.
     * @param {string} param - An optional parameter override for the input. (default: "")
     * @param {number} delay - An optional delay in seconds before triggering the input. (default: 0) 
     * @param {number} fires - The number of times the output should fire before becoming inactive. -1 indicates unlimited fires. (default: -1) 
     * 
     * This method provides a way to establish connections between entities, allowing them to trigger actions on each other based on outputs and inputs. 
    */
     function AddOutput(outputName, target, input, param = "", delay = 0, fires = -1) {
        if(typeof target == "instance" || typeof target == "pcapEntity")
            target = target.GetName()
        this.SetKeyValue(outputName, target + "\x001B" + input + "\x001B" + param + "\x001B" + delay + "\x001B" + fires)
    }

    /* 
     * Connects an output of the entity to a script function or string, allowing for delays and limited trigger counts. 
     * 
     * @param {string} outputName - The name of the output to connect.
     * @param {string|function} script - The VScripts code or function name to execute when the output is triggered.
     * @param {number} delay - An optional delay in seconds before executing the script. (default: 0) 
     * @param {number} fires - The number of times the output should fire before becoming inactive. -1 indicates unlimited fires. (default: -1) 
     * 
     * This method provides a way to connect entity outputs directly to script code, allowing for custom actions to be performed when the output is triggered.
    */
    function ConnectOutputEx(outputName, script, delay = 0, fires = -1) {
        if(typeof script == "function") {
            local funcName = script.getinfos().name
            local src = script.getinfos().src
            if(!funcName || src == "unnamedbuffer") { // If scripts is an anonymous function, assign it a unique name and add it to the root scope
                funcName = UniqueString("OutputFunc")
                getroottable()[funcName] <- script
            }
            script = funcName + "()"
        }

        this.AddOutput(outputName, "!self", "RunScriptCode", script, delay, fires)
    }

    /*
     * Connects a script function to an input of the entity, allowing external code to react to input events.
     * 
     * @param {string} inputName - The name of the input to connect to.
     * @param {function} closure - The function to execute when the input is triggered. 
     * 
     * This function enables the association of custom logic with specific entity inputs, facilitating communication and interaction between entities and external scripts.
    */
    function SetInputHook(inputName, closure) {
        if(this.ValidateScriptScope() == false) return
        this.GetScriptScope()["Input" + inputName] <- closure
        // This is a quick hack to address a bug where the game sometimes calls `Inputname` instead of `InputName` (Valve, why?)
        this.GetScriptScope()["Input" + inputName.tolower()] <- closure
    }

    /*
     * Plays a sound on the entity.
     *
     * @param {string} soundName - The name of the sound to play.
     * @param {number} fireDelay - An optional delay in seconds before playing the sound. (default: 0)
     * @param {string} eventName - The name of the event to schedule the sound playback under. (default: "global")
     *
     * This function is an enhanced version of the built-in EmitSound method, allowing for delayed sound playback 
     * and cancellation using ScheduleEvent.Cancel.
    */
    function EmitSound(soundName, fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.EmitSound, fireDelay, [soundName], this)

        this.CBaseEntity.EmitSound(soundName)
    }

    /*
     * Plays a sound on the entity with advanced options, including volume control and looping.
     *
     * @param {string} soundName - The name of the sound to play.
     * @param {number} volume - The volume of the sound (0-10). (default: 10)
     * @param {boolean} looped - Whether the sound should loop. (default: false)
     * @param {number} fireDelay - An optional delay in seconds before playing the sound. (default: 0)
     * @param {string} eventName - The name of the event to schedule the sound playback under. (default: "global")
     *
     * This function provides more control over sound playback compared to EmitSound. It allows you to adjust the volume,
     * loop sounds that are not inherently loopable, and stop the sound playback using StopSoundEx.
    */
    function EmitSoundEx(soundName, volume = 10, looped = false, fireDelay = 0, eventName = "global") { // add volume and loop flag
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.EmitSoundEx, fireDelay, [soundName], this)
        
        // for updating volume if sound active
        local soundEnt = this.GetUserData(soundName)
        if(soundEnt && soundEnt.IsValid()) 
            return soundEnt.SetAbsOrigin(this.GetOrigin() + Vector(0, 0, 3000 - volume * 300))
        
        // SO FKING CURSED WORKAROUND EVER!
        local soundEnt = entLib.CreateProp("prop_physics", Vector(), ALWAYS_PRECACHED_MODEL)
        soundEnt.SetAbsOrigin(this.GetOrigin() + Vector(0, 0, 3000 - volume * 300))
        soundEnt.SetParent(this)
        soundEnt.SetKeyValue("rendermode", 5)
        soundEnt.SetAlpha(0)

        local soundTime = macros.GetSoundDuration(soundName)
        this.SetUserData(soundName, soundEnt)
        soundEnt.EmitSound(soundName)
        
        if(!looped) return soundEnt.Destroy(soundTime)
        ScheduleEvent.AddInterval(soundEnt, soundEnt.EmitSound, soundTime, soundTime, [soundName], soundEnt) // :>
    }

    /*
     * Stops a sound played using EmitSoundEx.
     *
     * @param {string} soundName - The name of the sound to stop.
     * @param {number} fireDelay - An optional delay in seconds before stopping the sound. (default: 0)
     * @param {string} eventName - The name of the event to schedule the sound stop under. (default: "global")
     *
     * This function allows you to interrupt sounds that were started using EmitSoundEx. It ensures the sound is stopped
     * and the associated entity is cleaned up.
    */
    function StopSoundEx(soundName, fireDelay = 0, eventName = "global") {
        if(fireDelay != 0) {
            return ScheduleEvent.Add(eventName, this.StopSoundEx, fireDelay, [soundName], this)
        }

        local soundEnt = this.GetUserData(soundName)
        if(!soundEnt || !soundEnt.IsValid()) return

        ScheduleEvent.TryCancel(soundEnt)
        soundEnt.SetOrigin(Vector(0, 0, 10000))
        soundEnt.Destroy(0.04)
    }


    /*
     * Sets the targetname of the entity.
     *
     * @param {string} name - The targetname to be set.
    */
    function SetName(name, fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.SetName, fireDelay, [name], this)
        
        this.SetKeyValue("targetname", name)
    }

    /*
     * Sets a unique targetname for the entity using the provided prefix.
     *
     * @param {string} prefix - The prefix to be used for the unique targetname. (optional, default="u")
    */
    function SetUniqueName(prefix = "pcapEnt", fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.SetUniqueName, fireDelay, [prefix], this)
        
        this.SetKeyValue("targetname", UniqueString(prefix))
    }


    /*
     * Sets the parent of the entity.
     *
     * @param {string|CBaseEntity|pcapEntity} parent - The parent entity object or its targetname.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetParent(parentEnt, fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.SetParent, fireDelay, [parentEnt], this)
        
        this.SetUserData("parent", parentEnt)
        if(typeof parentEnt != "string") {
            local Pent = entLib.FromEntity(parentEnt)
            if(Pent.GetName() == "") 
                Pent.SetUniqueName("parent")
            parentEnt = Pent.GetName()
        }
        
        EntFireByHandle(this.CBaseEntity, "SetParent", parentEnt)            
    }

    /*
     * Gets the parent of the entity.
     *
     * @returns {pcapEntity|null} - The parent entity object or null if no parent is set.
    */
    function GetParent() {
        return this.GetUserData("parent")
    }

    /*
     * Gets a list of all DIRECT children of this entity.
     * This function is not recursive and will not find grandchildren.
     *
     * @returns {List} A List containing all direct child pcaptEntity objects.
    */
    function GetChildren() {
        local childrenList = List()

        local child = this.CBaseEntity.FirstMoveChild(); 
        while(child) {
            childrenList.append(entLib.FromEntity(child));
            child = child.NextMovePeer();
        }

        return childrenList;
    }

    /*
     * Recursively finds all descendants (children, grandchildren, etc.) of this entity.
     * Performs a depth-first search of the entity hierarchy.
     *
     * @returns {List} A List containing all descendant pcaptEntity objects.
    */    
    function GetAllChildrenRecursivly() {
        local descendantsList = List();
        _findDescendantsRecursive(this.CBaseEntity, descendantsList);

        return descendantsList;
    }


    /*
     * Sets the collision of the entity.
     *
     * @param {number} solidType - The type of collision.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetCollision(solidType, fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.SetCollision, fireDelay, [solidType], this)
        
        EntFireByHandle(this.CBaseEntity, "SetSolidtype", solidType.tostring()) 
        this.SetUserData("Solidtype", solidType)
    }


    /*
     * Sets the collision group of the entity.
     *
     * @param {number} collisionGroup - The collision group.
    */
    function SetCollisionGroup(collisionGroup, fireDelay = 0, eventName = "global") {
        this.SetKeyValue("CollisionGroup", collisionGroup, fireDelay, eventName)
    }
    

    /* 
     * Starts playing the specified animation.
     *
     * @param {string} animationName - The name of the animation to play.
     * @param {number} fireDelay - Delay in seconds before starting the animation.
    */
    function SetAnimation(animationName, fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.SetAnimation, fireDelay, [animationName], this)
        
        EntFireByHandle(this.CBaseEntity, "SetAnimation", animationName)
        this.SetUserData("animation", animationName)
    }


    /*
     * Sets the alpha (opacity) of the entity.
     *
     * @param {number} opacity - The alpha value (0-255).
     * @param {number} fireDelay - Delay in seconds before applying.
     * Note: Don't forget to set "rendermode" to 5 for alpha to work.
    */
    function SetAlpha(opacity, fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.SetAlpha, fireDelay, [opacity], this)
        
        EntFireByHandle(this.CBaseEntity, "Alpha", opacity.tostring())
        this.SetUserData("alpha", opacity)
    }


    /*
     * Sets the color of the entity.
     *
     * @param {string|Vector} colorValue - The color value as a string (e.g., "255 0 0") or a Vector.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetColor(colorValue, fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.SetColor, fireDelay, [colorValue], this)
        
        if(typeof colorValue == "Vector") 
            colorValue = macros.VecToStr(colorValue)

        EntFireByHandle(this.CBaseEntity, "Color", colorValue)
        this.SetUserData("color", colorValue)
    }


    /*
     * Sets the skin of the entity.
     *
     * @param {number} skin - The skin number.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetSkin(skin, fireDelay = 0, eventName = "global") { 
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.SetSkin, fireDelay, [skin], this)
        
        EntFireByHandle(this.CBaseEntity, "skin", skin.tostring())
        this.SetUserData("skin", skin)
    }


    /*
     * Sets whether the entity should be drawn or not. 
     *
     * @param {boolean} isEnabled - True to enable drawing, false to disable.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetDrawEnabled(isEnabled, fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.SetDrawEnabled, fireDelay, [isEnabled], this)
        
        local action = isEnabled ? "EnableDraw" : "DisableDraw"
        EntFireByHandle(this.CBaseEntity, action)
        this.SetUserData("IsDraw", isEnabled)
    }

    function Disable(fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.Disable, fireDelay, null, this)
        
        EntFireByHandle(this.CBaseEntity, "Disable")
        this.SetTraceIgnore(true)
    }

    function Enable(fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.Enable, fireDelay, null, this)
        
        EntFireByHandle(this.CBaseEntity, "Enable")
        this.SetTraceIgnore(false)
    }

    /*
     * Checks if the entity is set to be drawn.
     * 
     * @returns {boolean} - True if the entity is set to be drawn, false otherwise.
    */
    function IsDrawEnabled() {
        return this.GetUserData("IsDraw")
    }

    /*
     * Sets whether the entity should be ignored during traces.
     * 
     * @param {boolean} isEnabled - True to ignore the entity during traces, false otherwise.
    */
    function SetTraceIgnore(isEnabled, fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.SetTraceIgnore, fireDelay, [isEnabled], this)
        
        this.SetUserData("TracePlusIgnore", isEnabled)
        TracePlusIgnoreEnts[this.CBaseEntity] <- isEnabled
    }

    function IsTraceIgnored() {
        return this.GetUserData("TracePlusIgnore")
    }

    /*
     * Sets the spawnflags for the entity.
     *
     * @param {number} flag - The spawnflags value to set.
    */
    function SetSpawnflags(flag, fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.SetSpawnflags, fireDelay, [flag], this)
        
        this.SetKeyValue("SpawnFlags", flag)
    }


    /*
     * Sets the scale of the entity's model.
     *
     * @param {number} scaleValue - The scale value.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetModelScale(scaleValue, fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.SetModelScale, fireDelay, [scaleValue], this)
        
        EntFireByHandle(this.CBaseEntity, "AddOutput", "ModelScale " + scaleValue)
        this.SetUserData("ModelScale", scaleValue)
        // hack for entity update
        EntFireByHandle(this, "SetBodyGroup", "1"); EntFireByHandle(this, "SetBodyGroup", "0", 0.02)
    }

    /*
     * Gets the current model scale of the entity.
     *
     * @returns {number} - The current model scale value.
    */
    function GetModelScale() {
        local res = this.GetUserData("ModelScale")
        return res ? res : 1
    }


    /*
    * Sets the absolute center of the entity in world space.
    * This will override any parent-relative positioning.
    *
    * @param {Vector} vector - The desired absolute center vector in world coordinates.
    */
    function SetAbsCenter(vector) {
        local offset = this.CBaseEntity.GetCenter() - this.CBaseEntity.GetOrigin()
        this.CBaseEntity.SetAbsOrigin( vector - offset )
    }

    /*
     * Sets the center of the entity.
     *
     * @param {Vector} vector - The center vector.
    */
    function SetCenter(vector) {
        local offset = this.CBaseEntity.GetCenter() - this.CBaseEntity.GetOrigin()
        this.CBaseEntity.SetOrigin( vector - offset )
    }

    /*
     * Sets the bounding box of the entity.
     *
     * @param {Vector|string} min - The minimum bounds vector or a string representation of the vector.
     * @param {Vector|string} max - The maximum bounds vector or a string representation of the vector.
    */
    function SetBBox(minBounds, maxBounds) {
        // Please specify the data type of `min` and `max` to improve the documentation accuracy.
        if (type(minBounds) == "string") {
            minBounds = macros.StrToVec(minBounds)
        }
        if (type(maxBounds) == "string") {
            maxBounds = macros.StrToVec(maxBounds)
        }

        this.CBaseEntity.SetSize(minBounds, maxBounds)
    }


    /*
     * Sets a context value for the entity.
     *
     * @param {string} name - The name of the context value.
     * @param {any} value - The value to set.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetContext(name, value, fireDelay = 0, eventName = "global") {
        if(fireDelay != 0)
            return ScheduleEvent.Add(eventName, this.SetContext, fireDelay, [name, value], this)
        
        EntFireByHandle(this.CBaseEntity, "AddContext", (name + ":" + value))
        this.SetUserData(name, value)
    }
    
    /* 
     * Stores an arbitrary value associated with the entity.
     *
     * @param {string} name - The name of the value.  
     * @param {any} value - The value to store.
    */
    function SetUserData(name, value) {
        EntitiesScopes[this.CBaseEntity][name.tolower()] <- value
    }


    /*
     * Gets a stored user data value.
     *
     * @param {string} name - The name of the value to get.
     * @returns {any} - The stored value, or null if not found.
    */ 
    function GetUserData(name) {
        name = name.tolower()
        if(name in EntitiesScopes[this.CBaseEntity])
            return EntitiesScopes[this.CBaseEntity][name]
        return null
    }


    /*
     * Gets the bounding box of the entity.
     *
     * @returns {table} - The minimum bounds and maximum bounds of the entity.
    */
    function GetBBox() {
        local max = GetBoundingMaxs()
        local min = GetBoundingMins()
        return {min = min, max = max}
    }

    /*
     * Calculates the local coordinates (position and angles) of this entity relative to its move parent.
     * If the entity has no parent, its world coordinates are returned.
     *
     * @returns {table} A table containing the local coordinates: { pos = <Vector>, ang = <Vector> }.
    */    
    function GetLocalCoords() {
        local pParent = this.CBaseEntity.GetMoveParent();
        if (!pParent) {
            // If there's no parent, local coordinates are equal to world coordinates.
            return { pos = this.GetOrigin(), ang = this.GetAngles() };
        }

        // Get the world positions and angles of both entities
        local childWorldPos = this.GetOrigin();
        local parentWorldPos = pParent.GetOrigin();

        local childWorldAng = this.GetAngles();
        local parentWorldAng = pParent.GetAngles();

        // Calculate the offset vector in world coordinates
        local worldOffset = childWorldPos - parentWorldPos;

        // "Unrotate" the world offset vector by the parent's angles to get the local position
        local localPos = math.vector.unrotate(worldOffset, parentWorldAng);
        local localAng = childWorldAng - parentWorldAng;

        return { pos = localPos, ang = localAng };
    }

    /*
     * An experimental function that sets the entity's absolute origin in world space using teleportation.
     * The key difference is that standard position-setting functions use client-side interpolation, 
     * causing the entity to visibly slide to its new position.
     * This function bypasses interpolation, making the position change instantaneous.
     *
     * @param {Vector} desiredAbsVec - The desired absolute position in world coordinates.
    */
    function SetAbsOrigin2(desiredAbsVec) {
        local pParent = this.CBaseEntity.GetMoveParent();

        // --- CASE 1: ENTITY HAS NO PARENT ---
        if (!pParent) {
            // If there is no parent, local coordinates are equivalent to absolute coordinates.
            // Simply use the 'local' SetOrigin to set them.
            this.SetOrigin(desiredAbsVec);
            return;
        }

        // --- CASE 2: ENTITY HAS A PARENT ---
        // We need to convert the desired ABSOLUTE coordinates into LOCAL coordinates.

        // Get the parent's absolute coordinates and angles.
        local parentWorldPos = pParent.GetOrigin();
        local parentWorldAng = pParent.GetAngles();

        // Calculate the offset vector from the parent to the desired point in world coordinates.
        local worldOffsetVector = desiredAbsVec - parentWorldPos;

        // Transform the world offset vector into a local one.
        // To do this, we need to "unrotate" it by the parent's angles.
        // The math.vector.unrotate function does exactly that.
        local localPos = math.vector.unrotate(worldOffsetVector, parentWorldAng);

        this.SetOrigin(localPos);
    }

    /*
     * Checks if the bounding box of an entity is a cube (all sides have equal length).
     *
     * @returns {boolean} - True if the bounding box is a cube, false otherwise.
    */
    function IsSquareBbox() {
        // Get the minimum and maximum coordinates of the bounding box
        local mins = this.GetBoundingMins();
        local maxs = this.GetBoundingMaxs();
        
        // Calculate the size of the bounding box along each axis
        local sizeX = abs(maxs.x - mins.x)
        local sizeY = abs(maxs.y - mins.y)
        local sizeZ = abs(maxs.z - mins.z)

        // Check if the sizes are equal along all axes
        return sizeX == sizeY && sizeY == sizeZ;
    }

    //! TODO ADD TO DOCS
    function GetBoundingCenter() {
        local cachedResult = GetUserData("BoundingCenter")
        if(cachedResult) return cachedResult

        local result = (this.GetBoundingMaxs() - this.GetBoundingMins()) * 0.5
        this.SetUserData("BoundingCenter", result)
        return result
    }

    /* 
     * Returns the axis-aligned bounding box (AABB) of the entity.
     *
     * @returns {table} - The minimum bounds, maximum bounds, and center of the entity.
    */ 
    function GetAABB() {
        local max = CreateAABB(7)
        local min = CreateAABB(0)
        local center = CreateAABB(4)
        return {min = min, center = center, max = max}
    }


    /* 
     * Gets the index of the entity.
     *
     * @returns {int} - The index of the entity.
    */
    function GetIndex() {
        return this.CBaseEntity.entindex()
    }


    /*
     * Gets the value of the key-value pair of the entity.
     * Note: only works if you used the SetKeyValue function!
     *
     * @param {string} key - The key of the key-value pair.
     * @returns {any} - The value of the key-value pair.
    */
    function GetKeyValue(key) {
        local value = this.GetUserData(key)
        if(value != null)
            return value

        switch(key) {
            case "model":
                return this.GetModelName()
                break
            case "health":
                return this.GetHealth()
                break
            case "targetname":
                return this.GetName()
                break
        }

        return null
    }


    /*
     * Gets the spawnflags for the entity.
     * Note: only works if you used the SetKeyValue function!
     *
     * @returns {int|null} - The spawnflags value.
    */ 
    function GetSpawnflags() {
        return this.GetUserData("spawnflags")
    }


    /*
     * Gets the alpha/opacity value of the entity.
     * Note: only works if you used the SetKeyValue function!
     * 
     * @returns {int|null} - The alpha value.
    */
    function GetAlpha() {
        local alpha = this.GetUserData("alpha")
        return alpha != null ? alpha : 255
    }


    /*
     * Gets the color value of the entity.
     * Note: only works if you used the SetKeyValue function!
     *
     * @returns {string|null} - The color value.
    */
    function GetColor() {
        local color = this.GetUserData("color")
        return color ? color : "255 255 255"
    }


    /*
     * Gets the skin of the entity.
     * Note: only works if you used the SetKeyValue function!
     *
     * @returns {number|null} - The skin number.
    */
    function GetSkin() {
        local skin = this.GetUserData("skin")
        return skin ? skin : 0
    }


    /*
     * Gets the prefix of the entity name.
     *
     * @returns {string} - The prefix of the entity name.
    */
    function GetNamePrefix() {
        return macros.GetPrefix(this.GetName())
    }


    /*
     * Gets the postfix of the entity name.
     *
     * @returns {string} - The postfix of the entity name.
    */
    function GetNamePostfix() {
        return macros.GetPostfix(this.GetName())
    }

    /*
     * Retrieves the partner instance of the entity, prioritizing the actual partner entity if available, and falling back to user-stored partner data if necessary.
     *
     * @returns {Entity|null} - The partner entity, or null if no partner is found.
     * 
     * This method first attempts to retrieve the actual partner entity using the `GetPartnerInstance` method of the underlying CBaseEntity.
     * If no partner entity is found, it then checks for a partner stored in the entity's user data under the key "partner". This can be useful in situations where the partner relationship is not directly established through entity properties but is managed through custom logic. 
    */
    function GetPartnerInstance() {
        if(this.CBaseEntity instanceof CLinkedPortalDoor)
            return entLib.FromEntity(this.CBaseEntity.GetPartnerInstance())
        return FindPartnerForPropPortal(this)
    }


    /*
     * Gets the oriented bounding box of the entity.
     *
     * @param {number} stat - 0 for min bounds, 7 for max bounds, 4 for center bounds. 
     * @returns {Vector} - The bounds vector.
    */
    function CreateAABB(stat) { 
        local angles = this.GetAngles()
        if(stat == 4) 
            angles = Vector(45, 45, 45)

        local cache = GetUserData("aabbCache")
        if(cache && (angles - cache[0]).Length() <= 10)
            return Vector(cache[1][stat], cache[2][stat], cache[3][stat]) // todo what about state 4?

        local all_vertex = this.getBBoxPoints()
        local x = array(8)
        local y = array(8)
        local z = array(8)

        foreach(idx, vec in all_vertex) {
            x[idx] = vec.x
            y[idx] = vec.y
            z[idx] = vec.z
        }

        x.sort(); y.sort(); z.sort()
 
        local result
        if(stat == 4) {// centered
            result = ( Vector(x[7], y[7], z[7]) - Vector(x[0], y[0], z[0]) ) * 0.5
        } 
        else {
            result = Vector(x[stat], y[stat], z[stat])
        }
        
        this.SetUserData("aabbCache", [angles, x, y, z])
        return result
    }

    /*
     * Gets the 8 vertices of the axis-aligned bounding box.
     *
     * @returns {Array<Vector>} - The 8 vertices of the bounding box.  
    */
    function getBBoxPoints() {
        local max = this.GetBoundingMaxs();
        local min = this.GetBoundingMins();
        local angles = this.GetAngles()
    
        local getVertex = macros.GetVertex
        return [ // todo cache it?
            getVertex(max, min, min, angles), // 0 - Right-Bottom-Front
            getVertex(max, max, min, angles), // 1 - Right-Top-Front
            getVertex(min, max, min, angles), // 2 - Left-Top-Front
            getVertex(min, min, min, angles)  // 3 - Left-Bottom-Front 
            getVertex(min, min, max, angles), // 4 - Left-Bottom-Back
            getVertex(min, max, max, angles), // 5 - Left-Top-Back
            getVertex(max, max, max, angles), // 6 - Right-Top-Back
            getVertex(max, min, max, angles), // 7 - Right-Bottom-Back
        ]
    }

    /*
     * Gets the faces of the entity's bounding box as an array of triangle vertices.
     *
     * @returns {array} - An array of 12 Vector triplets, where each triplet represents the three vertices of a triangle face.
    */
    function getBBoxFaces() {
        local vertices = this.getBBoxPoints()
        local getTriangle = macros.GetTriangle
        return [ // todo cache it?
            /* Bottom face triangles */ 
            getTriangle(vertices[0], vertices[3], vertices[4]), // Face 0: Right-Bottom-Front, Left-Bottom-Front, Left-Bottom-Back
            getTriangle(vertices[0], vertices[4], vertices[7]), // Face 1: Right-Bottom-Front, Left-Bottom-Back, Right-Bottom-Back

            /* Top face triangles */ 
            getTriangle(vertices[1], vertices[2], vertices[5]), // Face 2: Right-Top-Front, Left-Top-Front, Left-Top-Back
            getTriangle(vertices[1], vertices[5], vertices[6]), // Face 3: Right-Top-Front, Left-Top-Back, Right-Top-Back

            /* Left face triangles */ 
            getTriangle(vertices[3], vertices[2], vertices[5]), // Face 4: Left-Bottom-Front, Left-Top-Front, Left-Top-Back 
            getTriangle(vertices[3], vertices[5], vertices[4]), // Face 5: Left-Bottom-Front, Left-Top-Back, Left-Bottom-Back

            /* Right face triangles */ 
            getTriangle(vertices[0], vertices[1], vertices[6]), // Face 6: Right-Bottom-Front, Right-Top-Front, Right-Top-Back
            getTriangle(vertices[0], vertices[6], vertices[7]), // Face 7: Right-Bottom-Front, Right-Top-Back, Right-Bottom-Back

            /* Front face triangles */ 
            getTriangle(vertices[0], vertices[1], vertices[2]), // Face 8: Right-Bottom-Front, Right-Top-Front, Left-Top-Front 
            getTriangle(vertices[0], vertices[2], vertices[3]), // Face 9: Right-Bottom-Front, Left-Top-Front, Left-Bottom-Front

            /* Back face triangles */
            getTriangle(vertices[7], vertices[6], vertices[5]), // Face 10: Right-Bottom-Back, Right-Top-Back, Left-Top-Back 
            getTriangle(vertices[7], vertices[5], vertices[4])  // Face 11: Right-Bottom-Back, Left-Top-Back, Left-Bottom-Back 
        ]
    }

    /*
     * Checks if this entity is equal to another entity based on their entity indices.
     *
     * @param {pcapEntity} other - The other entity to compare.
     * @returns {boolean} - True if the entities are equal, false otherwise.
    */
    function isEqually(other) return this.entindex() == other.entindex()

    /*
     * Converts the entity object to a string.
     *
     * @returns {string} - The string representation of the entity.
    */
    function _tostring() return "pcapEntity: " + this.CBaseEntity + ""

    /*
     * Returns the type of the entity object.
     *
     * @returns {string} - The type of the entity object.
    */
    function _typeof() return "pcapEntity"
}

/*
 * Internal helper function to perform a recursive depth-first search for descendants.
 * This should not be called directly.
 *
 * @param {CBaseEntity} pCurrentParent - The entity to search for children of.
 * @param {List} resultList - The list to append found children to.
*/
::_findDescendantsRecursive <- function(pCurrentParent, resultList) {
    local child = pCurrentParent.FirstMoveChild();

    while (child) {
        resultList.append(entLib.FromEntity(child));
        _findDescendantsRecursive(child, resultList);
        child = child.NextMovePeer();
    }
}

function pcapEntity::ConnectOutput(output, funcName) this.CBaseEntity.ConnectOutput(output, funcName)
function pcapEntity::DisconnectOutput(output, funcName) this.CBaseEntity.DisconnectOutput(output, funcName)
function pcapEntity::PrecacheSoundScript(sound_name) this.CBaseEntity.PrecacheSoundScript(sound_name)
function pcapEntity::IsSequenceFinished() return this.CBaseEntity.IsSequenceFinished()
function pcapEntity::SpawnEntity() this.CBaseEntity.SpawnEntity()

function pcapEntity::GetAngles() return this.CBaseEntity.GetAngles()
function pcapEntity::GetAngularVelocity() return this.CBaseEntity.GetAngularVelocity()
function pcapEntity::GetBoundingMaxs() return this.CBaseEntity.GetBoundingMaxs()
function pcapEntity::GetBoundingMins() return this.CBaseEntity.GetBoundingMins()
function pcapEntity::GetCenter() return this.CBaseEntity.GetCenter()
function pcapEntity::GetClassname() return this.CBaseEntity.GetClassname()
function pcapEntity::GetForwardVector() return this.CBaseEntity.GetForwardVector()
function pcapEntity::GetHealth() return this.CBaseEntity.GetHealth()
function pcapEntity::GetLeftVector() return this.CBaseEntity.GetLeftVector()
function pcapEntity::GetMaxHealth() return this.CBaseEntity.GetMaxHealth()
function pcapEntity::GetModelKeyValues() return this.CBaseEntity.GetModelKeyValues()
function pcapEntity::GetModelName() return this.CBaseEntity.GetModelName()
function pcapEntity::GetName() return this.CBaseEntity.GetName()
function pcapEntity::GetOrigin() return this.CBaseEntity.GetOrigin()
function pcapEntity::GetScriptId() return this.CBaseEntity.GetScriptId()
function pcapEntity::GetUpVector() return this.CBaseEntity.GetUpVector()
function pcapEntity::GetPartnername() return this.CBaseEntity.GetPartnername()
function pcapEntity::ValidateScriptScope() return this.CBaseEntity.ValidateScriptScope()
function pcapEntity::GetScriptScope() return this.CBaseEntity.GetScriptScope()
function pcapEntity::entindex() return this.CBaseEntity.entindex()

function pcapEntity::SetAbsOrigin(vector) this.CBaseEntity.SetAbsOrigin(vector)
function pcapEntity::SetForwardVector(vector) this.CBaseEntity.SetForwardVector(vector)
function pcapEntity::SetHealth(health) this.CBaseEntity.SetHealth(health)
function pcapEntity::SetMaxHealth(health) this.CBaseEntity.SetMaxHealth(health)
function pcapEntity::SetModel(model_name) this.CBaseEntity.SetModel(model_name)
function pcapEntity::SetOrigin(vector) this.CBaseEntity.SetOrigin(vector)
function pcapEntity::SetVelocity(vector) this.CBaseEntity.SetVelocity(vector)