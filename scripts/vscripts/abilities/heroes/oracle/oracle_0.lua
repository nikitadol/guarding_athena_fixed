---@class oracle_0 : eom_ability
oracle_0 = eom_ability({})
function oracle_0:Spawn()
	local hCaster = self:GetCaster()
	self:GameTimer(0, function()
		if self:IsFullyCastable() and self:GetAutoCastState() == true then
			local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, self:GetCastRange(vec3_invalid, nil), DOTA_UNIT_TARGET_TEAM_ENEMY, self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
			if IsValid(tTargets[1]) then
				ExecuteOrder(hCaster, DOTA_UNIT_ORDER_CAST_TARGET, self, tTargets[1])
			end
		end
		return AI_THINK_TICK_TIME
	end)
end
function oracle_0:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end
-- 处理2技能的减冷却效果
function oracle_0:GetCooldown(iLevel)
	local hCaster = self:GetCaster()
	local flCooldown = self.BaseClass.GetCooldown(self, iLevel)
	if hCaster:HasModifier("modifier_oracle_2") then
		return hCaster:GetOracleCooldown(flCooldown)
	end
	return flCooldown
end
function oracle_0:CastFilterResultTarget(hTarget)
	if hTarget:IsFriendly(self:GetCaster()) then
		if self:GetCaster():GetScepterLevel() >= 1 then
			return UF_SUCCESS
		else
			return UF_FAIL_FRIENDLY
		end
	end
end
function oracle_0:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	if hTarget:IsFriendly(hCaster) then
		hTarget:AddNewModifier(hCaster, self, "modifier_oracle_0_buff", { duration = self:GetSpecialValueFor("duration") })
	else
		hTarget:AddNewModifier(hCaster, self, "modifier_oracle_0_debuff", { duration = self:GetSpecialValueFor("duration") })
	end
	self:StartCooldown(self:GetCooldown(self:GetLevel() - 1))
end
----------------------------------------Modifier----------------------------------------
---@class modifier_oracle_0 : eom_modifier
modifier_oracle_0 = eom_modifier({
	Name = "modifier_oracle_0",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_oracle_0:GetAbilitySpecialValue()
	self.intellect_stack = self:GetAbilitySpecialValueFor("intellect_stack")
end
function modifier_oracle_0:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_oracle_0:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_oracle_0:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_oracle_0:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end
function modifier_oracle_0:EOM_GetModifierBonusStats_Intellect(params)
	return self.intellect_stack * self:GetStackCount()
end
----------------------------------------Modifier----------------------------------------
---@class modifier_oracle_0_debuff : eom_modifier
modifier_oracle_0_debuff = eom_modifier({
	Name = "modifier_oracle_0_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_oracle_0_debuff:GetAbilitySpecialValue()
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.bonus_damage_stack = self:GetAbilitySpecialValueFor("bonus_damage_stack")
	self.exp_gain_pct = self:GetAbilitySpecialValueFor("exp_gain_pct")
end
function modifier_oracle_0_debuff:OnCreated(params)
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_oracle_0") then
			self:SetStackCount(self:GetCaster():GetModifierStackCount("modifier_oracle_0", self:GetCaster()))
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/oracle/oracle_0.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_oracle_0_debuff:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		if not self:GetParent():IsAlive() then
			hCaster:AddNewModifier(hCaster, self:GetAbility(), "modifier_oracle_0", nil)
			local iLevel = hCaster:GetLevel()
			local iScepterLevel = hCaster:GetScepterLevel()
			if iLevel >= (iScepterLevel + 1) * 100 then
				return
			end
			local iExp = math.ceil((HERO_XP_PER_LEVEL_TABLE[iLevel + 1] - HERO_XP_PER_LEVEL_TABLE[iLevel]) * self.exp_gain_pct * 0.01)
			hCaster:AddExperience(iExp, DOTA_ModifyXP_CreepKill, false, false)
		end
	end
end
function modifier_oracle_0_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_oracle_0_debuff:EOM_GetModifierIncomingDamagePercentage(params)
	if params.attacker == self:GetCaster() then
		return self.bonus_damage + self.bonus_damage_stack * self:GetStackCount()
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_oracle_0_buff : eom_modifier
modifier_oracle_0_buff = eom_modifier({
	Name = "modifier_oracle_0_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_oracle_0_buff:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/oracle/oracle_0.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_oracle_0_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_REINCARNATION
	}
end
function modifier_oracle_0_buff:ReincarnateTime()
	return 1
end