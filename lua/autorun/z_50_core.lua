core.__LoadBegin()
do
    loader.AutoList( "core", {

        "sh_globals.lua",
        "sv_logs.lua",
        "sv_discord.lua",
        "sv_hostname.lua",

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
core.__LoadFinish( true )