/*
 * A class for displaying hints using the "env_instructor_hint" entity. 
*/
HUD["HintInstructor"] <- class {
    // The underlying pcapEntity object representing the "env_instructor_hint" entity.  
    CPcapEntity = null;

    /*
     * Constructor for a HintInstructor object. 
     *
     * @param {string} message - The hint message to display.
     * @param {number} holdtime - The duration in seconds to display the hint. (optional, default=5) 
     * @param {string} icon - The icon to display with the hint. (optional, default="icon_tip") 
     * @param {number} showOnHud - Whether to display the hint on the HUD or at the target entity's position (1 for HUD, 0 for target entity). (optional, default=1) 
     * @param {string} targetname - The targetname of the "env_instructor_hint" entity. (optional, default="") 
    */
    constructor(message, holdtime = 5, icon = "icon_tip", showOnHud = 1, targetname = "") {
        if (typeof message != "string")                                 throw("HUD.HintInstructor: 'message' must be a string, but got " + typeof message);
        if (typeof holdtime != "integer" && typeof holdtime != "float")  throw("HUD.HintInstructor: 'holdtime' must be a number, but got " + typeof holdtime);
        if (typeof icon != "string")                                    throw("HUD.HintInstructor: 'icon' must be a string, but got " + typeof message);

        this.CPcapEntity = entLib.CreateByClassname("env_instructor_hint", {
            // The text of your hint. 100 character limit.
            hint_caption = message,
            // Either show at the position of the Target Entity, or show the hint directly on the HUD at a fixed position.
            hint_static = showOnHud,
            hint_allow_nodraw_target = showOnHud,
            // The color of the caption text.
            hint_color = "255, 255, 255",
            // The icon to use when the hint is within the player's view.
            hint_icon_onscreen = icon,
            hint_icon_offscreen = icon,
            // The automatic timeout for the hint. 0 will persist until stopped with EndHint.
            hint_timeout = holdtime,
            hint_forcecaption = 1,
            hint_nooffscreen = 0,
            hint_range = 0, 
            targetname = targetname
        })
    }

    // Displays the hint.  
    function Enable() null
    // Hides the hint. 
    function Disable() null
    // Updates and redisplays the hint.  
    function Update() null
    
    //* Something like builders methods
    // Changes the message of the hint. 
    function SetText(message) null 
    // Sets the bind to display with the hint icon.  
    function SetBind(bind) null
    // Sets the positioning of the hint (on HUD or at target entity).  
    function SetPositioning(value, ent) null
    // Sets the color of the hint text as a string. 
    function SetColor(string_color) null
    // Sets the icon to display when the hint is on-screen.  
    function SetIconOnScreen(icon) null
    // Sets the icon to display when the hint is off-screen.  
    function SetIconOffScreen(bind) null
    // Sets the hold time (duration) of the hint.  
    function SetHoldTime(time) null
    // Sets the distance at which the hint is visible.  
    function SetDistance(value) null
    // Sets the visual effects for the hint.  
    function SetEffects(sizePulsing, alphaPulsing, shaking) null
}

// Implementation of 'enable' to display the on-screen text
/*
 * Displays the hint. 
*/
function HUD::HintInstructor::Enable() {
    EntFireByHandle(this.CPcapEntity, "ShowHint")
}

// Implementation of 'disable' to hide the on-screen text
/*
 * Hides the hint. 
*/
function HUD::HintInstructor::Disable() {
    EntFireByHandle(this.CPcapEntity, "EndHint")
}

/*
 * Updates and redisplays the hint. 
*/
function HUD::HintInstructor::Update() {
    this.Enable()
}

/*
 * Changes the message of the hint and redisplays it. 
 * 
 * @param {string} message - The new hint message to display. 
*/
function HUD::HintInstructor::SetText(message) {
    this.CPcapEntity.SetKeyValue("hint_caption", message)
    return this
}
 
/* 
 * Sets the bind to display with the hint icon and updates the icon to "use_binding". 
 *
 * @param {string} bind - The bind name to display. 
*/
function HUD::HintInstructor::SetBind(bind) {
    this.CPcapEntity.SetKeyValue("hint_binding", bind)
    this.CPcapEntity.SetKeyValue("hint_icon_onscreen", "use_binding")
    return this
}

/*
 * Sets the positioning of the hint (on HUD or at target entity). 
 *
 * @param {number} value - 1 to display the hint on the HUD, 0 to display it at the target entity's position.
 * @param {CBaseEntity|pcapEntity|null} entity - The target entity to position the hint at (only used if value is 0). (optional) 
*/
function HUD::HintInstructor::SetPositioning(value, ent = null) { // showOnHud
    this.CPcapEntity.SetKeyValue("hint_static", value)
    this.CPcapEntity.SetKeyValue("hint_target", ent)
    return this
}

/* 
 * Sets the color of the hint text as a string. 
 *
 * @param {string} color - The color string, e.g., "255 0 0". 
*/
function HUD::HintInstructor::SetColor(color) {
    this.CPcapEntity.SetKeyValue("hint_color", color)
    return this
}

/* 
 * Sets the icon to display when the hint is on-screen. 
 *
 * @param {string} icon - The icon name to display. 
*/
function HUD::HintInstructor::SetIconOnScreen(icon) {
    this.CPcapEntity.SetKeyValue("hint_icon_onscreen", icon)
    return this
}

/* 
 * Sets the icon to display when the hint is off-screen. 
 *
 * @param {string} icon - The icon name to display. 
*/
function HUD::HintInstructor::SetIconOffScreen(icon) {
    this.CPcapEntity.SetKeyValue("hint_icon_offscreen", icon)
    return this
}   

/* 
 * Sets the hold time (duration) of the hint. 
 *
 * @param {number} time - The hold time in seconds. 
*/
function HUD::HintInstructor::SetHoldTime(time) {
    this.CPcapEntity.SetKeyValue("hint_timeout", time)
    return this
}

/*
 * Sets the distance at which the hint is visible.
 *
 * @param {number} distance - The distance in units.  
*/
function HUD::HintInstructor::SetDistance(value) {
    this.CPcapEntity.SetKeyValue("hint_range", value)
    return this
}

/*
 * Sets the visual effects for the hint. 
 *
 * @param {number} sizePulsing - The size pulsing option (0 for no pulsing, 1 for pulsing). 
 * @param {number} alphaPulsing - The alpha pulsing option (0 for no pulsing, 1 for pulsing).
 * @param {number} shaking - The shaking option (0 for no shaking, 1 for shaking).  
*/
function HUD::HintInstructor::SetEffects(sizePulsing, alphaPulsing, shaking) {
    this.CPcapEntity.SetKeyValue("hint_pulseoption", sizePulsing)
    this.CPcapEntity.SetKeyValue("hint_alphaoption", alphaPulsing)
    this.CPcapEntity.SetKeyValue("hint_shakeoption", shaking)
    return this
}