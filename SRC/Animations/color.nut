/*
 * Creates an animation that transitions the color of entities over time.
 *
 * @param {array|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {string|Vector} startColor - The starting color as a string (e.g., "255 0 0") or a Vector. 
 * @param {string|Vector} endColor - The ending color as a string or a Vector. 
 * @param {number} time - The duration of the animation in seconds. 
 * @param {table} animSetting - A table containing additional animation settings. (optional) 
 * @returns {number} The duration of the animation in seconds. 
*/
animate["ColorTransition"] <- function(entities, startColor, endColor, time, animSetting = {}) {
    if (typeof startColor != "Vector" && typeof endColor != "string")   throw("ColorTransition: 'startColor' argument must be a Vector, but got " + typeof startColor);
    if (typeof endColor != "Vector"   && typeof endColor != "string")   throw("ColorTransition: 'endColor' argument must be a Vector, but got " + typeof endColor);
    if (typeof time != "integer" && typeof time != "float")             throw("ColorTransition: 'time' argument must be a number, but got " + typeof time);
    if (typeof animSetting != "table")                                  throw("ColorTransition: 'animSetting' argument must be a table, but got " + typeof animSetting);

    local animSetting = AnimEvent("color", animSetting, entities, time)
    local vars = {
        startColor = startColor,
        endColor = endColor,
        easeFunc = animSetting.easeFunc
    }

    animate.applyAnimation(
        animSetting, 
        function(step, transitionFrames, v) {return math.lerp.color(v.startColor, v.endColor, v.easeFunc(step / transitionFrames))},
        function(ent, newColor) {ent.SetColor(newColor)},
        vars
    )
    
    return animSetting.delay
}

animate.RT["ColorTransition"] <- function(entities, startColor, endColor, time, animSetting = {}) {
    if (typeof startColor != "Vector" && typeof endColor != "string")   throw("ColorTransition: 'startColor' argument must be a Vector, but got " + typeof startColor);
    if (typeof endColor != "Vector"   && typeof endColor != "string")   throw("ColorTransition: 'endColor' argument must be a Vector, but got " + typeof endColor);
    if (typeof time != "integer" && typeof time != "float")             throw("ColorTransition: 'time' argument must be a number, but got " + typeof time);
    if (typeof animSetting != "table")                                  throw("ColorTransition: 'animSetting' argument must be a table, but got " + typeof animSetting);

    local animSetting = AnimEvent("color", animSetting, entities, time)
    local vars = {
        startColor = startColor,
        endColor = endColor,
        easeFunc = animSetting.easeFunc
    }

    animate.applyRTAnimation(
        animSetting, 
        function(step, transitionFrames, v) {return math.lerp.color(v.startColor, v.endColor, v.easeFunc(step / transitionFrames))},
        function(ent, newColor) {ent.SetColor(newColor)},
        vars
    )
    
    return animSetting.delay
}