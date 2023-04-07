---@class pet_41_1: eom_ability
pet_41_1 = eom_ability({})
function pet_41_1:GetIntrinsicModifierName()
	return "modifier_pet_41_1"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_41_1 : eom_modifier
modifier_pet_41_1 = eom_modifier({
	Name = "modifier_pet_41_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_41_1:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0)
	end
end
function modifier_pet_41_1:OnIntervalThink()
	if self:GetCaster().GetMaster ~= nil and not self:GetCaster():GetMaster():HasModifier("modifier_pet_41_1_buff") then
		self.hModifier = self:GetCaster():GetMaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pet_41_1_buff", nil)
		self:StartIntervalThink(-1)
	end
end
function modifier_pet_41_1:OnDestroy()
	if IsServer() then
		if IsValid(self.hModifier) then
			self.hModifier:Destroy()
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_41_1_buff : eom_modifier
modifier_pet_41_1_buff = eom_modifier({
	Name = "modifier_pet_41_1_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_41_1_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_pet_41_1_buff:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_pet_41_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_pet_41_1_buff:GetModifierMoveSpeedBonus_Percentage(params)
	return self.movespeed
end