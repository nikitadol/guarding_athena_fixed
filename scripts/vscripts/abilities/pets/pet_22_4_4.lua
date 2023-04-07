---@class pet_22_4_4: eom_ability
pet_22_4_4 = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetAutoCastState()
	end,
	iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET,
}, nil, ability_base_ai)
function pet_22_4_4:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function pet_22_4_4:OnAbilityPhaseStart()
	self:GetCaster():StartGesture(ACT_DOTA_LEAP_STUN)
	return true
end
function pet_22_4_4:OnAbilityPhaseInterrupted()
	self:GetCaster():FadeGesture(ACT_DOTA_LEAP_STUN)
end
function pet_22_4_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor('duration')
	hCaster:AddNewModifier(hCaster, self, "modifier_pet_22_4_4_hop", { duration = duration, distance = (vPosition - hCaster:GetAbsOrigin()):Length2D() })
end
function pet_22_4_4:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_22_4_4_hop : eom_modifier
modifier_pet_22_4_4_hop = eom_modifier({
	Name = "modifier_pet_22_4_4_hop",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	Type = LUA_MODIFIER_MOTION_HORIZONTAL
})
function modifier_pet_22_4_4_hop:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_pet_22_4_4_hop:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end
function modifier_pet_22_4_4_hop:OnCreated(params)
	if IsServer() then
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
		self.distance = params.distance
		self.fSpeed = self.distance / self:GetDuration()
		self.vS = self:GetParent():GetAbsOrigin()
		self.vV = self:GetParent():GetForwardVector() * self.fSpeed
		self.radius = self:GetAbilitySpecialValueFor('radius')
		self.impact_damage = self:GetAbilityDamage() * self:GetParent():GetMaster():GetPrimaryStats()
		self.impact_stun_duration = self:GetAbility():GetDuration()
	end
end
function modifier_pet_22_4_4_hop:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetCaster():FadeGesture(ACT_DOTA_LEAP_STUN)
	end
end
function modifier_pet_22_4_4_hop:JumpFinish()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()

	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, GetGroundPosition(hParent:GetAbsOrigin(), hCaster))
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
	hParent:EmitSound("Hero_Centaur.HoofStomp")

	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self:GetAbility(), self.impact_damage)
		hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_stunned", { duration = self.impact_stun_duration * hUnit:GetStatusResistanceFactor() })
	end
end
function modifier_pet_22_4_4_hop:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local vPos = self.vV * dt + self:GetParent():GetAbsOrigin()
		local fDis = (vPos - self.vS):Length2D()
		if fDis > self.distance then
			fDis = self.distance
		end
		me:SetAbsOrigin(vPos)

		if fDis == self.distance then
			--成功着陆
			self:JumpFinish()
			self:Destroy()
		end
	end
end
function modifier_pet_22_4_4_hop:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_pet_22_4_4_hop:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end