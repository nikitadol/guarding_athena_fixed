---@class oracle_4 : eom_ability
oracle_4 = eom_ability({})
-- 处理2技能的减冷却效果
function oracle_4:GetCooldown(iLevel)
	local hCaster = self:GetCaster()
	local flCooldown = self.BaseClass.GetCooldown(self, iLevel)
	if hCaster:HasModifier("modifier_oracle_2") then
		return hCaster:GetOracleCooldown(flCooldown)
	end
	return flCooldown
end
function oracle_4:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function oracle_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local damage = self:GetSpecialValueFor("damage")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local pull_duration = self:GetSpecialValueFor("pull_duration")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, self:GetSpecialValueFor("radius"), self)
	for _, hUnit in ipairs(tTargets) do
		hCaster:DealDamage(hUnit, self, damage)
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", { duration = stun_duration })
	end
	-- 延迟造成吸引
	CreateModifierThinker(hCaster, self, "modifier_oracle_4_thinker", { duration = stun_duration }, vPosition, hCaster:GetTeamNumber(), false)
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/heroes/oracle/oracle_4_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID,	0, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- sound
	hCaster:EmitSound("Hero_Oracle.FalsePromise.Cast")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_oracle_4_thinker : eom_modifier
modifier_oracle_4_thinker = eom_modifier({
	Name = "modifier_oracle_4_thinker",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
}, nil, ModifierThinker)
function modifier_oracle_4_thinker:GetAbilitySpecialValue()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.pull_duration = self:GetAbilitySpecialValueFor("pull_duration")
	self.imprison_duration = self:GetAbilitySpecialValueFor("imprison_duration")
end
function modifier_oracle_4_thinker:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(self:GetDuration() - self.pull_duration)
	end
end
function modifier_oracle_4_thinker:OnDestroy()
	if IsServer() then
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/oracle/oracle_4_imprison.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_ObsidianDestroyer.AstralImprisonment.Cast", self:GetCaster())
		self:GetCaster():GameTimer(self.imprison_duration, function()
			ParticleManager:DestroyParticle(iParticleID, false)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end)
	end
end
function modifier_oracle_4_thinker:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local vPosition = hParent:GetAbsOrigin()
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, self.radius, self:GetAbility())
		for _, hUnit in ipairs(tTargets) do
			hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_oracle_4_pull", { duration = self.pull_duration })
			hUnit:KnockBack((vPosition - hUnit:GetAbsOrigin()):Normalized(), (vPosition - hUnit:GetAbsOrigin()):Length2D(), 0, self.pull_duration)
		end
		self:StartIntervalThink(-1)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_oracle_4_pull : eom_modifier
modifier_oracle_4_pull = eom_modifier({
	Name = "modifier_oracle_4_pull",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_oracle_4_pull:GetAbilitySpecialValue()
	self.imprison_duration = self:GetAbilitySpecialValueFor("imprison_duration")
end
function modifier_oracle_4_pull:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		hParent:AddNewModifier(hCaster, self:GetAbility(), "modifier_oracle_4_debuff", { duration = self.imprison_duration })
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_oracle_4_debuff : eom_modifier
modifier_oracle_4_debuff = eom_modifier({
	Name = "modifier_oracle_4_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_oracle_4_debuff:GetAbilitySpecialValue()
	self.imprison_duration = self:GetAbilitySpecialValueFor("imprison_duration")
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
end
function modifier_oracle_4_debuff:OnCreated(params)
	if IsServer() then
		self:GetParent():AddNoDraw()
	end
end
function modifier_oracle_4_debuff:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveNoDraw()
	end
end
function modifier_oracle_4_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_oracle_4_debuff:EOM_GetModifierIncomingDamagePercentage(params)
	if params.attacker == self:GetCaster() then
		return self.bonus_damage - 100
	end
end
function modifier_oracle_4_debuff:CheckState()
	return {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end
function modifier_oracle_4_debuff:ECheckState()
	return {
		[EOM_MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end