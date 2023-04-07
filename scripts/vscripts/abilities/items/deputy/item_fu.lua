---@class item_fu_1: eom_ability 斧
item_fu_1 = class({})
function item_fu_1:GetIntrinsicModifierName()
	return "modifier_fu"
end
---@class item_fu_2: eom_ability 斧
item_fu_2 = class({}, nil, item_fu_1)
---@class item_fu_3: eom_ability 斧
item_fu_3 = class({}, nil, item_fu_1)
---@class item_fu_4: eom_ability 斧
item_fu_4 = class({}, nil, item_fu_1)
---@class item_fu_5: eom_ability 斧
item_fu_5 = class({}, nil, item_fu_1)
function item_fu_5:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_fu_active", { duration = 10 })
end
----------------------------------------Modifier----------------------------------------
---@class modifier_fu : eom_modifier
modifier_fu = eom_modifier({
	Name = "modifier_fu",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_fu:OnCreated(params)
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.cleave_percent = self:GetAbilitySpecialValueFor("cleave_percent")
	self.cleave_radius = self:GetAbilitySpecialValueFor("cleave_radius")
	self.bonus_stats = self:GetAbilitySpecialValueFor("bonus_stats")
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")
	self.bonus_health_regen = self:GetAbilitySpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbilitySpecialValueFor("bonus_mana_regen")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.waist_cut_chance = self:GetAbilitySpecialValueFor("waist_cut_chance")
	self.waist_cut_percent = self:GetAbilitySpecialValueFor("waist_cut_percent")
	if IsServer() then
		self.records = {}
	end
end
function modifier_fu:OnRefresh(params)
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.cleave_percent = self:GetAbilitySpecialValueFor("cleave_percent")
	self.cleave_radius = self:GetAbilitySpecialValueFor("cleave_radius")
	self.bonus_stats = self:GetAbilitySpecialValueFor("bonus_stats")
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")
	self.bonus_health_regen = self:GetAbilitySpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbilitySpecialValueFor("bonus_mana_regen")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.waist_cut_chance = self:GetAbilitySpecialValueFor("waist_cut_chance")
	self.waist_cut_percent = self:GetAbilitySpecialValueFor("waist_cut_percent")
	if IsServer() then
	end
end
function modifier_fu:OnDestroy()
	if IsServer() then
	end
end
function modifier_fu:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_CLEAVE = { self:GetParent() },
	}
end
function modifier_fu:OnCleave(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:IsRangedAttacker() and not params.attacker:IsIllusion() then
		local waist_cut_chance = params.attacker:HasModifier("modifier_fu_active") and self.waist_cut_chance * 2 or self.waist_cut_chance
		if PRD(self, waist_cut_chance, "modifier_fu") then
			local sCleaveParticle = "particles/items_fx/battlefury_cleave.vpcf"
			local flBonusDamage = 0
			local waist_cut_percent = params.target:IsAncient() and self.waist_cut_percent * 0.1 or self.waist_cut_percent
			flBonusDamage = params.target:GetCustomHealth() * waist_cut_percent * 0.01
			sCleaveParticle = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength_crit.vpcf"
			-- 造成纯粹伤害
			params.attacker:DealDamage(params.target, self:GetAbility(), flBonusDamage, DAMAGE_TYPE_PURE)
			local iParticleID = ParticleManager:CreateParticle(sCleaveParticle, PATTACH_ABSORIGIN_FOLLOW, params.attacker)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(2, 17, 4))
			local n = 0
			for i, hUnit in ipairs(params.tTargets) do
				if hUnit ~= params.target then
					params.attacker:DealDamage(hUnit, self:GetAbility(), flBonusDamage, DAMAGE_TYPE_PURE)
					n = n + 1
					ParticleManager:SetParticleControlEnt(iParticleID, n + 1, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, hUnit:GetAbsOrigin(), true)
				end
			end
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(2, 17, n))
			ParticleManager:ReleaseParticleIndex(iParticleID)
			params.attacker:EmitSound("DOTA_Item.BattleFury")
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_fu_active : eom_modifier
modifier_fu_active = eom_modifier({
	Name = "modifier_fu_active",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})