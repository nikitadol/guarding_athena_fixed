---@class omniknight_0 : eom_ability
omniknight_0 = eom_ability({})
function omniknight_0:GetBehavior()
	-- 雷霆战士皮肤
	if self:GetCaster():HasModifier("modifier_omniknight_01") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
	return self.BaseClass.GetBehavior(self)
end
function omniknight_0:GetCooldown(iLevel)
	if self:GetCaster():HasModifier("modifier_omniknight_01") then
		return self:GetSpecialValueFor("active_cooldown")
	end
	return self:GetSpecialValueFor("cooldown")
end
function omniknight_0:GetIntrinsicModifierName()
	return "modifier_omniknight_0"
end
function omniknight_0:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_omniknight_0_active", nil)
end
-- 天罚
function omniknight_0:ThunderPower(hTarget, bEmitSound)
	local hCaster = self:GetCaster()
	local damage = self:GetSpecialValueFor("str_factor")
	local scepter_radius = self:GetSpecialValueFor("scepter_radius")
	if hTarget:IsStunned() then
		local hVictim = hTarget
		if hCaster:GetScepterLevel() >= 2 then
			hVictim = FindUnitsInRadiusWithAbility(hCaster, hTarget:GetAbsOrigin(), scepter_radius, self)
		end
		hCaster:DealDamage(hVictim, self, damage)
		-- particle
		local particle = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_omniknight/omniknight_0.vpcf", hCaster), PATTACH_CUSTOMORIGIN, hTarget)
		ParticleManager:SetParticleControl(particle, 0, hTarget:GetAbsOrigin() + Vector(0, 0, 5000))
		ParticleManager:SetParticleControl(particle, 1, hTarget:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 3, hTarget:GetAbsOrigin())
		-- sound
		if bEmitSound == true then
			hTarget:EmitSound("Hero_Zuus.LightningBolt")
		end
	end
end
function omniknight_0:Action(hTarget, bEmitSound)
	local hCaster = self:GetCaster()
	local damage = self:GetSpecialValueFor("str_factor")
	local scepter_radius = self:GetSpecialValueFor("scepter_radius")
	local hVictim = hTarget
	if hCaster:GetScepterLevel() >= 2 then
		hVictim = FindUnitsInRadiusWithAbility(hCaster, hTarget:GetAbsOrigin(), scepter_radius, self)
	end
	hCaster:DealDamage(hVictim, self, damage)
	-- particle
	local particle = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_omniknight/omniknight_0.vpcf", hCaster), PATTACH_CUSTOMORIGIN, hTarget)
	ParticleManager:SetParticleControl(particle, 0, hTarget:GetAbsOrigin() + Vector(0, 0, 5000))
	ParticleManager:SetParticleControl(particle, 1, hTarget:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 3, hTarget:GetAbsOrigin())
	-- sound
	if bEmitSound == true then
		hTarget:EmitSound("Hero_Zuus.LightningBolt")
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_omniknight_0 : eom_modifier
modifier_omniknight_0 = eom_modifier({
	Name = "modifier_omniknight_0",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_omniknight_0:GetAbilitySpecialValue()
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.cooldown = self:GetAbilitySpecialValueFor("cooldown")
end
-- function modifier_omniknight_0:GetEffectName()
-- 	return "particles/econ/items/faceless_void/faceless_void_weapon_voidhammer/faceless_void_weapon_voidhammer.vpcf"
-- end
-- function modifier_omniknight_0:GetEffectAttachType()
-- 	return DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
-- end
function modifier_omniknight_0:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_weapon_voidhammer/faceless_void_weapon_voidhammer.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_omniknight_0:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_omniknight_0:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
end
function modifier_omniknight_0:OnTooltip()
	return self:GetStackCount()
end
function modifier_omniknight_0:OnAttackLanded(params)
	if self:GetParent() == params.attacker then
		local hParent = self:GetParent()
		local hTarget = params.target
		local hAbility = self:GetAbility()
		hAbility:ThunderPower(hTarget, true)
		local hAbility3 = hParent:FindAbilityByName("omniknight_3")
		local bonus_chance = IsValid(hAbility3) and hAbility3:GetSpecialValueFor("bonus_chance") or 0
		if (hAbility:IsCooldownReady() and RollPercentage(self.chance + bonus_chance)) or hParent:HasModifier("modifier_omniknight_0_active") then
			local flCooldown = self.cooldown
			if self:GetParent():HasModifier("modifier_omniknight_2_aura") then
				if self:GetParent():FindModifierByName("modifier_omniknight_2_aura"):Roll() then
					flCooldown = 0
				end
			end
			hAbility:StartCooldown(flCooldown)
			self:IncrementStackCount()
			hTarget:AddNewModifier(hParent, hAbility, "modifier_stunned", { duration = self.stun_duration * hTarget:GetStatusResistanceFactor() })
			hParent:RemoveModifierByName("modifier_omniknight_0_active")
		end
	end
end
function modifier_omniknight_0:EOM_GetModifierBonusStats_Strength()
	return self:GetStackCount()
end
----------------------------------------Modifier----------------------------------------
---@class modifier_omniknight_0_active : eom_modifier
modifier_omniknight_0_active = eom_modifier({
	Name = "modifier_omniknight_0_active",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})