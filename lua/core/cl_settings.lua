local function PopulateToolMenu()
    local DForm = vgui.GetControlTable( "DForm" )

    local Settings = {
        {
            Name = "#core.settings.category.misc",
            {
                Name = "#core.settings.cl_thirdperson_enable",
                ConVar = "cl_thirdperson_enable",
                Init = DForm.CheckBox
            },
            {
                Name = "#core.settings.performantrender_enable",
                ConVar = "performantrender_enable",
                Init = DForm.CheckBox
            },
            {
                Name = "#core.settings.cl_autojump",
                ConVar = "cl_autojump",
                Init = DForm.CheckBox
            }
        },
        {
            Name = "#core.settings.category.smooth_noclip",
            {
                Name = "#core.settings.enabled",
                ConVar = "smooth_noclip",
                Init = DForm.CheckBox
            },
            {
                Name = "#core.settings.smooth_noclip_crouch_default",
                ConVar = "smooth_noclip_crouch_default",
                Init = DForm.CheckBox
            },
        },
        {
            Name = "#core.settings.category.mute_toolgun",
            {
                Name = "#core.settings.cl_toolgun_sound",
                ConVar = "cl_toolgun_sound",
                Init = DForm.CheckBox
            },
            {
                Name = "#core.settings.cl_toolgun_effects",
                ConVar = "cl_toolgun_effects",
                Init = DForm.CheckBox
            },
        },
    }

    
    spawnmenu.AddToolMenuOption( "Utilities", "User", "core", "#spawnemnu.category.core", nil, nil, function( cpanel )
        for _, entry in ipairs( Settings ) do
            local form = vgui.Create( "DForm", cpanel )
            form:SetLabel( entry.Name )

            cpanel:AddItem( form )

            for _, setting in ipairs( entry ) do
                setting.Init( form, setting.Name, setting.ConVar )
            end
        end
    end )
end


if vgui.Exists( "DForm" ) then PopulateToolMenu() end
hook.Add( "PopulateToolMenu", "core.settings", PopulateToolMenu )