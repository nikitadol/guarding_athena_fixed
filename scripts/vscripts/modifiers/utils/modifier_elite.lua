---@class modifier_elite:eom_modifier
modifier_elite = eom_modifier({
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	RemoveOnDeath = false
})
function modifier_elite:OnCreated(params)
	if IsServer() then
		self:SetStackCount(Rounds:GetRoundNumber())
	else
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_huskar_lifebreak.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, true, 10, false, false)
	end
end
function modifier_elite:OnDestroy()
	if IsServer() then
	end
end
function modifier_elite:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT = -50,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end
function modifier_elite:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = 1,
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_HEALTH_PERCENTAGE,
	}
end
function modifier_elite:GetModifierAttackSpeedBonus_Constant()
	return 20 * GameRules:GetCustomGameDifficulty()
end
function modifier_elite:GetModifierModelScale()
	return 50
end
function modifier_elite:EOM_GetModifierAttackDamagePercentage()
	return (GameRules:GetCustomGameDifficulty() / 2) * (1 + (0.01 * GameRules:GetCustomGameDifficulty())) ^ self:GetStackCount() * 100
end
function modifier_elite:EOM_GetModifierHealthPercentage()
	return (GameRules:GetCustomGameDifficulty() / 2) * (1 + (0.01 * GameRules:GetCustomGameDifficulty())) ^ self:GetStackCount() * 100
end