---@class slardar_run: eom_ability
slardar_run = eom_ability({})
function slardar_run:GetIntrinsicModifierName()
	return "modifier_slardar_run"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_slardar_run : eom_modifier
modifier_slardar_run = eom_modifier({
	Name = "modifier_slardar_run",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_slardar_run:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_slardar_run:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_sprint_river.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_slardar_run:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT = 1,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX = 800,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS = "sprint"
	}
end