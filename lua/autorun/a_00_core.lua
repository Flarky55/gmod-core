include( "core_extensions.lua" )

core = core or {}


local Msg; do
    local color_name = Color( 39, 174, 96 )

    ---MsgC with prefix
    ---@param ... any
    Msg = function( ... )
        MsgC( color_white, "[", color_name, "core", color_white, "] ", ... )
        MsgN()
    end
end
core.Msg = Msg


local TIME_TOTAL, TIME_BEGIN = 0, 0

function core.__LoadBegin( bMsg )
    TIME_BEGIN = SysTime()

    if bMsg then
        Msg( "Loading..." )
    end
end

function core.__LoadFinish( bMsg )
    TIME_TOTAL = TIME_TOTAL + ( SysTime() - TIME_BEGIN )

    if bMsg then
        Msg( string.format( "Loading took %.2fs!", TIME_TOTAL ) )
    end
end


core.__LoadBegin( true )
do
    include( "lzwd.lua" )

    loader.AutoList( "core", {
        "workshop/sv_workshop_watchdog.lua",
        "workshop/sh_workshop.lua",
    } )
end
core.__LoadFinish()