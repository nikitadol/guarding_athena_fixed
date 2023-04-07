---@class troll_blink: eom_ability
troll_blink = eom_ability({})
function troll_blink:GetIntrinsicModifierName()
	return "modifier_troll_blink"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_troll_blink : eom_modifier
modifier_troll_blink = eom_modifier({
	Name = "modifier_troll_blink",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_troll_blink:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_troll_blink:GetModifierAvoidDamage(params)
	local hAbility = self:GetAbility()
	if params and params.attacker and hAbility:IsCooldownReady() then
		hAbility:UseResources(false, false, true)
		local hParent = self:GetParent()
		hParent:EmitSound("DOTA_Item.BlinkDagger.Activate")
		local iParticleID = ParticleManager:CreateParticle("particles/units/troll_blink.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		local vPosition = hParent:GetAbsOrigin() + RandomVector(RandomInt(400, 600))
		FindClearSpaceForUnit(hParent, vPosition, true)
		ProjectileManager:ProjectileDodge(hParent)
		return 1
	end
end