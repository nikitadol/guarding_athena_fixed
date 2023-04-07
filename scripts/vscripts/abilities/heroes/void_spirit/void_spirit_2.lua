---@class void_spirit_2 : eom_ability
void_spirit_2 = eom_ability({})
function void_spirit_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	hCaster:EmitSound("Hero_VoidSpirit.Dissimilate.Cast")
	hCaster:EmitSound("Hero_VoidSpirit.Dissimilate.Portals")
	-- local disappear_time = self:GetSpecialValueFor("disappear_time")
	-- hCaster:AddNewModifier(hCaster, self, "modifier_void_spirit_2_phase", { duration = disappear_time, vPosition = vPosition })
	hCaster:AetherRemnant(hCaster:GetAbsOrigin())
	FindClearSpaceForUnit(hCaster, vPosition, true)
	hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_3_END)
	--特效
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius / 1.5, 0, radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, radius, self)
	for k, hTarget in pairs(tTargets) do
		hCaster:DealDamage(hTarget, self, damage)
		hTarget:AddNewModifier(hCaster, self, "modifier_stunned", { duration = stun_duration })
	end
	hCaster:EmitSound('Hero_VoidSpirit.Dissimilate.TeleportIn')
end