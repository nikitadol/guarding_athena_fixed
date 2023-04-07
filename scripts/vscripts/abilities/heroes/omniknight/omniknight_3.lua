---@class omniknight_3 : eom_ability
omniknight_3 = eom_ability({})
function omniknight_3:GetIntrinsicModifierName()
	return "modifier_omniknight_3"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_omniknight_3 : eom_modifier
modifier_omniknight_3 = eom_modifier({
	Name = "modifier_omniknight_3",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_omniknight_3:GetAbilitySpecialValue()
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
	self.bonus_str = self:GetAbilitySpecialValueFor("bonus_str")
	self.bonus_str_pct = self:GetAbilitySpecialValueFor("bonus_str_pct")
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.bonus_str_factor = self:GetAbilitySpecialValueFor("bonus_str_factor")
	self.bonus_chance = self:GetAbilitySpecialValueFor("bonus_chance")
	if IsServer() then
		self.tStrFactorData = {
			type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY,
			ability_name = "omniknight_0",
			special_value_name = "str_factor",
			special_value_property = "_str",
			operator = ABILITY_UPGRADES_OP_ADD,
			value = self.bonus_str_factor,
		}
		self.tChanceData = {
			type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE,
			ability_name = "omniknight_0",
			special_value_name = "chance",
			operator = ABILITY_UPGRADES_OP_ADD,
			value = self.bonus_chance,
		}
	end
end
function modifier_omniknight_3:AddCustomTransmitterData()
	return {
		iStrength = self.iStrength,
	}
end
function modifier_omniknight_3:HandleCustomTransmitterData(tData)
	self.iStrength = tData.iStrength
end
function modifier_omniknight_3:OnCreated(params)
	self:SetHasCustomTransmitterData(true)
	if IsServer() then
		self.iStrength = 0
		AbilityUpgrades:AddSpecialValuePropertyUpgrade(self:GetParent(), self.tStrFactorData)
		AbilityUpgrades:AddSpecialValueUpgrade(self:GetParent(), self.tChanceData)
	end
end
function modifier_omniknight_3:OnRefresh(params)
	if IsServer() then
		AbilityUpgrades:UpdateSpecialValuePropertyUpgrade(self:GetParent(), self.tStrFactorData)
		AbilityUpgrades:UpdateSpecialValueUpgrade(self:GetParent(), self.tChanceData)
	end
end
function modifier_omniknight_3:OnDestroy()
	if IsServer() then
		AbilityUpgrades:RemoveSpecialValuePropertyUpgrade(self:GetParent(), self.tStrFactorData)
		AbilityUpgrades:RemoveSpecialValueUpgrade(self:GetParent(), self.tChanceData)
	end
end
function modifier_omniknight_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_omniknight_3:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE_PERCENTAGE,
	}
end
function modifier_omniknight_3:OnAttackLanded(params)
	if self:GetParent() == params.attacker then
		-- 雷霆战士皮肤
		if self:GetParent():HasModifier("modifier_omniknight_01") and self:GetStackCount() == self.attack_count - 1 then
			local hAbility = self:GetParent():FindAbilityByName("omniknight_0")
			hAbility:Action(params.target, true)
		end
		self:IncrementStackCount()
	end
end
function modifier_omniknight_3:OnStackCountChanged(iStackCount)
	if self:GetStackCount() == self.attack_count then
		self:SetStackCount(0)
		if IsServer() then
			self:GetParent():AddPermanentAttribute(CUSTOM_ATTRIBUTE_STRENGTH, 1)
			self.iStrength = self.iStrength + 1
			self:SendBuffRefreshToClients()
		end
	end
end
function modifier_omniknight_3:EOM_GetModifierBonusStats_Strength()
	return self.bonus_str
end
function modifier_omniknight_3:EOM_GetModifierBaseStats_Strength_Percentage()
	return self.bonus_str_pct
end
function modifier_omniknight_3:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attackspeed
end
function modifier_omniknight_3:OnTooltip()
	return self.iStrength
end