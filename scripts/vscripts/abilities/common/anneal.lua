---@class anneal: eom_ability
anneal = eom_ability({})
function anneal:GetIntrinsicModifierName()
	return "modifier_anneal"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_anneal : eom_modifier
modifier_anneal = eom_modifier({
	Name = "modifier_anneal",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_anneal:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_anneal:GetAbilitySpecialValue()
	self.exp = self:GetAbilitySpecialValueFor("exp")
	self.gold = self:GetAbilitySpecialValueFor("gold")
end
function modifier_anneal:OnCreated(params)
	if IsServer() then
		self.vCenter = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink(1)
	end
end
function modifier_anneal:OnIntervalThink()
	if self:GetParent():GetAbsOrigin() ~= self.vCenter then
		self:GetParent():SetAbsOrigin(self.vCenter)
		local iEndParticleID = ParticleManager:CreateParticle("particles/items2_fx/teleport_end.vpcf", PATTACH_CUSTOMORIGIN, nil)
	end
end
function modifier_anneal:OnAttackLanded(params)
	local iPlayerID = params.attacker:GetPlayerOwnerID()
	if iPlayerID ~= -1 and PlayerResource:IsValidPlayer(iPlayerID) then
		local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
		hHero:AddExperience(self.exp, DOTA_ModifyXP_Unspecified, false, false)
		PlayerData:ModifyGold(iPlayerID, self.gold)
	end
end
function modifier_anneal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH = 1
	}
end
function modifier_anneal:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {nil, self:GetParent() },
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = 10
	}
end
function modifier_anneal:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true
	}
end
function modifier_anneal:ECheckState()
	return {
		[EOM_MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
end