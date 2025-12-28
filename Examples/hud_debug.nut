// Initialize the PCapture-Lib library.
DoIncludeScript("PCapture-Lib/SRC/PCapture-Lib", getroottable())

/*
 * This example demonstrates:
 * 1. The HUD module for creating persistent on-screen text.
 * 2. The 'dev' module for debug visualization (drawing boxes).
 * 3. A class-based update loop.
 */

class HudDebugDemo {
    textElement = null
    timer = 0.0

    constructor() {
        // Create a persistent screen text element using the HUD module.
        // Positioned at x=0.05, y=0.1 (Top-Left area).
        // Holdtime is set high (9999) because we will manually update/refresh it.
        this.textElement = HUD.ScreenText(Vector(0.05, 0.1, 0), "", 9999)
        this.textElement.SetColor("100 255 100") // Light Green
        this.textElement.SetChannel(1)
        this.textElement.Enable()

        // Start the update loop.
        this.Update()
    }

    function Update() {
        this.timer += 0.1

        // 1. Update HUD Text with dynamic data.
        local player = GetPlayerEx()
        local pos = player ? player.GetOrigin() : Vector(0,0,0)
        
        // Build the status string.
        local info = "Time Running: " + math.round(this.timer, 10) + "s\n"
        info += "Player Pos: " + macros.VecToStr(pos) + "\n"
        info += "FrameTime: " + FrameTime()

        // Update the text content and refresh the display.
        this.textElement.SetText(info).Update()

        // 2. Debug Visualization.
        // Find the nearest cube within 300 units of the player.
        if (player) {
            local nearestProp = entLib.FindByClassnameWithin("prop_weighted_cube", player.GetOrigin(), 300)
            if (nearestProp) {
                // Draw a blue bounding box around the prop for 0.11 seconds.
                // (Slightly longer than the update rate to prevent flickering).
                dev.DrawEntityBBox(nearestProp, Vector(0, 100, 255), 0.11)
                
                // Draw a red line from the player's eyes to the prop's center.
                DebugDrawLine(player.EyePosition(), nearestProp.GetCenter(), 255, 0, 0, true, 0.11)
            }
        }

        // Schedule the next update in 0.1 seconds.
        ScheduleEvent.Add("global", this.Update, 0.1, null, this)
    }
}

// Instantiate the demo
HudDebugDemo()
