---@class boss_epicenter: eom_ability
boss_epicenter = eom_ability({}, nil, ability_base_ai)
function boss_epicenter:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function boss_epicenter:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	hCaster:AddNewModifier(hCaster, self, "modifier_boss_epicenter", { duration = 2.13 + 9 })
	hCaster:EmitSound("Ability.SandKing_Epicenter.spell")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_epicenter : eom_modifier
modifier_boss_epicenter = eom_modifier({
	Name = "modifier_boss_epicenter",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_epicenter:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_boss_epicenter:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(2.13)
	end
end
function modifier_boss_epicenter:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION = ACT_DOTA_OVERRIDE_ABILITY_4
	}
end
function modifier_boss_epicenter:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		hParent:AddNewModifier(hParent, hAbility, "modifier_boss_epicenter_buff", { duration = 3 })
		self:StartIntervalThink(3)
		hParent:EmitSound("Ability.SandKing_Epicenter")
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_epicenter_buff : eom_modifier
modifier_boss_epicenter_buff = eom_modifier({
	Name = "modifier_boss_epicenter_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_epicenter_buff:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
function modifier_boss_epicenter_buff:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0.5)
		self:OnIntervalThink()
	end
end
function modifier_boss_epicenter_buff:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
		---@param hUnit CDOTA_BaseNPC
		for _, hUnit in ipairs(tTargets) do
			hParent:DealDamage(hUnit, hAbility, self.damage)
			hUnit:AddNewModifier(hParent, hAbility, "modifier_boss_epicenter_debuff", { duration = 3 })
		end
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_epicenter_debuff : eom_modifier
modifier_boss_epicenter_debuff = eom_modifier({
	Name = "modifier_boss_epicenter_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_epicenter_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = -50,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = -50,
	}
end