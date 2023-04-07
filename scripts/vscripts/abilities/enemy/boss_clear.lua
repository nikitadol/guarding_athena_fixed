---@class boss_clear: eom_ability
boss_clear = eom_ability({})
function boss_clear:GetIntrinsicModifierName()
	return "modifier_boss_clear"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_clear : eom_modifier
modifier_boss_clear = eom_modifier({
	Name = "modifier_boss_clear",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_clear:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_boss_clear:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_boss_clear_buff", { duration = self.duration })
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_clear_buff : eom_modifier
modifier_boss_clear_buff = eom_modifier({
	Name = "modifier_boss_clear_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_clear_buff:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0)
		self:OnIntervalThink()
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss_clear.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_ABSORIGIN_FOLLOW, "", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_boss_clear_buff:OnIntervalThink()
	self:GetParent():Purge(false, true, false, true, true)
end