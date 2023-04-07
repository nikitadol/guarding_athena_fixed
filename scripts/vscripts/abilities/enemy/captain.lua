---@class captain: eom_ability
captain = eom_ability({})
function captain:GetIntrinsicModifierName()
	return "modifier_captain"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_captain : eom_modifier
modifier_captain = eom_modifier({
	Name = "modifier_captain",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_captain:OnCreated(params)
	self.damage_limit = self:GetAbilitySpecialValueFor("damage_limit")
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	if IsServer() then
		self.flHealth = math.ceil(self:GetParent():GetCustomMaxHealth() * self.damage_limit * 0.01)
		self.threshold = self:GetParent():GetCustomMaxHealth() - self.flHealth
		local hParent = self:GetParent()
		-- hParent:SetDeathXP(hParent:GetDeathXP() * Spawner.difficulty * Spawner.unitFactor.eliteFactor ^ Rounds:GetRoundNumber())
		-- hParent:SetMinimumGoldBounty(hParent:GetGoldBounty() * (Spawner.difficulty / 2 + 0.5) * Spawner.unitFactor.eliteFactor ^ Rounds:GetRoundNumber())
		-- hParent:SetMaximumGoldBounty(hParent:GetGoldBounty() * (Spawner.difficulty / 2 + 0.5) * Spawner.unitFactor.eliteFactor ^ Rounds:GetRoundNumber())
		-- hParent:SetBaseDamageMin(hParent:GetBaseDamageMin() * (Spawner.difficulty / 2 + 0.5) * Spawner.unitFactor.eliteFactor ^ Rounds:GetRoundNumber())
		-- hParent:SetBaseDamageMax(hParent:GetBaseDamageMax() * (Spawner.difficulty / 2 + 0.5) * Spawner.unitFactor.eliteFactor ^ Rounds:GetRoundNumber())
		-- hParent:SetBaseMaxHealth(hParent:GetBaseMaxHealth() * (Spawner.difficulty / 2 + 0.5) * Spawner.unitFactor.eliteFactor ^ Rounds:GetRoundNumber())
		-- hParent:SetMaxHealth(hParent:GetBaseMaxHealth())
		-- hParent:SetHealth(hParent:GetBaseMaxHealth())
	end
end
function modifier_captain:OnRefresh(params)
	self.damage_limit = self:GetAbilitySpecialValueFor("damage_limit")
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	if IsServer() then
	end
end
function modifier_captain:OnDestroy()
	if IsServer() then
	end
end
function modifier_captain:OnTakeDamage(params)
	local hCaster = params.unit
	if hCaster == self:GetParent() then
		local hAbility = self:GetAbility()
		if hCaster:GetHealth() == self.threshold then
			hCaster:AddNewModifier(hCaster, hAbility, "modifier_captain_buff", { duration = self:GetAbility():GetDuration() })
			self:StartIntervalThink(0)
		end
	end
end
function modifier_captain:OnIntervalThink()
	self.threshold = math.max(self.threshold - self.flHealth, 0)
end
function modifier_captain:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end
function modifier_captain:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = self.health_regen_pct,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_CHANCE = self.crit_chance,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE = self.crit_mult,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() }
	}
end
function modifier_captain:GetMinHealth()
	if IsServer() then
		if self.threshold > 0 then
			return self.threshold
		end
	end
end
function modifier_captain:GetModifierMoveSpeedBonus_Constant()
	return self.movespeed
end
function modifier_captain:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end
function modifier_captain:GetModifierModelScale()
	return 50
end
----------------------------------------Modifier----------------------------------------
---@class modifier_captain_buff : eom_modifier
modifier_captain_buff = eom_modifier({
	Name = "modifier_captain_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_captain_buff:OnCreated(params)
	self.damage_reduce = self:GetAbilitySpecialValueFor("damage_reduce")
end
function modifier_captain_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_captain_buff:EOM_GetModifierIncomingDamagePercentage(params)
	return RemapVal(self:GetElapsedTime(), 0, self:GetDuration(), -self.damage_reduce, 0)
end