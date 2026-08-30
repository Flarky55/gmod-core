_G.HOSTNAME = _G.HOSTNAME or GetHostName()

local IDX_EMPTY, IDX_CHAT = 1, 2

local Strings = {
    [IDX_EMPTY] = "", -- empty
    [IDX_CHAT]  = "", -- chat last message
    "привет.",
    function() return string.format( "количество смен карты: %i", game.GetMapChangeCount() ) end
}


-- Custom Chat exclusive hook
hook.Add( "PostPlayerSay", "core.hostname", function( ply, text, _, channel, _, proximityMode )
    if not (channel == "global" and proximityMode == nil) then return end

    Strings[IDX_CHAT] = ply:Name() .. ": " .. text
end )


timer.Create( "core.hostname", 60 * 3, 0, function()
    local str = table.RandomSeq( Strings )

    local hostname = HOSTNAME
    if str ~= "" then
        if isfunction( str ) then str = str() end

        hostname = hostname .. " /// " .. str
    end

    RunConsoleCommand( "hostname", hostname )

    core.Msg( "Changed hostname to \"" .. hostname .. "\"" )
end )