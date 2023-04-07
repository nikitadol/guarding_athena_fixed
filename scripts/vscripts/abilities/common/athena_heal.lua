---@class athena_heal: eom_ability
athena_heal = eom_ability({
	funcCondition = function(hAbility)
		local bCastable = false
		Game:EachPlayerHero(function(hHero)
			if hHero:GetHealthPercent() < 80 then
				bCastable = true
			end
		end)
		return bCastable
	end
}, nil, ability_base_ai)
function athena_heal:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local iLevel = hCaster:GetLevel()
	Game:EachPlayerHero(function(hHero)
		hHero:AddNewModifier(hCaster, self, "modifier_athena_heal", { duration = duration + iLevel, iLevel = iLevel })
	end)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_athena_heal : eom_modifier
modifier_athena_heal = eom_modifier({
	Name = "modifier_athena_heal",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	RemoveOnDeath = false
})
function modifier_athena_heal:GetAbilitySpecialValue()
	self.health = self:GetAbilitySpecialValueFor("health")
	self.mana = self:GetAbilitySpecialValueFor("mana")
end
function modifier_athena_heal:OnCreated(params)
	if IsServer() then
		self:SetStackCount(params.iLevel)
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/athena/athena_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_athena_heal:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = self.health + (self:GetStackCount() - 1) * 40,
		EOM_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT = self.mana + (self:GetStackCount() - 1) * 8,
	}
end