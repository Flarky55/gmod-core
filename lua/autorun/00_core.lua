include( "includes/loader.lua" )

core = core or {}


local Print; do
    local color_name = Color( 39, 174, 96 )

    Print = function(...)
        MsgC(color_white, "[", color_name, "core", color_white, "] ", ...)
        MsgN()
    end
end
core.Print = Print


Print("Loading...")

local time_start = SysTime()
do
    include( "core_extensions.lua" )
    include( "lzwd.lua" )

    loader.AutoList( "core", {

        "sh_globals.lua",
        "sv_logs.lua",

        "workshop/sv_workshop_watchdog.lua",
        "workshop/sh_workshop.lua",

        "gamemode/sh_gamemode.lua",
        "gamemode/sv_gamemode.lua",

        "patches/sh_entities.lua",
        "patches/sh_maps.lua",
        "patches/sv_maps_doors.lua",

        "season/sh_season.lua",

        "cl_camera.lua",
        "cl_spawnlist.lua",
        "cl_settings.lua",
        "cl_localization_stub.lua",

    } )

    loader.AutoDir( "core/interface" )
end
local time_end = SysTime()

Print( string.format("Loaded in %fs!", time_end - time_start) )
