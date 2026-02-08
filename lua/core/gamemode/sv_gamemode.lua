hook.Add( "PlayerInitialSpawn", "core.gamemode", function( ply )
    ply:SetGamemode( CORE_GAMEMODE_BUILD )
end, PRE_HOOK )