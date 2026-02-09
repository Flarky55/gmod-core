local META_PLAYER   = FindMetaTable( "Player" )
local META_ENTITY   = FindMetaTable( "Entity" )
local META_VECTOR   = FindMetaTable( "Vector" )
local META_ANGLE    = FindMetaTable( "Angle" )

local STUDIO_RENDER = STUDIO_RENDER

local Nick, EngineNick, GetGamemode = META_PLAYER.Nick, META_PLAYER.EngineNick, META_PLAYER.GetGamemode
local GetPos, GetModel, LookupAttachment, GetAttachment = META_ENTITY.GetPos, META_ENTITY.GetModel, META_ENTITY.LookupAttachment, META_ENTITY.GetAttachment
local Add, DistToSqr = META_VECTOR.Add, META_VECTOR.DistToSqr
local Forward, Right, RotateAroundAxis = META_ANGLE.Forward, META_ANGLE.Right, META_ANGLE.RotateAroundAxis

local band = bit.band
local SetAlphaMultiplier = surface.SetAlphaMultiplier
local SimpleTextShadowed = draw.SimpleTextShadowed
local Start3D2D, End3D2D = cam.Start3D2D, cam.End3D2D
local EyePos, EyeAngles = EyePos, EyeAngles


local CVAR_DISTANCE = CreateClientConVar( "cr_3d2d_player_distance", 512, nil, nil, "", -1, 1024 )

local FONT_NICK         = "core.ui.Nick";           surface.CreateFont( FONT_NICK,          { font = "Comfortaa", size = 48, extended = true } )
local FONT_NICK_SHADOW  = "core.ui.Nick__shadow";   surface.CreateFont( FONT_NICK_SHADOW,   { font = "Comfortaa", size = 48, extended = true, blursize = 3 } )

local V_HEIGHT_OFFSET = Vector( 0, 0, 72 )
local V_HEAD_OFFSET = Vector( 0, 0, 16 )

local CHECK_DISTANCE, DISTANCE_SQUARED; do
    local setup = function( value )
        value = tonumber( value )

        CHECK_DISTANCE = value > 0

        if CHECK_DISTANCE then
            DISTANCE_SQUARED = value ^ 2
        end
    end

    setup( CVAR_DISTANCE:GetInt() )
    cvars.AddChangeCallback( CVAR_DISTANCE:GetName(), cvars.CallbackValue(setup) )
end


local function AttachmentPos( ent, name )
    local id = LookupAttachment( ent, name )
    if id <= 0 then return nil end

    return GetAttachment( ent, id ).Pos
end

local AttachmentHeadPos; do
    local NAMES = {
        ["models/player/zombie_classic.mdl"] = "head"
    }

    AttachmentHeadPos = function( ply )
        local pos = AttachmentPos( ply, NAMES[GetModel( ply )] or "anim_attachment_head" )
        
        if pos == nil then
            pos = GetPos( ply )
            Add( pos, V_HEIGHT_OFFSET )
        end

        return pos
    end
end


hook.Add( "PostPlayerDraw", "core.ui.3d2d.player", function( ply, flags )
    if band( flags, STUDIO_RENDER ) ~= STUDIO_RENDER then return end

    local distance = CHECK_DISTANCE and DistToSqr( GetPos( ply ), EyePos() )
    if distance and distance > DISTANCE_SQUARED then return end

    local nick, nick_engine = Nick( ply ), EngineNick( ply )
    local gm = GetGamemode( ply )


    local pos, ang; do
        pos = AttachmentHeadPos( ply )
        Add( pos, V_HEAD_OFFSET )

        ang = EyeAngles()
        RotateAroundAxis( ang, Forward( ang ),    90 )
        RotateAroundAxis( ang, Right( ang ),      90 )
    end

    local alpha = CHECK_DISTANCE and (
        2 - (distance / DISTANCE_SQUARED) * 2
    )

    Start3D2D( pos, ang, 0.1 )
        if alpha then SetAlphaMultiplier( alpha ) end

        SimpleTextShadowed( nick, FONT_NICK, 0, -24, color_white, TEXT_ALIGN_CENTER, nil, FONT_NICK_SHADOW )
        SimpleTextShadowed( gm.Name, FONT_NICK, 0, 24, color_white, TEXT_ALIGN_CENTER, nil, FONT_NICK_SHADOW )
    
        if alpha then SetAlphaMultiplier( 1 ) end
    End3D2D()
end )