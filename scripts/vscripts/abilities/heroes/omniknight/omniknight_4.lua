---@class omniknight_4 : eom_ability
omniknight_4 = eom_ability({})
function omniknight_4:OnToggle()
	local hCaster = self:GetCaster()
	local bToggle = self:GetToggleState()
	if bToggle then
		hCaster:AddNewModifier(hCaster, self, "modifier_omniknight_4", nil)
		hCaster:EmitSound("Hero_Terrorblade.Reflection")
	else
		hCaster:RemoveModifierByName("modifier_omniknight_4")
	end
end
function omniknight_4:ThunderStorm(hTarget)
	local hCaster = self:GetCaster()
	local hAbility = hCaster:FindAbilityByName("omniknight_0")
	local storm_chance = self:GetSpecialValueFor("storm_chance")
	local storm_jump_count = self:GetSpecialValueFor("storm_jump_count")
	local storm_str_damage = self:GetSpecialValueFor("storm_str_damage")
	if PRD(self, storm_chance, "omniknight_4") then
		hCaster:LightningStrike(hTarget, self, function(hUnit)
			hCaster:DealDamage(hUnit, self, storm_str_damage)
			hAbility:ThunderPower(hUnit)
		end, function(_hSource, _hTarget, bFirst)
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, _hTarget:GetAbsOrigin() + Vector(0, 0, 900))
			ParticleManager:SetParticleControl(iParticleID, 1, _hTarget:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end, { iJumpCount = storm_jump_count, flJumpDelay = 0.3, sSoundName = "Hero_Leshrac.Lightning_Storm" })
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_omniknight_4 : eom_modifier
modifier_omniknight_4 = eom_modifier({
	Name = "modifier_omniknight_4",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_omniknight_4:GetEffectName()
	return AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_omniknight/omniknight_4.vpcf", self:GetParent())
end
function modifier_omniknight_4:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_omniknight_4:GetAbilitySpecialValue()
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
	self.bonus_movespeed = self:GetAbilitySpecialValueFor("bonus_movespeed")
	self.bonus_resistance = self:GetAbilitySpecialValueFor("bonus_resistance")
	self.bonus_amp_percent = self:GetAbilitySpecialValueFor("bonus_amp_percent")
	self.mana_cost = self:GetAbilitySpecialValueFor("mana_cost")
	self.palsy_duration = self:GetAbilitySpecialValueFor("palsy_duration")
	self.palsy_radius = self:GetAbilitySpecialValueFor("palsy_radius")
	self.palsy_interval = self:GetAbilitySpecialValueFor("palsy_interval")
end
function modifier_omniknight_4:OnCreated(params)
	if IsServer() then
		self.bTrigger = true
		self:StartIntervalThink(self.palsy_interval)
	end
end
function modifier_omniknight_4:OnAttacked(params)
	-- 雷霆战士皮肤
	if self:GetParent() == params.target and self:GetParent():HasModifier("modifier_omniknight_01") and self.bTrigger then
		self.bTrigger = false
		self:GetAbility():ThunderStorm(params.attacker)
	end
end
function modifier_omniknight_4:OnIntervalThink()
	if IsServer() then
		self.bTrigger = true
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		hCaster:SpendMana(self.mana_cost, hAbility)

		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), hCaster, self.palsy_radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_CLOSEST, false)
		for _, hUnit in pairs(tTargets) do
			hUnit:AddNewModifier(hCaster, hAbility, "modifier_omniknight_4_debuff", { duration = self.palsy_duration * hUnit:GetStatusResistanceFactor() })
		end
		if hCaster:GetMana() < self.mana_cost then
			hAbility:ToggleAbility()
		end
	end
end
function modifier_omniknight_4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
end
function modifier_omniknight_4:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {nil, self:GetParent() },
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS,
		EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_DAMAGE_PERCENTAGE
	}
end
function modifier_omniknight_4:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attackspeed
end
function modifier_omniknight_4:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_movespeed
end
function modifier_omniknight_4:EOM_GetModifierArmorBonus()
	return self.bonus_resistance
end
function modifier_omniknight_4:EOM_GetModifierOutgoingMagicalDamagePercentage()
	return self.bonus_amp_percent
end
----------------------------------------Modifier----------------------------------------
---@class modifier_omniknight_4_debuff : eom_modifier
modifier_omniknight_4_debuff = eom_modifier({
	Name = "modifier_omniknight_4_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = true,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_omniknight_4_debuff:GetEffectName()
	return "particles/units/heroes/hero_leshrac/leshrac_lightning_slow.vpcf"
end
function modifier_omniknight_4_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_omniknight_4_debuff:GetAbilitySpecialValue()
	self.palsy_attackspeed = self:GetAbilitySpecialValueFor("palsy_attackspeed")
	self.palsy_movespeed = self:GetAbilitySpecialValueFor("palsy_movespeed")
	self.storm_chance = self:GetAbilitySpecialValueFor("storm_chance")
	self.scepter_damage = self:GetAbilitySpecialValueFor("scepter_damage")
end
function modifier_omniknight_4_debuff:OnCreated(params)
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		if RollPercentage(self.storm_chance) then
			self:GetAbility():ThunderStorm(self:GetParent())
		end
		if hCaster:GetScepterLevel() >= 4 then
			local hAbility = hCaster:FindAbilityByName("omniknight_0")
			hCaster:DealDamage(hParent, self:GetAbility(), self.scepter_damage)
			hAbility:ThunderPower(hParent)
		end
	end
end
function modifier_omniknight_4_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end
function modifier_omniknight_4_debuff:GetModifierAttackSpeedBonus_Constant()
	return -self.palsy_attackspeed
end
function modifier_omniknight_4_debuff:GetModifierMoveSpeedBonus_Constant()
	return -self.palsy_movespeed
end