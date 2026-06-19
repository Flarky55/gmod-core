-- Proj Volumetric Light (Shader)
return {
    wsid = "3712613623",
    category = "#optionaladdons.category.shader",
    onLoaded = function()
        local fn = (hook.GetTable()["InitPostEntity"] or {})["ProjVolumetricLight"]
        if fn == nil then
            ErrorNoHalt( "Failed to load Proj Volumetric Light: init function not found", "\n" )
            return
        end

        fn()

        RunConsoleCommand( "spawnmenu_reload" )
    end,
}