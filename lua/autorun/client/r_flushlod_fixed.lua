local sHook, sHookName = "RenderScene", "!FlushLod.RenderScene"
local sSayText, nRanTimes = "You ran r_flushlod %s times without a game crashing!\n", 0

local function RunCvarHere()
	RunConsoleCommand( "r_flushlod" )
	nRanTimes = nRanTimes + 1
	Msg( string.format( sSayText, nRanTimes ) )
	hook.Remove( sHook, sHookName )
	return true
end

local function flushlod()
	hook.Add( sHook, sHookName, RunCvarHere )
end

local sHelpText = "Flushes models out of cache ( stable version of r_flushlod )"

concommand.Add( "r_flushlod_fixed", flushlod, nil, sHelpText, FCVAR_DONTRECORD )