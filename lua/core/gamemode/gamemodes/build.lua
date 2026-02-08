local MODE = {
    Name    = "Build",
    Color   = Color(46, 204, 113)
}

MODE.CanTakeDamage = function() return false end

CORE_GAMEMODE_BUILD = core.gamemode.Define( 1, MODE )