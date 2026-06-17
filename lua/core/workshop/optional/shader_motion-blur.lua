-- Motion Blur (Shader)
return {
    wsid = "3613474540",
    category = "#optionaladdons.category.shader",
    onLoaded = function()
        local fn = (hook.GetTable()["PostCEFCodecFixStatus"] or {})["MotionBlur"]
        if fn == nil then
            ErrorNoHalt( "Failed to load Motion Blur: init function not found", "\n" )
            return
        end

        fn()

        RunConsoleCommand( "spawnmenu_reload" )
    end,
}