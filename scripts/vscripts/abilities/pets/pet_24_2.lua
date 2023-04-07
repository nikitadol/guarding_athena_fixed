---@class pet_24_2: eom_ability
pet_24_2 = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetAutoCastState()
	end
}, nil, ability_base_ai)
function pet_24_2:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function pet_24_2:OnAbilityPhaseStart()
	self:GetCaster():StartGesture(ACT_DOTA_DIE)
	return true
end
function pet_24_2:OnAbilityPhaseInterrupted()
	self:GetCaster():FadeGesture(ACT_DOTA_DIE)
end
function pet_24_2:OnSpellStart()
	self:GetCaster():FadeGesture(ACT_DOTA_DIE)
	local hCaster = self:GetCaster()
	local hMaster = hCaster:GetMaster()
	local flDamage = hMaster:GetPrimaryStats() * self:GetAbilityDamage()
	local radius = self:GetSpecialValueFor("radius")
	local vLocation = hCaster:GetAbsOrigin()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vLocation, radius, self)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, flDamage)
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", { duration = self:GetDuration() * hUnit:GetStatusResistanceFactor() })
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vLocation)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	hCaster:EmitSound("Hero_Zuus.Taunt.Jump")
	self:GetCaster():ForcePlayActivityOnce(ACT_DOTA_SPAWN)
end