_G.HOSTNAME = _G.HOSTNAME or GetHostName()

local IDX_CHAT = 2

local Strings = {
    [1]         = "", -- empty
    [IDX_CHAT]  = "", -- chat last message
    "привет."
}


-- Custom Chat exclusive hook
hook.Add( "PostPlayerSay", "core.hostname", function( ply, text, _, channel, _, proximityMode )
    if not (channel == "global" and proximityMode == nil) then return end

    Strings[IDX_CHAT] = text
end )


timer.Create( "core.hostname", 60 * 3, 0, function()
    local str = table.RandomSeq( Strings )

    local hostname = HOSTNAME
    if str ~= "" then hostname = hostname .. " /// " .. str end

    RunConsoleCommand( "hostname", hostname )

    core.Print( "Changed hostname to \"" .. hostname .. "\"" )
end )