---@class void_spirit_1 : eom_ability
void_spirit_1 = eom_ability({})
function void_spirit_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local active_duration = self:GetSpecialValueFor("active_duration")
	local duration = self:GetSpecialValueFor("duration")
	hCaster:AddNewModifier(hCaster, self, "modifier_void_spirit_1", { duration = active_duration })
	hCaster:AddNewModifier(hCaster, self, "modifier_void_spirit_1_shield", { duration = duration })
	for _, hUnit in ipairs(hCaster.tAetherRemnant) do
		if IsValid(hUnit) and hUnit:IsAlive() then
			hUnit:FindAbilityByName("void_spirit_1"):OnSpellStart()
		end
	end
	ProjectileManager:ProjectileDodge(hCaster)
	-- 特效
	hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(1200, 1, radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_VoidSpirit.Pulse")
	hCaster:EmitSound("Hero_VoidSpirit.Pulse.Cast")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_void_spirit_1 : eom_modifier
modifier_void_spirit_1 = eom_modifier({
	Name = "modifier_void_spirit_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_void_spirit_1:GetAbilitySpecialValue()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.debuff_duration = self:GetAbilitySpecialValueFor("debuff_duration")
	self.shield_per_attack = self:GetAbilitySpecialValueFor("shield_per_attack")
end
function modifier_void_spirit_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_void_spirit_1:OnCreated(params)
	if IsServer() then
		-- self:OnIntervalThink()
		self:StartIntervalThink(0.1)
		self.tTargets = {}
	end
end
function modifier_void_spirit_1:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), RemapVal(self:GetElapsedTime(), 0, self:GetDuration(), 0, self.radius), self:GetAbility())
	for _, hUnit in ipairs(tTargets) do
		if TableFindKey(self.tTargets, hUnit) == nil then
			table.insert(self.tTargets, hUnit)
			hUnit:AddNewModifier(hParent, self:GetAbility(), "modifier_void_spirit_1_debuff", { duration = self.debuff_duration })
		end
	end
	local hModifier = hParent:FindModifierByName("modifier_void_spirit_1_shield")
	if IsValid(hModifier) then
		hParent:AddShield(self.shield_per_attack * #tTargets, hModifier, DAMAGE_TYPE_PHYSICAL)
		if hParent:GetScepterLevel() >= 1 then
			hParent:AddShield(self.shield_per_attack * #tTargets, hModifier, DAMAGE_TYPE_MAGICAL)
		end
	end
end
function modifier_void_spirit_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
end
function modifier_void_spirit_1:GetAbsoluteNoDamagePhysical()
	return 1
end
function modifier_void_spirit_1:GetAbsoluteNoDamageMagical()
	return 1
end
function modifier_void_spirit_1:GetAbsoluteNoDamagePure()
	return 1
end
function modifier_void_spirit_1:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_void_spirit_1_debuff : eom_modifier
modifier_void_spirit_1_debuff = eom_modifier({
	Name = "modifier_void_spirit_1_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_void_spirit_1_debuff:GetAbilitySpecialValue()
	self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_void_spirit_1_debuff:IsDebuff()
	return true
end
function modifier_void_spirit_1_debuff:OnCreated(params)
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	-- 专属沉默
	self.bSilence = hCaster:GetScepterLevel() >= 1
	if IsServer() then
		hCaster:DealDamage(hParent, self:GetAbility(), self.damage)
	else
		if not self:GetCaster():IsIllusion() then
			-- 吸收特效
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_absorb.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end
end
function modifier_void_spirit_1_debuff:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_void_spirit_1_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_PERCENTAGE = -self.damage_reduce_pct,
	}
end
function modifier_void_spirit_1_debuff:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = self.bSilence
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_void_spirit_1_shield : eom_modifier
modifier_void_spirit_1_shield = eom_modifier({
	Name = "modifier_void_spirit_1_shield",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})

function modifier_void_spirit_1_shield:GetAbilitySpecialValue()
	self.base_shield = self:GetAbilitySpecialValueFor("base_shield")
end
function modifier_void_spirit_1_shield:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		hParent:AddShield(self.base_shield, self, DAMAGE_TYPE_PHYSICAL)
		if hParent:GetScepterLevel() >= 1 then
			hParent:AddShield(self.base_shield, hModifier, DAMAGE_TYPE_MAGICAL)
		end
	else
		-- 护盾特效
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self:GetParent():GetModelRadius(), 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_void_spirit_1_shield:OnShieldDestroy()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_void_spirit_1_shield:OnRefresh(params)
	if IsServer() then
		local hParent = self:GetParent()
		hParent:AddShield(self.base_shield, self, DAMAGE_TYPE_PHYSICAL)
		if hParent:GetScepterLevel() >= 1 then
			hParent:AddShield(self.base_shield, hModifier, DAMAGE_TYPE_MAGICAL)
		end
	end
end