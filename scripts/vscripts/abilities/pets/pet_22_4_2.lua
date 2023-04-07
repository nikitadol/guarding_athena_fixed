---@class pet_22_4_2: eom_ability
pet_22_4_2 = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetAutoCastState()
	end
}, nil, ability_base_ai)
function pet_22_4_2:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function pet_22_4_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hMaster = hCaster:GetMaster()
	local flDamage = hMaster:GetPrimaryStats() * self:GetAbilityDamage()
	local radius = self:GetSpecialValueFor("radius")
	local vLocation = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_stump"))
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vLocation, radius, self)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, flDamage)
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", { duration = self:GetDuration() * hUnit:GetStatusResistanceFactor() })
	end
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, GetGroundPosition(vLocation, hCaster))
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	hCaster:EmitSound("Hero_Centaur.HoofStomp")
end
function pet_22_4_2:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end