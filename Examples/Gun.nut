// Initialize the PCapture-Lib library. This must be done before any library functions are used.
DoIncludeScript("PCapture-Lib", getroottable())

// A simple weapon class demonstrating various PCapture-Lib features.
class Weapon {
    // A flag to prevent actions (like firing or reloading) from happening too quickly.
    locked = false;
    // Current ammo count.
    ammo = 10;
    // This will hold our HUD element to display ammo and status messages.
    game_text = null;
    // The entity (player) that owns this weapon.
    player = null;

    // The constructor is called when a new Weapon object is created.
    constructor(owner) {
        // Store the player who owns this weapon.
        this.player = owner
        // Create a ScreenText HUD element using the HUD module.
        // It's positioned at the bottom-center of the screen and will display for 1.1 seconds each time it's enabled.
        this.game_text = HUD.ScreenText(Vector(-1, -0.95, 0), "", 1.1)
        // Set up the input handling for firing and reloading.
        this.InitGameUi()
    }

    // This function sets up the system to capture player input (mouse clicks).
    function InitGameUi() {
        // Store a reference to this weapon instance ('this') to be used inside the function closures below.
        local weapon = this
        // Use entLib to create a 'game_ui' entity. This entity can capture player inputs.
        local gameui = entLib.CreateByClassname("game_ui", {FieldOfView = -1});
        
        // Use ConnectOutputEx to link the 'PressedAttack' output (left-click) to a VScript function.
        // The ':(weapon)' syntax use 'free-variable', capturing the 'weapon' variable so we can access it.
        gameui.ConnectOutputEx("PressedAttack", function() : (weapon) {
            weapon.OnPrimaryAction()
        })
        // Link 'PressedAttack2' (right-click) to the Reload function.
        gameui.ConnectOutputEx("PressedAttack2", function() : (weapon) {
            weapon.Reload()
        })
    
        // Activate the game_ui entity for the specific player, so it starts listening for their input.
        EntFireByHandle(gameui, "Activate", "", 0, this.player)
    }

    // A function to prevent the player from firing or reloading for a set amount of time.
    function LockInterface(delay) {
        // If already locked, do nothing.
        if(this.locked) return dev.warning("Already locked")
        // Lock the interface immediately.
        this.locked = true
    
        // Use the ActionScheduler to unlock the interface after the specified delay.
        ScheduleEvent.Add(
            "global", // A general-purpose event name.
            function() { // The action to execute when the timer finishes.
                this.locked = false 
            }, 
            delay, // The time in seconds to wait.
            null, // Optional arguments for the action function (none needed here).
            this // The 'scope'. This is crucial for 'this.locked' to refer to the weapon instance.
        )    
    }

    // This function is called when the player left-clicks.
    function OnPrimaryAction() {
        // Don't fire if the weapon is locked (e.g., during reload or between shots).
        if(this.locked) return

        this.ammo -= 1
        // Update the HUD text with the new ammo count and display it by calling Enable().
        this.game_text.SetText("Ammo: " + this.ammo + "/10").Enable()
        // Automatically reload if out of ammo.
        if(this.ammo == 0) this.Reload()

        // Play a firing sound on the player.
        this.player.EmitSound("weapons/wheatley/wheatley_fire_02.wav") // placeholder

        // Perform a precise BBox raycast from the player's eyes that correctly interacts with portals.
        local trace = TracePlus.FromEyes.PortalBbox(3000, this.player)
        // Use the dev utility to draw a small box at the hit position for debugging.
        dev.drawbox(trace.GetHitpos(), Vector(50, 25, 25), 0.7)
        // If the trace hit a world brush (like a wall), do nothing further.
        if(trace.DidHitWorld()) return

        // Get the entity that was hit by the trace.
        local hitEnt = trace.GetEntity()
        // Fire the 'Break' input on the hit entity (this is a placeholder for damage logic).
        EntFireByHandle(hitEnt, "Break")

        // Lock the weapon for 0.5 seconds to control the fire rate.
        this.LockInterface(0.5)
    }

    // This function is called when the player right-clicks or runs out of ammo.
    function Reload() {
        // Don't reload if already locked.
        if(this.locked) return

        // Update HUD to show 'Reloading...'.
        this.game_text.SetText("Reloading...").Enable()
        // Lock the weapon for the duration of the reload animation/sound.
        this.LockInterface(1.3)
        // Reset the ammo count.
        this.ammo = 10
        // Play a reload sound.
        this.player.EmitSound("weapons/wheatley/sphere_firing_powerup_01.wav") // placeholder
    }
}

// Use the macros utility to precache sounds, ensuring they play without delay the first time.
macros.Precache([
    "weapons/wheatley/sphere_firing_powerup_01.wav",
    "weapons/wheatley/wheatley_fire_02.wav"
])

// --- TESTING ---
// Create an instance of the Weapon class for the current player to start the script.
Weapon(GetPlayer())