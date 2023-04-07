---@class item_chui_1: eom_ability 锤
item_chui_1 = class({})
function item_chui_1:GetIntrinsicModifierName()
	return "modifier_chui"
end
---@class item_chui_2: eom_ability 锤
item_chui_2 = class({}, nil, item_chui_1)
---@class item_chui_3: eom_ability 锤
item_chui_3 = class({}, nil, item_chui_1)
---@class item_chui_4: eom_ability 锤
item_chui_4 = class({}, nil, item_chui_1)
---@class item_chui_5: eom_ability 锤
item_chui_5 = class({}, nil, item_chui_1)
function item_chui_5:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_chui_active", { duration = 10 })
end
----------------------------------------Modifier----------------------------------------
---@class modifier_chui : eom_modifier
modifier_chui = eom_modifier({
	Name = "modifier_chui",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_chui:GetAbilitySpecialValue(params)
	self.stun_chance = self:GetAbilitySpecialValueFor("stun_chance")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.stun_cooldown = self:GetAbilitySpecialValueFor("stun_cooldown")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self.bCooldownReady = true
	end
end
function modifier_chui:OnDestroy()
	if IsServer() then
	end
end
function modifier_chui:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end
function modifier_chui:OnAttackLanded(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:IsIllusion() then
		local hParent = self:GetParent()
		local hTarget = params.target
		local hAbility = self:GetAbility()
		if self.bCooldownReady == true or hParent:HasModifier("modifier_chui_active") then
			if PRD(self, self.stun_chance, "modifier_chui") then
				local flDamage = self:GetAbilitySpecialValueFor("damage")
				local tDamageInfo = {
					attacker = hParent,
					damage = flDamage,
					damage_type = hAbility:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					ability = hAbility
				}
				local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hTarget:GetAbsOrigin(), hParent, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _, hUnit in pairs(tTargets) do
					tDamageInfo.victim = hUnit
					ApplyDamage(tDamageInfo)

					hUnit:AddNewModifier(hParent, hAbility, "modifier_stunned", { duration = self.stun_duration * hTarget:GetStatusResistanceFactor() })
					hUnit:AddNewModifier(hParent, hAbility, "modifier_chui_debuff", { duration = 3 * hTarget:GetStatusResistanceFactor() })
					-- particle
					local p = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_CUSTOMORIGIN, hParent)
					ParticleManager:SetParticleControlEnt(p, 0, hParent, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_origin", hParent:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(p, 1, hUnit, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_origin", hUnit:GetAbsOrigin(), true)
				end
				-- hAbility:StartCooldown(self.stun_cooldown)
				self.bCooldownReady = false
				self:StartIntervalThink(self.stun_cooldown)
				hParent:EmitSound("Hero_Razor.UnstableCurrent.Strike")
			end
		end
	end
end
function modifier_chui:OnIntervalThink()
	if IsServer() then
		self:StartIntervalThink(-1)
		self.bCooldownReady = true
		return
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_chui_active : eom_modifier
modifier_chui_active = eom_modifier({
	Name = "modifier_chui_active",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
----------------------------------------Modifier----------------------------------------
---@class modifier_chui_debuff : eom_modifier
modifier_chui_debuff = eom_modifier({
	Name = "modifier_chui_active",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_chui_debuff:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/generic_gameplay/rune_doubledamage_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_chui_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
end
function modifier_chui_debuff:GetModifierAttackSpeedBonus_Constant()
	return -2000
end
function modifier_chui_debuff:GetModifierMoveSpeed_Absolute()
	return 100
end