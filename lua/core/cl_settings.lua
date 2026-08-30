local function Init_CheckBox( form, label, cvar )
    return form:CheckBox( label, cvar:GetName() )
end

local function Init_NumSlider( form, label, cvar )
    return form:NumSlider( label, cvar:GetName(), cvar:GetMin(), cvar:GetMax() )
end

local function Init_KeyBinder( form, label, cvar )
    local binder = vgui.Create( "CtrlNumPad", form )

    binder:SetLabel1( label )
    binder:SetConVar1( cvar:GetName() )

    form:AddItem( binder, nil )

    return binder
end


local Settings = {
    {
        Name = "#core.settings.category.misc",
        {
            Name = "#core.settings.performantrender_enable",
            Help = "#core.settings.performantrender_enable.help",
            ConVar = "performantrender_enable",
            Init = Init_CheckBox
        },
        {
            Name = "#core.settings.cl_autojump",
            ConVar = "cl_autojump",
            Init = Init_CheckBox
        }
    },
    {
        Name = "#core.settings.category.thirdperson",
        {
            Name = "#core.settings.enabled",
            ConVar = "cl_thirdperson_enable",
            Init = Init_CheckBox
        },
        {
            Name = "#core.settings.cl_thirdperson_fpaiming",
            ConVar = "cl_thirdperson_fpaiming",
            Init = Init_CheckBox
        },
        {
            Name = "#core.settings.cl_thirdperson_offset_distance",
            ConVar = "cl_thirdperson_offset_distance",
            Init = Init_NumSlider
        },
        {
            Name = "#core.settings.cl_thirdperson_offset_horizontal",
            ConVar = "cl_thirdperson_offset_horizontal",
            Init = Init_NumSlider
        },
        {
            Name = "#core.settings.cl_thirdperson_offset_vertical",
            ConVar = "cl_thirdperson_offset_vertical",
            Init = Init_NumSlider
        },
        {
            Name = "#core.settings.cl_thirdperson_switchshoulder",
            ConVar = "cl_thirdperson_switchshoulder",
            Init = Init_KeyBinder
        },
    },
    {
        Name = "#core.settings.category.smooth_noclip",
        {
            Name = "#core.settings.enabled",
            ConVar = "smooth_noclip",
            Init = Init_CheckBox
        },
        {
            Name = "#core.settings.smooth_noclip_crouch_default",
            ConVar = "smooth_noclip_crouch_default",
            Init = Init_CheckBox
        },
    },
    {
        Name = "#core.settings.category.mute_toolgun",
        {
            Name = "#core.settings.cl_toolgun_sound",
            ConVar = "cl_toolgun_sound",
            Init = Init_CheckBox
        },
        {
            Name = "#core.settings.cl_toolgun_effects",
            ConVar = "cl_toolgun_effects",
            Init = Init_CheckBox
        },
    },
    {
        Name = "#core.settings.category.character",
        {
            Name = "#core.settings.cl_character_sound",
            ConVar = "cl_character_sound",
            Init = Init_CheckBox,
        },
        {
            Name = "#core.settings.cl_character_sound_footsteps",
            ConVar = "cl_character_sound_footsteps",
            Init = Init_CheckBox,
        },
        {
            Name = "#core.settings.cl_character_sound_death",
            ConVar = "cl_character_sound_death",
            Init = Init_CheckBox,
        },
        {
            Name = "#core.settings.cl_character_sound_damage",
            ConVar = "cl_character_sound_damage",
            Init = Init_CheckBox,
        },
        {
            Name = "#core.settings.cl_character_sound_kill",
            ConVar = "cl_character_sound_kill",
            Init = Init_CheckBox,
        },
    },
}


local function PopulateToolMenu()
    spawnmenu.AddToolMenuOption( "Utilities", "User", "core", "#spawnemnu.utilities.addonsettings", nil, nil, function( cpanel )
        for _, entry in ipairs( Settings ) do
            local form = vgui.Create( "DForm", cpanel )
            form:SetLabel( entry.Name )

            cpanel:AddItem( form )

            for _, setting in ipairs( entry ) do
                setting.Init( form, setting.Name, GetConVar( setting.ConVar ) )

                if setting.Help then form:ControlHelp( setting.Help ) end
            end
        end
    end )
end


PopulateToolMenu()

hook.Add( "PopulateToolMenu", "core.settings", PopulateToolMenu )