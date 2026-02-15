local META_PLAYER = FindMetaTable( "Player" )

local cgamemode = core.gamemode or {}; core.gamemode = cgamemode

local KEY = "core.gamemode"


local Registry = {}

local function Define( id, tbl )
    Registry[id] = tbl
    return id
end
cgamemode.Define = Define

local function Get( id )
    return Registry[id]
end

-- it just looks odd and idk why, like it's not on its place
local MODE_UNKNOWN = {
    Name    = "???",
    Color   = Color( 0, 0, 0 )
}

Define( 0, MODE_UNKNOWN )

loader.Dir( file.CurrentDir() .. "gamemodes", loader.REALM_SHARED )


local Players = PlayerBoundTable( "core.gamemode" )

local function GetGamemodeId( ply )
    return ply:GetNW2Int( KEY )
end

local function GetGamemode( ply )
    return Players[ply] or MODE_UNKNOWN
end
META_PLAYER.GetGamemode = GetGamemode

local function IsInGamemode( ply, id )
    return GetGamemodeId( ply ) == id
end
META_PLAYER.IsInGamemode = IsInGamemode

if SERVER then
    local function SetGamemodeId( ply, id )
        ply:SetNW2Int( KEY, id )
    end
    META_PLAYER.SetGamemode = SetGamemodeId
end


local function PlayerEnterGamemode( ply, gm )
    local OnEnter = gm.OnEnter
    if OnEnter then OnEnter( ply ) end
end

local function PlayerLeaveGamemode( ply, gm )
    local OnLeave = gm.OnLeave
    if OnLeave then OnLeave( ply ) end
end

local function PlayerChangedGamemode( ply, oldGm, newGm )
    Players[ply] = newGm
end

hook.Add( "EntityNetworkedVarChanged", "core.gamemode", function( ent, name, oldValue, newValue )
    if name ~= KEY then return end
    
    local fullUpdate = oldValue == nil
    
    local oldGm = GetGamemode( ent )

    if not fullUpdate or oldGm == MODE_UNKNOWN then
        local newGm = Get( newValue )

        if oldGm ~= nil then PlayerLeaveGamemode( ent, oldGm ) end
        PlayerEnterGamemode( ent, newGm )

        PlayerChangedGamemode( ent, oldGm, newGm )
    end
end )


local function CanTakeDamage( ply, attacker )
    local gm = GetGamemode( ply )
    local CanTakeDamage = gm.CanTakeDamage
    if CanTakeDamage == nil then return true end

    return CanTakeDamage( ply, attacker )
end

hook.Add( "ScalePlayerDamage", "core.gamemode", function( ply, _, dmginfo )
    if CanTakeDamage( ply, dmginfo:GetAttacker() ) == false then
        return true
    end
end )

if SERVER then
    hook.Add( "EntityTakeDamage", "core.gamemode", function( ent, dmginfo )
        if not isplayer( ent ) then return end

        if CanTakeDamage( ent, dmginfo:GetAttacker() ) == false then
            return true
        end
    end )
end

hook.Add( "PlayerNoClip", "core.gamemode", function( ply, desiredState )
    if desiredState == false then return end

    local gm = GetGamemode( ply )

    return gm.NoClip ~= false
end, PRE_HOOK_RETURN )