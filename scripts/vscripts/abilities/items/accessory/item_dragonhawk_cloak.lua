---@class item_dragonhawk_cloak: eom_ability 龙鹰披风
item_dragonhawk_cloak = class({})
function item_dragonhawk_cloak:GetIntrinsicModifierName()
	return "modifier_item_dragonhawk_cloak"
end
---@class item_dragonhawk_cloak_2: eom_ability 龙鹰披风
item_dragonhawk_cloak_2 = class({}, nil, item_dragonhawk_cloak)
---@class item_dragonhawk_cloak_3: eom_ability 龙鹰披风
item_dragonhawk_cloak_3 = class({}, nil, item_dragonhawk_cloak)
---@class item_dragonhawk_cloak_4: eom_ability 龙鹰披风
item_dragonhawk_cloak_4 = class({}, nil, item_dragonhawk_cloak)
----------------------------------------Modifier----------------------------------------
---@class modifier_item_dragonhawk_cloak : eom_modifier
modifier_item_dragonhawk_cloak = eom_modifier({
	Name = "modifier_item_dragonhawk_cloak",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
}, nil, aura_base)
function modifier_item_dragonhawk_cloak:GetAbilitySpecialValue()
	self.aura_radius = self:GetAbilitySpecialValueFor("radius")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_dragonhawk_cloak_buff : eom_modifier
modifier_item_dragonhawk_cloak_buff = eom_modifier({
	Name = "modifier_item_dragonhawk_cloak_buff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_dragonhawk_cloak_buff:GetAbilitySpecialValue()
	self.bonus_miss = self:GetAbilitySpecialValueFor("bonus_miss")
	self.bonus_movespeed = self:GetAbilitySpecialValueFor("bonus_movespeed")
end
function modifier_item_dragonhawk_cloak_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE = self.bonus_miss or 0,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = self.bonus_movespeed or 0,
	}
end