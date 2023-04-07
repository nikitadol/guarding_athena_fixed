---@class item_demon_chains: eom_ability
item_demon_chains = class({})
function item_demon_chains:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vPosition = self:GetCursorPosition()
	local hModifier = self:GetIntrinsicModifier()
	if hTarget == nil and IsValid(hModifier.hDemon) and hModifier.hDemon:IsAlive() then
		FindClearSpaceForUnit(hModifier.hDemon, vPosition, true)
		ExecuteOrder(hModifier.hDemon, DOTA_UNIT_ORDER_ATTACK_MOVE, vPosition)
		self:EndCooldown()
	else
		local duration = self:GetSpecialValueFor("duration")
		hTarget:AddNewModifier(hCaster, self, "modifier_item_demon_chains_debuff", { duration = duration })
	end
end
function item_demon_chains:GetIntrinsicModifierName()
	return "modifier_item_demon_chains"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_demon_chains : eom_modifier
modifier_item_demon_chains = eom_modifier({
	Name = "modifier_item_demon_chains",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	RemoveOnDeath = false,
})
function modifier_item_demon_chains:GetAbilitySpecialValue()
	self.attack = self:GetAbilitySpecialValueFor("attack")
	self.armor = self:GetAbilitySpecialValueFor("armor")
	self.health = self:GetAbilitySpecialValueFor("health")
	self.str = self:GetAbilitySpecialValueFor("str")
	self.agi = self:GetAbilitySpecialValueFor("agi")
	self.int = self:GetAbilitySpecialValueFor("int")
end
function modifier_item_demon_chains:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		if not hParent:IsRealHero() then
			return
		end
		local hAbility = self:GetAbility()
		self.tValues = {
			attack = function() return RandomInt(2, 6) end,
			armor = function() return Round(RandomFloat(0.01, 0.05), 2) end,
			health = function() return RandomInt(5, 12) end,
			str = function() return RandomInt(1, 2) end,
			agi = function() return RandomInt(1, 2) end,
			int = function() return RandomInt(1, 2) end,
		}
		if hAbility.tUpgradeData == nil then
			hAbility.tUpgradeData = {
				{
					type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE,
					ability_name = "item_demon_chains",
					special_value_name = "attack",
					operator = ABILITY_UPGRADES_OP_ADD,
					value = 0,
				},
				{
					type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE,
					ability_name = "item_demon_chains",
					special_value_name = "armor",
					operator = ABILITY_UPGRADES_OP_ADD,
					value = 0,
				},
				{
					type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE,
					ability_name = "item_demon_chains",
					special_value_name = "health",
					operator = ABILITY_UPGRADES_OP_ADD,
					value = 0,
				},
				{
					type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE,
					ability_name = "item_demon_chains",
					special_value_name = "str",
					operator = ABILITY_UPGRADES_OP_ADD,
					value = 0,
				},
				{
					type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE,
					ability_name = "item_demon_chains",
					special_value_name = "agi",
					operator = ABILITY_UPGRADES_OP_ADD,
					value = 0,
				},
				{
					type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE,
					ability_name = "item_demon_chains",
					special_value_name = "int",
					operator = ABILITY_UPGRADES_OP_ADD,
					value = 0,
				}
			}
		end
		for i, v in ipairs(hAbility.tUpgradeData) do
			if v.value > 0 then
				AbilityUpgrades:AddSpecialValueUpgrade(self:GetParent(), v)
			end
		end
		self:StartIntervalThink(0.1)
	end
end
function modifier_item_demon_chains:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if self.hDemon == nil or not IsValid(self.hDemon) or not self.hDemon:IsAlive() then
		if self:GetAbility():IsCooldownReady() then
			-- 创建恶魔
			self.hDemon = hParent:SummonUnit("demon_chains_summoned", hParent:GetAbsOrigin() + RandomVector(300), true)
			-- self.hDemon = CreateUnitByNameWithNewData("demon_chains_summoned", hParent:GetAbsOrigin() + RandomVector(300), true, hParent, hParent, hParent:GetTeamNumber(), {})
			self.hDemon:AddNewModifier(hParent, hAbility, "modifier_item_demon_chains_buff", nil)
			self.hDemon:SetControllableByPlayer(hParent:GetPlayerOwnerID(), true)
		end
	end
end
function modifier_item_demon_chains:OnDestroy()
	if IsServer() then
		for i, v in ipairs(self:GetAbility().tUpgradeData) do
			AbilityUpgrades:RemoveSpecialValueUpgrade(self:GetParent(), v)
		end
		if IsValid(self.hDemon) then
			self.hDemon:RemoveModifierByName("modifier_item_demon_chains_buff")
			self.hDemon:ForceKill(false)
		end
	end
end
function modifier_item_demon_chains:OnDeath(params)
	local tData = RandomValue(self:GetAbility().tUpgradeData)
	if tData.value == 0 then
		tData.value = tData.value + self.tValues[tData.special_value_name]()
		self[tData.special_value_name] = self:GetAbilitySpecialValueFor(tData.special_value_name)
		AbilityUpgrades:AddSpecialValueUpgrade(self:GetParent(), tData)
		self:ForceRefresh()
	else
		tData.value = tData.value + self.tValues[tData.special_value_name]()
		self[tData.special_value_name] = self:GetAbilitySpecialValueFor(tData.special_value_name)
		AbilityUpgrades:UpdateSpecialValueUpgrade(self:GetParent(), tData)
		self:ForceRefresh()
	end
end
function modifier_item_demon_chains:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BONUS = self.attack,
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = self.armor,
		EOM_MODIFIER_PROPERTY_HEALTH_BONUS = self.health,
		EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS = self.str,
		EOM_MODIFIER_PROPERTY_STATS_AGILITY_BONUS = self.agi,
		EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS = self.int,
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_demon_chains_buff : eom_modifier
modifier_item_demon_chains_buff = eom_modifier({
	Name = "modifier_item_demon_chains_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_demon_chains_buff:GetAbilitySpecialValue()
	self.damage_percent = self:GetAbilitySpecialValueFor("damage_percent")
end
function modifier_item_demon_chains_buff:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/items/demon_chains/demon_chains_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/items/demon_chains/status_effect_demon_chains.vpcf", PATTACH_INVALID, hParent)
		self:AddParticle(iParticleID, false, true, 10, false, false)
	end
end
function modifier_item_demon_chains_buff:OnDeath(params)
	self:GetAbility():UseResources(false, false, true)
end
function modifier_item_demon_chains_buff:CheckState()
	return {
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = true
	}
end
function modifier_item_demon_chains_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE = -50,
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BONUS = self:GetCaster():GetAttackDamage() + self:GetCaster():GetPrimaryStats() * 100,
		EOM_MODIFIER_PROPERTY_HEALTH_BONUS = self:GetCaster():GetCustomMaxHealth(),
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = self:GetCaster():GetArmor(),
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent() }
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_demon_chains_debuff : eom_modifier
modifier_item_demon_chains_debuff = eom_modifier({
	Name = "modifier_item_demon_chains_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_demon_chains_debuff:GetAbilitySpecialValue()
	self.reduce_armor = self:GetAbilitySpecialValueFor("reduce_armor")
end
function modifier_item_demon_chains_debuff:OnCreated(params)
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	if IsServer() then
		hParent:EmitSound("Hero_Lich.SinisterGaze.TargetLayer.TI10")
		hParent:EmitSound("Hero_Lich.SinisterGaze.Cast")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/lich/lich_ti10_immortal_head/lich_ti10_immortal_gaze.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, "", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hCaster, PATTACH_ABSORIGIN_FOLLOW, "", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, hParent, PATTACH_ABSORIGIN_FOLLOW, "", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_demon_chains_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = self.reduce_armor,
	}
end
function modifier_item_demon_chains_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end