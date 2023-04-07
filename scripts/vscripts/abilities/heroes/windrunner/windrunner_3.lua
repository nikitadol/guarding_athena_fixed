---@class windrunner_3 : eom_ability
windrunner_3 = eom_ability({})
function windrunner_3:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_windrunner_3_buff", { duration = self:GetSpecialValueFor("duration") })
	hCaster:EmitSound("Ability.Windrun")
end
function windrunner_3:GetIntrinsicModifierName()
	return "modifier_windrunner_3"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_windrunner_3 : eom_modifier
modifier_windrunner_3 = eom_modifier({
	Name = "modifier_windrunner_3",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_windrunner_3:GetAbilitySpecialValue()
	self.bonus_movespeed = self:GetAbilitySpecialValueFor("bonus_movespeed")
end
function modifier_windrunner_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
end
function modifier_windrunner_3:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_movespeed
end
----------------------------------------Modifier----------------------------------------
---@class modifier_windrunner_3_buff : eom_modifier
modifier_windrunner_3_buff = eom_modifier({
	Name = "modifier_windrunner_3_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_windrunner_3_buff:IsAura()
	return true
end
function modifier_windrunner_3_buff:GetAuraRadius()
	return self.radius
end
function modifier_windrunner_3_buff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_windrunner_3_buff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_windrunner_3_buff:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_windrunner_3_buff:GetModifierAura()
	return "modifier_windrunner_3_debuff"
end
function modifier_windrunner_3_buff:GetAbilitySpecialValue()
	self.movespeed_pct = self:GetAbilitySpecialValueFor("movespeed_pct")
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
function modifier_windrunner_3_buff:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_windrunner_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
end
function modifier_windrunner_3_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_EVASION_CONSTANT = 100,
	}
end
function modifier_windrunner_3_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_pct
end
function modifier_windrunner_3_buff:GetModifierIgnoreMovespeedLimit()
	return 1
end
function modifier_windrunner_3_buff:GetActivityTranslationModifiers()
	return "windrun"
end
function modifier_windrunner_3_buff:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_windrunner_3_debuff : eom_modifier
modifier_windrunner_3_debuff = eom_modifier({
	Name = "modifier_windrunner_3_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_windrunner_3_debuff:GetAbilitySpecialValue()
	self.movespeed_reduce_pct = self:GetAbilitySpecialValueFor("movespeed_reduce_pct")
end
function modifier_windrunner_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = -(self.movespeed_reduce_pct or 0)
	}
end