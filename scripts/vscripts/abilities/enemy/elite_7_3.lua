---@class elite_7_3: eom_ability
elite_7_3 = eom_ability({}, nil, ability_base_ai)
function elite_7_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	CreateModifierThinker(hCaster, self, "modifier_elite_7_3", { duration = self:GetDuration() }, vPosition, hCaster:GetTeamNumber(), false)
	hCaster:EmitSound("Hero_Warlock.elite_7_3")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_7_3 : eom_modifier
modifier_elite_7_3 = eom_modifier({
	Name = "modifier_elite_7_3",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, ModifierThinker)
function modifier_elite_7_3:IsAura()
	return true
end
function modifier_elite_7_3:GetAuraRadius()
	return self.radius
end
function modifier_elite_7_3:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_elite_7_3:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_elite_7_3:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_elite_7_3:GetModifierAura()
	return "modifier_elite_7_3_debuff"
end
function modifier_elite_7_3:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_upheaval.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 1, 1))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_elite_7_3:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_7_3_debuff : eom_modifier
modifier_elite_7_3_debuff = eom_modifier({
	Name = "modifier_elite_7_3_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_7_3_debuff:OnCreated(params)
	self.max_slow = self:GetAbilitySpecialValueFor("max_slow")
	self.tick_time = 0.1
	if IsServer() then
		self:StartIntervalThink(self.tick_time)
	end
end
function modifier_elite_7_3_debuff:OnRefresh(params)
	self.max_slow = self:GetAbilitySpecialValueFor("max_slow")
	if IsServer() then
	end
end
function modifier_elite_7_3_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_elite_7_3_debuff:OnIntervalThink()
	self:IncrementStackCount()
end
function modifier_elite_7_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_elite_7_3_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self.max_slow * self:GetStackCount() / 60
end