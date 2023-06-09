---@class item_water_gun: eom_ability
item_water_gun = class({})
function item_water_gun:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local tProjectileInfo = {
		Target = hTarget,
		Source = hCaster,
		Ability = self,
		EffectName = "particles/units/heroes/hero_morphling/morphling_base_attack.vpcf",
		bDodgeable = false,
		iMoveSpeed = 1100,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
	}
	ProjectileManager:CreateTrackingProjectile(tProjectileInfo)
	-- sound
	hCaster:EmitSound("Hero_Shared.WaterFootsteps")
end
function item_water_gun:OnProjectileHit(hTarget, vLocation)
	if hTarget then
		local duration = self:GetSpecialValueFor("duration")
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_water_gun", { duration = duration })
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_water_gun : eom_modifier
modifier_item_water_gun = eom_modifier({
	Name = "modifier_item_water_gun",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_water_gun:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/econ/courier/courier_flopjaw/courier_flopjaw_ambient_water.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_water_gun:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end
function modifier_item_water_gun:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = self.health_regen_pct
	}
end
function modifier_item_water_gun:GetModifierMoveSpeedBonus_Constant(params)
	return -self.movespeed
end