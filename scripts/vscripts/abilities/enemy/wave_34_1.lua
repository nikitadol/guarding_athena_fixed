---@class wave_34_1: eom_ability
wave_34_1 = eom_ability({}, nil, ability_base_ai)
function wave_34_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local speed = self:GetSpecialValueFor("speed")
	local info = {
		hCaster = hCaster,
		hTarget = hTarget,
		sEffectName = "particles/econ/items/viper/viper_ti7_immortal/viper_poison_attack_ti7.vpcf",
		hAbility = self,
		iMoveSpeed = speed,
		vSpawnOrigin = hCaster:GetAttachmentPosition("attach_attack1"),
		OnProjectileHit = function(hTarget, vLocation, tInfo)
			hTarget:AddNewModifier(hCaster, self, "modifier_wave_34_1", { duration = self:GetSpecialValueFor("duration") })
		end
	}
	ProjectileSystem:CreateTrackingProjectile(info)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_34_1 : eom_modifier
modifier_wave_34_1 = eom_modifier({
	Name = "modifier_wave_34_1",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_34_1:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	if IsServer() then
		self.flDamage = self:GetAbility():GetAbilityDamage()
		self:StartIntervalThink(1)
	end
end
function modifier_wave_34_1:OnIntervalThink()
	if not IsValid(self:GetCaster()) or not IsValid(self:GetAbility()) then
		self:Destroy()
		return
	end
	self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), self.flDamage)
end
function modifier_wave_34_1:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end
function modifier_wave_34_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end