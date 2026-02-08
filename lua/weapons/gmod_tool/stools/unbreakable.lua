--[[******************
 *
 *                              Unbreakable STool
 *
 *
 *   Date   : 28  janvier 2007			Date	: 04 December 2013 - 16th June 2015
 *
 *   Auteur : Chaussette™			Author	: XxWestKillzXx + Gui + Sparky
 *
 ******************************************************************************]]


 local UNBREAKABLE_WHITELIST = {
    ["prop_physics"] = true,
    ["prop_physics_multiplayer"] = true,
    ["prop_physics_override"] = true
}

local function CanBeUnbreakable(ent)
    if not IsValid(ent) then return false end

    return UNBREAKABLE_WHITELIST[ent:GetClass()] == true
end




 if (SERVER) then

    -- Comment this line if you don't want to send this stool to clients
    AddCSLuaFile("weapons/gmod_tool/stools/unbreakable.lua")
    local RemakeFilterDamage

    local function MakeFilterDamage()
        local FilterDamage = ents.Create("filter_activator_name")
        FilterDamage:SetKeyValue("TargetName", "FilterDamage")
        FilterDamage:SetKeyValue("negated", "1")
        FilterDamage:Spawn()

        FilterDamage:CallOnRemove("RemakeFilter", function()
            timer.Simple(0, RemakeFilterDamage)
        end)
    end

    RemakeFilterDamage = function()
        MakeFilterDamage()

        for k, v in pairs(ents.GetAll()) do
            if v:GetVar("Unbreakable") then
                v:Fire("SetDamageFilter", "FilterDamage", 0)
            end
        end
    end

    hook.Add("InitPostEntity", "MakeFilterDamage", MakeFilterDamage)

    local function MakeUnbreakable(Element, Value)
        local Filter = ""

        if (Value) then
            Filter = "FilterDamage"
        end

        Element:SetVar("Unbreakable", Value)
        Element:Fire("SetDamageFilter", Filter, 0)

        duplicator.StoreEntityModifier(Element, "Unbreakable", {
            On = Value
        })
    end

    function TOOL:Unbreakable(Element, Value)
        MakeUnbreakable(Element, Value)
    end

    local function dupeUnbreakable(Player, Entity, Data)
        if Data.On and CanBeUnbreakable(Entity) then
            MakeUnbreakable(Entity, true)
        end
    end

    duplicator.RegisterEntityModifier("Unbreakable", dupeUnbreakable)

--[[    function TOOL:Run(Element, Value)
        if not IsValid(Element) then return end
        if not UNBREAKABLE_WHITELIST[Element:GetClass()] then return end


        if (Element:GetVar("Unbreakable") ~= Value) then
            self:Unbreakable(Element, Value)

            if (Element.Constraints) then
                for x, Constraint in pairs(Element.Constraints) do
                    for x = 1, 4 do
                        if (Constraint["Ent" .. x]) then
                            self:Run(Constraint["Ent" .. x], Value)
                        end
                    end
                end
            end
        end
    end]]
end

TOOL.Category = "Constraints"
TOOL.Name = "Unbreakable"
TOOL.Command = nil
TOOL.ConfigName = ""
TOOL.ClientConVar["toggle"] = "1"

if (CLIENT) then
    language.Add("tool.unbreakable.name", "Unbreakable")
    language.Add("tool.unbreakable.desc", "Make a prop unbreakable")
    language.Add("tool.unbreakable.0", "Left click to make a prop unbreakable. Right click to restore its previous settings")
--    language.Add("tool.unbreakable.toggle", "Extend To Constrained Objects")
end

function TOOL:Action(Element, Value)
    if not CanBeUnbreakable(Element) then return false end

    if SERVER then
--        if (self:GetClientNumber("toggle") == 0) then
        self:Unbreakable(Element, Value)
--        else
--            self:Run(Element, Value)
--       end
    end

    return true
end

function TOOL:LeftClick(Target)
    return self:Action(Target.Entity, true)
end

function TOOL:RightClick(Target)
    return self:Action(Target.Entity, false)
end

function TOOL.BuildCPanel(Panel)
    Panel:Help("#tool.unbreakable.name")
    Panel:Help("#tool.unbreakable.desc")
--    Panel:CheckBox("#tool.unbreakable.toggle", "unbreakable_toggle")
end