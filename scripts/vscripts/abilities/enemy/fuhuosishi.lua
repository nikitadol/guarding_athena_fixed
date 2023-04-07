---@class fuhuosishi: eom_ability
fuhuosishi = eom_ability({
	iTargetFlags = DOTA_UNIT_TARGET_FLAG_DEAD,
	funcUnitsCallback = function(hAbility, tTargets)
		for i = #tTargets, 1, -1 do
			local hUnit = tTargets[i]
			if hUnit:IsAlive() or hUnit:HasModifier("modifier_fuhuosishi") then
				table.remove(tTargets, i)
			end
		end
	end
}, nil, ability_base_ai)
function fuhuosishi:GetRadius()
	return 1200
end
function fuhuosishi:OnSpellStart()
	local hCaster = self:GetCaster()
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false)
	for i, v in ipairs(tTargets) do
		if not v:IsAlive() and not v:HasModifier("modifier_fuhuosishi") then
			v:RespawnUnit()
			v:AddNewModifier(hCaster, self, "modifier_kill", { duration = 60 })
			v:AddNewModifier(hCaster, self, "modifier_fuhuosishi", { duration = 60 })
			break
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_fuhuosishi : eom_modifier
modifier_fuhuosishi = eom_modifier({
	Name = "modifier_fuhuosishi",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	RemoveOnDeath = false
})
function modifier_fuhuosishi:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_wraithking_ghosts.vpcf", PATTACH_INVALID, hParent)
		self:AddParticle(iParticleID, false, true, 10, false, false)
	end
end