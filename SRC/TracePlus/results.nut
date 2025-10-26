local results = TracePlus["Result"]

results["Cheap"] <- class {
    traceHandler = null;
    hitpos = null;

    surfaceNormal = null;
    portalEntryInfo = null;

    /*
     * Constructor for a CheapTraceResult object.
     *
     * @param {table} traceHandler - The trace handler object containing trace information.
     * @param {Vector} hitpos - The hit position of the trace.
    */
    constructor(traceHandler, hitpos) {
        this.traceHandler = traceHandler
        this.hitpos = hitpos
    }

    /*
     * Gets the start position of the trace.
     *
     * @returns {Vector} - The start position.
    */
    function GetStartPos() {
        return this.traceHandler.startpos
    }

    /*
     * Gets the end position of the trace.
     *
     * @returns {Vector} - The end position.
    */
    function GetEndPos() {
        return this.traceHandler.endpos
    }

    /*
     * Gets the hit position of the trace.
     *
     * @returns {Vector} - The hit position. 
    */
    function GetHitPos() {
        return this.hitpos
    }

    /*
     * Gets the fraction of the trace distance where the hit occurred.
     *
     * @returns {number} - The hit fraction.
    */
    function GetFraction() {
        return this.traceHandler.fraction
    }

    /*
     * Checks if the trace hit anything.
     *
     * @returns {boolean} - True if the trace hit something, false otherwise.
    */
    function DidHit() {
        return this.traceHandler.fraction != 1
    }

    /*
     * Gets the direction vector of the trace.
     *
     * @returns {Vector} - The direction vector.
    */
    function GetDir() {
        return (this.GetEndPos() - this.GetStartPos())
    }

    /*
     * Gets the portal entry information for the trace.
     * 
     * @returns {CheapTraceResult|null} - The portal entry information, or null if not available.
    */
    function GetPortalEntryInfo() {
        return this.portalEntryInfo
    }

    /*
     * Gets an array of all portal entry information for the trace, including nested portals.
     * 
     * @returns {List} - An array of CheapTraceResult objects representing portal entries.
    */
    function GetAggregatedPortalEntryInfo() {
        local list = List(this)
        for(local trace = this; trace = trace.portalEntryInfo;) {
            list.append(trace)
        }
        return list.reverse()
    }

    /*
     * Gets the impact normal of the surface hit by the trace.
     *
     * @returns {Vector} - The impact normal vector.
    */
    function GetImpactNormal() {
        // If the surface normal is already calculated, return it
        if(this.surfaceNormal)
            return this.surfaceNormal
        
        this.surfaceNormal = CalculateImpactNormal(this.traceHandler.startpos, this.hitpos)
        return this.surfaceNormal 
    } 

    function _typeof() return "TraceResult"
    function _tostring() {
        return "TraceResult | startpos: " + GetStartPos() + ", endpos: " + GetEndPos() + ", fraction: " + GetFraction() + ", hitpos: " + GetHitPos()
    }
}



// Don't forget, the class extension is broken in VScripts
// Valvo's, I hate u :<
results["Bbox"] <- class {
    traceHandler = null;
    hitpos = null;
    hitent = null;

    surfaceNormal = null;
    portalEntryInfo = null;

    /*
     * Constructor for a BboxTraceResult object.
     *
     * @param {table} traceHandler - The trace handler object containing trace information.
     * @param {Vector} hitpos - The hit position of the trace.
     * @param {CBaseEntity} hitent - The entity hit by the trace.
    */
    constructor(traceHandler, hitpos, hitent) {
        this.traceHandler = traceHandler
        this.hitpos = hitpos
        this.hitent = hitent
    }

    /*
     * Gets the start position of the trace.
     *
     * @returns {Vector} - The start position.
    */
    function GetStartPos() {
        return this.traceHandler.startpos
    }

    /*
     * Gets the end position of the trace.
     *
     * @returns {Vector} - The end position.
    */
    function GetEndPos() {
        return this.traceHandler.endpos
    }

    /*
     * Gets the hit position of the trace.
     *
     * @returns {Vector} - The hit position. 
    */
    function GetHitPos() {
        return this.hitpos
    }

    /*
     * Gets the entity hit by the trace.
     *
     * @returns {pcapEntity|null} - The hit entity, or null if no entity was hit.
    */
    function GetEntity() {
        if(this.hitent && this.hitent.IsValid())
            return entLib.FromEntity(this.hitent)
    }

    /*
     * Gets the classname of the entity hit by the trace.
     *
     * @returns {string|null} - The classname of the hit entity, or null if no entity was hit.
    */
    function GetEntityClassname() {
        return (this.hitent && this.hitent.IsValid()) ? this.hitent.GetClassname() : null 
    }

    /*
     * Gets the list of entities that were ignored during the trace. 
     *
     * @returns {array|CBaseEntity|null} - The list of ignored entities, or null if no entities were ignored.
    */
    function GetIngoreEntities() {
        return this.traceHandler.ignoreEntities
    }

    /*
     * Gets the settings used for the trace.
     *
     * @returns {TraceSettings} - The trace settings object. 
    */
    function GetTraceSettings() {
        return this.traceHandler.settings
    }

    /*
     * Gets the note associated with the trace.
     *
     * @returns {string|null} - The trace note, or null if no note was provided.
    */
    function GetNote() {
        return this.traceHandler.note
    }

    /*
     * Checks if the trace hit anything.
     *
     * @returns {boolean} - True if the trace hit something, false otherwise.
    */
    function DidHit() {
        return this.GetFraction() != 1
    }

    /*
     * Checks if the trace hit the world geometry (not an entity). 
     *
     * @returns {boolean} - True if the trace hit the world, false otherwise.
    */
    function DidHitWorld() {
        return !this.hitent && DidHit()
    }

    /*
     * Gets the fraction of the trace distance where the hit occurred.
     *
     * @returns {number} - The hit fraction. 
    */
    function GetFraction() {
        return macros.GetDist(this.traceHandler.startpos, this.hitpos) / macros.GetDist(this.traceHandler.startpos, this.traceHandler.endpos)
    }

    /*
     * Gets the direction vector of the trace.
     *
     * @returns {Vector} - The direction vector.
    */
    function GetDir() {
        return (this.GetEndPos() - this.GetStartPos())
    }

    /*
     * Gets the portal entry information for the trace. 
     * 
     * @returns {BboxTraceResult|null} - The portal entry information, or null if not available.
    */
    function GetPortalEntryInfo() {
        return this.portalEntryInfo
    }

    /*
     * Gets an array of all portal entry information for the trace, including nested portals.
     * 
     * @returns {List} - An array of BboxTraceResult objects representing portal entries.
    */
    function GetAggregatedPortalEntryInfo() {
        local list = List(this)
        for(local trace = this; trace = trace.portalEntryInfo;) {
            list.append(trace)
        }
        return list.reverse()
    }

    /*
     * Gets the impact normal of the surface hit by the trace.
     *
     * @returns {Vector} - The impact normal vector.
    */
    function GetImpactNormal() {
        // If the surface normal is already calculated, return it
        if(this.surfaceNormal)
            return this.surfaceNormal

        local hitEnt = this.GetEntity()
        if(hitEnt) {
            this.surfaceNormal = CalculateImpactNormalFromBbox(this.GetStartPos(), this.hitpos, hitEnt)
        } else {
            this.surfaceNormal = CalculateImpactNormal(this.GetStartPos(), this.hitpos)
        }

        return this.surfaceNormal
    } 

    function _typeof() return "BboxTraceResult"
    function _tostring() {
        return "TraceResult | startpos: " + GetStartPos() + ", endpos: " + GetEndPos() + ", hitpos: " + GetHitPos() + ", entity: " + GetEntity()
    }
}