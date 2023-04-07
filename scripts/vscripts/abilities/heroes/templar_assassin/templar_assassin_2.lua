---@class templar_assassin_2 : eom_ability
templar_assassin_2 = eom_ability({})
function templar_assassin_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vPosition = self:GetCursorPosition()
	local speed = self:GetSpecialValueFor("speed")
	local distance = self:GetSpecialValueFor("distance")
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	if IsValid(hTarget) then
		hTarget:AddNewModifier(hCaster, self, "modifier_templar_assassin_2_motion", { vPosition = hCaster:GetAbsOrigin() + vDirection * 200 })
	else
		if (vPosition - hCaster:GetAbsOrigin()):Length2D() > distance then
			vPosition = hCaster:GetAbsOrigin() + vDirection * distance
		end
		hCaster:AddNewModifier(hCaster, self, "modifier_templar_assassin_2_motion", { vPosition = vPosition })
	end
	if hCaster:GetScepterLevel() >= 4 then
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), 1200, self)
		if IsValid(tTargets[1]) then
			hCaster:FindAbilityByName("templar_assassin_1"):OnSpellStart(tTargets[1])
		end
	end
end
function templar_assassin_2:OnAbilityChargeChanged(iCharge, iOldCharge)
	if IsServer() then
		local hCaster = self:GetCaster()
		-- scepter
		local scepter_refresh_chance = self:GetSpecialValueFor("scepter_refresh_chance")
		if hCaster:GetScepterLevel() >= 3 and PRD(self, scepter_refresh_chance, "templar_assassin_2") and iCharge < iOldCharge then
			self:AddCharges(1)
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_templar_assassin_2_motion : eom_modifier
modifier_templar_assassin_2_motion = eom_modifier({
	Name = "modifier_templar_assassin_2_motion",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	Type = LUA_MODIFIER_MOTION_HORIZONTAL
})
function modifier_templar_assassin_2_motion:GetAbilitySpecialValue()
	self.speed = self:GetAbilitySpecialValueFor("speed")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_templar_assassin_2_motion:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_templar_assassin_2_motion:GetEffectName()
	return "particles/heroes/revelater/revelater_motion.vpcf"
end
function modifier_templar_assassin_2_motion:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_templar_assassin_2_motion:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end
function modifier_templar_assassin_2_motion:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED] = self:GetParent() ~= self:GetCaster(),
		-- 魔免只对自身有效
		[MODIFIER_STATE_MAGIC_IMMUNE] = self:GetParent() == self:GetCaster(),
	}
end
function modifier_templar_assassin_2_motion:OnCreated(params)
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end

		self.vOrigin = self:GetParent():GetAbsOrigin()
		self.vPosition = StringToVector(params.vPosition)
		self.flDistance = (self.vPosition - self.vOrigin):Length2D()
		self.vDirection = (self.vPosition - self.vOrigin):Normalized()

		self.tTargets = {}
		self:GetParent():EmitSound("Hero_FacelessVoid.TimeDilation.Cast")
		if self:GetParent() == self:GetCaster() then
			ProjectileManager:ProjectileDodge(self:GetParent())
			self:GetParent():StartGesture(ACT_DOTA_TAUNT)
		end
	end
end
function modifier_templar_assassin_2_motion:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetParent():RemoveVerticalMotionController(self)
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		hParent:InterruptMotionControllers(true)
		-- 对自身加速
		if hParent == hCaster then
			hCaster:AddNewModifier(hCaster, self:GetAbility(), "modifier_templar_assassin_2_buff", { duration = self.duration })
			ProjectileManager:ProjectileDodge(hParent)
			hParent:RemoveGesture(ACT_DOTA_TAUNT)
		else
			-- 对敌人减速
			hParent:AddNewModifier(hCaster, self:GetAbility(), "modifier_templar_assassin_2_debuff", { duration = self.duration * hParent:GetStatusResistanceFactor() })
			-- 对灵魂冲散状态的敌人造成晕眩并提前结束冲散效果
			if hParent:HasModifier("modifier_templar_assassin_1_debuff") then
				local hModifier = hParent:FindModifierByName("modifier_templar_assassin_1_debuff")
				local flRemainingTime = hModifier:GetRemainingTime()
				hParent:AddNewModifier(hCaster, self:GetAbility(), "modifier_stunned", { duration = flRemainingTime * hParent:GetStatusResistanceFactor() })
				hModifier:Destroy()
			end
		end
	end
end
function modifier_templar_assassin_2_motion:OnHorizontalMotionInterrupted()
	self:Destroy()
end
function modifier_templar_assassin_2_motion:UpdateHorizontalMotion(me, dt)
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local vPos = hParent:GetAbsOrigin()

	if (vPos - self.vOrigin):Length2D() >= self.flDistance then
		FindClearSpaceForUnit(hParent, self.vPosition, true)
		self:Destroy()
		return
	end

	vPos = vPos + self.vDirection * self.speed * dt

	hParent:SetAbsOrigin(vPos)
	-- 伤害碰到的单位
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), vPos, nil, self.radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		if not TableFindKey(self.tTargets, hUnit) then
			table.insert(self.tTargets, hUnit)
			hCaster:DealDamage(hUnit, hAbility, self.damage)
		end
	end
end
function modifier_templar_assassin_2_motion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end
function modifier_templar_assassin_2_motion:GetOverrideAnimation()
	if self:GetParent() == self:GetCaster() then
		-- return ACT_DOTA_TAUNT_STATUE
	else
		return ACT_DOTA_DISABLED
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_templar_assassin_2_buff : eom_modifier
modifier_templar_assassin_2_buff = eom_modifier({
	Name = "modifier_templar_assassin_2_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_templar_assassin_2_buff:GetAbilitySpecialValue()
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_templar_assassin_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = self.movespeed or 0,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT = 1
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_templar_assassin_2_debuff : eom_modifier
modifier_templar_assassin_2_debuff = eom_modifier({
	Name = "modifier_templar_assassin_2_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_templar_assassin_2_debuff:GetAbilitySpecialValue()
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_templar_assassin_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = -(self.movespeed or 0)
	}
end