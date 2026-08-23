local MAP = game.GetMap()

local ROOT = file.CurrentDir() .. "maps/doors/"
local FILENAME = MAP .. ".lua"
local FILEPATH = ROOT .. FILENAME

if not file.Exists( FILEPATH, "LUA" ) then return end


local function ResolveEntity(val)
    if isnumber(val) then -- Creation ID
        local msg = "CrID ["..tostring(val).."]"
        local ent = ents.GetMapCreatedEntity(val)

        if not IsValid(ent) then
            return nil, "invalid "..msg
        end

        return {ent}, msg
    elseif isstring(val) then -- Name
        local msg = "name ["..val.."]"
        local entities = ents.FindByName(val)

        if table.IsEmpty(entities) then
            return nil, "nothing matches "..msg
        end

        return entities, msg
    elseif isvector(val) then -- Position
        local msg = "position ["..tostring(val).."]"
        local entities = ents.FindInSphere(val, 0.01)

        if table.IsEmpty(entities) then return nil, "nothing at "..msg end
        return entities, msg
    else
        error("Unsupported type "..type(val))
    end
end

local function ResolveFilterType(val, typefilter)
    local es, err = ResolveEntity(val, typefilter)
    if es == nil then return nil, err end

    local result = {}
    for _, e in ipairs(es) do
        if typefilter[e:GetClass()] then
            table.insert(result, e)
        end
    end

    if table.IsEmpty(es) then
        return nil, "no entities with correct type; "..err
    end

    return result, err
end

local function RunOnArray(array, typefilter, handler, errprefix)
    for _, item in ipairs(array) do
        local subitems, err = ResolveFilterType(item, typefilter)
        if subitems == nil then
            ErrorNoHalt(errprefix,err)
        else
            for _, subitem in ipairs(subitems) do
                handler(subitem)
            end
        end
    end
end

local function RunOnTable(tbl, typefilter, handler, errprefix)
    for item, arg in pairs(tbl) do
        local subitems, err = ResolveFilterType(item, typefilter)
        if subitems == nil then
            ErrorNoHalt(errprefix,err)
        else
            for _, subitem in ipairs(subitems) do
                handler(subitem, arg)
            end
        end
    end
end

local actions = include( FILEPATH )

local DOOR_TYPES = {func_door = true, func_door_rotating = true, prop_door_rotating = true}

local patch = function()
    RunOnArray(actions.unlock_doors or {}, DOOR_TYPES, function(ent)
        ent:AddSpawnFlags(256) -- Use Opens

        if ent:GetClass() == "prop_door_rotating" then
            ent:Fire("Unlock")
        end
    end, "Door fixer: ")

    if actions.specific ~= nil then
        actions.specific()
    end
end

hook.Add( "InitPostEntity", "core.patch.maps.doors", patch )