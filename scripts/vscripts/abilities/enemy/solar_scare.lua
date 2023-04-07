---@class solar_scare: eom_ability
solar_scare = eom_ability({}, nil, ability_base_ai)
function solar_scare:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")
	hTarget:AddNewModifier(hCaster, self, "modifier_solar_scare", { duration = duration })
	hCaster:EmitSound("Hero_Nightstalker.Trickling_Fear")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_solar_scare : eom_modifier
modifier_solar_scare = eom_modifier({
	Name = "modifier_solar_scare",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_solar_scare:GetAbilitySpecialValue()
	self.miss = self:GetAbilitySpecialValueFor("miss")
end
function modifier_solar_scare:GetAbilitySpecialValue()
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_void.vpcf", PATTACH_ABSORIGIN, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_solar_scare:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE = self.miss or 0
	}
end