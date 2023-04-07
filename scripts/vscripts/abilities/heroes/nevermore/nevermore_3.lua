---@class nevermore_3 : eom_ability
nevermore_3 = eom_ability({})
function nevermore_3:OnToggle()
	if self:GetToggleState() == true then
		self:GetIntrinsicModifier():SetStackCount(1)
	else
		self:GetIntrinsicModifier():SetStackCount(0)
	end
end
function nevermore_3:GetIntrinsicModifierName()
	return "modifier_nevermore_3"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_nevermore_3 : eom_modifier
modifier_nevermore_3 = eom_modifier({
	Name = "modifier_nevermore_3",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_nevermore_3:GetAbilitySpecialValue()
	self.mana_cost = self:GetAbilitySpecialValueFor("mana_cost")
	self.attack_per_str = self:GetAbilitySpecialValueFor("attack_per_str")
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
	self.armor_ignore = self:GetAbilitySpecialValueFor("armor_ignore")
	self.scepter_crit_damage = self:GetAbilitySpecialValueFor("scepter_crit_damage")
	self.scepter_cooldown = self:GetAbilitySpecialValueFor("scepter_cooldown")
end
function modifier_nevermore_3:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BONUS,
		EOM_MODIFIER_PROPERTY_IGNORE_ARMOR_PERCENTAGE = self.armor_ignore,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_CHANCE
	}
end
function modifier_nevermore_3:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL,
		-- MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
	}
end
function modifier_nevermore_3:OnAttack(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if self:GetStackCount() == 1 then
		if params.attacker == self:GetParent() then
			if params.attacker:GetMana() >= self.mana_cost then
				params.attacker:SpendMana(self.mana_cost, self:GetAbility())
			else
				self:GetAbility():ToggleAbility()
			end
		end
	end
end
function modifier_nevermore_3:EOM_GetModifierAttackDamageBonus(params)
	local flAttack = self:GetParent():GetStrength() * self.attack_per_str
	if self:GetStackCount() == 1 then
		flAttack = flAttack * 2
	end
	return flAttack
end
function modifier_nevermore_3:GetOverrideAttackMagical(params)
	if self:GetStackCount() == 1 and self:GetParent():GetScepterLevel() < 4 then
		return 1
	end
end
function modifier_nevermore_3:GetModifierProcAttack_BonusDamage_Pure(params)
	if self:GetStackCount() == 1 then
		return params.damage
	end
end
function modifier_nevermore_3:GetModifierAttackSpeedBonus_Constant(params)
	if self:GetStackCount() == 1 then
		return self.bonus_attackspeed
	end
end
function modifier_nevermore_3:EOM_GetModifierPhysicalCriticalStrikeChance(params)
	if IsServer() then
		if self:GetParent():GetScepterLevel() >= 4 and self:GetStackCount() == 1 and self:GetAbility():IsCooldownReady() then
			self:GetAbility():StartCooldown(self.scepter_cooldown)
			return 100
		end
	end
end
function modifier_nevermore_3:EOM_GetModifierPhysicalCriticalStrikeDamage(params)
	if self:GetParent():GetScepterLevel() >= 4 then
		return self.scepter_crit_damage
	end
end
function modifier_nevermore_3:GetModifierProjectileName(params)
	if self:GetStackCount() == 1 then
		return "particles/econ/world/towers/ti10_dire_tower/ti10_dire_tower_attack.vpcf"
	end
end