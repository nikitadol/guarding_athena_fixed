---@class ciba: eom_ability
ciba = eom_ability({})
function ciba:GetIntrinsicModifierName()
	return "modifier_ciba"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_ciba : eom_modifier
modifier_ciba = eom_modifier({
	Name = "modifier_ciba",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_ciba:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_ciba:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/econ/courier/courier_greevil_naked/courier_greevil_naked_ambient_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_ciba:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local vPosition = Game.tTeamBase[DOTA_TEAM_GOODGUYS]:GetAbsOrigin() + RandomVector(RandomInt(0, 900))
		local tTargets = FindUnitsInRadiusWithAbility(hParent, Game.tTeamBase[DOTA_TEAM_GOODGUYS]:GetAbsOrigin(), 900, hAbility)
		if IsValid(tTargets[1]) then
			vPosition = tTargets[1]:GetAbsOrigin()
		end
		hParent:MoveToPositionAggressive(vPosition)
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), 300, hAbility)
		hParent:DealDamage(tTargets, hAbility, 10000)
	end
end
function modifier_ciba:OnDestroy()
	if IsServer() then
	end
end
function modifier_ciba:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end
function modifier_ciba:ECheckState()
	return {
		[EOM_MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end