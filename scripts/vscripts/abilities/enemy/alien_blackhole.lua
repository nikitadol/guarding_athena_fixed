---@class alien_blackhole: eom_ability
alien_blackhole = eom_ability({})
function alien_blackhole:GetIntrinsicModifierName()
	return "modifier_alien_blackhole"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_alien_blackhole : eom_modifier
modifier_alien_blackhole = eom_modifier({
	Name = "modifier_alien_blackhole",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_alien_blackhole:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_alien_blackhole:OnDeath(params)
	if IsServer() then
		local hParent = self:GetParent()
		CreateModifierThinker(hParent, self:GetAbility(), "modifier_alien_blackhole_thinker", { duration = 5 }, hParent:GetAbsOrigin(), hParent:GetTeamNumber(), false)
	end
end
function modifier_alien_blackhole:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent() }
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_alien_blackhole_thinker : eom_modifier
modifier_alien_blackhole_thinker = eom_modifier({
	Name = "modifier_alien_blackhole_thinker",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	IsModifierThinker = true
})
function modifier_alien_blackhole_thinker:OnCreated(params)
	local hParent = self:GetParent()
	self.damage = self:GetAbilitySpecialValueFor("damage")
	if IsServer() then
		hParent:EmitSound("Hero_Enigma.Black_Hole")
		self:StartIntervalThink(0)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/alien_blackhole.vpcf", PATTACH_ABSORIGIN, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_alien_blackhole_thinker:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		local vDirection = (hUnit:GetAbsOrigin() - hParent:GetAbsOrigin()):Normalized()
		local flDistance = (hUnit:GetAbsOrigin() - hParent:GetAbsOrigin()):Length2D()
		hUnit:SetAbsOrigin(hUnit:GetAbsOrigin() - vDirection * flDistance / 40)
		hUnit:AddNewModifier(hUnit, nil, BUILT_IN_MODIFIER.PHASED, { duration = 0.2 })
		hParent:DealDamage(hUnit, nil, self.damage - ((flDistance / 400) * self.damage))
	end
end
function modifier_alien_blackhole_thinker:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:StopSound("Hero_Enigma.Black_Hole")
	end
end