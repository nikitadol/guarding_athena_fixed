---@class boss_blink: eom_ability
boss_blink = eom_ability({})
function boss_blink:GetIntrinsicModifierName()
	return "modifier_boss_blink"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_blink : eom_modifier
modifier_boss_blink = eom_modifier({
	Name = "modifier_boss_blink",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_blink:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_boss_blink:OnCreated(params)
	if IsServer() then
	end
end
function modifier_boss_blink:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_boss_blink:OnDestroy()
	if IsServer() then
	end
end
function modifier_boss_blink:DeclareFunctions()
	return {
	}
end
function modifier_boss_blink:EDeclareFunctions()
	return {
	}
end