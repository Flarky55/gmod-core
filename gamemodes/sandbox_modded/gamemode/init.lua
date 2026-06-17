AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

DEFINE_BASECLASS( "gamemode_sandbox" )


-- https://github.com/Facepunch/garrysmod/blob/94c5f12724a22cd77b35752a3ac87293350ef52a/garrysmod/gamemodes/sandbox/gamemode/init.lua#L33-L43
function GM:PlayerSpawn( ply, transition )
    player_manager.SetPlayerClass( ply, "player_sandbox_core" )

    -- gamemode_base.PlayerSpawn
    BaseClass.BaseClass.PlayerSpawn( self, ply, transition )
end

function GM:PlayerInitialSpawn( ply, transition )
    local team = self.GetUserGroupTeam( ply:GetUserGroup() )
    if team == nil then
        ErrorNoHalt( string.format( "Player %s has usergroup %s with no associated team!", ply:Name(), ply:GetUserGroup() ), "\n" )
        return
    end

    ply:SetTeam( self.GetUserGroupTeamIndex( team.Index ) )
end

-- Disables the high pitched ringing sound effect.
function GM:OnDamagedByExplosion() end