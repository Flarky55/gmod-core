-- Raindrops overlay (shader)
return {
    wsid = "3764126498",
    category = "#optionaladdons.category.shader",
    onLoaded = function()
        local fn = (hook.GetTable()["InitPostEntity"] or {})["RaindropsShader"]
        if fn == nil then
            ErrorNoHalt( "Failed to load Raindrops overlay: init function not found", "\n" )
            return
        end

        fn()

        RunConsoleCommand( "spawnmenu_reload" )
    end,
}