---@class wave_32_1: eom_ability
wave_32_1 = eom_ability({})
function wave_32_1:GetIntrinsicModifierName()
	return "modifier_wave_32_1"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_32_1 : eom_modifier
modifier_wave_32_1 = eom_modifier({
	Name = "modifier_wave_32_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_32_1:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	if IsServer() then
	end
end
function modifier_wave_32_1:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	if IsServer() then
	end
end
function modifier_wave_32_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_wave_32_1:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
function modifier_wave_32_1:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.target ~= nil and
	not params.attacker:PassivesDisabled() and
	RollPseudoRandomPercentage(self.chance, self:GetAbility():entindex(), self:GetParent()) then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		params.target:EmitSound("Hero_Chen.HolyPersuasionCast")
		params.attacker:DealDamage(params.target, self:GetAbility(), self.damage, DAMAGE_TYPE_PURE)
	end
end