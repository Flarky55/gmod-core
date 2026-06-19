-- Horizon-Based Ambient Occlusion (HBAO shader)
return {
    wsid = "3722503099",
    category = "#optionaladdons.category.shader",
    onLoaded = function()
        local fn = (hook.GetTable()["InitPostShaderlib"] or {})["HBAO"]
        if fn == nil then
            ErrorNoHalt( "Failed to load HBAO: init function not found", "\n" )
            return
        end

        fn()

        RunConsoleCommand( "spawnmenu_reload" )
    end,
}