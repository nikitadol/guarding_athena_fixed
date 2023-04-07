---@class pet_86_1: eom_ability
pet_86_1 = eom_ability({})
function pet_86_1:GetIntrinsicModifierName()
	return "modifier_pet_86_1"
end
function pet_86_1:IsHiddenWhenStolen()
	return false
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_86_1 : eom_modifier
modifier_pet_86_1 = eom_modifier({
	Name = "modifier_pet_86_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_86_1:GetAbilitySpecialValue()
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_pet_86_1:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_pet_86_1:OnIntervalThink()
	if self:GetCaster().GetMaster ~= nil and not self:GetCaster():GetMaster():HasModifier("modifier_pet_86_1_buff") then
		self:GetCaster():GetMaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pet_86_1_buff", { duration = self.duration })
		-- self:StartIntervalThink(-1)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_86_1_buff : eom_modifier
modifier_pet_86_1_buff = eom_modifier({
	Name = "modifier_pet_86_1_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_86_1_buff:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
function modifier_pet_86_1_buff:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	if IsClient() then
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_rabid_buff_speed.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControl(iParticleID, 2, hParent:GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pet_86_1_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end
function modifier_pet_86_1_buff:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end
function modifier_pet_86_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end