-- Screen Space Direction Occlusion (SSDO shader)
return {
    wsid = "3707449642",
    category = "#optionaladdons.category.shader",
    onLoaded = function()
        local fn = (hook.GetTable()["PostCEFCodecFixStatus"] or {})["SSDO"]
        if fn == nil then
            ErrorNoHalt( "Failed to load SSDO: init function not found", "\n" )
            return
        end

        fn()

        RunConsoleCommand( "spawnmenu_reload" )
    end,
}