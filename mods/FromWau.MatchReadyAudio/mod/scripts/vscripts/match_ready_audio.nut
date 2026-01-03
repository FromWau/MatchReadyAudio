untyped

// ============================================================================
// Match Ready Audio
// Author: FromWau
// Description: Temporarily enables sound when joining match to hear intro music
// ============================================================================

global function MatchReadyAudio_Init

// ============================================================================
// INITIALIZATION
// ============================================================================

void function MatchReadyAudio_Init()
{
    AddCallback_OnClientScriptInit( OnClientScriptInit )
}

void function OnClientScriptInit( entity player )
{
    string currentMap = GetMapName()

    // Only enable sound when loading into a game map (not lobby)
    if ( currentMap != "mp_lobby" && currentMap != "" )
    {
        thread EnableSoundTemporarily()
    }
}

// ============================================================================
// TEMPORARY SOUND ENABLE
// ============================================================================

void function EnableSoundTemporarily()
{
    // Check if "Sound in Background" is already enabled
    int originalValue = 0
    bool alreadyEnabled = false
    {
        try
        {
            originalValue = GetConVarInt( "sound_without_focus" )
            alreadyEnabled = ( originalValue == 1 )

            if ( alreadyEnabled )
                return

            SetConVarInt( "sound_without_focus", 1 )
        }
        catch ( ex )
        {
            printt("[MatchReadyAudio] WARNING: Failed to toggle sound_without_focus: " + ex)
        }
    }

    // Wait for player to be loaded
    entity player = GetLocalClientPlayer()
    int waitAttempts = 0
    while ( !IsValid( player ) && waitAttempts < 50 )
    {
        wait 0.1
        player = GetLocalClientPlayer()
        waitAttempts++
    }

    if ( !IsValid( player ) )
        return

    // Wait for match intro music to play before restoring setting
    wait 7.0

    {
        try
        {
            SetConVarInt( "sound_without_focus", originalValue )
        }
        catch ( ex )
        {
            printt("[MatchReadyAudio] WARNING: Failed to restore sound_without_focus: " + ex)
        }
    }
}
