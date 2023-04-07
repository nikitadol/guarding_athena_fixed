---@class windrunner_0 : eom_ability
windrunner_0 = eom_ability({})
function windrunner_0:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_windrunner/windrunner_0_magic_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_windrunner/windrunner_gold/windrunner_0_magic_attack.vpcf", context)
end
function windrunner_0:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hCaster:AddNewModifier(hCaster, self, "modifier_windrunner_0_active", { duration = self:GetSpecialValueFor("duration"), iEntIndex = hTarget:entindex() })
	hCaster:MoveToTargetToAttack(hTarget)
end
function windrunner_0:GetIntrinsicModifierName()
	return "modifier_windrunner_0"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_windrunner_0 : eom_modifier
modifier_windrunner_0 = eom_modifier({
	Name = "modifier_windrunner_0",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})

function modifier_windrunner_0:GetAbilitySpecialValue()
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.delay_pct = self:GetAbilitySpecialValueFor("delay_pct")
end
function modifier_windrunner_0:OnCreated(params)
	if IsServer() then
		self.tRecord = {}
	end
end
function modifier_windrunner_0:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_windrunner_0:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK = { self:GetParent() },
		MODIFIER_EVENT_ON_ATTACK_RECORD = { self:GetParent() },
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY = { self:GetParent() }
	}
end
function modifier_windrunner_0:OnAttackRecord(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end

	local hParent = self:GetParent()
	if hParent:HasModifier("modifier_windrunner_0_bonus_attack") then
		table.insert(self.tRecord, params.record)
	end
end
function modifier_windrunner_0:OnAttackRecordDestroy(params)
	ArrayRemove(self.tRecord, params.record)
end
function modifier_windrunner_0:OnAttack(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end

	local hParent = self:GetParent()
	if not hParent:HasModifier("modifier_windrunner_0_bonus_attack") then
		self.hModifier = hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_windrunner_0_bonus_attack", nil)
	else
		hParent:RemoveModifierByName("modifier_windrunner_0_bonus_attack")
	end
end
function modifier_windrunner_0:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
	}
end
function modifier_windrunner_0:GetOverrideAttackMagical(params)
	if TableFindKey(self.tRecord, params.record) then
		return 1
	end
end
function modifier_windrunner_0:GetModifierProcAttack_BonusDamage_Magical(params)
	if TableFindKey(self.tRecord, params.record) then
		local flDamage = params.damage
		if self:GetParent():GetScepterLevel() >= 1 then
			flDamage = flDamage + self:GetAbilitySpecialValueFor("scepter_damage")
		end
		return flDamage
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_windrunner_0_bonus_attack : eom_modifier
modifier_windrunner_0_bonus_attack = eom_modifier({
	Name = "modifier_windrunner_0_bonus_attack",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_windrunner_0_bonus_attack:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_windrunner_0_bonus_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end
function modifier_windrunner_0_bonus_attack:GetModifierAttackSpeedBonus_Constant(params)
	if IsServer() then
		return 1000
	end
end
function modifier_windrunner_0_bonus_attack:GetModifierBaseAttackTimeConstant()
	if IsServer() then
		return 0.01
	end
end
function modifier_windrunner_0_bonus_attack:GetModifierProjectileName()
	return AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_windrunner/windrunner_0_magic_attack.vpcf", self:GetParent())
end
----------------------------------------Modifier----------------------------------------
---@class modifier_windrunner_0_active : eom_modifier
modifier_windrunner_0_active = eom_modifier({
	Name = "modifier_windrunner_0_active",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_windrunner_0_active:GetAbilitySpecialValue()
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
	self.bonus_attack_range = self:GetAbilitySpecialValueFor("bonus_attack_range")
end
function modifier_windrunner_0_active:OnCreated(params)
	if IsServer() then
		self.hTarget = EntIndexToHScript(params.iEntIndex)
	end
end
function modifier_windrunner_0_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
end
function modifier_windrunner_0_active:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
end
function modifier_windrunner_0_active:GetModifierAttackSpeedBonus_Constant(params)
	if IsServer() then
		local hAggro = self:GetParent():GetAggroTarget()
		if IsValid(hAggro) and hAggro ~= self.hTarget then
			return 0
		end
	end
	return self.bonus_attackspeed
end
function modifier_windrunner_0_active:EOM_GetModifierAttackRangeBonus(params)
	if IsServer() then
		local hAggro = self:GetParent():GetAggroTarget()
		if IsValid(hAggro) and hAggro ~= self.hTarget then
			return 0
		end
	end
	return self.bonus_attack_range
end
function modifier_windrunner_0_active:GetModifierBaseAttackTimeConstant()
	if IsServer() then
		local hAggro = self:GetParent():GetAggroTarget()
		if IsValid(hAggro) and hAggro ~= self.hTarget then
			return 0
		end
	end
	return 1
end