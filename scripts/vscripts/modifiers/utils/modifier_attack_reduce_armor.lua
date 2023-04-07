---@class modifier_attack_reduce_armor : eom_modifier 攻击减甲buff
modifier_attack_reduce_armor = eom_modifier({
	IsHidden = true,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_attack_reduce_armor:AddCustomTransmitterData()
	return {
		flArmorReduce = self.flArmorReduce,
	}
end
function modifier_attack_reduce_armor:HandleCustomTransmitterData(tData)
	self.flArmorReduce = tData.flArmorReduce
end
function modifier_attack_reduce_armor:OnCreated(params)
	self:SetHasCustomTransmitterData(true)
	if IsServer() then
		self.flArmorReduce = params.flArmorReduce
	end
end
function modifier_attack_reduce_armor:OnRefresh(params)
	if IsServer() then
		self.flArmorReduce = self.flArmorReduce + params.flArmorReduce
		self:SendBuffRefreshToClients()
	end
end
function modifier_attack_reduce_armor:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS
	}
end
function modifier_attack_reduce_armor:EOM_GetModifierArmorBonus()
	return -self.flArmorReduce
end