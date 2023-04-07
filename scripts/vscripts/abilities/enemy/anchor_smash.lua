---@class anchor_smash: eom_ability
anchor_smash = eom_ability({}, nil, ability_base_ai)
function anchor_smash:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function anchor_smash:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local reduction_duration = self:GetSpecialValueFor("reduction_duration")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		hCaster:DealDamage(hUnit, self, damage)
		hUnit:AddNewModifier(hCaster, self, "modifier_anchor_smash", { duration = reduction_duration })
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_anchor_hero.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Tidehunter.AnchorSmash")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_anchor_smash : eom_modifier
modifier_anchor_smash = eom_modifier({
	Name = "modifier_anchor_smash",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_anchor_smash:GetAbilitySpecialValue()
	self.damage_reduction = self:GetAbilitySpecialValueFor("damage_reduction")
end
function modifier_anchor_smash:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_PERCENTAGE = self.damage_reduction
	}
end