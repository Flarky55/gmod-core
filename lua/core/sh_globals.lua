local MAPTAG_CITY   = { Name = "#core.maptag.city",     Color = Color( 52, 73, 94 ) }
local MAPTAG_SNOW   = { Name = "#core.maptag.snow",     Color = color_white }
local MAPTAG_DAY    = { Name = "#core.maptag.day",      Color = Color( 241, 196, 15 ) }
local MAPTAG_NIGHT  = { Name = "#core.maptag.night",    Color = Color( 44, 62, 80 ) }

local MAPTAG_HALFLIFE = { Name = "Half-Life", Color = Color( 230, 126, 34 ) }

list.Set( "MapTags", "gm_balkans_snow",         { MAPTAG_SNOW } )
list.Set( "MapTags", "gm_vyten",                { MAPTAG_SNOW } )
list.Set( "MapTags", "gm_boreas",               { MAPTAG_SNOW } )
list.Set( "MapTags", "gm_christruct",           { MAPTAG_SNOW } )
list.Set( "MapTags", "gm_christruct_noice",     { MAPTAG_SNOW } )
list.Set( "MapTags", "gm_frozen_lake",          { MAPTAG_SNOW, MAPTAG_DAY } )
list.Set( "MapTags", "gm_frozen_lake_night",    { MAPTAG_SNOW, MAPTAG_NIGHT } )

list.Set( "MapTags", "gm_bigcity_improved",     { MAPTAG_CITY } )
list.Set( "MapTags", "gm_bigcity_winter_day",   { MAPTAG_CITY, MAPTAG_SNOW, MAPTAG_DAY } )
list.Set( "MapTags", "gm_bigcity_winter",       { MAPTAG_CITY, MAPTAG_SNOW, MAPTAG_NIGHT } )

list.Set( "MapTags", "rp_industrial17_v1",  { MAPTAG_HALFLIFE } )
list.Set( "MapTags", "rp_city8_edit_v3b",   { MAPTAG_HALFLIFE } )


player_manager.AddValidDescription( "default", "Default" )