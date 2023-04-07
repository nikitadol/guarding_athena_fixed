---@class troll_block: eom_ability
troll_block = eom_ability({})
function troll_block:GetIntrinsicModifierName()
	return "modifier_troll_block"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_troll_block : eom_modifier
modifier_troll_block = eom_modifier({
	Name = "modifier_troll_block",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_troll_block:GetAbilitySpecialValue()
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_troll_block:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_troll_block:GetModifierAvoidDamage(params)
	local hAbility = self:GetAbility()
	if params and params.attacker and hAbility:IsCooldownReady() and PRD(self, 30, "modifier_troll_block") then
		hAbility:UseResources(false, false, true)
		local hParent = self:GetParent()
		hParent:AddNewModifier(hParent, hAbility, "modifier_troll_block_buff", { duration = self.duration })
		if hParent:IsPositionInRange(params.attacker:GetAbsOrigin(), 200) then
			params.attacker:KnockBack((params.attacker:GetAbsOrigin() - hParent:GetAbsOrigin()):Normalized(), 100, 0, 0.2)
		end
		hParent:EmitSound("Hero_DragonKnight.DragonTail.Target")
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/sven/sven_warcry_ti5/sven_warcry_shield_bash_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		return 1
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_troll_block_buff : eom_modifier
modifier_troll_block_buff = eom_modifier({
	Name = "modifier_troll_block_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_troll_block_buff:GetAbilitySpecialValue()
	self.block = self:GetAbilitySpecialValueFor("block")
end
function modifier_troll_block_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = -self.block
	}
end