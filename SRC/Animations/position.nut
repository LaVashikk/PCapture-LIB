/*
 * Creates an animation that transitions the position of entities over time.
 *
 * @param {array|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {Vector} startPos - The starting position. 
 * @param {Vector} endPos - The ending position. 
 * @param {number} time - The duration of the animation in seconds. 
 * @param {table} animSetting - A table containing additional animation settings. (optional) 
 * @returns {number} The duration of the animation in seconds. 
*/
animate["PositionTransitionByTime"] <- function(entities, startPos, endPos, time, animSetting = {}) {
    if (typeof startPos != "Vector")                        throw("PositionTransitionByTime: 'startPos' argument must be a Vector, but got " + typeof startPos);
    if (typeof endPos != "Vector")                          throw("PositionTransitionByTime: 'endPos' argument must be a Vector, but got " + typeof endPos);
    if (typeof time != "integer" && typeof time != "float")  throw("PositionTransitionByTime: 'time' argument must be a number, but got " + typeof time);
    if (typeof animSetting != "table")                      throw("PositionTransitionByTime: 'animSetting' argument must be a table, but got " + typeof animSetting);

    local animSetting = AnimEvent("position", animSetting, entities, time)
    local vars = {
        startPos = startPos,
        dist = endPos - startPos,
        easeFunc = animSetting.easeFunc
    }

    animate.applyAnimation(
        animSetting, 
        function(step, steps, v) {return v.startPos + v.dist * v.easeFunc(step / steps)},
        function(ent, newPosition) {ent.SetAbsOrigin(newPosition)},
        vars
    )
    
    return animSetting.delay
}

animate.RT["PositionTransitionByTime"] <- function(entities, startPos, endPos, time, animSetting = {}) {
    if (typeof startPos != "Vector")                        throw("PositionTransitionByTime: 'startPos' argument must be a Vector, but got " + typeof startPos);
    if (typeof endPos != "Vector")                          throw("PositionTransitionByTime: 'endPos' argument must be a Vector, but got " + typeof endPos);
    if (typeof time != "integer" && typeof time != "float")  throw("PositionTransitionByTime: 'time' argument must be a number, but got " + typeof time);
    if (typeof animSetting != "table")                      throw("PositionTransitionByTime: 'animSetting' argument must be a table, but got " + typeof animSetting);

    local animSetting = AnimEvent("position", animSetting, entities, time)
    local vars = {
        startPos = startPos,
        dist = endPos - startPos,
        easeFunc = animSetting.easeFunc
    }

    animate.applyRTAnimation(
        animSetting, 
        function(step, steps, v) {return v.startPos + v.dist * v.easeFunc(step / steps)},
        function(ent, newPosition) {ent.SetAbsOrigin(newPosition)},
        vars
    )
    
    return animSetting.delay
}


/*
 * Creates an animation that transitions the position of entities over time based on a specified speed. 
 *
 * @param {array|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {Vector} startPos - The starting position.
 * @param {Vector} endPos - The ending position.
 * @param {number} speed - The speed of the animation in units per tick.
 * @param {table} animSetting - A table containing additional animation settings. (optional)
 * 
 * The animation will calculate the time it takes to travel from the start position to the end position based on the specified speed. 
 * It will then use this time to create a smooth transition of the entities' positions over that duration.
 * @returns {number} The duration of the animation in seconds. 
*/
animate["PositionTransitionBySpeed"] <- function(entities, startPos, endPos, speed, animSetting = {}) {
    if (typeof startPos != "Vector")                        throw("PositionTransitionBySpeed: 'startPos' argument must be a Vector, but got " + typeof startPos);
    if (typeof endPos != "Vector")                          throw("PositionTransitionBySpeed: 'endPos' argument must be a Vector, but got " + typeof endPos);
    if (typeof speed != "integer" && typeof speed != "float")  throw("PositionTransitionBySpeed: 'speed' argument must be a number, but got " + typeof speed);
    if (typeof animSetting != "table")                      throw("PositionTransitionBySpeed: 'animSetting' argument must be a table, but got " + typeof animSetting);

    local animSetting = AnimEvent("position", animSetting, entities)
    local vars = {
        startPos = startPos,
        dist = endPos - startPos,
        easeFunc = animSetting.easeFunc
    }
    
    animate.applyAnimation(
        animSetting, 
        function(step, steps, v) {return v.startPos + v.dist * v.easeFunc(step / steps)},
        function(ent, newPosition) {ent.SetAbsOrigin(newPosition)},
        vars,
        vars.dist.Length() / speed.tofloat() // steps
    )
    
    return animSetting.delay
} 

animate.RT["PositionTransitionBySpeed"] <- function(entities, startPos, endPos, speed, animSetting = {}) {
    if (typeof startPos != "Vector")                        throw("PositionTransitionBySpeed: 'startPos' argument must be a Vector, but got " + typeof startPos);
    if (typeof endPos != "Vector")                          throw("PositionTransitionBySpeed: 'endPos' argument must be a Vector, but got " + typeof endPos);
    if (typeof speed != "integer" && typeof speed != "float")  throw("PositionTransitionBySpeed: 'speed' argument must be a number, but got " + typeof speed);
    if (typeof animSetting != "table")                      throw("PositionTransitionBySpeed: 'animSetting' argument must be a table, but got " + typeof animSetting);

    local animSetting = AnimEvent("position", animSetting, entities)
    local vars = {
        startPos = startPos,
        dist = endPos - startPos,
        easeFunc = animSetting.easeFunc
    }
    
    animate.applyRTAnimation(
        animSetting, 
        function(step, steps, v) {return v.startPos + v.dist * v.easeFunc(step / steps)},
        function(ent, newPosition) {ent.SetAbsOrigin(newPosition)},
        vars,
        vars.dist.Length() / speed.tofloat() // steps
    )
    
    return animSetting.delay
} 