---@class wave_33_1: eom_ability
wave_33_1 = eom_ability({})
function wave_33_1:GetIntrinsicModifierName()
	return "modifier_wave_33_1"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_33_1 : eom_modifier
modifier_wave_33_1 = eom_modifier({
	Name = "modifier_wave_33_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_33_1:GetAbilitySpecialValue()
	self.mana_burn = self:GetAbilitySpecialValueFor("mana_burn")
end
function modifier_wave_33_1:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
function modifier_wave_33_1:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:PassivesDisabled() then
		params.target:SpendMana(self.mana_burn, self:GetAbility())
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		params.target:EmitSound("Hero_Antimage.ManaBreak")
	end
end