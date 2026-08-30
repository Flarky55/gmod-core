-- Dynamic Depth of Field (DDOF Shader)
return {
    wsid = "3614258237",
    category = "#optionaladdons.category.shader",
    onLoaded = function()
        local fn = (hook.GetTable()["PostCEFCodecFixStatus"] or {})["GShaderDDoF"]
        if fn == nil then
            ErrorNoHalt( "Failed to load DDOF: init function not found", "\n" )
            return
        end

        fn()

        RunConsoleCommand( "spawnmenu_reload" )
    end,
}