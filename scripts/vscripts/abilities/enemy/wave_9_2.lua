---@class wave_9_2: eom_ability
wave_9_2 = eom_ability({})
function wave_9_2:GetIntrinsicModifierName()
	return "modifier_wave_9_2"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_9_2 : eom_modifier
modifier_wave_9_2 = eom_modifier({
	Name = "modifier_wave_9_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_9_2:GetAbilitySpecialValue()
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.heal = self:GetAbilitySpecialValueFor("heal")
end
function modifier_wave_9_2:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {nil, self:GetParent() }
	}
end
function modifier_wave_9_2:OnAttackLanded(params)
	if IsServer() and params.target == self:GetParent() then
		if RollPercentage(45) then
			-- self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_wave_9_2_buff", {duration = 1})
			self:GetParent():FadeGesture(ACT_DOTA_ATTACK)
			self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 2)
			self:GetParent():PerformAttack(self:GetParent():GetAttackTarget(), true, true, true, false, true, false, false)
			self:GetParent():Heal(self.heal, self:GetAbility())
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_courage_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			SendOverheadEventMessage(self:GetParent():GetPlayerOwner(), OVERHEAD_ALERT_HEAL, self:GetParent(), self.heal, self:GetParent():GetPlayerOwner())
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_9_2_buff : eom_modifier
modifier_wave_9_2_buff = eom_modifier({
	Name = "modifier_wave_9_2_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_9_2_buff:GetAbilitySpecialValue()
	self.heal = self:GetAbilitySpecialValueFor("heal")
end
function modifier_wave_9_2_buff:OnCreated(params)
	if IsServer() then
		if self:GetParent():GetAttackTarget() ~= nil then
			self:OnAttackLanded({ attacker = self:GetParent() })
			-- self:GetParent():PerformAttack(self:GetParent():GetAttackTarget(), true, true, true, false, true, false, false)
		end
	end
end
function modifier_wave_9_2_buff:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
function modifier_wave_9_2_buff:OnAttackLanded(params)
	if IsServer() and params.attacker == self:GetParent() then
		params.attacker:FadeGesture(ACT_DOTA_ATTACK)
		params.attacker:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 2)
		self:GetParent():PerformAttack(self:GetParent():GetAttackTarget(), true, true, true, false, true, false, false)
		params.attacker:Heal(self.heal, self:GetAbility())
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_courage_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker)
		SendOverheadEventMessage(params.attacker:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, params.attacker, self.heal, params.attacker:GetPlayerOwner())
		params.attacker:EmitSound("Hero_LegionCommander.Courage")
		self:Destroy()
	end
end
function modifier_wave_9_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_wave_9_2_buff:GetModifierAttackSpeedBonus_Constant()
	return 1000
end