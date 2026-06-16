require( "webapi/ipapi" )

local GetClass = FindMetaTable( "Entity" ).GetClass

local ServerLog_FormatPlayer = ServerLog_FormatPlayer


local function PlayerSpawnedString( _, ply, str )
    return ServerLog_FormatPlayer( ply ) .. " spawned " .. str
end

local function PlayerSpawnedEntity( _, ply, ent )
    return ServerLog_FormatPlayer( ply ) .. " spawned " .. GetClass( ent )
end

local function PlayerSpawnedVehicle( _, ply, ent )
    -- Glide vehicles are SENTs, but Glide also calls "PlayerSpawnedVehicle", so the log is repeated twice
    --  https://github.com/StyledStrike/gmod-glide/blob/dc0168bcef524fd47e4095de6a9c4fc89b0fada6/lua/glide/server/events.lua#L256-L263
    if ent.IsGlideVehicle then return end

    return PlayerSpawnedEntity( _, ply, ent )
end

list.Set( "ServerLogs", "PlayerSpawnedEffect",  PlayerSpawnedString )
list.Set( "ServerLogs", "PlayerSpawnedProp",    PlayerSpawnedString )
list.Set( "ServerLogs", "PlayerSpawnedRagdoll", PlayerSpawnedString )

list.Set( "ServerLogs", "PlayerSpawnedNPC",     PlayerSpawnedEntity )
list.Set( "ServerLogs", "PlayerSpawnedSENT",    PlayerSpawnedEntity )
list.Set( "ServerLogs", "PlayerSpawnedSWEP",    PlayerSpawnedEntity )
list.Set( "ServerLogs", "PlayerSpawnedVehicle", PlayerSpawnedVehicle )

list.Set( "ServerLogs", "PlayerGiveSWEP", function( _, ply, class )
    return ServerLog_FormatPlayer( ply ) .. " gave himself " .. class
end )

list.Set( "ServerLogs", "CanTool", function( _, ply, _, toolname )
    return ServerLog_FormatPlayer( ply ) .. " attempts to use " .. toolname
end )


gameevent.Listen( "player_connect" )
list.Set( "ServerLogs", "player_connect", function( fnLog, data )
    if data.bot == 1 then return end

    local name, userid, networkid = data.name, data.userid, data.networkid
    local address = data.address

    -- https://www.youtube.com/watch?v=QYyMLXq_SSo
    webapi.ipapi.GetAll( string.match( data.address, "(.+):" ),
        function( result )
            fnLog( ServerLog_FormatPlayerString( name, userid, networkid ) .. " connected, address \"" .. address .. "\" (" .. result.city .. ", " .. result.country .. ")"  )
        end,
        function( err )
            ErrorNoHalt( string.format( "ServerLog: failed to fetch ip info ('%s'): %s", address, err ), "\n" )

            fnLog( ServerLog_FormatPlayerString( name, userid, networkid ) .. " connected, address \"" .. address .. "\"", false )
        end
    )
end )

gameevent.Listen( "player_disconnect" )
list.Set( "ServerLogs", "player_disconnect", function( _, data )
    if data.bot == 1 then return end

    local name, userid, networkid = data.name, data.userid, data.networkid
    local reason = data.reason

    return ServerLog_FormatPlayerString( name, userid, networkid ) .. " disconnected (reason \"" .. reason .. "\")", false
end )