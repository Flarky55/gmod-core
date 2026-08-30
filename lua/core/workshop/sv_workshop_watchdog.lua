require( "injector" )


local DISABLE_WORKSHOP = {
    ["2290839694"] = true, -- gm_carcon_ext
    ["1804554591"] = true, -- badcoderz_content (OOF sound, literally)
}

local DISABLE_FILE = {
    -- MediaPlayer (already using AddWorkshop)
    ["materials/mediaplayer/ui/spritesheet2015-10-7.png"] = true,
    ["resource/fonts/ClearSans-Medium.ttf"] = true,
    ["materials/theater/STATIC.vmt"] = true,
    ["models/gmod_tower/suitetv_large.mdl"] = true,
    ["materials/models/gmod_tower/suitetv_large.vmt"] = true,
    ["materials/entities/mediaplayer_tv.png"] = true,

    -- PAC3 (already using AddWorkshop)
    ["materials/icon64/new pac icon.png"] = true,
    ["materials/icon64/pac3.png"] = true,
}


resource.AddWorkshop = injector.replace( resource.AddWorkshop, function( fnOriginal, workshopid )
    if DISABLE_WORKSHOP[workshopid] then return end

    local info = debug.getinfo( 2, "S" )
    if info.source ~= "@addons/core/lua/core/workshop/sh_workshop.lua" then return end

    fnOriginal( workshopid )
end )

local function AddFile( fnOriginal, path )
    if DISABLE_FILE[path]
        or string.find( path, "stormfox" )
    then return end

    fnOriginal( path )
end
resource.AddSingleFile  = injector.replace( resource.AddSingleFile, AddFile )
resource.AddFile        = injector.replace( resource.AddFile, AddFile )