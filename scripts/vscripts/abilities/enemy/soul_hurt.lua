---@class soul_hurt: eom_ability
soul_hurt = eom_ability({})
function soul_hurt:GetIntrinsicModifierName()
	return "modifier_soul_hurt"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_soul_hurt : eom_modifier
modifier_soul_hurt = eom_modifier({
	Name = "modifier_soul_hurt",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_soul_hurt:GetAbilitySpecialValue()
	self.rate = self:GetAbilitySpecialValueFor("rate")
end
function modifier_soul_hurt:OnTakeDamage(params)
	local hAbility = self:GetAbility()
	if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return
	end
	if hAbility:IsCooldownReady() then
		hAbility:UseResources(false, false, true)
		local hParent = self:GetParent()
		hParent:DealDamage(params.attacker, hAbility, params.damage * self.rate, params.damage_type, DOTA_DAMAGE_FLAG_REFLECTION)
	end
end
function modifier_soul_hurt:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() }
	}
end