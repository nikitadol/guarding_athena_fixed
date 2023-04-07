---@class juggernaut_3 : eom_ability
juggernaut_3 = eom_ability({})
function juggernaut_3:GetIntrinsicModifierName()
	return "modifier_juggernaut_3"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_juggernaut_3 : eom_modifier
modifier_juggernaut_3 = eom_modifier({
	Name = "modifier_juggernaut_3",
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_juggernaut_3:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.scepter_damage_pct = self:GetAbilitySpecialValueFor("scepter_damage_pct")
	self.scepter_reduce_pct = self:GetAbilitySpecialValueFor("scepter_reduce_pct")
	self.scepter_ignore_armor_chance = self:GetAbilitySpecialValueFor("scepter_ignore_armor_chance")
end
function modifier_juggernaut_3:IsHidden()
	return self:GetStackCount() == 0 and true or false
end
function modifier_juggernaut_3:OnCreated(params)
	if IsServer() then
		self.tData = {}
	end
end
function modifier_juggernaut_3:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_START = { self:GetParent() },
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_IGNORE_ARMOR_PERCENTAGE
	}
end
function modifier_juggernaut_3:OnIntervalThink()
	local flTime = GameRules:GetGameTime()
	for i = #self.tData, 1, -1 do
		if flTime >= self.tData[i].flDieTime then
			table.remove(self.tData, i)
			self:DecrementStackCount()
		end
	end
	-- 暂停计时器
	if #self.tData == 0 then
		self:StartIntervalThink(-1)
	end
end
function modifier_juggernaut_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_juggernaut_3:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed * self:GetStackCount()
end
function modifier_juggernaut_3:OnAttackStart(params)
	if params.attacker == self:GetParent() then
		local iParticleID = ParticleManager:CreateParticle("particles/skills/blade_dance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(RandomInt(0, 180), RandomInt(0, 180), RandomInt(0, 180)))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_juggernaut_3:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			local hParent = self:GetParent()
			local hAbility = self:GetAbility()
			local flDamage = self.damage
			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
			hParent:DealDamage(tTargets, hAbility, flDamage)
			-- if hParent:GetScepterLevel() >= 3 and RollPercentage(self.scepter_ignore_armor_chance) then
			-- 	params.target:AddNewModifier(hParent, hAbility, "modifier_juggernaut_3_ignore_armor", { duration = FrameTime() })
			-- end
			-- 叠加攻速
			if self:GetStackCount() == 0 then
				self:StartIntervalThink(0)
			end
			self:IncrementStackCount()
			table.insert(self.tData, {
				flDieTime = GameRules:GetGameTime() + self.duration
			})
		end
	end
end
function modifier_juggernaut_3:EOM_GetModifierIncomingDamagePercentage()
	if self:GetParent():GetScepterLevel() >= 4 then
		return -self.scepter_reduce_pct * self:GetStackCount()
	end
end
function modifier_juggernaut_3:EOM_GetModifierOutgoingDamagePercentage()
	if self:GetParent():GetScepterLevel() >= 4 then
		return self.scepter_damage_pct * self:GetStackCount()
	end
end
function modifier_juggernaut_3:EOM_GetModifierIgnoreArmorPercentage(params)
	if self:GetParent():GetScepterLevel() >= 3 and PRD(self, self.scepter_ignore_armor_chance, "modifier_juggernaut_3") then
		return 100
	end
end