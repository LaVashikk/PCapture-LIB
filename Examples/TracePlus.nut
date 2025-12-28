// Initialize the PCapture-Lib library.
DoIncludeScript("PCapture-Lib/SRC/PCapture-Lib", getroottable())

/*
 * This example showcases the advanced tracing capabilities of TracePlus.
 * It performs a continuous raycast (scanner) from the player's eyes that:
 * 1. Passes through portals correctly.
 * 2. Uses precise Bounding Box collision detection (BBox Casting).
 * 3. Filters entities based on custom settings.
 */

// Define trace settings to configure what the trace hits and ignores.
traceSettings <- TracePlus.Settings.new({
    // Ignore generic trigger entities and the player entity itself.
    ignoreClasses = ["trigger_", "player"],
    
    // Enable binary refinement to calculate the exact hit point on the bounding box surface.
    // This is crucial for accurate surface normal calculation.
    bynaryRefinement = true 
});

// A function that simulates a laser scanner.
function PerformScannerTrace() {
    local player = GetPlayerEx();
    if (!player) return;

    // Perform a portal-aware BBox trace from the player's eyes.
    // The maximum distance is set to 2000 units.
    // 'null' for ignoreEntities because we handle that via traceSettings.
    local result = TracePlus.FromEyes.PortalBbox(2000, player, null, traceSettings);

    // Get the start and hit positions to draw the beam.
    local start = result.GetStartPos();
    local end = result.GetHitPos();
    
    // Draw the main segment of the beam (Green).
    DebugDrawLine(start, end, 0, 255, 0, true, 0.1);

    // If the trace went through portals, visualize the segments passing through them.
    local entries = result.GetAggregatedPortalEntryInfo();
    foreach(entry in entries.iter()) {
        // GetStartPos/GetHitPos of entry info represent the segment before the portal.
        // This helps visualize the path the ray took through 3D space.
        local pStart = entry.GetStartPos();
        local pEnd = entry.GetHitPos();
        DebugDrawLine(pStart, pEnd, 0, 255, 255, true, 0.1); // Cyan for portal segments
    }

    // If the trace hit something (entity or world geometry).
    if (result.DidHit()) {
        local entity = result.GetEntity();
        local hitPos = result.GetHitPos();
        local normal = result.GetImpactNormal();

        // Draw a small red box at the exact point of impact.
        dev.drawbox(hitPos, Vector(255, 0, 0), 0.1);
        
        // Draw the surface normal vector (Yellow line pointing out).
        DebugDrawLine(hitPos, hitPos + normal * 20, 255, 255, 0, true, 0.1);

        if (entity) {
            // If an entity was hit, show its classname and model.
            local msg = "Hit: " + entity.GetClassname();
            if (entity.GetModelName() != "") msg += "      (" + entity.GetModelName() + ")";
            
            // Show a hint at the hit location.
            HUD.HintInstructor(msg, 0.1, "icon_tip", 1).Enable();
        } else {
             // If the world (brushes/walls) was hit.
             HUD.HintInstructor("Hit World", 0.1, "icon_tip", 1).Enable();
        }
    }

    // Schedule this function to run again in 0.1 seconds to create a continuous loop.
    ScheduleEvent.Add("global", PerformScannerTrace, 0.1);
}

printl("Starting TracePlus example...");
PerformScannerTrace();
