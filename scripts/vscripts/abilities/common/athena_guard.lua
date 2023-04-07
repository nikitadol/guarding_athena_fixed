---@class athena_guard: eom_ability
athena_guard = eom_ability({
	funcCondition = function(hAbility)
		local bCastable = false
		Game:EachPlayerHero(function(hHero)
			if hHero:GetHealthPercent() < 60 then
				bCastable = true
			end
		end)
		return bCastable
	end
}, nil, ability_base_ai)
function athena_guard:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local iLevel = hCaster:GetLevel()
	Game:EachPlayerHero(function(hHero)
		hHero:AddNewModifier(hCaster, self, "modifier_athena_guard", { duration = duration + iLevel, iLevel = iLevel })
	end)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_athena_guard : eom_modifier
modifier_athena_guard = eom_modifier({
	Name = "modifier_athena_guard",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_athena_guard:GetAbilitySpecialValue()
	self.armor = self:GetAbilitySpecialValueFor("armor")
	self.reduce = self:GetAbilitySpecialValueFor("reduce")
end
function modifier_athena_guard:OnCreated(params)
	if IsServer() then
		self:SetStackCount(params.iLevel)
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_frost_armor.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(1, 0, 0))
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_ABSORIGIN_FOLLOW, "", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_athena_guard:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = -self.reduce - 0.5 * (self:GetStackCount() - 1),
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = self.armor + (self:GetStackCount() - 1),
	}
end