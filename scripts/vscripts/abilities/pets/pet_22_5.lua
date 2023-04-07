---@class pet_22_5: eom_ability
pet_22_5 = eom_ability({})
function pet_22_5:GetIntrinsicModifierName()
	return "modifier_pet_22_5"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_22_5 : eom_modifier
modifier_pet_22_5 = eom_modifier({
	Name = "modifier_pet_22_5",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_22_5:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0)
	end
end
function modifier_pet_22_5:OnIntervalThink()
	if self:GetCaster().GetMaster ~= nil and not self:GetCaster():GetMaster():HasModifier("modifier_pet_22_5_buff") then
		self:GetCaster():GetMaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pet_22_5_buff", nil)
		self:StartIntervalThink(-1)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_22_5_buff : eom_modifier
modifier_pet_22_5_buff = eom_modifier({
	Name = "modifier_pet_22_5_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_22_5_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_pet_22_5_buff:OnCreated(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.health_regen = self:GetAbilitySpecialValueFor("health_regen")
	self.mana_regen = self:GetAbilitySpecialValueFor("mana_regen")
	if IsServer() then
		self:GetParent():AddItemByName("item_essence_str_1")
	end
end
function modifier_pet_22_5_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_pet_22_5_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = self.health_regen,
		EOM_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT = self.mana_regen
	}
end
function modifier_pet_22_5_buff:GetModifierAttackSpeedBonus_Constant(params)
	return self.attackspeed
end
function modifier_pet_22_5_buff:GetModifierMoveSpeedBonus_Constant(params)
	return self.movespeed
end