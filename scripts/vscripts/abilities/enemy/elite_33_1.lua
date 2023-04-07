---@class elite_33_1: eom_ability
elite_33_1 = eom_ability({})
function elite_33_1:GetIntrinsicModifierName()
	return "modifier_elite_33_1"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_33_1 : eom_modifier
modifier_elite_33_1 = eom_modifier({
	Name = "modifier_elite_33_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_33_1:GetAbilitySpecialValue()
	self.delay = self:GetAbilitySpecialValueFor("delay")
end
function modifier_elite_33_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_elite_33_1:GetModifierAvoidDamage(params)
	if self:GetAbility():IsCooldownReady() and not self:GetParent():PassivesDisabled() and not self:GetParent():IsIllusion() then
		self:GetAbility():UseResources(false, false, true)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_elite_33_1_buff", { duration = self.delay, iEntIndex = params.attacker:entindex() })
		return 1
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_33_1_buff : eom_modifier
modifier_elite_33_1_buff = eom_modifier({
	Name = "modifier_elite_33_1_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_33_1_buff:OnCreated(params)
	self.image_count = self:GetAbilitySpecialValueFor("image_count")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.outgoing_damage = self:GetAbilitySpecialValueFor("outgoing_damage")
	self.incoming_damage = self:GetAbilitySpecialValueFor("incoming_damage")
	if IsServer() then
		local hParent = self:GetParent()
		hParent:AddNoDraw()
		self.hTarget = EntIndexToHScript(params.iEntIndex)
		self.vPosition = self.hTarget:GetAbsOrigin()
		-- damage
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
		hParent:DealDamage(tTargets, self:GetAbility(), self:GetAbility():GetAbilityDamage())
		-- sound
		hParent:EmitSound("Hero_NagaSiren.MirrorImage")
	else
		-- 娜迦分身水波特效
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/naga/naga_ti8_immortal_tail/naga_ti8_immortal_riptide.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
		ParticleManager:SetParticleControl(iParticleID, 3, Vector(self.radius, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_elite_33_1_buff:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		local duration = self:GetAbility():GetDuration()
		hParent:RemoveNoDraw()
		local vStartVector = RandomVector(175)
		FindClearSpaceForUnit(hParent, self.vPosition + vStartVector, true)
		hParent:SetForwardVector((self.vPosition - hParent:GetAbsOrigin()):Normalized())
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_mirror_image_h.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- 幻象
		-- local tIllusions = CreateIllusions( hParent, hParent, {duration = 2, outgoing_damage = self.outgoing_damage, incoming_damage = self.incoming_damage}, self.image_count, 100, true, true )
		for index = 1, self.image_count - 1 do
			local hIllusion = hParent:SummonUnit(hParent:GetUnitName(), self.vPosition + Rotation2D(vStartVector, math.rad(360 / self.image_count * index)), true, duration)
			hIllusion:AddNewModifier(hIllusion, self:GetAbility(), "modifier_illusion", { duration = duration })
			hIllusion:AddNewModifier(hIllusion, self:GetAbility(), "modifier_elite_33_1_illusion", { duration = duration })
			hIllusion:MakeIllusion()
			-- FindClearSpaceForUnit(tIllusions[i], self.vPosition + Rotation2D(vStartVector, math.rad(360 / self.image_count * i)), true)
			hIllusion:SetForwardVector((self.vPosition - hIllusion:GetAbsOrigin()):Normalized())
			hIllusion:SetForceAttackTarget(self.hTarget)
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_mirror_image_h.vpcf", PATTACH_ABSORIGIN, hIllusion)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end
end
function modifier_elite_33_1_buff:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	-- [MODIFIER_STATE_INVISIBLE] = true,
	}
end
function modifier_elite_33_1_buff:ECheckState()
	return {
		[EOM_MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_33_1_illusion : eom_modifier
modifier_elite_33_1_illusion = eom_modifier({
	Name = "modifier_elite_33_1_illusion",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_33_1_illusion:GetAbilitySpecialValue()
	self.outgoing_damage = self:GetAbilitySpecialValueFor("outgoing_damage")
	self.incoming_damage = self:GetAbilitySpecialValueFor("incoming_damage")
end
function modifier_elite_33_1_illusion:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE = self.outgoing_damage - 100,
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = self.incoming_damage
	}
end