---@class windrunner_2 : eom_ability
windrunner_2 = eom_ability({})
function windrunner_2:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_invoker/invoker_tornado.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_windrunner/windrunner_2.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_windrunner/windrunner_gold/windrunner_2.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_windrunner/windrunner_gold/windrunner_2_tornado.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti10/cyclone_ti10.vpcf", context)
end
function windrunner_2:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_windrunner_2", { duration = self:GetSpecialValueFor("duration") })
end
function windrunner_2:Action(hTarget)
	local hCaster = self:GetCaster()
	local flWidth = self:GetSpecialValueFor("width")
	local flDistance = self:GetSpecialValueFor("distance")
	local flSpeed = self:GetSpecialValueFor("speed")
	local vDirection = (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized()
	ProjectileSystem:CreateLinearProjectile({
		hAbility = self,
		hCaster = hCaster,
		sEffectName = AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_invoker/invoker_tornado.vpcf", hCaster),
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		vDirection = vDirection,
		iMoveSpeed = flSpeed,
		flDistance = flDistance,
		flRadius = flWidth,
		OnProjectileHit = function(hTarget, vPosition, tInfo)
			hTarget:AddNewModifier(hCaster, self, "modifier_windrunner_2_motion", { duration = self:GetSpecialValueFor("stun_duration") * hTarget:GetStatusResistanceFactor() })
			hTarget:AddNewModifier(hCaster, self, "modifier_windrunner_2_debuff", { duration = self:GetSpecialValueFor("reduce_duration") * hTarget:GetStatusResistanceFactor() })
		end
	})
end
----------------------------------------Modifier----------------------------------------
---@class modifier_windrunner_2 : eom_modifier
modifier_windrunner_2 = eom_modifier({
	Name = "modifier_windrunner_2",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_windrunner_2:GetAbilitySpecialValue()
	self.spirit_count = self:GetAbilitySpecialValueFor("spirit_count")
end
function modifier_windrunner_2:OnCreated(params)
	if IsServer() then
		self:SetStackCount(self.spirit_count)
	else
		self.iParticleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_windrunner/windrunner_2.vpcf", self:GetParent()), PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(self.spirit_count, 0, 0))
		self:AddParticle(self.iParticleID, false, false, -1, false, false)
	end
end
function modifier_windrunner_2:OnRefresh(params)
	self.spirit_count = self:GetAbilitySpecialValueFor("spirit_count")
	if IsServer() then
		self:SetStackCount(self.spirit_count)
	end
end
function modifier_windrunner_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_windrunner_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_windrunner_2:GetModifierAvoidDamage(params)
	if self:GetStackCount() > 0 then
		self:DecrementStackCount()
		self:GetAbility():Action(params.attacker)
		return 1
	end
end
function modifier_windrunner_2:OnStackCountChanged(iStackCount)
	if IsServer() then
		if self:GetStackCount() == 0 then
			self:Destroy()
		end
	else
		ParticleManager:DestroyParticle(self.iParticleID, true)
		self.iParticleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_windrunner/windrunner_2.vpcf", self:GetParent()), PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(self:GetStackCount(), 0, 0))
		self:AddParticle(self.iParticleID, false, false, -1, false, false)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_windrunner_2_motion : eom_modifier
modifier_windrunner_2_motion = eom_modifier({
	Name = "modifier_windrunner_2_motion",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	Type = LUA_MODIFIER_MOTION_VERTICAL
})
function modifier_windrunner_2_motion:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_windrunner_2_motion:OnCreated()
	if IsServer() then
		local pos = self:GetParent():GetAbsOrigin()
		pos.z = GetGroundHeight(pos, self:GetParent())
		self:GetParent():SetAbsOrigin(pos)
		-- 
		self.rate = 1
		self.flRiseTime = 0.3
		self.vVelocity = 1000
		self.vForward = self:GetParent():GetForwardVector()
		self.fAge = 0
		self.fMax = 30
		self.fSpeed = self.fMax
		self.fSpeedAge = 300
		if not self:ApplyVerticalMotionController() then
			self:Destroy()
			return
		end
	else
		local iParticleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/items_fx/cyclone.vpcf", self:GetCaster()), PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_windrunner_2_motion:OnRefresh(params)
	if IsServer() then
		local pos = self:GetParent():GetAbsOrigin()
		pos.z = GetGroundHeight(pos, self:GetParent())
		self:GetParent():SetAbsOrigin(pos)

		-- damage
		self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), self.damage)
	end
end
function modifier_windrunner_2_motion:UpdateVerticalMotion(me, dt)
	if IsServer() then
		local vPos = me:GetAbsOrigin()
		if self:GetElapsedTime() < self.flRiseTime then
			vPos = me:GetAbsOrigin() + Vector(0, 0, self.vVelocity * dt)
		elseif self:GetElapsedTime() > self:GetDuration() - self.flRiseTime then
			vPos = me:GetAbsOrigin() - Vector(0, 0, self.vVelocity * dt)
		else
			local vForward = RotatePosition(Vector(0, 0, 0), QAngle(math.sin(math.rad(self.fAge * 5)) * 5, self.fAge, 0), self.vForward)
			local angle = VectorToAngles(vForward:Normalized())
			me:SetLocalAngles(0, angle[2], 0)
			self.fAge = (self.fAge + self.fSpeedAge * dt) % 360

			local fSpeed = 360 * math.sin(math.rad(self.fAge))
			vPos = Vector(0, 0, fSpeed) * dt + me:GetAbsOrigin()
		end
		me:SetAbsOrigin(vPos)
	end
end
function modifier_windrunner_2_motion:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_windrunner_2_motion:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		local pos = hParent:GetAbsOrigin()
		pos.z = GetGroundHeight(pos, self:GetCaster())
		hParent:SetAbsOrigin(pos)

		hParent:RemoveVerticalMotionController(self)

		-- damage
		self:GetCaster():DealDamage(hParent, self:GetAbility(), self.damage)
	end
end
function modifier_windrunner_2_motion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end
function modifier_windrunner_2_motion:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end
function modifier_windrunner_2_motion:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_windrunner_2_debuff : eom_modifier
modifier_windrunner_2_debuff = eom_modifier({
	Name = "modifier_windrunner_2_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_windrunner_2_debuff:GetAbilitySpecialValue()
	self.armor_reduce = self:GetAbilitySpecialValueFor("armor_reduce")
end
function modifier_windrunner_2_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = -self.armor_reduce
	}
end