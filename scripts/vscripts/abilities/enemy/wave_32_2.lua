---@class wave_32_2: eom_ability
wave_32_2 = eom_ability({}, nil, ability_base_ai)
function wave_32_2:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_wave_32_2", { duration = self:GetDuration() })

	hCaster:EmitSound("Hero_Chen.PenitenceCast")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_32_2 : eom_modifier
modifier_wave_32_2 = eom_modifier({
	Name = "modifier_wave_32_2",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_32_2:OnCreated(params)
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/units/wave_32/holy_armor_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_wave_32_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL
	}
end
function modifier_wave_32_2:GetAbsoluteNoDamagePhysical()
	return 1
end
function modifier_wave_32_2:GetAbsoluteNoDamageMagical()
	return 1
end