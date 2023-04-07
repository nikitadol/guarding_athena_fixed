---@class shiwangchouxue: eom_ability
shiwangchouxue = eom_ability({}, nil, ability_base_ai)
function shiwangchouxue:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function shiwangchouxue:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function shiwangchouxue:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local heal = self:GetSpecialValueFor("heal")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, radius, self)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		hCaster:DealDamage(hUnit, self, hUnit:GetCustomMaxHealth() * damage * 0.01)
		hCaster:Heal(hCaster:GetCustomMaxHealth() * heal * 0.01, self)
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, 0, 0))
	ParticleManager:SetParticleControl(iParticleID, 2, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Undying.Decay.Cast")
end