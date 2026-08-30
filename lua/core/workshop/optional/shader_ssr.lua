-- Screen Space Reflections (SSR Shader)
return {
    wsid = "3586554495",
    category = "#optionaladdons.category.shader",
    onLoaded = function()
        local fn = (hook.GetTable()["PostCEFCodecFixStatus"] or {})["SSR"]
        if fn == nil then
            ErrorNoHalt( "Failed to load SSR: init function not found", "\n" )
            return
        end

        fn()

        RunConsoleCommand( "spawnmenu_reload" )
    end,
}