TOOL.Name = "#tool.unbreakable.name"
TOOL.Category = "Construction"

TOOL.Information = {
    { name = "left" },
    { name = "right" },
    { name = "reload" },
}


local UNBREAKABLE_WHITELIST = {
    ["prop_physics"] = true,
    ["prop_physics_multiplayer"] = true,
    ["prop_physics_override"] = true
}

local function CanBeUnbreakable(ent)
    if not IsValid(ent) then return false end

    return UNBREAKABLE_WHITELIST[ent:GetClass()] == true
end

local SetUnbreakable
if SERVER then
    SetUnbreakable = function( ent, state )
        if state then
            ent:SetVar( "unbreakable", state )
            duplicator.StoreEntityModifier( ent, "Unbreakable", { state } )
        else
            ent:SetVar( "unbreakable", nil )
            duplicator.ClearEntityModifier( ent, "Unbreakable" )
        end
    end

    duplicator.RegisterEntityModifier( "Unbreakable", function( ply, ent, data )
        SetUnbreakable( ent, data[1] )
    end )


    hook.Add( "EntityTakeDamage", "Unbreakable", function( ent, dmgInfo )
        if ent:GetVar( "unbreakable", false ) then return true end
    end )
end


function TOOL:LeftClick( trace )
    local ent = trace.Entity
    if not IsValid( ent ) 
        or not CanBeUnbreakable( ent )
    then return false end

    if SERVER then SetUnbreakable( ent, true ) end

    return true
end

function TOOL:RightClick( trace )
    local ent = trace.Entity
    if not IsValid( ent ) then return false end

    if SERVER then
        for _, e in ipairs( constraint.GetAllConstrainedEntities( ent ) ) do
            if not CanBeUnbreakable( e ) then continue end

            SetUnbreakable( e, true )
        end
    end

    return true
end

function TOOL:Reload( trace )
    local ent = trace.Entity
    if not IsValid( ent ) 
        or not CanBeUnbreakable( ent )
    then return false end

    if SERVER then SetUnbreakable( ent, false ) end

    return true
end

if CLIENT then
    function TOOL.BuildCPanel( cpanel )
        cpanel:Help( "#tool.unbreakable.desc" )
    end
end