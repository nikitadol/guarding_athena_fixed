---@class pet_44_2: eom_ability
pet_44_2 = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetAutoCastState()
	end
}, nil, ability_base_ai)
function pet_44_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hMaster = hCaster:GetMaster()
	hMaster:AddNewModifier(hCaster, self, "modifier_pet_44_2_buff", { duration = self:GetDuration() })
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_44_2_buff : eom_modifier
modifier_pet_44_2_buff = eom_modifier({
	Name = "modifier_pet_44_2_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_44_2_buff:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	if IsClient() then
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_sprint.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pet_44_2_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end
function modifier_pet_44_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end