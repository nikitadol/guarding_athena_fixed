---@class hit_back: eom_ability
hit_back = eom_ability({})
function hit_back:GetIntrinsicModifierName()
	return "modifier_hit_back"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_hit_back : eom_modifier
modifier_hit_back = eom_modifier({
	Name = "modifier_hit_back",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_hit_back:OnAttackLanded(params)
	if IsServer() then
		local hParent = self:GetParent()
		params.target:KnockBack((params.target:GetAbsOrigin() - hParent:GetAbsOrigin()):Normalized(), 50, 0, 0.3, false)
	end
end
function modifier_hit_back:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROJECTILE_NAME = "particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas.vpcf"
	}
end
function modifier_hit_back:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
	}
end