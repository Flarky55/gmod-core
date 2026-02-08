local ROOT = file.CurrentDir() .. "scripts/"

local is_event_active = function(dateData)
    local date = os.date("*t")
    
    for k, v in pairs(dateData) do
        local current = date[k]
    
        if istable(v) then
            if not math.IsInRange(current, v[1], v[2]) then
                return false
            end
        else
            if current ~= v then
                return false
            end
        end
    end

    return true
end

local SEASONS = {
    -- TODO: block map change when new year's eve
    ["new_year"] = is_event_active({ yday = {365 - 14,  366} }) 
                or is_event_active({ yday = {1,         14} }),

    ["birthday_flarky"] = is_event_active({ month = 4, day = 30 }),
}


local _include = function( path, fnInclude )
    for filepath, filename in file.Iterator( path .. "*.lua", "LUA" ) do
        fnInclude( filepath )
    end
end

for dirname, active in pairs(SEASONS) do
    if not active then continue end

    core.Print( "Loading active season: ", Color(0, 255, 0), dirname, color_white, "!" )

    local path = ROOT .. dirname .. "/"

    _include( path .. "server/", loader.Server )
    _include( path .. "client/", loader.Client )
    _include( path, loader.Shared )
end