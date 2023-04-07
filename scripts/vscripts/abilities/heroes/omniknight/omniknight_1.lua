---@class omniknight_1 : eom_ability
omniknight_1 = eom_ability({})
function omniknight_1:GetCooldown(iLevel)
	local hCaster = self:GetCaster()
	if hCaster:HasModifier("modifier_omniknight_2_aura") then
		return self.BaseClass.GetCooldown(self, iLevel) * 0.5
	end
	return self.BaseClass.GetCooldown(self, iLevel)
end
function omniknight_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hAbility = hCaster:FindAbilityByName("omniknight_0")
	local vLocation = hCaster:GetAbsOrigin()
	local radius = self:GetSpecialValueFor("radius")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local damage_increase_pct = self:GetSpecialValueFor("damage_increase_pct")
	local damage = self:GetSpecialValueFor("base_damage")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vLocation, radius, hAbility)
	for _, hUnit in pairs(tTargets) do
		local flDamage = damage * (1 + (hUnit:HasModifier("modifier_omniknight_1_debuff") and hUnit:FindModifierByName("modifier_omniknight_1_debuff"):GetStackCount() * damage_increase_pct * 0.01 or 0))
		hCaster:DealDamage(hUnit, hAbility, flDamage)
		hAbility:ThunderPower(hUnit)
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", { duration = stun_duration * hUnit:GetStatusResistanceFactor() })
		-- 雷霆战士皮肤
		if hCaster:HasModifier("modifier_omniknight_01") then
			hUnit:AddNewModifier(hCaster, self, "modifier_omniknight_1_debuff", { duration = stun_duration * hUnit:GetStatusResistanceFactor() })
		end
	end
	-- particle
	ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_omniknight/omniknight_1.vpcf", hCaster), PATTACH_ABSORIGIN, hCaster)
	-- sound
	hCaster:EmitSound("n_creep_Thunderlizard_Big.Stomp")
end
function omniknight_1:OnScepterLevelup(iLevel)
	if iLevel == 1 then
		self:SetMaxCharges(self:GetSpecialValueFor("scepter_charges"))
	end
end
function omniknight_1:OnScepterRemove(iLevel)
	self:SetMaxCharges(KeyValues.AbilitiesKv[self:GetAbilityName()].CustomAbilityCharges)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_omniknight_1_debuff : eom_modifier
modifier_omniknight_1_debuff = eom_modifier({
	Name = "modifier_omniknight_1_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_omniknight_1_debuff:OnCreated(params)
	if not IsServer() then return end
	self:IncrementStackCount()
end
function modifier_omniknight_1_debuff:OnRefresh(params)
	self:OnCreated(params)
end