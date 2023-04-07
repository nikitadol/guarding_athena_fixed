---@class pet_9_3: eom_ability
pet_9_3 = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetAutoCastState()
	end
}, nil, ability_base_ai)
function pet_9_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local hMaster = hCaster:GetMaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_pet_9_3", { duration = self:GetDuration() })
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_9_3 : eom_modifier
modifier_pet_9_3 = eom_modifier({
	Name = "modifier_pet_9_3",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_9_3:OnCreated(params)
	if IsServer() then
		self.flDamage = self:GetCaster():GetMaster():GetPrimaryStats() * self:GetAbilityDamage()
		self:StartIntervalThink(1)
		self:GetParent():EmitSound("Hero_DoomBringer.Doom")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pet_9_3:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_DoomBringer.Doom")
	end
end
function modifier_pet_9_3:OnIntervalThink()
	self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), self.flDamage)
end
function modifier_pet_9_3:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
end