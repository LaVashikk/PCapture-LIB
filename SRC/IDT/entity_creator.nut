::entLib <- class {
    /*
     * Creates an entity of the specified classname with the provided keyvalues.
     *
     * @param {string} classname - The classname of the entity.
     * @param {table} keyvalues - The key-value pairs for the entity.
     * @returns {pcapEntity} - The created entity object.
    */
    function CreateByClassname(classname, keyvalues = {}) {
        local new_entity = entLib.FromEntity(Entities.CreateByClassname(classname))
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
        local new_entity = entLib.FromEntity(::CreateProp(classname, origin, modelname, activity))
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
        if(typeof CBaseEntity == "pcapEntity")
            return CBaseEntity
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
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
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
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
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
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
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
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
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
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
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
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
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
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindInSphere(start_ent, origin, radius)
        return entLib.__init(new_entity)
    }



    /* 
     * Initializes an entity object.
     *
     * @param {CBaseEntity} entity - The entity object.
     * @returns {pcapEntity} - A new entity object.
    */
    function __init(CBaseEntity) {
        if(!CBaseEntity || !CBaseEntity.IsValid())
            return null

        if(CBaseEntity in pcapEntityCache) {
            return pcapEntityCache[CBaseEntity]
        } else {
            local pcapEnt = pcapEntity(CBaseEntity)
            pcapEntityCache[CBaseEntity] <- pcapEnt
            return pcapEnt
        }
    }
}