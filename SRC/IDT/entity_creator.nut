::entLib <- class {
    /*
     * Creates an entity of the specified classname with the provided keyvalues.
     *
     * @param {string} classname - The classname of the entity.
     * @param {table} keyvalues - The key-value pairs for the entity.
     * @returns {pcapEntity} - The created entity object.
    */
    function CreateByClassname(classname, keyvalues = {}) {
        // Validate parameters
        if (typeof classname != "string")
            throw("CreateByClassname: 'classname' must be a string, got " + typeof classname)
        if (classname == "")
            throw("CreateByClassname: 'classname' cannot be an empty string")
        if (typeof keyvalues != "table")
            throw("CreateByClassname: 'keyvalues' must be a table, got " + typeof keyvalues)

        local new_entity = entLib.FromEntity(Entities.CreateByClassname(classname))
        if (!new_entity)
            throw("CreateByClassname: Failed to create entity with classname '" + classname + "'")

        foreach(key, value in keyvalues) {
            new_entity.SetKeyValue(key, value)
        }

        pcapEntityCache[new_entity.CBaseEntity] <- new_entity

        return new_entity
    }


    /*
     * Creates a prop entity with the specified parameters.
     * 
     * @param {string} classname - The classname of the prop.
     * @param {Vector} origin - The initial origin (position) of the prop.
     * @param {string} modelname - The model name of the prop.
     * @param {number} activity - The initial activity of the prop. (optional, default=1)
     * @param {table} keyvalues - Additional key-value pairs for the prop. (optional)
     * @returns {pcapEntity} - The created prop entity object.
    */
    function CreateProp(classname, origin, modelname, activity = 1, keyvalues = {}) {
        // Validate parameters
        if (typeof classname != "string")
            throw("CreateProp: 'classname' must be a string, got " + typeof classname)
        if (classname == "")
            throw("CreateProp: 'classname' cannot be an empty string")
        if (typeof origin != "Vector")
            throw("CreateProp: 'origin' must be a Vector, got " + typeof origin)
        if (typeof modelname != "string")
            throw("CreateProp: 'modelname' must be a string, got " + typeof modelname)
        if (modelname == "")
            throw("CreateProp: 'modelname' cannot be an empty string")
        if (typeof activity != "integer" && typeof activity != "float")
            throw("CreateProp: 'activity' must be a number, got " + typeof activity)
        if (typeof keyvalues != "table")
            throw("CreateProp: 'keyvalues' must be a table, got " + typeof keyvalues)

        local new_entity = entLib.FromEntity(::CreateProp(classname, origin, modelname, activity))
        if (!new_entity)
            throw("CreateProp: Failed to create prop with classname '" + classname + "' and model '" + modelname + "'")

        foreach(key, value in keyvalues) {
            new_entity.SetKeyValue(key, value)
        }
        
        pcapEntityCache[new_entity.CBaseEntity] <- new_entity

        return new_entity
    }
    

    /*
     * Wraps a CBaseEntity object in a pcapEntity object.
     *
     * @param {CBaseEntity} CBaseEntity - The CBaseEntity object to wrap.
     * @returns {pcapEntity} - The wrapped entity object.
    */
    function FromEntity(CBaseEntity) {
        if (CBaseEntity == null)
            return null
        if (typeof CBaseEntity == "pcapEntity")
            return CBaseEntity
        if (typeof CBaseEntity != "instance")
            throw("FromEntity: Expected CBaseEntity instance or pcapEntity, got " + typeof CBaseEntity)
        
        return entLib.__init(CBaseEntity)
    }

    
    /*
     * Finds an entity with the specified classname.
     *
     * @param {string} classname - The classname to search for.
     * @param {CBaseEntity|pcapEntity} start_ent - The starting entity to search within. (optional)
     * @returns {pcapEntity|null} - The found entity object, or null if not found.
    */
    function FindByClassname(classname, start_ent = null) {
        // Validate parameters
        if (typeof classname != "string")
            throw("FindByClassname: 'classname' must be a string, got " + typeof classname)
        if (classname == "")
            throw("FindByClassname: 'classname' cannot be an empty string")
        
        if (start_ent != null) {
            if (typeof start_ent == "pcapEntity")
                start_ent = start_ent.CBaseEntity
            else if (typeof start_ent != "instance")
                throw("FindByClassname: 'start_ent' must be a CBaseEntity or pcapEntity, got " + typeof start_ent)
        }

        local new_entity = Entities.FindByClassname(start_ent, classname)
        return entLib.__init(new_entity)
    }


    /*
     * Finds an entity with the specified classname within a given radius from the origin.
     *
     * @param {string} classname - The classname to search for.
     * @param {Vector} origin - The origin position.
     * @param {number} radius - The search radius.
     * @param {CBaseEntity|pcapEntity} start_ent - The starting entity to search within. (optional)
     * @returns {pcapEntity|null} - The found entity object, or null if not found.
    */
    function FindByClassnameWithin(classname, origin, radius, start_ent = null) {
        // Validate parameters
        if (typeof classname != "string")
            throw("FindByClassnameWithin: 'classname' must be a string, got " + typeof classname)
        if (classname == "")
            throw("FindByClassnameWithin: 'classname' cannot be an empty string")
        if (typeof origin != "Vector")
            throw("FindByClassnameWithin: 'origin' must be a Vector, got " + typeof origin)
        if (typeof radius != "integer" && typeof radius != "float")
            throw("FindByClassnameWithin: 'radius' must be a number, got " + typeof radius)
        if (radius <= 0)
            throw("FindByClassnameWithin: 'radius' must be greater than zero, got " + radius)
        
        if (start_ent != null) {
            if (typeof start_ent == "pcapEntity")
                start_ent = start_ent.CBaseEntity
            else if (typeof start_ent != "instance")
                throw("FindByClassnameWithin: 'start_ent' must be a CBaseEntity or pcapEntity, got " + typeof start_ent)
        }

        local new_entity = Entities.FindByClassnameWithin(start_ent, classname, origin, radius)
        return entLib.__init(new_entity)
    }
    
    
    /* 
     * Finds an entity with the specified targetname within the given starting entity.
     *
     * @param {string} targetname - The targetname to search for.
     * @param {CBaseEntity|pcapEntity} start_ent - The starting entity to search within. (optional)
     * @returns {pcapEntity|null} - The found entity object, or null if not found.
    */
    function FindByName(targetname, start_ent = null) {
        // Validate parameters
        if (typeof targetname != "string")
            throw("FindByName: 'targetname' must be a string, got " + typeof targetname)
        if (targetname == "")
            throw("FindByName: 'targetname' cannot be an empty string")
        
        if (start_ent != null) {
            if (typeof start_ent == "pcapEntity")
                start_ent = start_ent.CBaseEntity
            else if (typeof start_ent != "instance")
                throw("FindByName: 'start_ent' must be a CBaseEntity or pcapEntity, got " + typeof start_ent)
        }

        local new_entity = Entities.FindByName(start_ent, targetname)
        return entLib.__init(new_entity)
    }


    /*
     * Finds an entity with the specified targetname within a given radius from the origin.
     *
     * @param {string} targetname - The targetname to search for.
     * @param {Vector} origin - The origin position.
     * @param {number} radius - The search radius.
     * @param {CBaseEntity|pcapEntity} start_ent - The starting entity to search within. (optional)
     * @returns {pcapEntity|null} - The found entity object, or null if not found.
    */
    function FindByNameWithin(targetname, origin, radius, start_ent = null) {
        // Validate parameters
        if (typeof targetname != "string")
            throw("FindByNameWithin: 'targetname' must be a string, got " + typeof targetname)
        if (targetname == "")
            throw("FindByNameWithin: 'targetname' cannot be an empty string")
        if (typeof origin != "Vector")
            throw("FindByNameWithin: 'origin' must be a Vector, got " + typeof origin)
        if (typeof radius != "integer" && typeof radius != "float")
            throw("FindByNameWithin: 'radius' must be a number, got " + typeof radius)
        if (radius <= 0)
            throw("FindByNameWithin: 'radius' must be greater than zero, got " + radius)
        
        if (start_ent != null) {
            if (typeof start_ent == "pcapEntity")
                start_ent = start_ent.CBaseEntity
            else if (typeof start_ent != "instance")
                throw("FindByNameWithin: 'start_ent' must be a CBaseEntity or pcapEntity, got " + typeof start_ent)
        }

        local new_entity = Entities.FindByNameWithin(start_ent, targetname, origin, radius)
        return entLib.__init(new_entity)
    }


    /* 
     * Finds an entity with the specified model within the given starting entity.
     *
     * @param {string} model - The model to search for.
     * @param {CBaseEntity|pcapEntity} start_ent - The starting entity to search within. (optional)
     * @returns {pcapEntity|null} - The found entity object, or null if not found.
    */
    function FindByModel(model, start_ent = null) {
        // Validate parameters
        if (typeof model != "string")
            throw("FindByModel: 'model' must be a string, got " + typeof model)
        if (model == "")
            throw("FindByModel: 'model' cannot be an empty string")
        
        if (start_ent != null) {
            if (typeof start_ent == "pcapEntity")
                start_ent = start_ent.CBaseEntity
            else if (typeof start_ent != "instance")
                throw("FindByModel: 'start_ent' must be a CBaseEntity or pcapEntity, got " + typeof start_ent)
        }

        local new_entity = Entities.FindByModel(start_ent, model)
        return entLib.__init(new_entity)
    }


    /*
     * Finds an entity with the specified model within a given radius from the origin.
     *
     * @param {string} model - The model to search for.
     * @param {Vector} origin - The origin position.
     * @param {number} radius - The search radius.
     * @param {CBaseEntity|pcapEntity} start_ent - The starting entity to search within. (optional)
     * @returns {pcapEntity|null} - The found entity object, or null if not found.
    */
    function FindByModelWithin(model, origin, radius, start_ent = null) {
        // Validate parameters
        if (typeof model != "string")
            throw("FindByModelWithin: 'model' must be a string, got " + typeof model)
        if (model == "")
            throw("FindByModelWithin: 'model' cannot be an empty string")
        if (typeof origin != "Vector")
            throw("FindByModelWithin: 'origin' must be a Vector, got " + typeof origin)
        if (typeof radius != "integer" && typeof radius != "float")
            throw("FindByModelWithin: 'radius' must be a number, got " + typeof radius)
        if (radius <= 0)
            throw("FindByModelWithin: 'radius' must be greater than zero, got " + radius)
        
        if (start_ent != null) {
            if (typeof start_ent == "pcapEntity")
                start_ent = start_ent.CBaseEntity
            else if (typeof start_ent != "instance")
                throw("FindByModelWithin: 'start_ent' must be a CBaseEntity or pcapEntity, got " + typeof start_ent)
        }

        local new_entity = null
        for(local ent; ent = Entities.FindByClassnameWithin(ent, "*", origin, radius);) {
            if(ent.GetModelName() == model && ent != start_ent) {
                new_entity = ent;
                break;
            }
        }

        return entLib.__init(new_entity)
    }


    /*
     * Finds entities within a sphere defined by the origin and radius.
     *
     * @param {Vector} origin - The origin position of the sphere.
     * @param {number} radius - The radius of the sphere.
     * @param {CBaseEntity|pcapEntity} start_ent - The starting entity to search within. (optional)
     * @returns {pcapEntity|null} - The found entity object, or null if not found.
    */
    function FindInSphere(origin, radius, start_ent = null) {
        // Validate parameters
        if (typeof origin != "Vector")
            throw("FindInSphere: 'origin' must be a Vector, got " + typeof origin)
        if (typeof radius != "integer" && typeof radius != "float")
            throw("FindInSphere: 'radius' must be a number, got " + typeof radius)
        if (radius <= 0)
            throw("FindInSphere: 'radius' must be greater than zero, got " + radius)
        
        if (start_ent != null) {
            if (typeof start_ent == "pcapEntity")
                start_ent = start_ent.CBaseEntity
            else if (typeof start_ent != "instance")
                throw("FindInSphere: 'start_ent' must be a CBaseEntity or pcapEntity, got " + typeof start_ent)
        }

        local new_entity = Entities.FindInSphere(start_ent, origin, radius)
        return entLib.__init(new_entity)
    }


    /* 
     * Initializes an entity object.
     *
     * @param {CBaseEntity} entity - The entity object.
     * @returns {pcapEntity|null} - A new entity object or null if invalid.
    */
    function __init(CBaseEntity) {
        if (!CBaseEntity || !CBaseEntity.IsValid())
            return null

        if (CBaseEntity in pcapEntityCache) {
            return pcapEntityCache[CBaseEntity]
        } else {
            local pcapEnt = pcapEntity(CBaseEntity)
            pcapEntityCache[CBaseEntity] <- pcapEnt
            return pcapEnt
        }
    }
}