---@class pet_4_1: eom_ability
pet_4_1 = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetAutoCastState()
	end
}, nil, ability_base_ai)
function pet_4_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = hCaster:GetMaster()
	local duration = self:GetDuration()
	local cooldown_reduction = self:GetSpecialValueFor("cooldown_reduction")
	local mana_restore = math.ceil(self:GetSpecialValueFor("mana_restore") * hTarget:GetMaxMana() * 0.01)

	hTarget:GiveMana(mana_restore)
	SendOverheadEventMessage(hTarget:GetPlayerOwner(), OVERHEAD_ALERT_MANA_ADD, hTarget, mana_restore, hTarget:GetPlayerOwner())

	hTarget:AddNewModifier(hCaster, self, "modifier_pet_4_1", { duration = duration })

	EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_KeeperOfTheLight.ChakraMagic.Target", hCaster)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_4_1 : eom_modifier
modifier_pet_4_1 = eom_modifier({
	Name = "modifier_pet_4_1",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_4_1:GetAbilitySpecialValue()
	self.cooldown_reduction = self:GetAbilitySpecialValueFor("cooldown_reduction")
end
function modifier_pet_4_1:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_COOLDOWN_CONSTANT = self.cooldown_reduction,
		MODIFIER_EVENT_ON_VALID_ABILITY_EXECUTED = { self:GetParent() }
	}
end
function modifier_pet_4_1:OnValidAbilityExecuted(params)
	if IsServer() then
		self:SetDuration(0, false)
	end
end