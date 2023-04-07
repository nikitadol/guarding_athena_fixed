---@class alien_parasitism: eom_ability
alien_parasitism = eom_ability({})
function alien_parasitism:GetIntrinsicModifierName()
	return "modifier_alien_parasitism"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_alien_parasitism : eom_modifier
modifier_alien_parasitism = eom_modifier({
	Name = "modifier_alien_parasitism",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_alien_parasitism:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(AI_THINK_TICK_TIME)
	end
end
function modifier_alien_parasitism:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), 150, hAbility)
		if IsValid(tTargets[1]) then
			tTargets[1]:AddNewModifier(hParent, hAbility, "modifier_alien_parasitism_debuff", { duration = 30 })
			hParent:AddNewModifier(hParent, hAbility, "modifier_alien_parasitism_buff", { duration = 30 })
			hParent:AddNoDraw()
			hParent:EmitSound("Hero_LifeStealer.Infest")
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_alien_parasitism_debuff : eom_modifier
modifier_alien_parasitism_debuff = eom_modifier({
	Name = "modifier_alien_parasitism_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_alien_parasitism_debuff:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_alien_parasitism_debuff:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		hCaster:DealDamage(hParent, self:GetAbility(), hParent:GetCustomMaxHealth() * 0.03, DAMAGE_TYPE_PURE)
	end
end
function modifier_alien_parasitism_debuff:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		hCaster:ForceKill(false)
		local hUnit = CreateUnitByNameWithNewData("alien_worm_boss", hParent:GetAbsOrigin(), true, nil, nil, ENEMY_TEAM, {
			CustomStatusHealth = KeyValues.UnitsKv["alien_worm_boss"].CustomStatusHealth + 24000 * self:GetStackCount(),
			Armor = KeyValues.UnitsKv["alien_worm_boss"].Armor + 2.4 * self:GetStackCount(),
			AttackDamage = KeyValues.UnitsKv["alien_worm_boss"].AttackDamage + 700 * self:GetStackCount(),
		})
		hUnit:EmitSound("Hero_LifeStealer.Consume")
		hUnit:CreatureLevelUp(self:GetStackCount() - 1)
		hUnit:DealDamage(hParent, nil, self.damage * hParent:GetCustomMaxHealth() * 0.01, DAMAGE_TYPE_PURE)
		hUnit:AddNewModifier(hUnit, nil, "modifier_alien_parasitism_attack", nil)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest.vpcf", PATTACH_ABSORIGIN, hParent)
	end
end
function modifier_alien_parasitism_debuff:OnIntervalThink()
	if IsServer() then
		self:IncrementStackCount()
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_alien_parasitism_buff : eom_modifier
modifier_alien_parasitism_buff = eom_modifier({
	Name = "modifier_alien_parasitism_buff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_alien_parasitism_buff:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end
function modifier_alien_parasitism_buff:ECheckState()
	return {
		[EOM_MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_alien_parasitism_attack : eom_modifier
modifier_alien_parasitism_attack = eom_modifier({
	Name = "modifier_alien_parasitism_attack",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_alien_parasitism_attack:OnAttackLanded(params)
	local hParent = self:GetParent()
	hParent:DealDamage(params.target, nil, 1000 * hParent:GetLevel() * GameRules:GetCustomGameDifficulty())
end
function modifier_alien_parasitism_attack:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end