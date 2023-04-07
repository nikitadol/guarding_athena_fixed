---@class boss_soulclash: eom_ability
boss_soulclash = eom_ability({}, nil, ability_base_ai)
function boss_soulclash:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local damage = self:GetSpecialValueFor("damage")
	local info = {
		hCaster = hCaster,
		hTarget = hTarget,
		sEffectName = "particles/units/heroes/hero_visage/visage_soul_assumption_bolt6.vpcf",
		hAbility = self,
		iMoveSpeed = 900,
		vSpawnOrigin = hCaster:GetAttachmentPosition("attach_attack1"),
		OnProjectileHit = function(hTarget, vLocation, tInfo)
			hCaster:DealDamage(hTarget, self, hTarget:GetCustomMaxHealth() * damage * 0.01)
			hTarget:EmitSound("DOTA_Item.EtherealBlade.Target")
			hTarget:AddNewModifier(hCaster, self, "modifier_boss_soulclash", { duration = 30 })
		end
	}
	ProjectileSystem:CreateTrackingProjectile(info)
	hCaster:EmitSound("DOTA_Item.EtherealBlade.Activate")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_soulclash : eom_modifier
modifier_boss_soulclash = eom_modifier({
	Name = "modifier_boss_soulclash",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_soulclash:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = 1
	}
end