---@class boss_fire_reborn: eom_ability
boss_fire_reborn = eom_ability({})
-- function boss_fire_reborn:GetIntrinsicModifierName()
-- 	return "modifier_boss_fire_reborn"
-- end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_fire_reborn : eom_modifier
modifier_boss_fire_reborn = eom_modifier({
	Name = "modifier_boss_fire_reborn",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_fire_reborn:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_boss_fire_reborn:OnCreated(params)
	if IsServer() then
	end
end
function modifier_boss_fire_reborn:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_boss_fire_reborn:OnDestroy()
	if IsServer() then
	end
end
function modifier_boss_fire_reborn:DeclareFunctions()
	return {
	}
end
function modifier_boss_fire_reborn:EDeclareFunctions()
	return {
	}
end