---@class item_ogre_1: eom_ability
item_ogre_1 = class({})
function item_ogre_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function item_ogre_1:OnSpellStart()
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
function item_ogre_1:GetIntrinsicModifierName()
	return "modifier_item_ogre_1"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_ogre_1 : eom_modifier
modifier_item_ogre_1 = eom_modifier({
	Name = "modifier_item_ogre_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_ogre_1:OnCreated(params)
	self.bonus_attack = self:GetAbilitySpecialValueFor("bonus_attack")
end
function modifier_item_ogre_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end
function modifier_item_ogre_1:GetModifierPreAttack_BonusDamage(params)
	return self.bonus_attack
end