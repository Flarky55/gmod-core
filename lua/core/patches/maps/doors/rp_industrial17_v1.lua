local doors = {
    -- door names and button map creation IDs
    {"warehouse_door3", 5340},
    {"warehouse_door4", 4588},
    {"warehouse_door5", 4587},
    {"warehouse_door6", 4935},
    {"warehouse_door7", 4589},
    --{"warehouse_door8", 4590, broken = true}, -- The broken door
}

return {
    unlock_doors = { 
        3302,
        5385,
        2542,
        2543,
        5422,
        5106,
        5307,
        6116,
        5306,
        1902,
        2140,
        5393,
        3105,
        4493,
        3905,
        1672,
        1676,
        3106,
        3759,
        3758,
        4065,
        4064,
        3415,
        4907,
        5555
    },
    specific = function()
        for _, pair in ipairs(doors) do
            local doorname = pair[1]
            local door = ents.FindByName(doorname)
            assert(#door == 1 and door[1]:GetClass() == "func_door")
            door = door[1]

            local button_mcrid = pair[2]
            local button = ents.GetMapCreatedEntity(button_mcrid)
            assert(IsValid(button) and button:GetClass() == "func_button")

            
            door:AddSpawnFlags(32) -- Toggle
            button:AddSpawnFlags(32) -- Toggle
            button:SetKeyValue("wait", 0) -- Remove press delay

            button:ClearAllOutputs()
            button:Fire("AddOutput", "OnIn "..doorname..":Open::0:-1")
            button:Fire("AddOutput", "OnOut "..doorname..":Close::0:-1")
        end
    end
}