---@class boss_untouchable: eom_ability
boss_untouchable = eom_ability({})
function boss_untouchable:GetIntrinsicModifierName()
	return "modifier_boss_untouchable"
end
function boss_untouchable:Spawn()
	local iLevel = Load("clotho") or 0
	if IsServer() then
		self:GetCaster():CreatureLevelUp(iLevel)
	end
	CommonSave("clotho", default(iLevel + 1, 1))
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_untouchable : eom_modifier
modifier_boss_untouchable = eom_modifier({
	Name = "modifier_boss_untouchable",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_untouchable:GetAbilitySpecialValue()
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
end
function modifier_boss_untouchable:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = (self.attackspeed or 0) * CommonLoad("clotho"),
	}
end
function modifier_boss_untouchable:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_BONUS = 100000 * CommonLoad("clotho"),
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE = 2000 * CommonLoad("clotho"),
		EOM_MODIFIER_PROPERTY_ARMOR_BASE = 10 * CommonLoad("clotho"),
		MODIFIER_EVENT_ON_ATTACK_START = {nil, self:GetParent() },
	}
end
function modifier_boss_untouchable:OnAttackStart(params)
	params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_boss_untouchable_buff", { duration = 4 })
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_untouchable_buff : eom_modifier
modifier_boss_untouchable_buff = eom_modifier({
	Name = "modifier_boss_untouchable_buff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_untouchable_buff:GetAbilitySpecialValue()
	self.slow_attack_speed = self:GetAbilitySpecialValueFor("slow_attack_speed")
end
function modifier_boss_untouchable_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = -(self.slow_attack_speed or 0) * CommonLoad("clotho"),
	}
end