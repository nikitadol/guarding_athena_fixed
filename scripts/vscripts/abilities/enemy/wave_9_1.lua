---@class wave_9_1: eom_ability
wave_9_1 = eom_ability({})
function wave_9_1:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_wave_9_1", { duration = self:GetDuration() })
	hCaster:EmitSound("Hero_LegionCommander.PressTheAttack")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_9_1 : eom_modifier
modifier_wave_9_1 = eom_modifier({
	Name = "modifier_wave_9_1",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_9_1:GetAbilitySpecialValue()
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.heal = self:GetAbilitySpecialValueFor("heal")
end
function modifier_wave_9_1:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_press_owner.vpcf", PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_POINT_FOLLOW, "attach_attack1", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_wave_9_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_wave_9_1:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = self.heal
	}
end
function modifier_wave_9_1:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end