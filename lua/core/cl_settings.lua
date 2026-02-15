local Settings = {
    {
        Name = "#core.settings.thirdperson",
        ConVar = "cl_thirdperson_enable",
        -- Init = 
    },
    {
        Name = "#core.settings.smooth_noclip",
        ConVar = "smooth_noclip",
        -- Init = 
    },
    {
        Name = "#core.settings.smooth_noclip_crouch_default",
        ConVar = "smooth_noclip_crouch_default",
        -- Init = 
    },
}


hook.Add( "PopulateToolMenu", "core.settings", function()
    spawnmenu.AddToolMenuOption( "Utilities", "User", "core", "#spawnemnu.category.core", nil, nil, function( cpanel )
        cpanel:CheckBox( "#core.settings.thirdperson", "cl_thirdperson_enable" )
    end )
end )