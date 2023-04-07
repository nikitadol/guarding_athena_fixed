---@class bash: eom_ability
bash = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetCaster():HasModifier("modifier_trial_buff")
	end
}, nil, ability_base_ai)
function bash:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	local damage = self:GetSpecialValueFor("damage")
	local info = {
		hAbility = self,
		hCaster = hCaster,
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		vDirection = vDirection,
		iMoveSpeed = 5000,
		flDistance = 200,
		flStartRadius = 150,
		flEndRadius = 450,
		OnProjectileHit = function(hTarget, vPosition, tInfo)
			hCaster:DealDamage(hTarget, self, damage * hCaster:GetAttackDamage() * 0.01)
			hTarget:KnockBack(vDirection, 150, 0, 0.2)
			hTarget:AddNewModifier(hCaster, self, "modifier_bash", { duration = 2 })
		end
	}
	ProjectileSystem:CreateLinearProjectile(info)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_mars/mars_shield_bash.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControlForward(iParticleID, 0, vDirection)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(500, 500, 500))
	hCaster:EmitSound("Hero_Mars.Shield.Cast")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_bash : eom_modifier
modifier_bash = eom_modifier({
	Name = "modifier_bash",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_bash:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = -50,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = -50
	}
end