local MAP = game.GetMap()

local ROOT = file.CurrentDir() .. "maps/"
local FILENAME = MAP .. ".lua"

local PATCHES = {}

local function populate( root, filename, fnInclude )
    local filepath = root .. filename
    if not file.Exists( filepath, "LUA" ) then return end

    --[[
        value: function (patch) | string (filename) | MapPatchData | nil

        MapPatchData {
            patch: function
            filename: string | nil     
        }
    --]]
    local value = fnInclude( filepath )
    if value == nil then return end

    if isfunction( value ) then
        table.insert( PATCHES, value )
    else
        populate( root, value .. ".lua", fnInclude )
    end
end

populate( ROOT .. "server/", FILENAME, loader.Server )
populate( ROOT .. "client/", FILENAME, loader.Client )
populate( ROOT, FILENAME, loader.Shared )

if #PATCHES == 0 then return end 


local patch = function()
    for i = 1, #PATCHES do
        local func = PATCHES[i]
        
        if func then
            func()
        end
    end
end

hook.AddOnce( "InitPostEntity", "core.patch.maps", patch )
hook.Add( "PostCleanupMap", "core.patch.maps", patch )