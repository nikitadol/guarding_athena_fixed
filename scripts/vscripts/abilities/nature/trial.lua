---@class trial: eom_ability
trial = eom_ability({
	funcCondition = function(hAbility)
		return not hAbility:GetCaster():HasModifier("modifier_trial_buff")
	end,
	funcUnitsCallback = function(hAbility, tTargets)
		if hAbility:GetCaster():GetTeamNumber() ~= DOTA_TEAM_GOODGUYS then
			for i = #tTargets, 1, -1 do
				if not tTargets[i]:IsRealHero() or Task:GetPlayerTaskState(tTargets[i]:GetPlayerOwnerID(), "Trial") ~= TASK_STATE_TYPE_PROGRESS then
					table.remove(tTargets, i)
				end
			end
		end
	end
}, nil, ability_base_ai)
function trial:GetRadius()
	return 700
end
function trial:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_trial_buff", nil)
end
function trial:GetIntrinsicModifierName()
	return "modifier_trial"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_trial : eom_modifier
modifier_trial = eom_modifier({
	Name = "modifier_trial",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_trial:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_trial:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = not self:GetParent():HasModifier("modifier_trial_buff"),
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_ROOTED] = not self:GetParent():HasModifier("modifier_trial_buff"),
		[MODIFIER_STATE_DISARMED] = not self:GetParent():HasModifier("modifier_trial_buff"),
	}
end
function modifier_trial:ECheckState()
	return {
		[EOM_MODIFIER_STATE_NO_HEALTH_BAR] = not self:GetParent():HasModifier("modifier_trial_buff"),
	}
end
function modifier_trial:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS = "attack_long_range"
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_trial_buff : eom_modifier
modifier_trial_buff = eom_modifier({
	Name = "modifier_trial_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_trial_buff:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0.1)
		self.vCenter = self:GetParent():GetAbsOrigin()
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_mars/mars_arena_of_blood.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(700, 0, 0))
		ParticleManager:SetParticleControl(iParticleID, 2, hParent:GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_trial_buff:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local iUnitType = DOTA_UNIT_TARGET_HERO
	if hParent:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		iUnitType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	end
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), self.vCenter, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, iUnitType, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #tTargets == 0 then
		self:IncrementStackCount()
		if self:GetStackCount() > 1 then
			self:Destroy()
			FindClearSpaceForUnit(hParent, self.vCenter, true)
		end
	end
end