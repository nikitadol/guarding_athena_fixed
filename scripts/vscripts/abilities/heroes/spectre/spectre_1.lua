---@class spectre_1 : eom_ability
spectre_1 = eom_ability({})
function spectre_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local distance = self:GetSpecialValueFor("distance")
	local speed = self:GetSpecialValueFor("speed")
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local vDir = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	local hThinker = CreateModifierThinker(hCaster, self, "modifier_spectre_1_thinker", { vStart = hCaster:GetAbsOrigin() }, hCaster:GetAbsOrigin(), hCaster:GetTeamNumber(), false)

	local iParticleID = ProjectileSystem:CreateLinearProjectile({
		hAbility = self,
		hCaster = hCaster,
		sEffectName = "particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger.vpcf",
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		vDirection = vDir,
		iMoveSpeed = speed,
		flDistance = distance,
		flRadius = radius,
		iEntIndex = hThinker:GetEntityIndex()
	})
	-- sound
	hCaster:EmitSound("Hero_Spectre.DaggerCast")
	local hAbility = hCaster:FindAbilityByName("spectre_1_0")
	hAbility:SetLevel(1)
	hAbility.iParticleID = iParticleID
	hAbility.hThinker = hThinker
	hAbility.flDuration = duration
	hCaster:SwapAbilities("spectre_1", "spectre_1_0", false, true)
end
function spectre_1:OnProjectileThink(vLocation, tInfo)
	local hThinker = EntIndexToHScript(tInfo.iEntIndex)
	hThinker:SetAbsOrigin(vLocation)
end
function spectre_1:OnProjectileHit(hTarget, vLocation, tInfo)
	local hCaster = self:GetCaster()
	if IsValid(hTarget) then
		local root_duration = self:GetSpecialValueFor("root_duration")
		local flDamage = self:GetSpecialValueFor("damage")
		hTarget:AddNewModifier(hCaster, self, "modifier_spectre_1_root", { duration = root_duration * hTarget:GetStatusResistanceFactor() })
		hCaster:DealDamage(hTarget, self, flDamage)
		-- sound
		EmitSoundOnLocationWithCaster(vLocation, "Hero_Spectre.DaggerImpact", hCaster)
	end
end
function spectre_1:OnProjectileDestroy(vLocation, tInfo)
	local hCaster = self:GetCaster()
	local hThinker = EntIndexToHScript(tInfo.iEntIndex)
	hCaster:SwapAbilities("spectre_1", "spectre_1_0", true, false)
	hThinker:FindModifierByName("modifier_spectre_1_thinker"):SetDuration(self:GetSpecialValueFor("duration"), false)
end
--Abilities
if spectre_1_0 == nil then
	spectre_1_0 = class({})
end
function spectre_1_0:OnSpellStart()
	local hCaster = self:GetCaster()
	-- hCaster:SwapAbilities("spectre_1", "spectre_1_0", true, false)
	FindClearSpaceForUnit(hCaster, self.hThinker:GetAbsOrigin(), true)
	ProjectileSystem:DestroyProjectile(self.iParticleID)
	self.hThinker:FindModifierByName("modifier_spectre_1_thinker"):SetDuration(self.flDuration, false)
	local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_2_illusion.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Spectre.Reality")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_spectre_1_root : eom_modifier
modifier_spectre_1_root = eom_modifier({
	Name = "modifier_spectre_1_root",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_spectre_1_root:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_willow/dark_willow_bramble_root.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_spectre_1_root:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_spectre_1_thinker : eom_modifier
modifier_spectre_1_thinker = eom_modifier({
	Name = "modifier_spectre_1_thinker",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
}, nil, ModifierThinker)
function modifier_spectre_1_thinker:OnCreated(params)
	if IsServer() then
		self.vStart = self:GetParent():GetAbsOrigin()
		self.radius = self:GetAbilitySpecialValueFor("radius")
		self.flInterval = 0.5
		self.flDamage = self:GetAbilitySpecialValueFor("per_damage") * self.flInterval
		self:StartIntervalThink(self.flInterval)
	end
end
function modifier_spectre_1_thinker:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local vPosition = hParent:GetAbsOrigin()
	local tTargets = FindUnitsInLine(hCaster:GetTeamNumber(), self.vStart, vPosition, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self:GetAbility(), self.flDamage)
		hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_spectre_1_debuff", nil)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_spectre_1_debuff : eom_modifier
modifier_spectre_1_debuff = eom_modifier({
	Name = "modifier_spectre_1_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_spectre_1_debuff:GetAbilitySpecialValue()
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_spectre_1_debuff:OnCreated(params)
	if IsServer() then
		self:SetDuration(0.1, false)
	end
end
function modifier_spectre_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = -(self.movespeed or 0)
	}
end