/*
 * Creates an animation that transitions the angles of entities over time.
 *
 * @param {array|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {Vector} startAngles - The starting angles. 
 * @param {Vector} endAngles - The ending angles. 
 * @param {number} time - The duration of the animation in seconds. 
 * @param {table} animSetting - A table containing additional animation settings. (optional) 
 * @returns {number} The duration of the animation in seconds. 
*/
animate["AnglesTransitionByTime"] <- function(entities, startAngles, endAngles, time, animSetting = {}) {
    if (typeof startAngles != "Vector")                     throw("AnglesTransitionByTime: 'startAngles' argument must be a Vector, but got " + typeof startAngles);
    if (typeof endAngles != "Vector")                       throw("AnglesTransitionByTime: 'endAngles' argument must be a Vector, but got " + typeof endAngles);
    if (typeof time != "integer" && typeof time != "float")  throw("AnglesTransitionByTime: 'time' argument must be a number, but got " + typeof time);
    if (typeof animSetting != "table")                      throw("AnglesTransitionByTime: 'animSetting' argument must be a table, but got " + typeof animSetting);

    local animSetting = AnimEvent("angles", animSetting, entities, time)

    local deltaAngleX = ((((endAngles.x - startAngles.x) % 360) + 540) % 360) - 180;
    local deltaAngleY = ((((endAngles.y - startAngles.y) % 360) + 540) % 360) - 180;
    local deltaAngleZ = ((((endAngles.z - startAngles.z) % 360) + 540) % 360) - 180;
    
    local vars = {
        startAngles = startAngles,
        angleDelta = Vector(deltaAngleX, deltaAngleY, deltaAngleZ),
        easeFunc = animSetting.easeFunc
    }

    animate.applyAnimation(
        animSetting, 
        function(step, steps, v){return v.startAngles + v.angleDelta * v.easeFunc(step / steps)},
        function(ent, newAngle) {ent.SetAbsAngles(newAngle)},
        vars
    )
    
    return animSetting.delay
}

animate.RT["AnglesTransitionByTime"] <- function(entities, startAngles, endAngles, time, animSetting = {}) {
    if (typeof startAngles != "Vector")                     throw("AnglesTransitionByTime: 'startAngles' argument must be a Vector, but got " + typeof startAngles);
    if (typeof endAngles != "Vector")                       throw("AnglesTransitionByTime: 'endAngles' argument must be a Vector, but got " + typeof endAngles);
    if (typeof time != "integer" && typeof time != "float")  throw("AnglesTransitionByTime: 'time' argument must be a number, but got " + typeof time);
    if (typeof animSetting != "table")                      throw("AnglesTransitionByTime: 'animSetting' argument must be a table, but got " + typeof animSetting);

    local animSetting = AnimEvent("angles", animSetting, entities, time)

    local deltaAngleX = ((((endAngles.x - startAngles.x) % 360) + 540) % 360) - 180;
    local deltaAngleY = ((((endAngles.y - startAngles.y) % 360) + 540) % 360) - 180;
    local deltaAngleZ = ((((endAngles.z - startAngles.z) % 360) + 540) % 360) - 180;
    
    local vars = {
        startAngles = startAngles,
        angleDelta = Vector(deltaAngleX, deltaAngleY, deltaAngleZ),
        easeFunc = animSetting.easeFunc
    }

    animate.applyRTAnimation(
        animSetting, 
        function(step, steps, v){return v.startAngles + v.angleDelta * v.easeFunc(step / steps)},
        function(ent, newAngle) {ent.SetAbsAngles(newAngle)},
        vars
    )
    
    return animSetting.delay
}