---@class pet_9_1: eom_ability
pet_9_1 = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetAutoCastState()
	end
}, nil, ability_base_ai)
function pet_9_1:CastFilterResultTarget(hTarget)
	if hTarget:IsBoss() or hTarget:IsAncient() or hTarget:IsConsideredHero() then
		return UF_FAIL_ANCIENT
	end
	return UF_SUCCESS
end
function pet_9_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hMaster = hCaster:GetMaster()
	local hTarget = self:GetCursorTarget()
	hTarget:Kill(self, hCaster)
	local iGold = (tonumber(KeyValues:GetUnitData(hTarget, "BountyGold")) or 0) * self:GetSpecialValueFor("bonus_gold")
	local iExp = (tonumber(KeyValues:GetUnitData(hTarget, "BountyXP")) or 0) * self:GetSpecialValueFor("bonus_exp")
	-- hMaster:ModifyGold(iGold, true, 0)
	PlayerData:ModifyGold(hMaster:GetPlayerOwnerID(), iGold)
	hMaster:AddExperience(iExp, 0, false, false)
	SendOverheadEventMessage(hMaster:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, hMaster, iGold, hMaster:GetPlayerOwner())
	SendOverheadEventMessage(hMaster:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, hMaster, iExp, hMaster:GetPlayerOwner())
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/doom/doom_ti8_immortal_arms/doom_ti8_immortal_devour.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 0, hTarget:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
	hCaster:EmitSound("Hero_DoomBringer.Devour")
end