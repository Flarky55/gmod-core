
AddCSLuaFile()

SWEP.Base = "weapon_medkit"

SWEP.PrintName = "Armor Kit"
SWEP.Author = "Flarky"
SWEP.Purpose = "Charge other people's HEV with primary attack, charge yours with secondary attack."

SWEP.Spawnable = true

SWEP.HealSound = Sound( "ItemBattery.Touch" )
SWEP.DenySound = Sound( "SuitRecharge.Deny" )

function SWEP:DoHeal( ent )

	local amount = self.HealAmount

	if ( !self:CanHeal( ent ) ) then self:HealFail( ent ) return false end

	local armor, maxarmor = ent:Armor(), ent:GetMaxArmor()
	if ( armor >= maxarmor ) then self:HealFail( ent ) return false end

	-- Check regen right before we access the clip
	-- to make sure we're up to date
	self:Regen( true )

	local healamount = self.HealAmount

	-- No support for "damage kits"
	if ( healamount > 0 ) then
		healamount = math.min( maxarmor - armor, healamount )
		local ammo = self:Clip1()
		if ( ammo < healamount ) then self:HealFail( ent ) return false end

		-- Heal ent
		self:SetClip1( ammo - healamount )
		if SERVER then 
			ent:SetArmor( armor + healamount )
		end
	else
		healamount = 0
	end

	self:HealSuccess( ent, healamount )

	return true

end