---@class item_ogre_4: eom_ability
item_ogre_4 = class({})
function item_ogre_4:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function item_ogre_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local duration = self:GetSpecialValueFor("duration")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, radius, self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", { duration = duration * hUnit:GetStatusResistanceFactor() })
		hCaster:DealDamage(hUnit, self, damage)
	end
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(400, 400, 400))
	-- sound
	hCaster:EmitSound("n_creep_Thunderlizard_Big.Stomp")
end