---@class legion_commander_4: eom_ability
legion_commander_4 = eom_ability({})
function legion_commander_4:OnSpellStart(bPassive)
	bPassive = default(bPassive, false)
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	if not bPassive then
		hCaster:FindAbilityByName("legion_commander_1"):EndCooldown()
		hCaster:FindAbilityByName("legion_commander_2"):EndCooldown()
		hCaster:FindAbilityByName("legion_commander_3"):EndCooldown()
	end
	hCaster:EmitSound("Hero_Sven.GodsStrength")
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_4_mark.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(400, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:AddNewModifier(hCaster, self, "modifier_legion_commander_4", { duration = duration })
	if hCaster:GetScepterLevel() >= 4 then
		hCaster:FindAbilityByName("legion_commander_2"):ScepterAction()
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_legion_commander_4 : eom_modifier
modifier_legion_commander_4 = eom_modifier({
	Name = "modifier_legion_commander_4",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_legion_commander_4:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_legion_commander_4:GetAbilitySpecialValue()
	self.str = self:GetAbilitySpecialValueFor("str")
	self.kill_str = self:GetAbilitySpecialValueFor("kill_str")
	self.str_percent = self:GetAbilitySpecialValueFor("str_percent")
	self.chance = self:GetAbilitySpecialValueFor("chance")
end
function modifier_legion_commander_4:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_life_stealer_rage.vpcf", PATTACH_INVALID, hParent)
		self:AddParticle(iParticleID, false, true, 10, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/skills/war_god.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/war_god_eye.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_eyeL", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_POINT_FOLLOW, "attach_eyeR", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_legion_commander_4:OnDestroy()
	if IsServer() then
	end
end
function modifier_legion_commander_4:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_SILENCED] = false,
	}
end
function modifier_legion_commander_4:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS = self.str,
		EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE_PERCENTAGE = self.str_percent,
		MODIFIER_EVENT_ON_DEATH = { self:GetParent() },
		MODIFIER_EVENT_ON_ATTACKED = {nil, self:GetParent() }
	}
end
function modifier_legion_commander_4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION = 1499
	}
end
function modifier_legion_commander_4:OnDeath(params)
	self:GetParent():AddPermanentAttribute(CUSTOM_ATTRIBUTE_STRENGTH, self.kill_str)
end
function modifier_legion_commander_4:OnAttacked(params)
	if PRD(self, self.chance, "modifier_legion_commander_4") then
		local hAbility = self:GetParent():FindAbilityByName("legion_commander_3")
		if IsValid(hAbility) then
			hAbility:MomentOfCourage(params.attacker)
		end
	end
end