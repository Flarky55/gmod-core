if render.GetHDREnabled() then return end


local dirs = {"lf", "ft", "rt", "bk", "dn", "up"}

local sky_current = "skybox/" .. GetConVar("sv_skyname"):GetString()
local sky_replacement = "skybox/sky_day01_06"

for _, dir in ipairs(dirs) do
    Material(sky_current .. dir):SetTexture("$basetexture", Material(sky_replacement .. dir):GetTexture("$basetexture"))
end