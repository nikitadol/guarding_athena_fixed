---@class pet_57_1: eom_ability
pet_57_1 = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetAutoCastState()
	end
}, nil, ability_base_ai)
function pet_57_1:GetRadius()
	return self:GetSpecialValueFor("distance")
end
function pet_57_1:GetIntrinsicModifierName()
	return "modifier_pet_57_1"
end
function pet_57_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	local speed = self:GetSpecialValueFor("speed")
	local distance = self:GetSpecialValueFor("distance")
	local width = self:GetSpecialValueFor("width")
	local tInfo = {
		Ability = self,
		Source = hCaster,
		EffectName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf",
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		vVelocity = vDirection * speed,
		fDistance = distance,
		fStartRadius = width,
		fEndRadius = width,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	}
	ProjectileManager:CreateLinearProjectile(tInfo)
	hCaster:EmitSound("Hero_Jakiro.DualBreath.Cast")
end
function pet_57_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if hTarget ~= nil then
		local hCaster = self:GetCaster()
		local damage = self:GetSpecialValueFor("damage")
		hCaster:DealDamage(hTarget, self, damage * hCaster:GetMaster():GetPrimaryStats(), DAMAGE_TYPE_MAGICAL)
	end
end