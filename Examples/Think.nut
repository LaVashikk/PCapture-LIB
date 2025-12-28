// Initialize the PCapture-Lib library.
DoIncludeScript("PCapture-Lib/SRC/PCapture-Lib", getroottable())

/*
 * This example demonstrates how to create a "Think" loop using the ScheduleEvent system.
 */

class RotatingCube {
    entity = null;
    speed = 0;

    constructor(origin, rotationSpeed) {
        this.entity = entLib.CreateProp("prop_physics_override", origin, "models/props/switch001.mdl");
        
        // Disable motion so it stays in the air while rotating.
        this.entity.SetKeyValue("motiondisabled", 1)
        
        this.speed = rotationSpeed;

        // Start the think loop immediately.
        ScheduleEvent.AddInterval("global", this.Think, FrameTime(), 0, null, this)
    }

    // The core logic function that runs periodically.
    function Think() {
        // If the entity is invalid (e.g., destroyed/killed), stop the loop to prevent errors.
        if (!this.entity || !this.entity.IsValid()) return;

        // Calculate new angles based on the current frame time to ensure smooth rotation.
        local angles = this.entity.GetAngles();
        local newYaw = angles.y + (this.speed * FrameTime());
        
        // Apply the new rotation (Pitch, Yaw, Roll).
        this.entity.SetAngles(angles.x, newYaw, angles.z);
    }
}

// --- TESTING ---
// Spawn the cube 150 units in front of the player's eyes.
local player = GetPlayerEx();
if (player) {
    local spawnPos = macros.GetEyeEndpos(player, 150);
    // Create the cube instance, which starts its own loop.
    RotatingCube(spawnPos, 90.0); // Rotate at 90 degrees per second.
    printl("Created RotatingCube at " + spawnPos);
}
