---@class hades_3: eom_ability
hades_3 = eom_ability({}, nil, ability_base_ai)
function hades_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_hades_3", { duration = self:GetDuration() })
end
----------------------------------------Modifier----------------------------------------
---@class modifier_hades_3 : eom_modifier
modifier_hades_3 = eom_modifier({
	Name = "modifier_hades_3",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_hades_3:OnCreated(params)
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	if IsServer() then
	else
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_marker.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, true)

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, true)
	end
	AddModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetCaster())
end
function modifier_hades_3:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_hades_3:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetCaster())
end
function modifier_hades_3:OnDeath(params)
	if IsServer() then
		local hCaster = self:GetCaster()
		if params.unit == hCaster then
			local hParent = self:GetParent()
			local hAbility = self:GetAbility()
			if not hParent:IsMagicImmune() and not hParent:IsInvulnerable() then
				hParent:AddNewModifier(hCaster, hAbility, "modifier_hades_3_stun", { duration = self.stun_duration })
			end
			hCaster:RespawnUnit()
			hCaster:GameTimer(0, function()
				hCaster:AddNewModifier(hCaster, hAbility, "modifier_hades_3_stun", { duration = self.stun_duration })
			end)
			hCaster:EmitSound("Hero_Abaddon.BorrowedTime")
		end
	end
end
function modifier_hades_3:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_hades_3_stun : eom_modifier
modifier_hades_3_stun = eom_modifier({
	Name = "modifier_hades_3_stun",
	IsHidden = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_hades_3_stun:IsDebuff()
	return not self:GetParent():IsFriendly(self:GetCaster())
end
function modifier_hades_3_stun:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/wave_26/hades_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_hades_3_stun:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		if hParent:IsFriendly(hCaster) then
			hParent:Heal(hParent:GetCustomMaxHealth() * 0.5, hAbility)
		else
			hParent:ForceKill(true)
			hCaster:Heal(hCaster:GetCustomMaxHealth() * 0.5, hAbility)
		end
	end
end
function modifier_hades_3_stun:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end