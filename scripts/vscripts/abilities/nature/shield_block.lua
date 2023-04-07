---@class shield_block: eom_ability
shield_block = eom_ability({ funcCondition = function(hAbility)
	return hAbility:GetCaster():HasModifier("modifier_trial_buff")
end }, nil, ability_base_ai)
function shield_block:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_shield_block", { duration = 2 })
end
----------------------------------------Modifier----------------------------------------
---@class modifier_shield_block : eom_modifier
modifier_shield_block = eom_modifier({
	Name = "modifier_shield_block",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_shield_block:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/trial/shield_block.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_shield_block:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS = "bulwark",
		MODIFIER_PROPERTY_AVOID_DAMAGE,
		MODIFIER_PROPERTY_DISABLE_TURNING = 1
	}
end
function modifier_shield_block:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}
end
function modifier_shield_block:GetModifierAvoidDamage(params)
	local hParent = self:GetParent()
	if params and IsValid(params.attacker) and not params.attacker:IsInvulnerable() and params.damage > 0 and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
		hParent:DealDamage(params.attacker, self:GetAbility(), params.damage, params.damage_type, params.damage_flags + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_REFLECTION)
		params.attacker:AddNewModifier(hParent, self:GetAbility(), "modifier_stunned", { duration = 1 })
		hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_shield_block_buff", { duration = 2 })
		self:Destroy()
		return 1
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_shield_block_buff : eom_modifier
modifier_shield_block_buff = eom_modifier({
	Name = "modifier_shield_block_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_shield_block_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = 100
	}
end