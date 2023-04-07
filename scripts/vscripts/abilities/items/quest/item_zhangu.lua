---@class item_zhangu: eom_ability
item_zhangu = class({})
function item_zhangu:OnSpellStart()
	local hCaster = self:GetCaster()
	local heal_amount = self:GetSpecialValueFor("heal_amount")
	local mana_amount = self:GetSpecialValueFor("mana_amount")
	local duration = self:GetSpecialValueFor("duration")
	hCaster:Heal(heal_amount * self:GetCurrentCharges(), self)
	hCaster:GiveMana(mana_amount * self:GetCurrentCharges())
	hCaster:AddNewModifier(hCaster, self, "modifier_item_zhangu_lifesteal", { duration = duration })
	hCaster:EmitSound("DOTA_Item.DoE.Activate")
end
function item_zhangu:GetIntrinsicModifierName()
	return "modifier_item_zhangu"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_zhangu : eom_modifier
modifier_item_zhangu = eom_modifier({
	Name = "modifier_item_zhangu",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, aura_base)
function modifier_item_zhangu:GetAbilitySpecialValue()
	self.aura_radius = self:GetAbilitySpecialValueFor("radius")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_zhangu_buff : eom_modifier
modifier_item_zhangu_buff = eom_modifier({
	Name = "modifier_item_zhangu_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_item_zhangu_buff:GetAbilitySpecialValue()
	self.bonus_attack = self:GetAbilitySpecialValueFor("bonus_attack")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
end
function modifier_item_zhangu_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.bonus_attack_speed or 0
	}
end
function modifier_item_zhangu_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_PERCENTAGE = self.bonus_attack,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() }
	}
end
function modifier_item_zhangu_buff:OnTakeDamage(params)
	self:GetAbility():SetCurrentCharges(self:GetAbility():GetCurrentCharges() + 1)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_zhangu_lifesteal : eom_modifier
modifier_item_zhangu_lifesteal = eom_modifier({
	Name = "modifier_item_zhangu_lifesteal",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_item_zhangu_lifesteal:GetAbilitySpecialValue()
	self.bonus_lifesteal = self:GetAbilitySpecialValueFor("bonus_lifesteal")
end
function modifier_item_zhangu_lifesteal:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ALL_LIFESTEAL = self.bonus_lifesteal,
	}
end