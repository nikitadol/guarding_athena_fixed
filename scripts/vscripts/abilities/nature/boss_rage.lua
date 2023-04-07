---@class boss_rage: eom_ability
boss_rage = eom_ability({}, nil, ability_base_ai)
function boss_rage:GetRadius()
	return 400
end
function boss_rage:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	hCaster:AddNewModifier(hCaster, self, "modifier_boss_rage", { duration = duration })
	hCaster:EmitSound("Hero_LifeStealer.Rage")
	hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_rage : eom_modifier
modifier_boss_rage = eom_modifier({
	Name = "modifier_boss_rage",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_rage:GetAbilitySpecialValue()
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.attakc_time = self:GetAbilitySpecialValueFor("attakc_time")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.damaeg_pct = self:GetAbilitySpecialValueFor("damaeg_pct")
end
function modifier_boss_rage:OnCreated(params)
	if IsServer() then
	end
end
function modifier_boss_rage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.attackspeed or 0,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT = self.movespeed or 0,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT = self.attakc_time or 0,
	}
end
function modifier_boss_rage:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = self.damaeg_pct
	}
end