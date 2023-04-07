---@class gush: eom_ability
gush = eom_ability({}, nil, ability_base_ai)
function gush:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorTarget():GetAbsOrigin()
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	local damage = self:GetSpecialValueFor("damage")
	local duration = self:GetSpecialValueFor("duration")
	local info = {
		hAbility = self,
		hCaster = hCaster,
		sEffectName = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf",
		vSpawnOrigin = hCaster:GetAttachmentPosition("attach_attack2"),
		vDirection = vDirection,
		iMoveSpeed = 1200,
		flDistance = 2000,
		flRadius = 300,
		OnProjectileHit = function(hTarget, vPosition, tInfo)
			hCaster:DealDamage(hTarget, self, damage)
			hTarget:AddNewModifier(hCaster, self, "modifier_gush", { duration = duration })
		end
	}
	ProjectileSystem:CreateLinearProjectile(info)
	hCaster:EmitSound("Hero_Tidehunter.Gush.AghsProjectile")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_gush : eom_modifier
modifier_gush = eom_modifier({
	Name = "modifier_gush",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_gush:GetAbilitySpecialValue()
	self.movement_speed = self:GetAbilitySpecialValueFor("movement_speed")
	self.armor_bonus = self:GetAbilitySpecialValueFor("armor_bonus")
end
function modifier_gush:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = self.movement_speed or 0,
	}
end
function modifier_gush:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = -self.armor_bonus
	}
end