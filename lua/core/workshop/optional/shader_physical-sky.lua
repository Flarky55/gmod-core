-- Physical Sky & Volumetric Clouds (Shader)
return {
    wsid = "3669946645",
    category = "#optionaladdons.category.shader",
    onLoaded = function()
        local fn = (hook.GetTable()["PostCEFCodecFixStatus"] or {})["PhysicalSky"]
        if fn == nil then
            ErrorNoHalt( "Failed to load Physical Sky: init function not found", "\n" )
            return
        end

        fn()

        RunConsoleCommand( "spawnmenu_reload" )
    end,
}