---@class ring_4_5: eom_modifier 诡丝双瞳
ring_4_5 = eom_modifier({
	Name = "ring_4_5",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_4_5:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = -25,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() }
	}
end
function ring_4_5:OnTakeDamage(params)
	if IsServer() then
		local hParent = self:GetParent()
		local hTarget = params.unit
		local damage = hParent:GetPrimaryStats() * 40
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for i, hUnit in ipairs(tTargets) do
			hParent:DealDamage(hUnit, nil, damage, DAMAGE_TYPE_PURE)
			if i <= 6 then
				local iParticleID = ParticleManager:CreateParticle("particles/items/ring/ring_4_5.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
				ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
				ParticleManager:ReleaseParticleIndex(iParticleID)
			end
		end
	end
end
function ring_4_5:GetTexture()
	return "item_ring_secret"
end