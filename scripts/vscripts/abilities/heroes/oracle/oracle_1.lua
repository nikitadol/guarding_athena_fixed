---@class oracle_1 : eom_ability
oracle_1 = eom_ability({})
function oracle_1:Spawn()
	if IsServer() then
		local hCaster = self:GetCaster()
		local scepter_interval = self:GetLevelSpecialValueFor("scepter_interval", 1)
		self:GameTimer(0, function()
			if hCaster:GetScepterLevel() >= 4 then
				local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, self:GetCastRange(vec3_invalid, nil), DOTA_UNIT_TARGET_TEAM_ENEMY, self:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
				-- local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), self:GetCastRange(vec3_invalid, nil), self)
				local hTarget = tTargets[1]
				local vPosition = IsValid(hTarget) and hTarget:GetAbsOrigin() or hCaster:GetAbsOrigin() + RandomVector(RandomInt(0, self:GetCastRange(vec3_invalid, nil)))
				self:PurifyingFlames(vPosition)
			end
			return scepter_interval
		end)
	end
end
-- 处理2技能的减冷却效果
function oracle_1:GetCooldown(iLevel)
	local hCaster = self:GetCaster()
	local flCooldown = self.BaseClass.GetCooldown(self, iLevel)
	if hCaster:HasModifier("modifier_oracle_2") then
		return hCaster:GetOracleCooldown(flCooldown)
	end
	return flCooldown
end
function oracle_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function oracle_1:PurifyingFlames(vPosition)
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local flDuration = self:GetSpecialValueFor("duration")
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), vPosition, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, damage)
		hUnit:AddNewModifier(hCaster, self, "modifier_oracle_1_debuff", { duration = flDuration })
	end
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_hit.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
function oracle_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local flDuration = self:GetSpecialValueFor("duration")

	self:PurifyingFlames(vPosition)
	-- 回血
	hCaster:AddNewModifier(hCaster, self, "modifier_oracle_1_buff", { duration = flDuration })
	-- sound
	hCaster:EmitSound("Hero_Oracle.PurifyingFlames.Damage")
end
function oracle_1:GetIntrinsicModifierName()
	return "modifier_oracle_1"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_oracle_1_buff : eom_modifier
modifier_oracle_1_buff = eom_modifier({
	Name = "modifier_oracle_1_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_oracle_1_buff:GetAbilitySpecialValue()
	self.damage_dot = self:GetAbilitySpecialValueFor("damage_dot")
	self.interval = self:GetAbilitySpecialValueFor("interval")
end
function modifier_oracle_1_buff:OnCreated(params)
	if IsServer() then
		self.flHealAmount = self:GetCaster():GetIntellect() * self.damage_dot * self.interval
		self:StartIntervalThink(self.interval)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_oracle_1_buff:OnIntervalThink()
	self:GetParent():Heal(self.flHealAmount, self:GetAbility())
end
----------------------------------------Modifier----------------------------------------
---@class modifier_oracle_1_debuff : eom_modifier
modifier_oracle_1_debuff = eom_modifier({
	Name = "modifier_oracle_1_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_oracle_1_debuff:GetAbilitySpecialValue()
	self.damage_dot = self:GetAbilitySpecialValueFor("damage_dot")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
end
function modifier_oracle_1_debuff:OnCreated(params)
	if IsServer() then
		self.flDamage = self.damage_dot * self.interval
		self:SetStackCount(1)
		self:StartIntervalThink(self.interval)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/oracle/oracle_1_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_oracle_1_debuff:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_oracle_1_debuff:OnIntervalThink()
	self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), self.flDamage * self:GetStackCount())
end
function modifier_oracle_1_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE
	}
end
function modifier_oracle_1_debuff:EOM_GetModifierOutgoingDamagePercentage()
	return -self.damage_reduce_pct
end