---@class elite_33_3: eom_ability
elite_33_3 = eom_ability({}, nil, ability_base_ai)
function elite_33_3:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function elite_33_3:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_elite_33_3", { duration = self:GetDuration() })
	hCaster:EmitSound("Hero_NagaSiren.SongOfTheSiren")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_33_3 : eom_modifier
modifier_elite_33_3 = eom_modifier({
	Name = "modifier_elite_33_3",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_33_3:IsAura()
	return true
end
function modifier_elite_33_3:GetAuraRadius()
	return self.radius
end
function modifier_elite_33_3:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_elite_33_3:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_elite_33_3:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_elite_33_3:GetModifierAura()
	return "modifier_elite_33_3_debuff"
end
function modifier_elite_33_3:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_siren_song_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_33_3_debuff : eom_modifier
modifier_elite_33_3_debuff = eom_modifier({
	Name = "modifier_elite_33_3_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_33_3_debuff:OnCreated(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
end
function modifier_elite_33_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_elite_33_3_debuff:GetModifierAttackSpeedBonus_Constant()
	return -self.attackspeed
end
function modifier_elite_33_3_debuff:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true
	}
end