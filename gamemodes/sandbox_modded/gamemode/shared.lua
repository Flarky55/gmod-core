include( "includes/loader.lua" )

DeriveGamemode( "sandbox" )

loader.Shared( "player_class/player_sandbox_core.lua" )
loader.Client( "cl_scoreboard.lua" )


local TEAM_INDEX_OFFSET = 100

local Teams = {
    ["user"] = {
        Index = 0,
        Color = Color( 128, 128, 128 )
    },
    ["admin"] = {
        Index = 9,
        Color = Color( 231, 76, 60 )
    },
    ["superadmin"] = {
        Index = 10,
        Color = Color( 200, 53, 69 )
    },
}


function GM.GetUserGroupTeam( usergroup )
    return Teams[usergroup]
end

local function GetUserGroupTeamIndex( idx )
    return TEAM_INDEX_OFFSET + idx
end
GM.GetUserGroupTeamIndex = GetUserGroupTeamIndex


function GM:CreateTeams()
    for usergroup, entry in pairs( Teams ) do
        team.SetUp( GetUserGroupTeamIndex( entry.Index ), "#team." .. usergroup, entry.Color, false )
    end
end