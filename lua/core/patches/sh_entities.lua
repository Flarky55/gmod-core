local ROOT = file.CurrentDir() .. "entities/"

local PATCHES, PATCHES_DYNAMIC = {}, {}

local function populate( path, fnInclude )
    for filepath, filename in file.Iterator( path .. "*.lua", "LUA" ) do
        --[[
            value1: function (patch) | EntityPatchData

            value2: function (checkclass) | table (classnames) | nil

            EntityPatchData {
                patch: function
                classnames: table(string) | nil
            }
        --]]
        local value1, value2 = fnInclude( filepath )
        if value1 == nil then
            ErrorNoHalt( string.format( "Failed to include entity patch script '%s' (%s): no value was returned", filename, filepath ), "\n" )
            continue
        end

        if value2 == nil then
            local class = string.StripExtension( filename )

            PATCHES[class] = value1
        else
            if isfunction( value2 ) then
                table.insert( PATCHES_DYNAMIC, { checkclass = value2, func = value1 } )
            else
                -- expect table
                for _, classname in ipairs( value2 ) do
                    PATCHES[classname] = value1
                end
            end
        end
    end
end

populate( ROOT .. "server/", loader.Server )
populate( ROOT .. "client/", loader.Client )
populate( ROOT, loader.Shared )

local PATCHES_DYNAMIC_COUNT = #PATCHES_DYNAMIC


local patch = function( tbl, class )
    for i = 1, PATCHES_DYNAMIC_COUNT do
        local data = PATCHES_DYNAMIC[i]
        
        if data.checkclass( tbl, class ) then
            data.func( tbl, class )    
        end
    end

    local func = PATCHES[class]
    if func ~= nil then 
        func( tbl, class )
    end
end

hook.Add( "PreRegisterSENT", "core.patch", patch )
hook.Add( "PreRegisterSWEP", "core.patch", patch )