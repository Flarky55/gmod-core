local insert = table.insert

local MAP = game.GetMap()

local ROOT = file.CurrentDir()
local FILENAME_MAP = MAP .. ".lua"

local DEFAULT, LAZY, OPTIONAL = {}, {}, {}

local function populate_optional( path )
    for filepath, filename in file.Iterator( path .. "*.lua", "LUA" ) do
        local value = loader.Client( filepath )

        if CLIENT then
            insert( OPTIONAL, value )
        end
    end
end

local function populate_map( root, filename )
    local filepath = root .. filename
    if not file.Exists( filepath, "LUA" ) then return end

    local value = SERVER and loader.Server( filepath ) or loader.Client( filepath )
    if value == nil then
        ErrorNoHalt( string.format( "Failed to include map-specific workshop autoload list '%s' (%s): no value was returned", filename, filepath ), "\n" )
        return
    end

    if istable( value ) then
        if SERVER then
            for _, wsid in ipairs( value ) do
                insert( DEFAULT, value )
            end

            if value.optional ~= nil then
                loader.Client( filepath )
            end
        else
            if value.optional == nil then
                ErrorNoHalt( string.format( "Failed to load map-specific workshop autoload list '%s' (%s): 'optional' key was expected", filename, filepath ), "\n" )
                return
            end

            for _, wsid in ipairs( value.optional ) do
                insert( OPTIONAL, value )
            end
        end
    elseif isstring( value ) then
        populate_map( root, value .. ".lua" )
    else
        ErrorNoHalt( string.format( "Failed to load map-specific workshop autoload list '%s' (%s): unsupported value returned", filename, filepath ), "\n" )
    end
end

if SERVER then
    --[[
            Default resource.AddWorkshop
            All addons might be lazy loaded, but here are pitfalls
    --]]
    -- materials/
    --  https://wiki.facepunch.com/gmod/game.MountGMA#description
    --  Any error materials currently loaded that the mounted addon provides will NOT be reloaded.
    insert( DEFAULT, "3542644649" ) -- GShader Library
    insert( DEFAULT, "3389728250" ) -- Glide // Styled's Vehicle Base
    insert( DEFAULT, "3613807148" ) -- Glide Extension // Ремень Безопасности
    insert( DEFAULT, "3734712166" ) -- [TacRP] Tactical RP Weapons
    insert( DEFAULT, "2837856621" ) -- [LSCS] - Lightsaber - Force Powers
    insert( DEFAULT, "546392647" )  -- Media Player
    insert( DEFAULT, "104691717" )  -- PAC3
    insert( DEFAULT, "2799307109" ) -- Custom Chat
    -- data_static/
    --  Lua just loading earlier
    insert( DEFAULT, "3626277245" ) -- Animated Avatars!
    -- animations are bad with lazy loading too
    insert( DEFAULT, "775573383" )  -- The Prone Mod - wOS
    insert( DEFAULT, "2143558752" ) -- xdReanimsBase
    insert( DEFAULT, "918084741" )  -- [wOS] Animation Extension - Prone Mod
    insert( DEFAULT, "848953359" )  -- [wOS] Animation Extension - Blade Symphony
    insert( DEFAULT, "2247494212" ) -- [WOS] Standard Sword Art
    insert( DEFAULT, "3166246769" ) -- [xdR/wOS] uTaunt - Team Fortress 2
    insert( DEFAULT, "3161530501" ) -- [xdR] uTaunt - Fortnite Taunts ( Custom Taunt )
    insert( DEFAULT, "2912631064" ) -- Female Sit Animation [xdR]
    insert( DEFAULT, "3554302778" ) -- [xdR]talking_sit by mixamo

    --[[
            Lazy loading
    --]]
    insert( LAZY, "3647731518" )    -- Simple UI Skin Selector
    insert( LAZY, "3333669763" )    -- [ACE] Armored Combat Extended
    insert( LAZY, "403587498" )     -- ACF Missiles Support Pack
    insert( LAZY, "3386887696" )    -- CSteps
    insert( LAZY, "3386887019" )    -- CSlide
    insert( LAZY, "3113528615" )    -- Fin 3 - Superior Flight
    insert( LAZY, "3335380314" )    -- G-Rule Tool - Advanced Measurement
    insert( LAZY, "104575630" )     -- Ragdoll Mover
    insert( LAZY, "2675972006" )    -- Custom Loadout
    insert( LAZY, "3389795738" )    -- Glide // GTAV: Helicopters
    insert( LAZY, "3620516732" )    -- Glide // Styled's Experiments
    insert( LAZY, "3542961565" )    -- Liberty City // GLIDE
    insert( LAZY, "2656563609" )    -- Musical Keyboard
    insert( LAZY, "2840295308" )    -- Primitive
    insert( LAZY, "173482196" )     -- SProps
    insert( LAZY, "3412004213" )    -- StarfallEx - Git Master
    insert( LAZY, "2458909924" )    -- Prop2Mesh
    insert( LAZY, "737640184" )     -- Tank Track Tool
    insert( LAZY, "3066780663" )    -- Wiremod Canary
    insert( LAZY, "246756300" )     -- 3D Stream Radio
    insert( LAZY, "3734728497" )    -- [TacRP] Iron Curtain Weapons Pack
    -- fatass models
    insert( LAZY, "1089287594" )    -- Russian road signs Ultimate
    insert( LAZY, "3140746840" )    -- stpM64's Prop Pack
    insert( LAZY, "2992912462" )    -- CONRED Prop Pack
    insert( LAZY, "2721454163" )    -- Half-Life 2 props extended
    insert( LAZY, "2891252709" )    -- Half Life 2 Props Extended
    insert( LAZY, "310835919" )     -- Half-Life 2 Leak Props: Complete
    insert( LAZY, "1551672122" )    -- Half-Life 2 Signs Prop Pack
    insert( LAZY, "430077474" )     -- ZONA Stalker Props Pack [1/4] [Base]
    insert( LAZY, "430106735" )     -- ZONA Stalker Props Pack [2/4]
    insert( LAZY, "430147227" )     -- ZONA Stalker Props Pack [3/4]
    insert( LAZY, "430453978" )     -- ZONA Stalker Props Pack [4/4]
else
    insert( OPTIONAL, { wsid = "1983329448" } ) -- Better Icons16
    insert( OPTIONAL, { wsid = "3495129511" } ) -- GUI Scaler (Fix Small Spawnmenu)

    insert( OPTIONAL, { wsid = "3556046077", category = "#optionaladdons.category.shader", onLoaded = function() RunConsoleCommand( "spawnmenu_reload" ) end } ) -- Physically Based Bloom (Shader)
    insert( OPTIONAL, { wsid = "3555378834", category = "#optionaladdons.category.shader", onLoaded = function() RunConsoleCommand( "spawnmenu_reload" ) end } ) -- FXAA Shader
    insert( OPTIONAL, { wsid = "3455761038", category = "#optionaladdons.category.shader", onLoaded = function() RunConsoleCommand( "spawnmenu_reload" ) end } ) -- SMAA Shader
    insert( OPTIONAL, { wsid = "3453386337", category = "#optionaladdons.category.shader", onLoaded = function() RunConsoleCommand( "spawnmenu_reload" ) end } ) -- Volumetric Clouds Shader
    insert( OPTIONAL, { wsid = "3730026700", category = "#optionaladdons.category.shader", onLoaded = function() RunConsoleCommand( "spawnmenu_reload" ) end } ) -- Contrast Adaptive Sharpening (AMD FidelityFX CAS)
    insert( OPTIONAL, { wsid = "3644677720", category = "#optionaladdons.category.shader", onLoaded = function() RunConsoleCommand( "spawnmenu_reload" ) end } ) -- Sharpness Shader

    insert( OPTIONAL, { wsid = "3107793296", category = "#optionaladdons.category.dermaskin" } ) -- Luna Blue Derma Skin | Windows XP Visual Style
    insert( OPTIONAL, { wsid = "2972603323", category = "#optionaladdons.category.dermaskin" } ) -- GMod98 UI Skin - Win98 Style UI
    insert( OPTIONAL, { wsid = "3379423670", category = "#optionaladdons.category.dermaskin" } ) -- Garry's Mod Classic UI Spawnmenu
    insert( OPTIONAL, { wsid = "3647771064", category = "#optionaladdons.category.dermaskin", onLoaded = function() include( "skins/devinity.lua" ) end } ) -- Milk outside a bag of milk outside a bag of milk - UI Skin
    insert( OPTIONAL, { wsid = "3659339920", category = "#optionaladdons.category.dermaskin", onLoaded = function() include( "skins/oneshot.lua" ) end } )  -- OneShot - UI Skin
end

populate_optional( ROOT .. "optional/" )
populate_map( ROOT .. "maps/", FILENAME_MAP )


if SERVER then
    for _, wsid in ipairs( DEFAULT ) do
        resource.AddWorkshop( wsid )
    end

    for _, wsid in ipairs( LAZY ) do
        resource.AddWorkshopLazy( wsid )
    end

    resource.AddSingleFile( "resource/fonts/comfortaa.ttf" )
else
    for _, data in ipairs( OPTIONAL ) do
        resource.AddWorkshopOptional( data.wsid, data )
    end
end
