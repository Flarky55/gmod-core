-- Screen Space Ambient Occlusion (SSAO+ shader)
return {
    wsid = "3453258660",
    category = "#optionaladdons.category.shader",
    onLoaded = function()
        local fn = (hook.GetTable()["PostCEFCodecFixStatus"] or {})["SSAO"]
        if fn == nil then
            ErrorNoHalt( "Failed to load SSAO+: init function not found", "\n" )
            return
        end

        fn()

        RunConsoleCommand( "spawnmenu_reload" )
    end,
}