---@class phantom_assassin_1: eom_ability
phantom_assassin_1 = eom_ability({})
function phantom_assassin_1:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:StartGesture(ACT_DOTA_SPAWN)
	local damage = self:GetSpecialValueFor("damage")
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local cooldown_pct = self:GetSpecialValueFor("cooldown_pct")
	local bScepter = hCaster:GetScepterLevel() >= 2
	local hAbility = hCaster:FindAbilityByName("phantom_assassin_3")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		hCaster:DealDamage(hUnit, self, damage)
		if bScepter then
			hAbility:OnSpellStart(hUnit)
		end
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", { duration = FrameTime() })
		hUnit:AddNewModifier(hCaster, self, "modifier_phantom_assassin_1", { duration = duration })
		if not hUnit:IsAlive() then
			local flCooldownRemaining = self:GetCooldownTimeRemaining()
			self:EndCooldown()
			self:StartCooldown(flCooldownRemaining * (1 - cooldown_pct * 0.01))
		end
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_1.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_PhantomAssassin.CoupDeGrace")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_phantom_assassin_1 : eom_modifier
modifier_phantom_assassin_1 = eom_modifier({
	Name = "modifier_phantom_assassin_1",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_phantom_assassin_1:GetAbilitySpecialValue()
	self.reduce_pct = self:GetAbilitySpecialValueFor("reduce_pct")
end
function modifier_phantom_assassin_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = -(self.reduce_pct or 0),
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = -(self.reduce_pct or 0)
	}
end