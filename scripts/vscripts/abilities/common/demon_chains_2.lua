---@class demon_chains_2: eom_ability
demon_chains_2 = eom_ability({})
function demon_chains_2:GetIntrinsicModifierName()
	return "modifier_demon_chains_2"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_demon_chains_2 : eom_modifier
modifier_demon_chains_2 = eom_modifier({
	Name = "modifier_demon_chains_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, aura_base)
function modifier_demon_chains_2:GetAbilitySpecialValue()
	self.aura_radius = self:GetAbilitySpecialValueFor("radius")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_demon_chains_2_buff : eom_modifier
modifier_demon_chains_2_buff = eom_modifier({
	Name = "modifier_demon_chains_2_buff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_demon_chains_2_buff:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_demon_chains_2_buff:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_demon_chains_2_buff:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	hCaster:DealDamage(hParent, hAbility, hCaster:GetSummoner():GetPrimaryStats() * self.damage, DAMAGE_TYPE_MAGICAL)
end