---@class solar_lock: eom_ability
solar_lock = eom_ability({}, nil, ability_base_ai)
function solar_lock:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")
	hTarget:AddNewModifier(hCaster, self, "modifier_solar_lock", { duration = duration })
	hCaster:EmitSound("Hero_ShadowDemon.Soul_Catcher.Cast")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_solar_lock : eom_modifier
modifier_solar_lock = eom_modifier({
	Name = "modifier_solar_lock",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_solar_lock:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/solar_lock.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_solar_lock:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}
end