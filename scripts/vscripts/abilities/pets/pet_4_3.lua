---@class pet_4_3: eom_ability
pet_4_3 = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetAutoCastState()
	end
}, nil, ability_base_ai)
function pet_4_3:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function pet_4_3:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_pet_4_3", nil)
end
function pet_4_3:OnChannelFinish(bInterrupted)
	local hCaster = self:GetCaster()
	hCaster:RemoveModifierByName("modifier_pet_4_3")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_4_3 : eom_modifier
modifier_pet_4_3 = eom_modifier({
	Name = "modifier_pet_4_3",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_4_3:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.explosion_radius = self:GetAbilitySpecialValueFor("explosion_radius")
	self.explosion_interval = self:GetAbilitySpecialValueFor("explosion_interval")
	self.slow_duration = self:GetAbilitySpecialValueFor("slow_duration")
	self.explosion_min_dist = self.explosion_radius
	self.explosion_max_dist = self.radius - self.explosion_radius
	if IsServer() then
		local hParent = self:GetParent()
		self.flDamage = hParent:GetMaster():GetPrimaryStats() * self:GetAbility():GetAbilityDamage()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, iParticleID)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius + self.explosion_radius, self.radius + self.explosion_radius))
		self:AddParticle(iParticleID, false, false, -1, false, false)

		hParent:EmitSound("hero_Crystal.freezingField.wind")

		self.count = 0
		self:StartIntervalThink(self.explosion_interval)
	end
end
function modifier_pet_4_3:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_pet_4_3:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("hero_Crystal.freezingField.wind")
	end
end
function modifier_pet_4_3:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local radian = math.rad(self.count * 90 + RandomFloat(0, 90))
		local distance = RandomFloat(self.explosion_min_dist, self.explosion_max_dist)
		local vPosition = GetGroundPosition(hParent:GetAbsOrigin() + Rotation2D(Vector(1, 0, 0), radian) * distance, hParent)

		local tTargets = FindUnitsInRadiusWithAbility(hParent, vPosition, self.explosion_radius, hAbility)
		hParent:DealDamage(tTargets, hAbility, self.flDamage)

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
		ParticleManager:ReleaseParticleIndex(iParticleID)

		EmitSoundOnLocationWithCaster(vPosition, "hero_Crystal.freezingField.explosion", hParent)

		local tTargets = FindUnitsInRadiusWithAbility(hParent, vPosition, self.radius, hAbility)
		for _, hUnit in pairs(tTargets) do
			hUnit:AddNewModifier(hParent, hAbility, "modifier_pet_4_3_slow", { duration = self.slow_duration * hUnit:GetStatusResistanceFactor() })
		end

		self.count = self.count + 1
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_4_3_slow : eom_modifier
modifier_pet_4_3_slow = eom_modifier({
	Name = "modifier_pet_4_3_slow",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_4_3_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end
function modifier_pet_4_3_slow:StatusEffectPriority()
	return 10
end
function modifier_pet_4_3_slow:OnCreated(params)
	self.movespeed_slow = self:GetAbilitySpecialValueFor("movespeed_slow")
	self.attack_slow = self:GetAbilitySpecialValueFor("attack_slow")
end
function modifier_pet_4_3_slow:OnRefresh(params)
	self.movespeed_slow = self:GetAbilitySpecialValueFor("movespeed_slow")
	self.attack_slow = self:GetAbilitySpecialValueFor("attack_slow")
end
function modifier_pet_4_3_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_pet_4_3_slow:GetModifierMoveSpeedBonus_Percentage(params)
	return self.movespeed_slow
end
function modifier_pet_4_3_slow:GetModifierAttackSpeedBonus_Constant(params)
	return self.attack_slow
end