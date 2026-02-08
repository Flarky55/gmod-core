local MODE = {
    Name    = "PvP",
    Color   = Color(231, 76, 60)
}

if SERVER then
    MODE.OnEnter = function( ply )
        ply:SpawnReliable()
    end
end

MODE.CanTakeDamage = function( ply, attacker )
    if not isplayer( attacker ) then return end

    return attacker:GetGamemode() == MODE
end

CORE_GAMEMODE_PVP = core.gamemode.Define( 2, MODE )