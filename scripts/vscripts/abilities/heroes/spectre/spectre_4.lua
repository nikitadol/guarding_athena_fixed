---@class spectre_4 : eom_ability
spectre_4 = eom_ability({})
function spectre_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_spectre_4_lock", { duration = self:GetSpecialValueFor("stun_duration") })
	hTarget:AddNewModifier(hCaster, self, "modifier_spectre_4_debuff", { duration = self:GetSpecialValueFor("duration") })
	-- 沉默
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hTarget:GetAbsOrigin(), self:GetSpecialValueFor("radius"), self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_spectre_4_silence", { duration = 5 })
	end
	-- sound
	hCaster:EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
	hTarget:EmitSound("Hero_Necrolyte.ReapersScythe.Target")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_spectre_4_lock : eom_modifier
modifier_spectre_4_lock = eom_modifier({
	Name = "modifier_spectre_4_lock",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_spectre_4_lock:GetAbilitySpecialValue()
	self.damage_deepen = self:GetAbilitySpecialValueFor("damage_deepen")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.max_bonus_damage = self:GetAbilitySpecialValueFor("max_bonus_damage")
	self.damage_count = self:GetAbilitySpecialValueFor("damage_count")
	self.damage_time_point = self:GetAbilitySpecialValueFor("damage_time_point")
end
function modifier_spectre_4_lock:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_spectre_4_lock:OnCreated(params)
	self.MagicArmor = self:GetParent():GetBaseMagicalResistanceValue()
	self:StartIntervalThink(self.damage_time_point)
	if IsServer() then
	else
		local hParent = self:GetParent()
		-- 锁链
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_4_lock.vpcf", PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		-- 烟雾
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_4_somke.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(600, 600, 600))
		self:AddParticle(iParticleID, false, false, -1, false, false)
		-- 死神虚影
		for i = 1, self.damage_count do
			local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_4.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
			ParticleManager:SetParticleControl(iParticleID, 1, hParent:GetAbsOrigin())
			ParticleManager:SetParticleControlForward(iParticleID, 0, Rotation2D(Vector(0, 1, 0), math.rad(90 * i)))
			ParticleManager:SetParticleControlForward(iParticleID, 1, Rotation2D(Vector(0, 1, 0), math.rad(90 * i)))
			self:AddParticle(iParticleID, false, false, -1, false, false)
			local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_4_impact.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, Rotation2D(Vector(0, 600, 0), math.rad(90 * i)))
			ParticleManager:SetParticleControl(iParticleID, 1, Rotation2D(Vector(0, 600, 0), math.rad(90 * i)))
			self:AddParticle(iParticleID, false, false, -1, false, false)
		end
	end
end
function modifier_spectre_4_lock:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if IsServer() then
		local flLosePct = math.min((100 - hParent:GetHealthPercent()), self.max_bonus_damage)
		local flBonusDamage = flLosePct * hParent:GetCustomMaxHealth() * 0.01
		local flDamage = self.damage + flBonusDamage / self.damage_count
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, hAbility)
		for i = 1, self.damage_count do
			hCaster:DealDamage(tTargets, hAbility, flDamage)
		end
		if hCaster:GetScepterLevel() >= 4 and not hParent:IsAlive() then
			local flCooldown = hAbility:GetCooldownTimeRemaining() * (1 - self:GetAbilitySpecialValueFor("scepter_cooldown") * 0.01)
			hAbility:EndCooldown()
			hAbility:StartCooldown(flCooldown)
		end
	else
		-- 地面特效
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_4_explode.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(600, 600, 300))
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- self:AddParticle(iParticleID, false, false, -1, false, false)
		-- 命中特效
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_4_impact_f.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, hParent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- self:AddParticle(iParticleID, false, false, -1, false, false)
	end
	self:StartIntervalThink(-1)
end
function modifier_spectre_4_lock:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BASE_PERCENTAGE = -100,
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = self.damage_deepen
	}
end
function modifier_spectre_4_lock:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_spectre_4_debuff : eom_modifier
modifier_spectre_4_debuff = eom_modifier({
	Name = "modifier_spectre_4_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_spectre_4_debuff:GetAbilitySpecialValue()
	self.soul_loss = self:GetAbilitySpecialValueFor("soul_loss")
end
function modifier_spectre_4_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE = -self.soul_loss,
		EOM_MODIFIER_PROPERTY_HEALTH_PERCENTAGE = -self.soul_loss
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_spectre_4_silence : eom_modifier
modifier_spectre_4_silence = eom_modifier({
	Name = "modifier_spectre_4_silence",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = true,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_spectre_4_silence:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
	}
end