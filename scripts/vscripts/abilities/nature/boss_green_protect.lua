---@class boss_green_protect: eom_ability
boss_green_protect = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetCaster():GetHealthPercent() < 70
	end
}, nil, ability_base_ai)
function boss_green_protect:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	hCaster:EmitSound("Hero_Treant.LivingArmor.Target")
	hCaster:AddNewModifier(hCaster, self, "modifier_boss_green_protect", { duration = duration })
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_green_protect : eom_modifier
modifier_boss_green_protect = eom_modifier({
	Name = "modifier_boss_green_protect",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_green_protect:GetAbilitySpecialValue()
	self.armor = self:GetAbilitySpecialValueFor("armor")
	self.damage_reduce = self:GetAbilitySpecialValueFor("damage_reduce")
	self.regen = self:GetAbilitySpecialValueFor("armor")
end
function modifier_boss_green_protect:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/skills/green_protect.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_boss_green_protect:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = self.armor,
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = -self.damage_reduce,
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = self.regen,
	}
end