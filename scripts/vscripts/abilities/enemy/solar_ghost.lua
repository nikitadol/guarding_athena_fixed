---@class solar_ghost: eom_ability
solar_ghost = eom_ability({})
function solar_ghost:GetIntrinsicModifierName()
	return "modifier_solar_ghost"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_solar_ghost : eom_modifier
modifier_solar_ghost = eom_modifier({
	Name = "modifier_solar_ghost",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_solar_ghost:GetAbilitySpecialValue()
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_solar_ghost:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		hParent:AddNewModifier(hParent, hAbility, "modifier_solar_ghost_buff", nil)
		self:SetStackCount(1)
		self:StartIntervalThink(self.interval)
	end
end
function modifier_solar_ghost:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(1)
	end
end
function modifier_solar_ghost:OnAttackLanded(params)
	if IsServer() then
		if self:GetStackCount() == 1 then
			self:SetStackCount(0)
			local hParent = self:GetParent()
			local hAbility = self:GetAbility()
			hParent:DealDamage(params.target, hAbility, params.target:GetCustomHealth() * self.damage * 0.01)
			hParent:RemoveModifierByName("modifier_solar_ghost_buff")
			hParent:AddNewModifier(hParent, hAbility, "modifier_solar_ghost_buff", nil)
		end
	end
end
function modifier_solar_ghost:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_solar_ghost_buff : eom_modifier
modifier_solar_ghost_buff = eom_modifier({
	Name = "modifier_solar_ghost_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_solar_ghost_buff:GetModifierInvisibilityLevel()
	return RemapValClamped(self:GetElapsedTime(), 0, 0.7, 0, 1)
end
function modifier_solar_ghost_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
end
function modifier_solar_ghost_buff:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = self:GetModifierInvisibilityLevel() == 1
	}
end