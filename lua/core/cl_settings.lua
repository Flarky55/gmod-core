local Settings = {}


hook.Add( "PopulateToolMenu", "core.settings", function()
    spawnmenu.AddToolMenuOption( "Utilities", "User", "core", "#spawnemnu.category.core", nil, nil, function( cpanel )

    end )
end )