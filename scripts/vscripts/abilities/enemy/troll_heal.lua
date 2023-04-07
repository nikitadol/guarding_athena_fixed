---@class troll_heal: eom_ability
troll_heal = eom_ability({})
function troll_heal:GetIntrinsicModifierName()
	return "modifier_troll_heal"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_troll_heal : eom_modifier
modifier_troll_heal = eom_modifier({
	Name = "modifier_troll_heal",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, aura_base)
function modifier_troll_heal:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.aura_radius, self.aura_radius, self.aura_radius))
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration_flame.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_POINT_FOLLOW, "attach_attack1", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_troll_heal_buff : eom_modifier
modifier_troll_heal_buff = eom_modifier({
	Name = "modifier_troll_heal_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_troll_heal_buff:GetAbilitySpecialValue()
	self.heal = self:GetAbilitySpecialValueFor("heal")
end
function modifier_troll_heal_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = self.heal
	}
end