---@class troll_concentrate: eom_ability
troll_concentrate = eom_ability({})
function troll_concentrate:GetIntrinsicModifierName()
	return "modifier_troll_concentrate"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_troll_concentrate : eom_modifier
modifier_troll_concentrate = eom_modifier({
	Name = "modifier_troll_concentrate",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_troll_concentrate:GetAbilitySpecialValue()
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.attack = self:GetAbilitySpecialValueFor("attack")
end
function modifier_troll_concentrate:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(AI_THINK_TICK_TIME)
	end
end
function modifier_troll_concentrate:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), 1000, hAbility)
		if #tTargets == 1 and tTargets[1]:IsRealHero() then
			local vPosition = hParent:GetAbsOrigin() + (hParent:GetAbsOrigin() - tTargets[1]:GetAbsOrigin()):Normalized() * 200
			if GridNav:CanFindPath(hParent:GetAbsOrigin(), vPosition) then
				hParent:MoveToPosition(vPosition)
			end
		end
	end
end
function modifier_troll_concentrate:OnAttackLanded(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	self:IncrementStackCount()
end
function modifier_troll_concentrate:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_troll_concentrate:GetModifierAttackSpeedBonus_Constant()
	return (self.attackspeed or 0) * self:GetStackCount()
end
function modifier_troll_concentrate:EOM_GetModifierAttackDamageBase()
	return self.attack * self:GetStackCount()
end
function modifier_troll_concentrate:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE
	}
end