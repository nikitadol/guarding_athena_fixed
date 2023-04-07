---@class legion_commander_0: eom_ability
legion_commander_0 = eom_ability({})
function legion_commander_0:GetIntrinsicModifierName()
	return "modifier_legion_commander_0"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_legion_commander_0 : eom_modifier
modifier_legion_commander_0 = eom_modifier({
	Name = "modifier_legion_commander_0",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_legion_commander_0:GetAbilitySpecialValue()
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.threshold = self:GetAbilitySpecialValueFor("threshold")
	self.scepter_threshold = self:GetAbilitySpecialValueFor("scepter_threshold")
end
function modifier_legion_commander_0:OnCreated(params)
	if IsServer() then
		self.tDamageInfo = {}
	end
end
function modifier_legion_commander_0:OnDestroy()
	if IsServer() then
	end
end
function modifier_legion_commander_0:OnTakeDamage(params)
	local hParent = self:GetParent()
	local hAbility = hParent:FindAbilityByName("legion_commander_4")
	if IsValid(hAbility) and hAbility:GetLevel() > 0 then
		table.insert(self.tDamageInfo, {
			flDamage = params.damage,
			flDieTime = GameRules:GetGameTime() + self.duration
		})
		local flDamage = 0
		for i = #self.tDamageInfo, 1, -1 do
			if GameRules:GetGameTime() < self.tDamageInfo[i].flDieTime then
				flDamage = flDamage + self.tDamageInfo[i].flDamage
			else
				table.remove(self.tDamageInfo, i)
			end
		end
		local threshold = hParent:GetScepterLevel() >= 3 and self.threshold or self.scepter_threshold
		local flHealthThreshold = hParent:GetCustomMaxHealth() * threshold * 0.01
		if flDamage >= flHealthThreshold and not hParent:HasModifier("modifier_legion_commander_4") then
			hParent:FindAbilityByName("legion_commander_4"):OnSpellStart(true)
			hParent:Purge(false, true, false, true, true)
		end
	end
end
function modifier_legion_commander_0:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() }
	}
end