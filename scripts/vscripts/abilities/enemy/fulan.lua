---@class fulan: eom_ability
fulan = eom_ability({})
function fulan:GetIntrinsicModifierName()
	return "modifier_fulan"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_fulan : eom_modifier
modifier_fulan = eom_modifier({
	Name = "modifier_fulan",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, aura_base)
function modifier_fulan:GetAbilitySpecialValue()
	self.aura_radius = self:GetAbilitySpecialValueFor("radius")
end
function modifier_fulan:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/wave_38/undying_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_fulan_buff : eom_modifier
modifier_fulan_buff = eom_modifier({
	Name = "modifier_fulan_buff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_fulan_buff:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_fulan_buff:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_fulan_buff:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	hCaster:DealDamage(hParent, hAbility, self.damage)
end
function modifier_fulan_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT = (self.movespeed or 0)
	}
end