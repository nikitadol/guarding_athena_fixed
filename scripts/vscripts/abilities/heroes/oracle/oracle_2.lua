---@class oracle_2 : eom_ability
oracle_2 = eom_ability({})
function oracle_2:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_oracle_2", { duration = self:GetSpecialValueFor("duration") })
	hCaster:EmitSound("Hero_Oracle.FalsePromise.Damaged")
	self:StartCooldown(self:GetCooldown(self:GetLevel() - 1))
end
----------------------------------------Modifier----------------------------------------
---@class modifier_oracle_2 : eom_modifier
modifier_oracle_2 = eom_modifier({
	Name = "modifier_oracle_2",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_oracle_2:GetAbilitySpecialValue()
	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.scepter_bonus_int_pct = self:GetAbilitySpecialValueFor("scepter_bonus_int_pct")
	self.cooldown_reduction = self:GetAbilitySpecialValueFor("cooldown_reduction")
	self.base_level = self:GetAbilitySpecialValueFor("base_level")
	self.util_level = self:GetAbilitySpecialValueFor("util_level")
	if IsServer() then
		self.tData = {
			{
				type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE,
				ability_name = "oracle_1",
				special_value_name = "damage",
				operator = ABILITY_UPGRADES_OP_ADD,
				value = 80 * self.base_level,
			},
			{
				type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY,
				ability_name = "oracle_1",
				special_value_name = "damage",
				special_value_property = "_int",
				operator = ABILITY_UPGRADES_OP_ADD,
				value = 2 * self.base_level,
			},
			{
				type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY,
				ability_name = "oracle_1",
				special_value_name = "damage_dot",
				special_value_property = "_int",
				operator = ABILITY_UPGRADES_OP_ADD,
				value = 0.5 * self.base_level,
			},
			{
				type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE,
				ability_name = "oracle_3",
				special_value_name = "damage",
				operator = ABILITY_UPGRADES_OP_ADD,
				value = 50 * self.base_level,
			},
			{
				type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY,
				ability_name = "oracle_3",
				special_value_name = "damage",
				special_value_property = "_int",
				operator = ABILITY_UPGRADES_OP_ADD,
				value = 3 * self.base_level,
			},
			{
				type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE,
				ability_name = "oracle_4",
				special_value_name = "damage",
				operator = ABILITY_UPGRADES_OP_ADD,
				value = 200 * self.util_level,
			},
			{
				type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY,
				ability_name = "oracle_4",
				special_value_name = "damage",
				special_value_property = "_int",
				operator = ABILITY_UPGRADES_OP_ADD,
				value = 80 * self.util_level,
			},
		}
	end
end
function modifier_oracle_2:OnCreated(params)
	local hParent = self:GetParent()
	hParent.GetOracleCooldown = function(hParent, flCooldown)
		return flCooldown * (1 - self.cooldown_reduction * 0.01)
	end
	if IsServer() then
		for i, tData in ipairs(self.tData) do
			if tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE then
				AbilityUpgrades:AddSpecialValueUpgrade(hParent, tData)
			else
				AbilityUpgrades:AddSpecialValuePropertyUpgrade(hParent, tData)
			end
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/oracle/oracle_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_oracle_2:OnRefresh(params)
	local hParent = self:GetParent()
	if IsServer() then
		for i, tData in ipairs(self.tData) do
			if tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE then
				AbilityUpgrades:UpdateSpecialValueUpgrade(hParent, tData)
			else
				AbilityUpgrades:UpdateSpecialValuePropertyUpgrade(hParent, tData)
			end
		end
	end
end
function modifier_oracle_2:OnDestroy()
	local hParent = self:GetParent()
	hParent.GetOracleCooldown = nil
	if IsServer() then
		for i, tData in ipairs(self.tData) do
			if tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE then
				AbilityUpgrades:RemoveSpecialValueUpgrade(hParent, tData)
			else
				AbilityUpgrades:RemoveSpecialValuePropertyUpgrade(hParent, tData)
			end
		end
	end
end
function modifier_oracle_2:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BASE_PERCENTAGE,
	}
end
function modifier_oracle_2:EOM_GetModifierBonusStats_Intellect(t)
	return self.bonus_intellect
end
function modifier_oracle_2:EOM_GetModifierBaseStats_Intellect_Percentage(t)
	if self:GetParent():GetScepterLevel() >= 2 then
		return self.scepter_bonus_int_pct
	end
end