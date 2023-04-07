---@class alien_obsidian_star: eom_ability
alien_obsidian_star = eom_ability({}, nil, ability_base_ai)
function alien_obsidian_star:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	CreateModifierThinker(hCaster, self, "modifier_alien_obsidian_star", { duration = 2 }, vPosition, hCaster:GetTeamNumber(), false)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_alien_obsidian_star : eom_modifier
modifier_alien_obsidian_star = eom_modifier({
	Name = "modifier_alien_obsidian_star",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	IsModifierThinker = true
})
function modifier_alien_obsidian_star:OnCreated(params)
	local hParent = self:GetParent()
	self.damage = self:GetAbilitySpecialValueFor("damage")
	if IsServer() then
		self:StartIntervalThink(0)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/alien_obsidian_star.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin() + Vector(0, 0, 200))
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(200, 200, 200))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_alien_obsidian_star:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		local vDirection = (hUnit:GetAbsOrigin() - hParent:GetAbsOrigin()):Normalized()
		local flDistance = (hUnit:GetAbsOrigin() - hParent:GetAbsOrigin()):Length2D()
		hUnit:SetAbsOrigin(hUnit:GetAbsOrigin() - vDirection * flDistance / 20)
		hUnit:AddNewModifier(hUnit, nil, BUILT_IN_MODIFIER.PHASED, { duration = 0.2 })
		hParent:DealDamage(hUnit, nil, self.damage - ((flDistance / 400) * self.damage))
	end
end