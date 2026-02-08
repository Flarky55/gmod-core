-- Screen Space Sun Shafts (SSSS Shader)
return {
    wsid = "3647783822",
    category = "#optionaladdons.category.shader",
    onLoaded = function()
        local fn = (hook.GetTable()["PostCEFCodecFixStatus"] or {})["SSSS"]
        if fn == nil then 
            ErrorNoHalt( "Failed to load SSSS: init function not found", "\n" )
            return 
        end

        fn()
        
        RunConsoleCommand( "spawnmenu_reload" )
    end
}