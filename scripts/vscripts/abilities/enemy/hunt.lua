---@class hunt: eom_ability
hunt = eom_ability({
	funcUnitsCallback = function(hAbility, tTargets)
		local hCaster = hAbility:GetCaster()
		for i = #tTargets, 1, -1 do
			if (tTargets[i]:GetAbsOrigin() - hCaster:GetAbsOrigin()):Length2D() < 700 then
				table.remove(tTargets, i)
			end
		end
	end
}, nil, ability_base_ai)
function hunt:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vPosition = hTarget:GetAbsOrigin()
	local vDirection = (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized()
	local flDistance = (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Length2D() - 100
	hCaster:StartGesture(ACT_DOTA_ATTACK)
	hCaster:Dash(vDirection, flDistance, 200, 0.4, nil, function()
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, 200, self)
		---@param hUnit CDOTA_BaseNPC
		for _, hUnit in ipairs(tTargets) do
			hCaster:Attack(hTarget, ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_NEVERMISS)
			hUnit:AddNewModifier(hCaster, self, "modifier_hunt_debuff", { duration = 1 })
			hCaster:AddNewModifier(hCaster, self, "modifier_hunt_buff", { duration = 1 })
			hCaster:Attack(hTarget, ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_NEVERMISS)
			hCaster:RemoveModifierByName("modifier_hunt_buff")
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ursa/ursa_fury_sweep_cross.vpcf", PATTACH_ABSORIGIN, hCaster)
			ParticleManager:ReleaseParticleIndex(iParticleID)
			hCaster:EmitSound("Hero_Juggernaut.BladeDance")
		end
		hCaster:FindModifierByName("modifier_hunt"):OnIntervalThink()
	end)
end
function hunt:GetIntrinsicModifierName()
	return "modifier_hunt"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_hunt : eom_modifier
modifier_hunt = eom_modifier({
	Name = "modifier_hunt",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_hunt:GetAbilitySpecialValue()
	self.evasion = self:GetAbilitySpecialValueFor("evasion")
end
function modifier_hunt:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0.7)
	end
end
function modifier_hunt:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), 1200, self:GetAbility())
		if IsValid(tTargets[1]) and not hParent:HasModifier("modifier_dash") then
			local vDireciton = (tTargets[1]:GetAbsOrigin() - hParent:GetAbsOrigin()):Normalized()
			local vForward = RotatePosition(vec3_zero, QAngle(0, RollPercentage(50) and 60 or -60, 0), vDireciton)
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_MOVE_TO_POSITION, (tTargets[1]:GetAbsOrigin() - vDireciton * 900) + vForward * 900)
		end
	end
end
function modifier_hunt:EOM_GetModifierEvasion_Constant()
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:IsMoving() then
			return self.evasion
		end
	end
end
function modifier_hunt:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE = 1200
	}
end
function modifier_hunt:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_EVASION_CONSTANT
	}
end
------------------------------Modifier----------------------------------------
---@class modifier_hunt_debuff : eom_modifier
modifier_hunt_debuff = eom_modifier({
	Name = "modifier_hunt_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_hunt_debuff:GetAbilitySpecialValue()
	self.reduce = self:GetAbilitySpecialValueFor("reduce")
end
function modifier_hunt_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = -self.reduce
	}
end
------------------------------Modifier----------------------------------------
---@class modifier_hunt_buff : eom_modifier
modifier_hunt_buff = eom_modifier({
	Name = "modifier_hunt_buff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_hunt_buff:GetAbilitySpecialValue()
	self.critical = self:GetAbilitySpecialValueFor("critical")
end
function modifier_hunt_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_CHANCE = 100,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE = self.critical
	}
end