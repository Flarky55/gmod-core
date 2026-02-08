-- https://github.com/CFC-Servers/cfc_map_scripts/blob/main/lua/map_scripts/maps/gm_boreas.lua

local removeThese = {
    env_steam = true,
    env_sprite = true,
    prop_ragdoll = true,
    dynamic_light = true,
    light_dynamic = true,
    env_soundscape = true,
    func_dustmotes = true,
    ambient_generic = true,
    func_illusionary = true,
    env_physexplosion = true,
    env_fog_controller = true,
    func_reflective_glass = true,
    prop_physics = true,

    weapon_357 = true,
    weapon_ar2 = true,
    weapon_crossbow = true,
    weapon_crowbar = true,
    weapon_frag = true,
    weapon_physcannon = true,
    weapon_physgun = true,
    weapon_pistol = true,
    weapon_rpg = true,
    weapon_shotgun = true,
    weapon_smg1 = true,
    item_ammo_crate = true,
    item_ammo_pistol = true,
    item_ammo_smg1 = true,
    item_box_buckshot = true,
    item_healthkit = true,
    item_item_crate = true,

}

local function isMapEnt( ent )
    return ent:MapCreationID() ~= -1
end

--- point_spotlight entities are serverside only, so they don't eat up edict count
--- however, they also spawn "beam" and "spotlight_end" entities that get networked to the client
--- If we try to delete point_spotlight, their children will still exist (and they don't have a MapCreationID)
--- So the goal is to turn them off, then in the next tick, delete them directly
local function Utils_TurnOffSpotlights()
    local spotlights = ents.FindByClass( "point_spotlight" )
    for _, spotlight in ipairs( spotlights ) do
        spotlight:Fire( "LightOff" )
    end

    timer.Simple( 1, function()
        for _, spotlight in ipairs( spotlights ) do
            SafeRemoveEntity( spotlight )
        end
    end )
end

--- Finds the shadow controller and sets its "disableallshadows" keyvalue to 1
local function Utils_DisableShadowControl()
    local shadowControls = ents.FindByClass( "shadow_control" )

    for _, shadowControl in ipairs( shadowControls ) do
        shadowControl:Fire( "SetShadowsDisabled", 1 )
    end
end


return function()
    -- Technically the spotlights on this map are set to "efficient" and "no dynamic light" but we can get rid of a
    -- bunch of networked ents by turning them off and then removing them
    Utils_TurnOffSpotlights()

    Utils_DisableShadowControl()

    for _, ent in ipairs( ents.GetAll() ) do
        if removeThese[ent:GetClass()] and isMapEnt( ent ) then
            SafeRemoveEntity( ent )
        end
    end
end