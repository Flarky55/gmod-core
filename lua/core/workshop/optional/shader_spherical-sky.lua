-- Spherical Sky (Shader)
return {
    wsid = "3731958150",
    category = "#optionaladdons.category.shader",
    onLoaded = function()
        local fn = (hook.GetTable()["InitPostEntity"] or {})["SphericalSky"]
        if fn == nil then
            ErrorNoHalt( "Failed to load Spherical Sky: init function not found", "\n" )
            return
        end

        fn()

        RunConsoleCommand( "spawnmenu_reload" )
    end,
}