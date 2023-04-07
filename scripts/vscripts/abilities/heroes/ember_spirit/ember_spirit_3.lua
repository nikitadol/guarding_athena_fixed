---@class ember_spirit_3 : eom_ability
ember_spirit_3 = eom_ability({})
function ember_spirit_3:OnToggle()
	local hCaster = self:GetCaster()
	if self:GetToggleState() then
		hCaster:AddNewModifier(hCaster, self, "modifier_ember_spirit_3", nil)
		hCaster:EmitSound("Hero_EmberSpirit.FlameGuard.Cast")
	else
		hCaster:RemoveModifierByName("modifier_ember_spirit_3")
	end
end
function ember_spirit_3:ResetToggleOnRespawn()
	return false
end
---------------------------------------------------------------------
--Modifiers
modifier_ember_spirit_3 = eom_modifier({
	Name = "modifier_ember_spirit_3",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_ember_spirit_3:GetAbilitySpecialValue()
	self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
	self.health_cost_pct = self:GetAbilitySpecialValueFor("health_cost_pct")
	self.attack_per_health = self:GetAbilitySpecialValueFor("attack_per_health")
	self.interval = 0.1
end
function modifier_ember_spirit_3:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
		self:StartIntervalThink(self.interval)
		hParent:EmitSound("Hero_EmberSpirit.FlameGuard.Loop")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/skills/fire_spirit_3_1.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_ember_spirit_3:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local flHealthCost = hParent:GetCustomMaxHealth() * self.health_cost_pct * 0.01
	if hParent:GetCustomHealth() > flHealthCost * self.interval then
		if not hParent:HasModifier("modifier_ember_spirit_1") and
		not hParent:HasModifier("modifier_ember_spirit_2") and
		not hParent:HasModifier("modifier_ember_spirit_4")
		then
			hParent:SpendHealth(flHealthCost * self.interval, hAbility, false)
		end
		self:SetStackCount(math.floor(flHealthCost))
	else
		hAbility:ToggleAbility()
	end
end
function modifier_ember_spirit_3:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:StopSound("Hero_EmberSpirit.FlameGuard.Loop")
	end
end
function modifier_ember_spirit_3:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE = -self.damage_reduce_pct,
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BONUS
	}
end
function modifier_ember_spirit_3:EOM_GetModifierAttackDamageBonus()
	return self:GetStackCount() * self.attack_per_health
end