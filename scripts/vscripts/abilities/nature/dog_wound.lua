---@class dog_wound: eom_ability
dog_wound = eom_ability({})
function dog_wound:GetIntrinsicModifierName()
	return "modifier_dog_wound"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_dog_wound : eom_modifier
modifier_dog_wound = eom_modifier({
	Name = "modifier_dog_wound",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_dog_wound:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_dog_wound:OnAttackLanded(params)
	local hParent = self:GetParent()
	local hTarget = params.target
	local hAbility = self:GetAbility()
	hParent:Heal(self.damage, hAbility)
	hParent:DealDamage(hTarget, hAbility, self.damage, DAMAGE_TYPE_PURE)
	hTarget:AddNewModifier(hParent, hAbility, "modifier_dog_wound_debuff", { duration = duration })
	hParent:EmitSound("Item_Desolator.Target")
end
function modifier_dog_wound:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = 50
	}
end
function modifier_dog_wound:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_dog_wound_debuff : eom_modifier
modifier_dog_wound_debuff = eom_modifier({
	Name = "modifier_dog_wound_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_dog_wound_debuff:GetAbilitySpecialValue()
	self.armor_reduce = self:GetAbilitySpecialValueFor("armor_reduce")
end
function modifier_dog_wound_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = -self.armor_reduce
	}
end