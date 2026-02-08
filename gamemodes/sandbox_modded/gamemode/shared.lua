include( "includes/loader.lua" )

DeriveGamemode( "sandbox" )

loader.Shared( "player_class/player_sandbox_core.lua" )
loader.Client( "cl_scoreboard.lua" )