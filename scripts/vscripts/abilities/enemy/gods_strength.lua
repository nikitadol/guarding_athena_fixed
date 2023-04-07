---@class gods_strength: eom_ability
gods_strength = eom_ability({}, nil, ability_base_ai)
function gods_strength:GetRadius()
	return 900
end
function gods_strength:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_gods_strength", { duration = self:GetDuration() })
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Sven.GodsStrength")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_gods_strength : eom_modifier
modifier_gods_strength = eom_modifier({
	Name = "modifier_gods_strength",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_gods_strength:GetAbilitySpecialValue()
	self.gods_strength_damage = self:GetAbilitySpecialValueFor("gods_strength_damage")
end
function modifier_gods_strength:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_POINT_FOLLOW, "attach_eyes", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_gods_strength.vpcf", PATTACH_INVALID, hParent)
		self:AddParticle(iParticleID, false, true, 10, false, false)
	end
end
function modifier_gods_strength:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_PERCENTAGE = self.gods_strength_damage
	}
end