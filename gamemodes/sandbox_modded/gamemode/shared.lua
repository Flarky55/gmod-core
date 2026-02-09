include( "includes/loader.lua" )

DeriveGamemode( "sandbox" )

loader.Shared( "player_class/player_sandbox_core.lua" )
loader.Client( "cl_scoreboard.lua" )


function GM:CreateTeams()
    local OFFSET = 100

    team.SetUp( 0 + OFFSET, "#team.superadmin",  Color( 200, 53, 69 ) )
    team.SetUp( 1 + OFFSET, "#team.user",        Color( 128, 128, 128 ) )
end