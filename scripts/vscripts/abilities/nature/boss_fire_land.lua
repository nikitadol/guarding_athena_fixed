---@class boss_fire_land: eom_ability
boss_fire_land = eom_ability({})
function boss_fire_land:GetIntrinsicModifierName()
	return "modifier_boss_fire_land"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_fire_land : eom_modifier
modifier_boss_fire_land = eom_modifier({
	Name = "modifier_boss_fire_land",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_fire_land:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.heal = self:GetAbilitySpecialValueFor("heal")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_boss_fire_land:OnAttackLanded(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local hTarget = params.target
	if (hParent == hTarget and PRD(self, self.chance, "modifier_boss_fire_land")) or (hParent == params.attacker and PRD(self, self.chance * 0.5, "modifier_boss_fire_land")) then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
		---@param hUnit CDOTA_BaseNPC
		for _, hUnit in ipairs(tTargets) do
			hUnit:AddNewModifier(hParent, hAbility, "modifier_stunned", { duration = self.duration })
			hParent:DealDamage(hUnit, hAbility, self.damage)
		end
		hParent:Heal(self.heal, hAbility)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", PATTACH_ABSORIGIN, hParent)
		hParent:EmitSound("n_creep_Thunderlizard_Big.Stomp")
	end
end
function modifier_boss_fire_land:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent(), self:GetParent() },
	}
end