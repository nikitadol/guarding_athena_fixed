---@class zombie_tower: eom_ability
zombie_tower = eom_ability({})
function zombie_tower:GetIntrinsicModifierName()
	return "modifier_zombie_tower"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_zombie_tower : eom_modifier
modifier_zombie_tower = eom_modifier({
	Name = "modifier_zombie_tower",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_zombie_tower:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_zombie_tower:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1.4)
	end
end
function modifier_zombie_tower:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAlive() then
		local hAbility = self:GetAbility()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), 600, hAbility)
		if IsValid(tTargets[1]) then
			local hUnit = tTargets[1]
			local iParticleID = ParticleManager:CreateParticle("particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_medium_ti_5.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin() + Vector(0, 0, 200))
			ParticleManager:SetParticleControlEnt(iParticleID, 1, hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetAbsOrigin(), false)
			ParticleManager:ReleaseParticleIndex(iParticleID)
			if hUnit:HasItemInInventory("item_mirror") or Items:IsDevouredItem(hUnit, "item_mirror") then
				local _tTargets = FindUnitsInRadiusWithAbility(hUnit, hUnit:GetAbsOrigin(), 600, hAbility)
				if _tTargets[1] then
					hUnit:DealDamage(_tTargets[1], hAbility, _tTargets[1]:GetCustomMaxHealth() * self.damage * 0.01, DAMAGE_TYPE_PURE)
					local iParticleID = ParticleManager:CreateParticle("particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_medium_ti_5.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(iParticleID, 0, hUnit:GetAttachmentPosition("attach_hitloc"))
					ParticleManager:SetParticleControlEnt(iParticleID, 1, _tTargets[1], PATTACH_POINT_FOLLOW, "attach_hitloc", _tTargets[1]:GetAbsOrigin(), false)
					ParticleManager:ReleaseParticleIndex(iParticleID)
				end
			else
				hParent:DealDamage(hUnit, hAbility, hUnit:GetCustomMaxHealth() * self.damage * 0.01, DAMAGE_TYPE_PURE)
				hParent:EmitSound("Hero_Pugna.NetherWard.Attack.Wight")
			end
		end
	end
end
function modifier_zombie_tower:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_TURNING = 1
	}
end
function modifier_zombie_tower:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
	}
end