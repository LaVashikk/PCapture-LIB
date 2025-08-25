/*
 * A class for displaying on-screen text using the "game_text" entity.
*/
HUD["ScreenText"] <- class {
    // The underlying pcapEntity object representing the "game_text" entity. 
    CPcapEntity = null;
    holdtime = 0;
    
    /*
     * Constructor for a ScreenText object.
     *
     * @param {Vector} position - The position of the text on the screen. 
     * @param {string} message - The text message to display. 
     * @param {number} holdtime - The duration in seconds to display the text. (optional, default=10)
     * @param {string} targetname - The targetname of the "game_text" entity. (optional) 
    */
    constructor(position, message, holdtime = 10, targetname = "") {
        if (typeof position != "Vector")                                throw("HUD.ScreenText: 'position' must be a Vector, but got " + typeof position);
        if (typeof message != "string")                                 throw("HUD.ScreenText: 'message' must be a string, but got " + typeof message);
        if (typeof holdtime != "integer" && typeof holdtime != "float")  throw("HUD.ScreenText: 'holdtime' must be a number, but got " + typeof holdtime);
    
        this.holdtime = holdtime
        this.CPcapEntity = entLib.CreateByClassname("game_text", {
            // Set initial properties for the text display entity
            channel = 2,
            color = "170 170 170",
            color2 = "0 0 0",
            effect = 0,
            fadein = 0,
            fadeout = 0,
            fxtime = 0,
            holdtime = holdtime,
            x = position.x,
            y = position.y,
            spawnflags = 0,
            message = message,
            targetname = targetname
        })
    }

    // Displays the on-screen text. 
    function Enable() null
    // Hides the on-screen text. 
    function Disable() null
    // Updates and redisplays the on-screen text. 
    function Update() null

    //* Something like builders methods
    // Changes the message of the text display 
    function SetText(message) null 
    // Sets the channel of the text display.  
    function SetChannel(value) null
    // Sets the primary color of the text display as a string.  
    function SetColor(string_color) null
    // Sets the secondary color of the text display as a string.  
    function SetColor2(string_color) null
    // Sets the effect of the text display.  
    function SetEffect(value) null
    // Sets the fade-in time of the text display. 
    function SetFadeIn(value) null
    // Sets the fade-out time of the text display. 
    function SetFadeOut(value) null
    // Sets the hold time (duration) of the text display.  
    function SetHoldTime(time) null
    // Sets the position of the text display.  
    function SetPos(Vector) null
}


/*
 * Displays the on-screen text. 
*/
function HUD::ScreenText::Enable(holdtime = null) {
    this.CPcapEntity.SetKeyValue("holdtime", holdtime ? holdtime : this.holdtime)
    EntFireByHandle(this.CPcapEntity, "Display")
    return this
}

/*
 * Hides the on-screen text. 
*/
function HUD::ScreenText::Disable() {
    this.CPcapEntity.SetKeyValue("holdtime", 0.01)
    EntFireByHandle(this.CPcapEntity, "Display")
}

/*
 * Updates and redisplays the on-screen text. 
*/
function HUD::ScreenText::Update() {
    this.Enable()
}

/*
 * Changes the message of the text display and redisplays it.
 * 
 * @param {string} message - The new text message to display. 
*/
function HUD::ScreenText::SetText(message) {
    this.CPcapEntity.SetKeyValue("message", message)
    return this
}

/*
 * Sets the channel of the text display. 
 *
 * @param {number} channel - The channel to set.
*/
function HUD::ScreenText::SetChannel(channel) {
    this.CPcapEntity.SetKeyValue("channel", channel)
    return this
}

/*
 * Sets the primary color of the text display as a string. 
 *
 * @param {string} color - The color string, e.g., "255 0 0". 
*/
function HUD::ScreenText::SetColor(color) {
    this.CPcapEntity.SetKeyValue("color", color)
    return this
}

/*
 * Sets the secondary color of the text display as a string. 
 *
 * @param {string} color - The color string, e.g., "255 0 0". 
*/
function HUD::ScreenText::SetColor2(color) {
    this.CPcapEntity.SetKeyValue("color2", color)
    return this
}

/* 
 * Sets the effect of the text display. 
 *
 * @param {number} index - The index of the effect to set. 
*/
function HUD::ScreenText::SetEffect(idx) {
    this.CPcapEntity.SetKeyValue("effect", idx)
    return this
}

/*
 * Sets the fade-in time of the text display.
 *
 * @param {number} value - The fade-in time in seconds.  
*/ 
function HUD::ScreenText::SetFadeIn(value) {
    this.CPcapEntity.SetKeyValue("fadein", value)
    return this
}

/*
 * Sets the fade-out time of the text display.
 *
 * @param {number} value - The fade-out time in seconds.  
*/ 
function HUD::ScreenText::SetFadeOut(value) {
    this.CPcapEntity.SetKeyValue("fadeout", value)
    return this
}

/*
 * Sets the hold time (duration) of the text display. 
 *
 * @param {number} time - The hold time in seconds.  
*/
function HUD::ScreenText::SetHoldTime(time) {
    this.holdtime = time
    this.CPcapEntity.SetKeyValue("holdtime", time)
    return this
}

/*
 * Sets the position of the text display. 
 *
 * @param {Vector} position - The new position of the text. 
*/
function HUD::ScreenText::SetPos(position) {
    this.CPcapEntity.SetKeyValue("x", position.x)
    this.CPcapEntity.SetKeyValue("y", position.y)
    return this
}