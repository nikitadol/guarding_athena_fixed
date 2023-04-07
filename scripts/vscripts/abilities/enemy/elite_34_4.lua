---@class elite_34_4: eom_ability
elite_34_4 = eom_ability({}, nil, ability_base_ai)
function elite_34_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_elite_34_4", { duration = self:GetDuration() })
	hCaster:EmitSound("Hero_ShadowDemon.Soul_Catcher.Cast")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_34_4 : eom_modifier
modifier_elite_34_4 = eom_modifier({
	Name = "modifier_elite_34_4",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_34_4:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/solar_lock.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end
function modifier_elite_34_4:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_SILENCED] = true
	}
end