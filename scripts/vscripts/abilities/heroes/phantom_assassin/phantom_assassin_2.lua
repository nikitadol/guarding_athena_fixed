---@class phantom_assassin_2: eom_ability
phantom_assassin_2 = eom_ability({})
function phantom_assassin_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local vStart = hCaster:GetAbsOrigin()
	local blink_range = self:GetSpecialValueFor("blink_range")
	local damage = self:GetSpecialValueFor("damage")
	local width = self:GetSpecialValueFor("width")
	local vDirection = (vPosition - vStart):Normalized()
	local vEnd = vPosition
	if (vPosition - vStart):Length2D() > blink_range then
		vEnd = vStart + vDirection * blink_range
	end
	local tTargets = FindUnitsInLineWithAbility(hCaster, vStart, vEnd, width, self)
	hCaster:DealDamage(tTargets, self, damage)
	FindClearSpaceForUnit(hCaster, vEnd, false)
	EmitSoundOnLocationWithCaster(vStart, "Hero_QueenOfPain.Blink_out", hCaster)
	EmitSoundOnLocationWithCaster(vEnd, "Hero_QueenOfPain.Blink_in", hCaster)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_2.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vStart)
	ParticleManager:SetParticleControlForward(iParticleID, 0, vDirection)
	ParticleManager:SetParticleControl(iParticleID, 2, vDirection * (vEnd - vStart):Length2D())
	ParticleManager:ReleaseParticleIndex(iParticleID)
	ProjectileSystem:ProjectileDodge(hCaster)
	hCaster:FindAbilityByName("phantom_assassin_1"):EndCooldown()
end