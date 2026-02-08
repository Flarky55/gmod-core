AddCSLuaFile()

if SERVER then return end

local snow_enabled = CreateClientConVar("snowflakes_enabled", "1", true, false)
local emitter = ParticleEmitter(Vector(), false)

// change grass to snow
local spawned = false
local mat_whitelist = {
	["grass"] = true,
	["dirt"] = true,
	["paper"] = true,
	["antlionsand"] = true,
}
hook.Add("InitPostEntity", "snow_initialize", function()
	for k, v in ipairs(game.GetWorld():GetBrushSurfaces()) do
		local mat = string.lower(v:GetMaterial():GetString("$surfaceprop") or "")
		if mat_whitelist[mat] then
			v:GetMaterial():SetTexture("$basetexture", "nature/snowfloor001a")
			v:GetMaterial():SetTexture("$basetexture2", "nature/snowfloor001a")
			v:GetMaterial():SetVector("$color2", Vector(0.6, 0.6, 0.6))	// snow is kinda bright, tone it down a bit.
		end
	end
	Material("infmap/flatgrass"):SetTexture("$basetexture", "nature/snowfloor001a")
	Material("infmap/flatgrass"):SetVector("$color2", Vector(0.75, 0.75, 0.75))
	spawned = true
end)

hook.Add("Think", "snow_spawn", function()
	if !snow_enabled or !snow_enabled:GetBool() then return end
	if !util.IsSkyboxVisibleFromPoint(EyePos()) then return end
	if !spawned then return end

	for i = 1, 10 do
		local startpos = EyePos() + Vector(math.Rand(-3000, 3000), math.Rand(-3000, 3000), math.Rand(1000, 2000))
		local particle = emitter:Add("particle/particle_glow_04", startpos)
		if particle then
			local tr = util.QuickTrace(startpos, Vector(0, 0, -2000)).HitPos
			local dietime = (startpos[3] - tr[3]) * 0.0035	// weird conversion
			particle:SetDieTime(math.min(dietime, 10)) 
		
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255) 
			particle:SetAirResistance(120)
		
			local flake_size = math.Rand(5, 10)
			particle:SetStartSize(flake_size) 
			particle:SetEndSize(flake_size) 
		
			particle:SetGravity(Vector(0, 0, -600)) 
			particle:SetVelocity(Vector(0, 0, -600))
			particle:SetNextThink(CurTime())
		end
	end
end)

local function calc_fog(mult)
	render.FogStart(0)
	render.FogMaxDensity(1)	// magic numbers that look good
	render.FogColor(240, 240, 240)
	render.FogEnd(20000 * (mult or 1))
	render.FogMode(MATERIAL_FOG_LINEAR)
	return true
end
hook.Add("SetupWorldFog", "!snowfog", calc_fog)
hook.Add("SetupSkyboxFog", "!snowfog", calc_fog)