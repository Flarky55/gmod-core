local discord = core.discord or {}; core.discord = discord

local JSONToTable, TableToJSON = util.JSONToTable, util.TableToJSON
local cMsg = core.Msg


local CVAR_URL      = CreateConVar( "sv_core_discord_url", "ws://localhost:6767", FCVAR_ARCHIVE )
local CVAR_PASSWORD = CreateConVar( "sv_core_discord_password", "", FCVAR_PROTECTED )


local Msg; do
    local color = Color( 88, 101, 242 )

    Msg = function( ... )
        cMsg( color_white, "[", color, "discord", color_white, "] ", ... )
    end
end

local function Err( ... )
    Msg( color_red, "[err] ", color_white, ... )
end


local INSTALLED = util.IsBinaryModuleInstalled( "gwsockets" )

local WebSocket = discord.WebSocket
if WebSocket == nil then
    if INSTALLED then
        require( "gwsockets" )

        WebSocket = GWSockets.createWebSocket( CVAR_URL:GetString() )
    else
        WebSocket = setmetatable( {}, {
            __call = function() end
        } )

        ErrorNoHaltWithStack( "GWSockets is required! (https://github.com/FredyH/GWSockets)" )
    end

    discord.WebSocket = WebSocket
end
do
    function WebSocket:onMessage( message )
        message = JSONToTable( message )
        if not message then
            Err( "[ws] JSONToTable failed on message receive. (message: ", message, ")" )
            return
        end

        hook.Run( "core.discord:" .. message.name, self, message )
    end

    function WebSocket:onError( err )
        Err( "[ws] Error: " .. err )
    end

    function WebSocket:onDisconnected()
        Msg( "[ws] Disconnected!" )
    end

    function WebSocket:onConnected()
        Msg( "[ws] Connected!" )
    end
end

do
	local setup = function( value )
	    WebSocket:setHeader( "password", value )
	end

	setup( CVAR_PASSWORD:GetString() )
	cvars.AddChangeCallback( CVAR_PASSWORD:GetName(), cvars.CallbackValue( setup ) )
end

if not WebSocket:isConnected() then pcall( WebSocket.open, WebSocket ) end


---@param name string
---@param payload table|nil
local function Send( name, payload )
    payload = payload or {}
    payload.name = name

    local json = TableToJSON( payload )

    WebSocket:write( json )
end
discord.Send = Send


do
    local color_name = Color( 220, 220, 220 )

    hook.Add( "core.discord:chat", "core.discord", function( ws, message )
        chat.AddText( nil,
            { blockType = "avatar", blockValue = message.avatarURL },
            color_name, message.username, color_white, ": ", message.content
        )
    end )
end



-- Custom Chat exclusive hook
hook.Add( "PostPlayerSay", "core.discord", function( ply, text, _, channel, _, proximityMode )
    if not (channel == "global" and proximityMode == nil) then return end

    Send( "chat", {
        username    = ply:Name(),
        content     = text,
        avatarURL   = ply.SteamUser.Summary.avatarfull,
    } )
end )

hook.Add( "PlayerInitialSpawn", "core.discrod", function( ply )
    Send( "connect", {
        username    = ply:Name(),
        steamid     = ply:SteamID(),
    } )
end )

hook.Add( "PlayerDisconnected", "core.discord", function( ply )
    Send( "disconnect", {
        username    = ply:Name(),
        steamid     = ply:SteamID(),
    } )
end )