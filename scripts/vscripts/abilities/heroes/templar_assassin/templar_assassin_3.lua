---@class templar_assassin_3 : eom_ability
templar_assassin_3 = eom_ability({})
function templar_assassin_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local delay = self:GetSpecialValueFor("delay")
	local active_duration = self:GetSpecialValueFor("active_duration")
	hCaster:AddNewModifier(hCaster, self, "modifier_templar_assassin_3_active", { duration = active_duration + delay })
	hCaster:EmitSound("DOTA_Item.AbyssalBlade.Activate")
end
function templar_assassin_3:GetIntrinsicModifierName()
	return "modifier_templar_assassin_3"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_templar_assassin_3 : eom_modifier
modifier_templar_assassin_3 = eom_modifier({
	Name = "modifier_templar_assassin_3",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_templar_assassin_3:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.bonus_attack_range = self:GetAbilitySpecialValueFor("bonus_attack_range")
end
function modifier_templar_assassin_3:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS = self.bonus_attack_range
	}
end
function modifier_templar_assassin_3:OnAttackLanded(params)
	if IsServer() then
		if self:GetParent() == params.attacker and not self:GetParent():PassivesDisabled() then
			local hParent = self:GetParent()
			local hTarget = params.target
			local hAbility = self:GetAbility()
			hTarget:AddNewModifier(hParent, hAbility, "modifier_templar_assassin_3_debuff", { duration = self.duration * hTarget:GetStatusResistanceFactor() })
			local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hTarget:GetAbsOrigin(), hParent, self.radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, true)
			hParent:DealDamage(tTargets, hAbility, self.damage)
			-- particle
			local iParticleID = ParticleManager:CreateParticle("particles/heroes/revelater/revelater_trail_blade_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_templar_assassin_3_debuff : eom_modifier
modifier_templar_assassin_3_debuff = eom_modifier({
	Name = "modifier_templar_assassin_3_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_templar_assassin_3_debuff:GetAbilitySpecialValue()
	self.resistance = self:GetAbilitySpecialValueFor("resistance")
end
function modifier_templar_assassin_3_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = -self.resistance,
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_templar_assassin_3_active : eom_modifier
modifier_templar_assassin_3_active = eom_modifier({
	Name = "modifier_templar_assassin_3_active",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_templar_assassin_3_active:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_templar_assassin_3_active:GetAbilitySpecialValue()
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.damage_tick = self:GetAbilitySpecialValueFor("damage_tick")
	self.active_radius = self:GetAbilitySpecialValueFor("active_radius")
	self.active_duration = self:GetAbilitySpecialValueFor("active_duration")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.scepter_stun_duration = self:GetAbilitySpecialValueFor("scepter_stun_duration")
end
function modifier_templar_assassin_3_active:OnCreated(params)
	if IsServer() then
		self.bActived = false
		self:StartIntervalThink(self.delay)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/revelater/revelater_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/revelater/revelater_trail_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.active_duration, self.delay, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_templar_assassin_3_active:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		if self.bActived == false then
			self.bActived = true
			self:StartIntervalThink(self.damage_tick)
			hParent:EmitSound("DOTA_Item.BladeMail.Activate")
		end
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.active_radius, hAbility)
		for _, hUnit in pairs(tTargets) do
			hParent:DealDamage(hUnit, hAbility, self.damage)
			if hParent:GetScepterLevel() >= 1 then
				hUnit:AddNewModifier(hParent, hAbility, "modifier_stunned", { duration = self.scepter_stun_duration * hUnit:GetStatusResistanceFactor() })
			end
			hUnit:AddNewModifier(hParent, hAbility, "modifier_templar_assassin_3_debuff", { duration = self.duration * hUnit:GetStatusResistanceFactor() })
		end
	end
end