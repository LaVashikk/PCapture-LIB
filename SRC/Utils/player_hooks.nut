if("AllPlayers" in getroottable()) return

::AllPlayers <- ArrayEx()
const PLAYER_DEATH_MARKER = -999

/* 
 * Gets an array of all players in the game. 
 *
 * @returns {array} - An array of pcapEntity objects representing the players. 
*/
::GetPlayers <- function() { // -> ArrayEx
    return AllPlayers
}


/* 
 * Tracks players joining the game and initializes their. 
 *
 * This function iterates over all player entities in the game, attaching eye control 
 * and initializing new portal pairs for each new player. It calls OnPlayerJoin for 
 * each player added to the AllPlayers list.
*/
::TrackPlayerJoins <- function() {
    for(local player; player = entLib.FindByClassname("player", player);) {
        if(player.GetUserData("Eye")) continue // if already inited (AllPlayers.contains(player))
        
        // Attach eye control to the new player
        AttachEyeControl(player)
        // Initialize a new portal pair for this player:
        InitPortalPair(AllPlayers.len())
        
        AllPlayers.append(player)
        // Trigger join event
        OnPlayerJoined(player)
    }
}

/* 
 * Handles player events in MP, such as health checks and death events. 
 *
 * This function iterates over all players in the AllPlayers list, checking if 
 * each player is valid and updating their state accordingly. It calls OnDeath 
 * for dead players and schedules their respawn logic.
*/
::HandlePlayerEventsMP <- function() {
    local playersToRemove = []
    foreach(idx, player in AllPlayers){
        if(!player.IsValid()) {
            OnPlayerLeft(player)
            playersToRemove.append(idx)
            continue
        }
        
        if(player.GetHealth() > 0 || player.GetHealth() == PLAYER_DEATH_MARKER) continue

        OnPlayerDeath(player)
        ScheduleEvent.AddInterval("global", _monitorRespawn, 0.3, 0, null, player)
        player.SetHealth(PLAYER_DEATH_MARKER)
    }

    if(playersToRemove.len() > 0) {
        for(local i = playersToRemove.len() - 1; i >= 0; i--) {
            AllPlayers.remove(playersToRemove[i])
        }        
    } 
}

::HandlePlayerEventsSP <- function() {
    local h = AllPlayers[0].GetHealth()
    if(h > 0 || h == PLAYER_DEATH_MARKER) return
    OnPlayerDeath(AllPlayers[0])
    AllPlayers[0].SetHealth(PLAYER_DEATH_MARKER)
}

/* 
 * Monitors player respawn status. 
*/
function _monitorRespawn() {
    if(this.GetHealth() > 0)
        return OnPlayerRespawn(this)
}


/* 
 * Attaches eye control entities to all players in the game. 
 *
 * This function creates logic_measure_movement and info_target entities for each player to track their eye position and angles. 
 * It is called automatically at the initialization of the library and periodically in multiplayer games. 
*/
function AttachEyeControl(player) {
    if(player.GetUserData("Eye")) return

    local controlName = UniqueString("eyeControl")
    local eyeControlEntity = entLib.CreateByClassname("logic_measure_movement", {
        targetname = controlName, measuretype = 1}
    )

    local eyeName = UniqueString("eyePoint")
    local eyePointEntity = entLib.CreateByClassname("info_target", {targetname = eyeName})

    local playerName = player.GetName() == "" ? "!player" : player.GetName()

    EntFireByHandle(eyeControlEntity, "setmeasuretarget", playerName)
    EntFireByHandle(eyeControlEntity, "setmeasurereference", controlName);
    EntFireByHandle(eyeControlEntity, "SetTargetReference", controlName);
    EntFireByHandle(eyeControlEntity, "Settarget", eyeName);
    EntFireByHandle(eyeControlEntity, "Enable")

    player.SetUserData("Eye", eyePointEntity)
}


// Empty Hooks
function OnPlayerJoined(player) {}
function OnPlayerLeft(player) {}
function OnPlayerDeath(player) {}
function OnPlayerRespawn(player) {}