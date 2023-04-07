---@class item_treant_1: eom_ability
item_treant_1 = class({})
function item_treant_1:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_item_treant_1", { duration = self:GetSpecialValueFor("duration") })
	hCaster:EmitSound("Hero_Treant.LivingArmor.Cast")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_treant_1 : eom_modifier
modifier_item_treant_1 = eom_modifier({
	Name = "modifier_item_treant_1",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_treant_1:OnCreated(params)
	self.damage_block = self:GetAbilitySpecialValueFor("damage_block")
	self.bonus_hp_regen = self:GetAbilitySpecialValueFor("bonus_hp_regen")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/skills/green_protect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_treant_1:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = -self.damage_block,
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = self.bonus_hp_regen,
	}
end