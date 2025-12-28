// Initialize the PCapture-Lib library.
DoIncludeScript("PCapture-Lib/SRC/PCapture-Lib", getroottable())

/*
 * This example demonstrates asynchronous logic flow using generators and the 'yield' keyword.
 * This allows writing sequential code that executes over time without "callback hell".
 * 
 * The `yield` keyword pauses the function for X seconds, then resumes execution.
 * 
 * WARNING: While an asynchronous action is running (active generator), saving or loading 
 * the game will cause a crash due to engine limitations with VScript generator serialization.
 */

function AsyncSequence() {
    local player = GetPlayerEx();
    if (!player) return;

    printl("Async Sequence: Started");
    
    // Step 1: Display a message and play a sound.
    HUD.ScreenText(Vector(0.5, 0.4, 0), "Sequence Starting...", 2).Enable();
    player.EmitSound("buttons/button14.wav");
    
    // Pause execution for 2.0 seconds.
    yield 2.0;

    // Step 2: Spawn a prop after the delay.
    printl("Async Sequence: Spawning prop");
    local spawnPos = macros.GetEyeEndpos(player, 150);
    local prop = entLib.CreateProp("prop_physics_override", spawnPos, "models/props/switch001.mdl");
    prop.SetColor("0 255 0"); // Green
    
    // Pause for 1.0 second.
    yield 1.0;

    // Step 3: Animate the prop (Move up).
    printl("Async Sequence: Moving prop");
    local startPos = prop.GetOrigin();
    local endPos = startPos + Vector(0, 0, 50);
    
    // Use the Animation module to move the prop smoothly over 2 seconds.
    // Note: The animation runs in parallel, but we wait for it using yield.
    animate.PositionTransitionByTime(prop, startPos, endPos, 2.0);
    
    // Wait for the 2-second animation to finish.
    yield 2.0;

    // Step 4: Change color and play another sound.
    printl("Async Sequence: Changing color");
    prop.SetColor("255 0 0"); // Red
    player.EmitSound("buttons/bell1.wav");
    
    // Wait one last second.
    yield 1.0;
    
    // Step 5: Cleanup.
    printl("Async Sequence: Finished (Deleting prop)");
    prop.Destroy();
    HUD.ScreenText(Vector(0.5, 0.4, 0), "Sequence Complete", 2).Enable();
}

// Start the asynchronous sequence.
// ScheduleEvent automatically detects that 'AsyncSequence' is a generator (due to 'yield')
// and handles the pausing/resuming logic.
ScheduleEvent.Add("global", AsyncSequence, 0);
