dash = eom_ability({})
function dash:RequiresFacing()
	return true
end
function dash:CastFilterResult()
	if IsClient() then
		SendToConsole("cast_on_mouse_cursor_position" + date_now + " " .. self:entindex())
	end
	return UF_SUCCESS
end
function dash:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local max_distance = self:GetSpecialValueFor("max_distance")
	local min_distance = self:GetSpecialValueFor("min_distance")

	if vPosition == vec3_zero then
		self:RefundManaCost()
		self:EndCooldown()
		return
	end

	local vDirection = vPosition - hCaster:GetAbsOrigin()
	vDirection.z = 0
	if vDirection == vec3_zero then
		vDirection = hCaster:GetForwardVector()
	end

	local vTargetPosition = GetGroundPosition(hCaster:GetAbsOrigin() + vDirection:Normalized() * Clamp(vDirection:Length(), min_distance, max_distance), hCaster)

	hCaster:Interrupt()
	-- local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = "eom/t7_character/t7_lvqiling/t7_lvqiling02.vmdl", origin = hCaster:GetAbsOrigin() })
	-- hWearable:FollowEntity(hCaster, true)
	hCaster:FaceTowards(vTargetPosition)
	hCaster:SetForwardVector(vDirection:Normalized())
	hCaster:AddNewModifier(hCaster, self, "modifier_dash_common", { duration = duration, position = vTargetPosition })
end
function dash:Spawn()
	if IsServer() then
		self:SetLevel(1)
	end
end
---------------------------------------------------------------------
--Modifiers
---@class modifier_dash_common:eom_ability
modifier_dash_common = eom_modifier({
	Name = "modifier_dash_common",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	Type = LUA_MODIFIER_MOTION_HORIZONTAL,
})
function modifier_dash_common:GetEffectName()
	return "particles/dash.vpcf"
end
function modifier_dash_common:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_dash_common:GetStatusEffectName()
	return "particles/status_fx/status_effect_dash.vpcf"
end
function modifier_dash_common:StatusEffectPriority()
	return 1
end
function modifier_dash_common:OnCreated(params)
	if IsServer() then
		self.vTargetPosition = StringToVector(params.position)
		if self.vTargetPosition == nil then
			return
		end
		self:SetPriority(DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST)
		if self:ApplyHorizontalMotionController() then
			self.vStartPosition = self:GetParent():GetAbsOrigin()
		end
	end
end
function modifier_dash_common:OnRefresh(params)
	if IsServer() then
		self.vTargetPosition = StringToVector(params.position)
		if self.vTargetPosition == nil then
			return
		end
		self:SetPriority(DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST)
		if self:ApplyHorizontalMotionController() then
			self.vStartPosition = self:GetParent():GetAbsOrigin()
		end
	end
end
function modifier_dash_common:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
	end
end
function modifier_dash_common:UpdateHorizontalMotion(hParent, dt)
	if IsServer() then
		local fPercent = Clamp(self:GetElapsedTime() / self:GetDuration(), 0, 1)
		local vStartPosition = hParent:GetAbsOrigin()
		local vTargetPosition = VectorLerp(fPercent, self.vStartPosition, self.vTargetPosition)
		local vPosition = vStartPosition

		local vDirection = vTargetPosition - vStartPosition
		vDirection.z = 0
		for fDistance = 0, vDirection:Length(), 16 do
			local vTempPosition = vStartPosition + vDirection:Normalized() * math.min(vDirection:Length(), fDistance)
			if GridNav:IsBlocked(vPosition) or not GridNav:IsTraversable(vPosition) then
				self:Destroy()
				break
			else
				vPosition = vTempPosition
			end
		end

		hParent:SetAbsOrigin(vPosition)
	end
end
function modifier_dash_common:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE = 2,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION = ACT_DOTA_FLAIL,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS = "forcestaff_friendly",
	}
end