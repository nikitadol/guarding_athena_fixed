---@class elite_34_3: eom_ability
elite_34_3 = eom_ability({})
function elite_34_3:GetIntrinsicModifierName()
	return "modifier_elite_34_3"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_34_3 : eom_modifier
modifier_elite_34_3 = eom_modifier({
	Name = "modifier_elite_34_3",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_34_3:GetAbilitySpecialValue()
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_elite_34_3:OnAttackLanded(params)
	params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_elite_34_3_buff", { duration = self.stun_duration + self.duration })
end
function modifier_elite_34_3:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_34_3_buff : eom_modifier
modifier_elite_34_3_buff = eom_modifier({
	Name = "modifier_elite_34_3_buff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_34_3_buff:GetAbilitySpecialValue()
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
end
function modifier_elite_34_3_buff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = self:GetElapsedTime() < self.stun_duration and true or false
	}
end
function modifier_elite_34_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
end
function modifier_elite_34_3_buff:GetModifierAttackSpeedBonus_Constant()
	return -1000
end
function modifier_elite_34_3_buff:GetModifierMoveSpeed_Absolute()
	return 100
end