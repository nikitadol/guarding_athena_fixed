---@class troll_knockback: eom_ability
troll_knockback = eom_ability({})
function troll_knockback:GetIntrinsicModifierName()
	return "modifier_troll_knockback"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_troll_knockback : eom_modifier
modifier_troll_knockback = eom_modifier({
	Name = "modifier_troll_knockback",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_troll_knockback:GetAbilitySpecialValue()
	self.stun = self:GetAbilitySpecialValueFor("stun")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_troll_knockback:OnAttackLanded(params)
	if PRD(self, self.stun, "modifier_troll_knockback") then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		params.target:AddNewModifier(hParent, hAbility, BUILT_IN_MODIFIER.STUNNED, { duration = 0.2 })
		params.target:AddNewModifier(hParent, hAbility, "modifier_troll_knockback_buff", { duration = self.duration })
		hParent:DealDamage(params.target, hAbility, self.damage)
	end
end
function modifier_troll_knockback:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_troll_knockback_buff : eom_modifier
modifier_troll_knockback_buff = eom_modifier({
	Name = "modifier_troll_knockback_buff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_troll_knockback_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE = -80
	}
end