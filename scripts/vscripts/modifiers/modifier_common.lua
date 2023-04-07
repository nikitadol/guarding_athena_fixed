modifier_common = eom_modifier({})

local public = modifier_common

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:RemoveOnDeath()
	return false
end
function public:OnCreated(params)
	local hParent = self:GetParent()
	hParent.hModifierCommon = self
end
function public:CheckState()
	return {
		[MODIFIER_STATE_BLOCK_DISABLED] = self:GetParent():IsHero() and not self:GetParent():IsRangedAttacker(),
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	-- [MODIFIER_STATE_NO_HEALTH_BAR] = self:GetParent():IsHero(),
	}
end
-- function public:ECheckState()
-- 	return {
-- 		[MODIFIER_STATE_BLOCK_DISABLED] = self:GetParent():IsHero() and not self:GetParent():IsRangedAttacker(),
-- 		[EOM_MODIFIER_STATE_NO_HEALTH_BAR] = not self:GetParent():IsHero(),
-- 	}
-- end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,

		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_ALWAYS_AUTOATTACK_WHILE_HOLD_POSITION = 1
	}
end
function public:GetModifierPreAttack_CriticalStrike(params)
	local hAttacker = params.attacker
	local hTarget = params.target
	local fChance = GetPhysicalCriticalStrikeChance(hAttacker, params)
	local fDamage = GetPhysicalCriticalStrikeDamage(hAttacker, params)
	if fChance > 0 and fDamage > 0 and PRD(hAttacker, fChance, "physical_critical_strike") then
		_PhysicalCrit(params.record)
		return fDamage
	end
end
function public:GetAttackSound(params)
	local hAttacker = params.attacker
	local sSound = GetCriticalStrikeSound(hAttacker, params)
	if DamageFilter(params.record, DAMAGE_STATE_PHYSICAL_CRIT) and sSound ~= 0 then
		return sSound
	end
end
function public:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = { self:GetParent() },
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED = { self:GetParent() },
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = { self:GetParent() },
		MODIFIER_EVENT_ON_ABILITY_END_CHANNEL = { self:GetParent() },
	}
end
function public:OnAbilityFullyCast(params)
	if IsServer() then
		if bit.band(params.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_CHANNELLED) ~= DOTA_ABILITY_BEHAVIOR_CHANNELLED then
			if self:GetParent():HasAttackCapability() then
				ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_ATTACK_MOVE, self:GetParent():GetAbsOrigin())
			end
		end
	end
end
function public:OnAbilityEndChannel(params)
	if IsServer() and not self:GetParent():IsChanneling() then
		if self:GetParent():HasAttackCapability() then
			ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_ATTACK_MOVE, self:GetParent():GetAbsOrigin())
		end
	end
end
function public:GetModifierBaseAttack_BonusDamage(params)
	return GetAttackDamage(self:GetParent(), params)
end
function public:GetModifierCooldownReduction_Constant(params)
	if params ~= nil and params.ability ~= nil and KeyValues.AbilitiesKv[params.ability:GetAbilityName()] and KeyValues.AbilitiesKv[params.ability:GetAbilityName()].IgnoreCooldownReduction and KeyValues.AbilitiesKv[params.ability:GetAbilityName()].IgnoreCooldownReduction == 1 then
		return 0
	end
	return GetCooldownConstantReduction(self:GetParent(), params)
end
function public:GetModifierPercentageCooldown(params)
	if params ~= nil and params.ability ~= nil and KeyValues.AbilitiesKv[params.ability:GetAbilityName()] and KeyValues.AbilitiesKv[params.ability:GetAbilityName()].IgnoreCooldownReduction and KeyValues.AbilitiesKv[params.ability:GetAbilityName()].IgnoreCooldownReduction == 1 then
		return 0
	end
	return GetCooldownReduction(self:GetParent(), params)
end
function public:GetModifierEvasion_Constant(params)
	return GetEvasion(self:GetParent(), params)
end
function public:GetModifierConstantHealthRegen(params)
	-- if tostring(GetHealthRegen(self:GetParent()) / GetHealth(self:GetParent()) * self:GetParent():GetMaxHealth()) == "5000" then
	-- 	print(self:GetParent():GetUnitName())
	-- end
	return GetHealthRegen(self:GetParent()) / GetHealth(self:GetParent()) * self:GetParent():GetMaxHealth()
end
function public:GetModifierManaBonus(params)
	return GetMana(self:GetParent()) - GetOriginalBaseStatusMana(self:GetParent())
end
function public:GetModifierConstantManaRegen(params)
	return GetManaRegen(self:GetParent())
end
function public:GetModifierAttackSpeedBaseOverride(params)
	local fBonus = GetBonusMaximumAttackSpeed(self:GetParent())
	return Clamp(1 + self:GetParent():GetIncreasedAttackSpeed(), MINIMUM_ATTACK_SPEED * 0.01, (MAXIMUM_ATTACK_SPEED + fBonus) * 0.01)
end
function public:GetModifierAttackRangeOverride(params)
	return GetAttackRange(self:GetParent(), params)
end
function public:GetModifierBaseAttackTimeConstant(params)
	return GetBaseAttackTime(self:GetParent(), params)
end
-- 这个只在server运行
function public:GetModifierTotalDamageOutgoing_Percentage(params)
	local iDamageFlags = params.damage_flags
	local iDamageType = params.damage_type
	local iDamageCategory = params.damage_category
	local fPercent = 100
	local hAttacker = params.attacker
	local hTarget = params.target

	if iDamageCategory ~= DOTA_DAMAGE_CATEGORY_ATTACK then
		RECORD_SYSTEM_DUMMY.iLastRecord = params.record
	end

	-- 暴击
	if iDamageCategory ~= DOTA_DAMAGE_CATEGORY_ATTACK then
		if iDamageType == DAMAGE_TYPE_PHYSICAL and not HasCriticalImmune(hTarget) and not DamageFilter(params.record, DAMAGE_STATE_PHYSICAL_CRIT, DAMAGE_STATE_NO_CRIT) then
			local fChance = GetPhysicalCriticalStrikeChance(hAttacker, params)
			local fDamage = GetPhysicalCriticalStrikeDamage(hAttacker, params)
			if fChance > 0 and fDamage > 0 and PRD(hAttacker, fChance, "physical_critical_strike") then
				_PhysicalCrit(params.record)
				FireModifierEvent(MODIFIER_EVENT_ON_CRITICAL, params, hAttacker)
				fPercent = fPercent * fDamage * 0.01
			end
		elseif iDamageType == DAMAGE_TYPE_MAGICAL and not HasCriticalImmune(hTarget) and not DamageFilter(params.record, DAMAGE_STATE_MAGICAL_CRIT, DAMAGE_STATE_NO_CRIT) then
			local fChance = GetMagicalCriticalStrikeChance(hAttacker, params)
			local fDamage = GetMagicalCriticalStrikeDamage(hAttacker, params)
			if fChance > 0 and fDamage > 0 and PRD(hAttacker, fChance, "magical_critical_strike") then
				_MagicalCrit(params.record)
				FireModifierEvent(MODIFIER_EVENT_ON_CRITICAL, params, hAttacker)
				fPercent = fPercent * fDamage * 0.01
			end
		end
	end

	if IsValid(hAttacker) then
		if not DamageFilter(params.record, DAMAGE_STATE_CLEAVE) then
			if iDamageType == DAMAGE_TYPE_PHYSICAL then
				fPercent = fPercent * (1 + GetOutgoingPhysicalDamagePercent(hAttacker, params) * 0.01)
			elseif iDamageType == DAMAGE_TYPE_MAGICAL then
				fPercent = fPercent * (1 + GetOutgoingMagicalDamagePercent(hAttacker, params) * 0.01)
			end
		end
	end

	return fPercent - 100
end
-- 这个只在server运行
function public:GetModifierIncomingDamage_Percentage(params)
	local iDamageFlags = params.damage_flags
	local iDamageType = params.damage_type
	local iDamageCategory = params.damage_category
	local fPercent = 100
	local hAttacker = params.attacker
	local hTarget = params.target

	if params.original_damage > 0 and math.floor(params.original_damage) > 0 and iDamageCategory ~= DOTA_DAMAGE_CATEGORY_ATTACK then
		local bMagicalCrit = DamageFilter(params.record, DAMAGE_STATE_MAGICAL_CRIT)
		if bMagicalCrit or DamageFilter(params.record, DAMAGE_STATE_PHYSICAL_CRIT) then
			local iNumber = math.floor(params.original_damage)
			local sNumber = tostring(iNumber)
			local fDuration = 3
			local vColor = bMagicalCrit and Vector(0, 191, 255) or Vector(255, 32, 32)
			local iParticleID = ParticleManager:CreateParticle("particles/msg_fx/msg_crit.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_OVERHEAD_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(0, iNumber, bMagicalCrit and 6 or 4))
			ParticleManager:SetParticleControl(iParticleID, 2, Vector(fDuration, #sNumber + 1, 0))
			ParticleManager:SetParticleControl(iParticleID, 3, vColor)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end

	if IsValid(hTarget) then
		if iDamageType == DAMAGE_TYPE_PHYSICAL then
			fPercent = fPercent * (1 - GetReduction(hTarget, params))
			fPercent = fPercent * (1 + GetIncomingPhysicalDamagePercent(hTarget, params) * 0.01)
		elseif iDamageType == DAMAGE_TYPE_MAGICAL then
			-- fPercent = fPercent * (1 - GetReduction(hTarget, params))
			fPercent = fPercent * 0.75
			fPercent = fPercent * (1 + GetIncomingMagicalDamagePercent(hTarget, params) * 0.01)
		end

		-- 伤害格挡
		local fLastDamage = params.damage * fPercent * 0.01
		params.last_damage = fLastDamage
		local fIgnoreDamage = GetIgnoreDamage(hTarget, params)
		fPercent = fPercent * (1 - Clamp(fIgnoreDamage / fLastDamage, 0, 1))
	end

	return fPercent - 100
end
----------------------------------------事件----------------------------------------
function public:OnTakeDamage(params)
	if not IsValid(params.unit) or params.unit:GetClassname() == "dota_item_drop" then return end

	local hParent = self:GetParent()
	if params.attacker == hParent then
		if params.unit:IsBuilding() or params.unit:IsOther() or params.unit == params.attacker then
			return
		end

		if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
			if params.damage_type == DAMAGE_TYPE_PHYSICAL then
				local fValue = GetPhysicalLifesteal(params.attacker, params)
				if fValue > 0 then
					local iParticleID = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
					ParticleManager:ReleaseParticleIndex(iParticleID)

					hParent:Heal(params.damage * fValue * 0.01, self:GetAbility())
				end
			end
			if params.damage_type == DAMAGE_TYPE_MAGICAL then
				local fValue = GetMagicalLifesteal(params.attacker, params)
				if fValue > 0 then
					local iParticleID = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
					ParticleManager:ReleaseParticleIndex(iParticleID)

					hParent:Heal(params.damage * fValue * 0.01, self:GetAbility())
				end
			end
		end
	end
end
function public:OnDamageCalculated(params)
	local hTarget = params.target
	if not IsValid(hTarget) == nil or hTarget:GetClassname() == "dota_item_drop" then return end
	local hParent = self:GetParent()

	-- 分裂
	if params.attacker == hParent and not AttackFilter(params.record, ATTACK_STATE_NOT_PROCESSPROCS) then
		local fCleaveRadius = GetCleaveRadius(hParent, params)
		local fCleaveDamage = GetCleaveDamage(hParent, params)
		if fCleaveRadius > 0 and fCleaveDamage > 0 then
			local sParticlePath = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf", hParent)
			local iParticleID = ParticleManager:CreateParticle(sParticlePath, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), false)
			local n = 0
			local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, fCleaveRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
			for _, hUnit in ipairs(tTargets) do
				if hUnit ~= hTarget then
					local tDamageTable = {
						victim = hUnit,
						attacker = hParent,
						damage = params.original_damage * fCleaveDamage * 0.01,
						damage_type = DAMAGE_TYPE_PHYSICAL,
					}
					ApplyDamage(tDamageTable, DAMAGE_STATE_NO_CRIT + DAMAGE_STATE_CLEAVE)
					n = n + 1
					ParticleManager:SetParticleControlEnt(iParticleID, n + 1, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, hUnit:GetAbsOrigin(), true)
				end
			end
			FireModifierEvent(MODIFIER_EVENT_ON_CLEAVE, {
				attacker = hParent,
				target = hTarget,
				center = hTarget:GetAbsOrigin(),
				radius = fCleaveRadius,
				damage = params.original_damage * fCleaveDamage * 0.01,
				tTargets = tTargets,
			}, hParent, hTarget)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(2, 17, n))
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end
end