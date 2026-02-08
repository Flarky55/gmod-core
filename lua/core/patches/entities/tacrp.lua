local MOD_DAMAGE_MULT = function( mult )
    return function( t )
        t.Damage_Max = t.Damage_Max * mult
        t.Damage_Min = t.Damage_Min * mult
    end
end

local MOD_DAMAGE_HALF = MOD_DAMAGE_MULT( 0.5 )


local MODIFIERS = {
    ["tacrp_ks23"]  = MOD_DAMAGE_HALF,
    ["tacrp_bekas"] = MOD_DAMAGE_HALF,
    ["tacrp_tgs12"] = MOD_DAMAGE_HALF,
}


return function( tbl, class )

    local mod = MODIFIERS[class]
    if mod ~= nil then
        mod( tbl )
    end

end, function( tbl, class ) return class:StartWith("tacrp") end