---@class spectre_2 : eom_ability
spectre_2 = eom_ability({})
function spectre_2:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_spectre_2_buff", { duration = 0.5 })
	-- 使下次攻击达到浮动上限
	self:GetIntrinsicModifier():SetStackCount(self:GetSpecialValueFor("damage_limit"))
	hCaster:EmitSound("Hero_Bane.BrainSap.Target")
end
function spectre_2:GetIntrinsicModifierName()
	return "modifier_spectre_2"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_spectre_2 : eom_modifier
modifier_spectre_2 = eom_modifier({
	Name = "modifier_spectre_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_spectre_2:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.damage_limit = self:GetAbilitySpecialValueFor("damage_limit")
	self.damage_add = self:GetAbilitySpecialValueFor("damage_add")
	self.health_cost = self:GetAbilitySpecialValueFor("health_cost")
end
function modifier_spectre_2:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() }
	}
end
function modifier_spectre_2:OnAttackLanded(params)
	if IsServer() then
		local hParent = self:GetParent()
		local hTarget = params.target
		if params.attacker == self:GetParent() then
			-- 消耗生命
			local flHealthCost = hParent:GetCustomMaxHealth() * self.health_cost * 0.01
			hParent:SpendHealth(flHealthCost, self:GetAbility(), false)
			-- 触发受到伤害效果
			local hModifier = hParent:FindModifierByName("modifier_spectre_3")
			if IsValid(hModifier) then
				hModifier:OnTakeDamage({ unit = hParent, damage = flHealthCost, original_damage = flHealthCost })
			end
			self:OnTakeDamage({ unit = hParent, damage = flHealthCost, original_damage = flHealthCost })
			-- 造成攻击伤害
			local iMaxFactor = self.damage + self:GetStackCount()
			local iScepterLevel = hParent:GetScepterLevel()
			-- 二转：最小伤害提升为最大伤害的一半
			local flMinDamage = self:GetCaster():GetScepterLevel() >= 2 and iMaxFactor * self:GetAbilitySpecialValueFor("scepter_min_damage_pct") * 0.01 or 1
			local flDamage = RandomInt(flMinDamage, iMaxFactor)
			hParent:DealDamage(hTarget, self:GetAbility(), flDamage)
			if hParent:IsRealHero() then
				CreateNumberEffect(hTarget, flDamage, 1, MSG_ORIT, { 199, 21, 133 }, 6)
			else
				CreateNumberEffect(hTarget, flDamage, 1, MSG_ORIT, { 148, 0, 211 }, 6)
			end
			-- particle
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_desolate.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT, "attach_hitloc", hTarget:GetAbsOrigin(), true)
			local vDirection = hTarget:GetAbsOrigin() - hParent:GetAbsOrigin()
			vDirection.z = 0
			ParticleManager:SetParticleControlForward(iParticleID, 0, vDirection:Normalized())
			ParticleManager:ReleaseParticleIndex(iParticleID)
			-- sound
			hParent:EmitSound("Hero_Spectre.Desolate")

			self:SetStackCount(0)
		end
	end
end
function modifier_spectre_2:OnTakeDamage(params)
	if IsServer() then
		local hParent = self:GetParent()
		if params.unit == hParent then
			if self:GetStackCount() < self.damage_limit then
				self:SetStackCount(math.min(self:GetStackCount() + self.damage_add, self.damage_limit))
			end
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_spectre_2_buff : eom_modifier
modifier_spectre_2_buff = eom_modifier({
	Name = "modifier_spectre_2_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_spectre_2_buff:GetAbilitySpecialValue()
	self.heal = self:GetAbilitySpecialValueFor("heal")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.damage_active = self:GetAbilitySpecialValueFor("damage_active")
	self.shock_duration = self:GetAbilitySpecialValueFor("shock_duration")
end
function modifier_spectre_2_buff:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		local flHealthCost = hParent:GetCustomHealth() * 0.3
		hParent:SpendHealth(flHealthCost, self:GetAbility(), false)
		-- 触发受到伤害效果
		local hModifier = hParent:FindModifierByName("modifier_spectre_3")
		if IsValid(hModifier) then
			hModifier:OnTakeDamage({ unit = hParent, damage = flHealthCost, original_damage = flHealthCost })
		end
		self.flDamage = self.damage_active * flHealthCost * (0.1 / self:GetDuration())
		self:StartIntervalThink(0.1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_2_tentacle.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_spectre_2_buff:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_spectre_2_buff:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
	for _, hUnit in pairs(tTargets) do
		hUnit:Stop()
		hUnit:AddNewModifier(hParent, self:GetAbility(), "modifier_spectre_2_debuff", { duration = self.shock_duration })
		hParent:DealDamage(hUnit, self:GetAbility(), self.flDamage)
		hParent:Heal(self.heal * self.flDamage, self:GetAbility())
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_spectre_2_debuff : eom_modifier
modifier_spectre_2_debuff = eom_modifier({
	Name = "modifier_spectre_2_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_spectre_2_debuff:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0.2)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_nightmare.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_spectre_2_debuff:OnIntervalThink()
	self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin() + Vector(RandomInt(-200, 200), RandomInt(-200, 200), 0))
end
function modifier_spectre_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
end
function modifier_spectre_2_debuff:CheckState()
	return {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}
end
function modifier_spectre_2_debuff:GetModifierMoveSpeed_Absolute()
	return 100
end