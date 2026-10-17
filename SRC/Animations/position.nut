::__positionValueCalculator <- function(step, steps, v) {return v.startPos + v.dist * v.easeFunc(step / steps)}
::__positionPropertySetter <- function(ent, newPosition) {ent.CBaseEntity.SetAbsOrigin(newPosition)}

/*
 * Creates an animation that transitions the position of entities over time.
 *
 * @param {string|array|ArrayEx|List|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {Vector} startPos - The starting position. 
 * @param {Vector} endPos - The ending position. 
 * @param {number} time - The duration of the animation in seconds. 
 * @param {table} animSetting - A table containing additional animation settings. (optional) 
 * @returns {number} - The duration of the animation in seconds.
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
        __positionValueCalculator,
        __positionPropertySetter,
        vars
    )
    
    return animSetting.delay
}

/*
 * Real-time version of `animate.PositionTransitionByTime`: frames are computed as the animation plays,
 * and `filterCallback` in `animSetting` can stop it. The parameters and return value are the same.
*/
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
        __positionValueCalculator,
        __positionPropertySetter,
        vars
    )

    return animSetting.delay
}


/*
 * Creates an animation that transitions the position of entities over time based on a specified speed.
 * The number of frames is the distance divided by `speed`, rounded up; each frame lasts `frameInterval`.
 *
 * @param {string|array|ArrayEx|List|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {Vector} startPos - The starting position.
 * @param {Vector} endPos - The ending position.
 * @param {number} speed - The speed in units per frame (per `frameInterval`, FrameTime() by default). Must be greater than 0.
 * @param {table} animSetting - A table containing additional animation settings. (optional)
 * @returns {number} - The duration of the animation in seconds.
*/
animate["PositionTransitionBySpeed"] <- function(entities, startPos, endPos, speed, animSetting = {}) {
    if (typeof startPos != "Vector")                        throw("PositionTransitionBySpeed: 'startPos' argument must be a Vector, but got " + typeof startPos);
    if (typeof endPos != "Vector")                          throw("PositionTransitionBySpeed: 'endPos' argument must be a Vector, but got " + typeof endPos);
    if (typeof speed != "integer" && typeof speed != "float")  throw("PositionTransitionBySpeed: 'speed' argument must be a number, but got " + typeof speed);
    if (typeof animSetting != "table")                      throw("PositionTransitionBySpeed: 'animSetting' argument must be a table, but got " + typeof animSetting);
    if (speed <= 0) throw("PositionTransitionBySpeed: 'speed' must be greater than 0, but got " + speed)

    local animSetting = AnimEvent("position", animSetting, entities)
    local vars = {
        startPos = startPos,
        dist = endPos - startPos,
        easeFunc = animSetting.easeFunc
    }
    
    animate.applyAnimation(
        animSetting, 
        __positionValueCalculator,
        __positionPropertySetter,
        vars,
        vars.dist.Length() / speed.tofloat() // steps
    )
    
    return animSetting.delay
} 

/*
 * Real-time version of `animate.PositionTransitionBySpeed`: frames are computed as the animation plays,
 * and `filterCallback` in `animSetting` can stop it. The parameters and return value are the same.
*/
animate.RT["PositionTransitionBySpeed"] <- function(entities, startPos, endPos, speed, animSetting = {}) {
    if (typeof startPos != "Vector")                        throw("PositionTransitionBySpeed: 'startPos' argument must be a Vector, but got " + typeof startPos);
    if (typeof endPos != "Vector")                          throw("PositionTransitionBySpeed: 'endPos' argument must be a Vector, but got " + typeof endPos);
    if (typeof speed != "integer" && typeof speed != "float")  throw("PositionTransitionBySpeed: 'speed' argument must be a number, but got " + typeof speed);
    if (typeof animSetting != "table")                      throw("PositionTransitionBySpeed: 'animSetting' argument must be a table, but got " + typeof animSetting);
    if (speed <= 0) throw("PositionTransitionBySpeed: 'speed' must be greater than 0, but got " + speed)

    local animSetting = AnimEvent("position", animSetting, entities)
    local vars = {
        startPos = startPos,
        dist = endPos - startPos,
        easeFunc = animSetting.easeFunc
    }
    
    animate.applyRTAnimation(
        animSetting, 
        __positionValueCalculator,
        __positionPropertySetter,
        vars,
        vars.dist.Length() / speed.tofloat() // steps
    )
    
    return animSetting.delay
} 