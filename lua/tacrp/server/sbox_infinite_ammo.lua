-- FIXME: not working at all  
local CVAR_SBOX, CVAR_TACRP = GetConVar( "sbox_infinite_ammo" ), TacRP.ConVars["infiniteammo"]

cvars.AddChangeCallback( CVAR_SBOX:GetName(), function( _, _, value )
    CVAR_TACRP:SetInt( value )
end, "TacRP" )