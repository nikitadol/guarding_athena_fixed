---@class bomb_suicide: eom_ability
bomb_suicide = eom_ability({})
function bomb_suicide:GetIntrinsicModifierName()
	return "modifier_bomb_suicide"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_bomb_suicide : eom_modifier
modifier_bomb_suicide = eom_modifier({
	Name = "modifier_bomb_suicide",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_bomb_suicide:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
function modifier_bomb_suicide:OnDeath(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
	hParent:DealDamage(tTargets, hAbility, self.damage, DAMAGE_TYPE_MAGICAL)
	hParent:EmitSound("Hero_Techies.Suicide.Arcana")
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_suicide.vpcf", PATTACH_ABSORIGIN, hParent)
	ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 3, hParent:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
function modifier_bomb_suicide:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent() }
	}
end