local PLAYER = {}

DEFINE_BASECLASS( "player_sandbox" )

PLAYER.MaxStamina   = 100
PLAYER.StartStamina = 100

InstallPlayerStamina( PLAYER )

player_manager.RegisterClass( "player_sandbox_core", PLAYER, "player_sandbox" )