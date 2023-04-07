---@class wolf_wound: eom_ability
wolf_wound = eom_ability({})
function wolf_wound:GetIntrinsicModifierName()
	return "modifier_wolf_wound"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wolf_wound : eom_modifier
modifier_wolf_wound = eom_modifier({
	Name = "modifier_wolf_wound",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wolf_wound:GetAbilitySpecialValue()
	self.bonus_reset_time = self:GetAbilitySpecialValueFor("bonus_reset_time")
	self.damage_per_stack = self:GetAbilitySpecialValueFor("damage_per_stack")
end
function modifier_wolf_wound:OnAttackLanded(params)
	local hTarget = params.target
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	hTarget:AddNewModifier(hParent, hAbility, "modifier_wolf_wound_debuff", { duration = 10 })
end
function modifier_wolf_wound:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wolf_wound_debuff : eom_modifier
modifier_wolf_wound_debuff = eom_modifier({
	Name = "modifier_wolf_wound_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wolf_wound_debuff:GetAbilitySpecialValue()
	self.damage_per_stack = self:GetAbilitySpecialValueFor("damage_per_stack")
end
function modifier_wolf_wound_debuff:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_wolf_wound_debuff:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_wolf_wound_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_TARGET
	}
end
function modifier_wolf_wound_debuff:GetModifierPreAttack_BonusDamage_Target()
	return self:GetStackCount() * self.damage_per_stack
end