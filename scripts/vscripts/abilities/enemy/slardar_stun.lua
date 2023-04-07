---@class slardar_stun: eom_ability
slardar_stun = eom_ability({})
function slardar_stun:GetIntrinsicModifierName()
	return "modifier_slardar_stun"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_slardar_stun : eom_modifier
modifier_slardar_stun = eom_modifier({
	Name = "modifier_slardar_stun",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_slardar_stun:GetAbilitySpecialValue()
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
end
function modifier_slardar_stun:OnAttackLanded(params)
	if PRD(self, self.chance, "modifier_slardar_stun") then
		params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_slardar_stun_debuff", { duration = self.duration })
		params.attacker:EmitSound("Hero_Slardar.Bash")
	end
end
function modifier_slardar_stun:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.attackspeed
	}
end
function modifier_slardar_stun:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_slardar_stun_debuff : eom_modifier
modifier_slardar_stun_debuff = eom_modifier({
	Name = "modifier_slardar_stun_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	IsIndependent = true,
	StackDuration = 6
})
function modifier_slardar_stun_debuff:GetAbilitySpecialValue()
	self.stats = self:GetAbilitySpecialValueFor("stats")
end
function modifier_slardar_stun_debuff:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_slardar_stun_debuff:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_slardar_stun_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS
	}
end
function modifier_slardar_stun_debuff:EOM_GetModifierBonusStats_All()
	return -self.stats * self:GetStackCount()
end