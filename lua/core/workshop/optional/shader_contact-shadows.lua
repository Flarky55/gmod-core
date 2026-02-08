-- Contact Shadows (Shader)
return {
    wsid = "3645490126",
    category = "#optionaladdons.category.shader",
    onLoaded = function()
        local fn = (hook.GetTable()["InitPostShaderlib"] or {})["ContactShadows"]
        if fn == nil then 
            ErrorNoHalt( "Failed to load Contact Shadows: init function not found", "\n" )
            return 
        end

        fn()

        RunConsoleCommand( "spawnmenu_reload" )
    end
}