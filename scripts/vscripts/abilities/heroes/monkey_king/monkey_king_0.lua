---@class monkey_king_0 : eom_ability
monkey_king_0 = eom_ability({})
function monkey_king_0:GetIntrinsicModifierName()
	return "modifier_monkey_king_0"
end
---------------------------------------------------------------------
--Modifiers
modifier_monkey_king_0 = eom_modifier({
	Name = "modifier_monkey_king_0",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_monkey_king_0:GetAbilitySpecialValue()
	self.damage_reduce = self:GetAbilitySpecialValueFor("damage_reduce")
	self.damage_deep = self:GetAbilitySpecialValueFor("damage_deep")
	self.scepter_chance = self:GetAbilitySpecialValueFor("scepter_chance")
	self.scepter_critical = self:GetAbilitySpecialValueFor("scepter_critical")
end
function modifier_monkey_king_0:OnCreated(params)
	if IsServer() then
		self.tRecord = {}
	end
end
function modifier_monkey_king_0:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_RECORD = { self:GetParent() },
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_IGNORE_ARMOR_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_CHANCE,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE,
	-- MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
	}
end
function modifier_monkey_king_0:EOM_GetModifierIncomingDamagePercentage(params)
	if params and params.attacker then
		local flHealthPct = 100 - params.attacker:GetHealthPercent()
		return -flHealthPct * self.damage_reduce
	end
end
function modifier_monkey_king_0:EOM_GetModifierOutgoingDamagePercentage(params)
	if params and params.target then
		local flHealthPct = 100 - params.target:GetHealthPercent()
		return flHealthPct * self.damage_deep
	end
end
-- function modifier_monkey_king_0:GetModifierProcAttack_BonusDamage_Pure(params)
-- 	if self:GetParent():GetScepterLevel() >= 3 and PRD(self, self.scepter_chance, "modifier_monkey_king_0") then
-- 		local flDamage = params.original_damage * self.scepter_critical
-- 		CreateNumberEffect(params.target, flDamage, 1.5, MSG_ORIT, "orange", 4)
-- 		return flDamage
-- 	end
-- end
function modifier_monkey_king_0:OnAttackRecord(params)
	if IsServer() then
		if self:GetParent():GetScepterLevel() >= 3 and PRD(self, self.scepter_chance, "modifier_monkey_king_0") then
			table.insert(self.tRecord, params.record)
		end
	end
end
function modifier_monkey_king_0:OnAttackRecordDestroy(params)
	if IsServer() then
		ArrayRemove(self.tRecord, params.record)
	end
end
function modifier_monkey_king_0:EOM_GetModifierIgnoreArmorPercentage(params)
	if TableFindKey(self.tRecord, params.record) then
		return 100
	end
end
function modifier_monkey_king_0:EOM_GetModifierPhysicalCriticalStrikeChance(params)
	if params and params.record and TableFindKey(self.tRecord, params.record) then
		return 100
	end
end
function modifier_monkey_king_0:EOM_GetModifierPhysicalCriticalStrikeDamage(params)
	if params and params.record and TableFindKey(self.tRecord, params.record) then
		return self.scepter_critical * 100
	end
end