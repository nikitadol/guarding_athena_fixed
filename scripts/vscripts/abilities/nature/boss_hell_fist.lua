---@class boss_hell_fist: eom_ability
boss_hell_fist = eom_ability({}, nil, ability_base_ai)
function boss_hell_fist:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local damage_percent = self:GetSpecialValueFor("damage_percent")
	hTarget:AddNewModifier(hCaster, self, "modifier_boss_hell_fist", { duration = duration })
	hTarget:AddNewModifier(hCaster, self, BUILT_IN_MODIFIER.STUNNED, { duration = stun_duration })
	hCaster:DealDamage(hTarget, self, hTarget:GetCustomMaxHealth() * damage_percent * 0.01)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_infernal_blade.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_hell_fist : eom_modifier
modifier_boss_hell_fist = eom_modifier({
	Name = "modifier_boss_hell_fist",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = true,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_hell_fist:GetAbilitySpecialValue()
	self.damage_per_second = self:GetAbilitySpecialValueFor("damage_per_second")
end
function modifier_boss_hell_fist:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", PATTACH_ABSORIGIN, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff.vpcf", PATTACH_ABSORIGIN, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_boss_hell_fist:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		hCaster:DealDamage(hParent, hAbility, self.damage_per_second)
	end
end
function modifier_boss_hell_fist:OnDestroy()
	if IsServer() then
	end
end
function modifier_boss_hell_fist:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_HEALING = 1
	}
end