-- 基础Modifier
if BaseModifier == nil then
	BaseModifier = class({})
end
function BaseModifier:IsHidden()
	return false
end
function BaseModifier:IsDebuff()
	return false
end
function BaseModifier:IsPurgable()
	return false
end
function BaseModifier:IsPurgeException()
	return false
end
function BaseModifier:IsStunDebuff()
	return false
end
function BaseModifier:IsHexDebuff()
	return false
end
function BaseModifier:AllowIllusionDuplicate()
	return false
end
---------------------------------------------------------------------
---增益buff
if ModifierPositiveBuff == nil then
	ModifierPositiveBuff = class({}, nil, BaseModifier)
end
function ModifierPositiveBuff:IsPurgable()
	return true
end
function ModifierPositiveBuff:IsPurgeException()
	return true
end
---------------------------------------------------------------------
---负面buff
if ModifierDebuff == nil then
	ModifierDebuff = class({}, nil, ModifierPositiveBuff)
end
function ModifierDebuff:IsDebuff()
	return true
end
---------------------------------------------------------------------
---晕眩buff
if ModifierStun == nil then
	ModifierStun = class({}, nil, ModifierDebuff)
end
function ModifierStun:IsStunDebuff()
	return true
end
function ModifierStun:IsPurgable()
	return false
end
function ModifierStun:OnCreated(params)
	if IsClient() then
		if self.bHasParticle then
			local iParticleID = ParticleManager:CreateParticle("particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
			self:AddParticle(iParticleID, false, false, -1, false, false)
		end
	end
end
function ModifierStun:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function ModifierStun:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end
function ModifierStun:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end
---------------------------------------------------------------------
---隐藏buff
if ModifierHidden == nil then
	ModifierHidden = class({}, nil, BaseModifier)
end
function ModifierHidden:IsHidden()
	return true
end
---------------------------------------------------------------------
AssetModifier = class({})

if AssetModifier == nil then
	AssetModifier = class({})
end
function AssetModifier:IsHidden()
	return true
end
function AssetModifier:IsDebuff()
	return false
end
function AssetModifier:IsPurgable()
	return false
end
function AssetModifier:IsPurgeException()
	return false
end
function AssetModifier:IsStunDebuff()
	return false
end
function AssetModifier:IsHexDebuff()
	return false
end
function AssetModifier:AllowIllusionDuplicate()
	return false
end
function AssetModifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function AssetModifier:Init()
	local hParent = self:GetParent()
	hParent.GetSkinName = function(hParent)
		return string.sub(self:GetName(), 10, -1)
	end
end
function AssetModifier:OnCreated(params)
	self:Init()
end
---------------------------------------------------------------------
---特效
if ParticleModifier == nil then
	ParticleModifier = class({}, nil, ModifierHidden)
end
function ParticleModifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

---------------------------------------------------------------------
---Thinker
if ParticleModifierThinker == nil then
	ParticleModifierThinker = class({}, nil, ParticleModifier)
end
function ParticleModifierThinker:OnDestroy()
	if IsServer() then
		if IsValid(self:GetParent()) then
			self:GetParent():RemoveSelf()
		end
	end
end
function ParticleModifierThinker:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end
---------------------------------------------------------------------
if ModifierThinker == nil then
	ModifierThinker = class({})
end
function ModifierThinker:OnDestroy()
	if IsServer() then
		if IsValid(self:GetParent()) then
			self:GetParent():RemoveSelf()
		end
	end
end
function ModifierThinker:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end
---------------------------------------------------------------------
if HorizontalModifier == nil then
	HorizontalModifier = class({})
end
function HorizontalModifier:IsHidden()
	return true
end
function HorizontalModifier:IsDebuff()
	return false
end
function HorizontalModifier:IsPurgable()
	return false
end
function HorizontalModifier:IsPurgeException()
	return false
end
function HorizontalModifier:IsStunDebuff()
	return false
end
function HorizontalModifier:IsHexDebuff()
	return false
end
function HorizontalModifier:AllowIllusionDuplicate()
	return false
end
function HorizontalModifier:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end
---------------------------------------------------------------------
if VerticalModifier == nil then
	VerticalModifier = class({})
end
function VerticalModifier:IsHidden()
	return true
end
function VerticalModifier:IsDebuff()
	return false
end
function VerticalModifier:IsPurgable()
	return false
end
function VerticalModifier:IsPurgeException()
	return false
end
function VerticalModifier:IsStunDebuff()
	return false
end
function VerticalModifier:IsHexDebuff()
	return false
end
function VerticalModifier:AllowIllusionDuplicate()
	return false
end
function VerticalModifier:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end
---------------------------------------------------------------------
if BothModifier == nil then
	BothModifier = class({})
end
function BothModifier:IsHidden()
	return true
end
function BothModifier:IsDebuff()
	return false
end
function BothModifier:IsPurgable()
	return false
end
function BothModifier:IsPurgeException()
	return false
end
function BothModifier:IsStunDebuff()
	return false
end
function BothModifier:IsHexDebuff()
	return false
end
function BothModifier:AllowIllusionDuplicate()
	return false
end
function BothModifier:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end
----------------------------------------物品基类----------------------------------------
if item_base == nil then
	item_base = class({})
end
function item_base:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
-- function item_base:OnCreated(params)
-- 	self.auto_attack			= self:GetAbilitySpecialValueFor("auto_attack")
-- 	self.auto_attackspeed		= self:GetAbilitySpecialValueFor("auto_attackspeed")
-- 	self.auto_movespeed			= self:GetAbilitySpecialValueFor("auto_movespeed")
-- 	self.auto_health			= self:GetAbilitySpecialValueFor("auto_health")
-- 	self.auto_mana				= self:GetAbilitySpecialValueFor("auto_mana")
-- 	self.auto_health_regen		= self:GetAbilitySpecialValueFor("auto_health_regen")
-- 	self.auto_mana_regen		= self:GetAbilitySpecialValueFor("auto_mana_regen")
-- 	self.auto_armor				= self:GetAbilitySpecialValueFor("auto_armor")
-- 	self.auto_magic_resistance	= self:GetAbilitySpecialValueFor("auto_magic_resistance")
-- 	self.auto_evade				= self:GetAbilitySpecialValueFor("auto_evade")
-- 	self.auto_cast_range		= self:GetAbilitySpecialValueFor("auto_cast_range")
-- 	self.auto_projectile_speed	= self:GetAbilitySpecialValueFor("auto_projectile_speed")
-- 	self.auto_cooldown_reduce	= self:GetAbilitySpecialValueFor("auto_cooldown_reduce")
-- 	self.auto_strength			= self:GetAbilitySpecialValueFor("auto_strength") or 0
-- 	self.auto_agility			= self:GetAbilitySpecialValueFor("auto_agility") or 0
-- 	self.auto_intellect			= self:GetAbilitySpecialValueFor("auto_intellect") or 0
-- 	self.auto_attribute			= self:GetAbilitySpecialValueFor("auto_attribute") or 0
-- end
-- function item_base:OnRefresh(params)
-- 	self.auto_attack			= self:GetAbilitySpecialValueFor("auto_attack")
-- 	self.auto_attackspeed		= self:GetAbilitySpecialValueFor("auto_attackspeed")
-- 	self.auto_movespeed			= self:GetAbilitySpecialValueFor("auto_movespeed")
-- 	self.auto_health			= self:GetAbilitySpecialValueFor("auto_health")
-- 	self.auto_mana				= self:GetAbilitySpecialValueFor("auto_mana")
-- 	self.auto_health_regen		= self:GetAbilitySpecialValueFor("auto_health_regen")
-- 	self.auto_mana_regen		= self:GetAbilitySpecialValueFor("auto_mana_regen")
-- 	self.auto_armor				= self:GetAbilitySpecialValueFor("auto_armor")
-- 	self.auto_magic_resistance	= self:GetAbilitySpecialValueFor("auto_magic_resistance")
-- 	self.auto_evade				= self:GetAbilitySpecialValueFor("auto_evade")
-- 	self.auto_cast_range		= self:GetAbilitySpecialValueFor("auto_cast_range")
-- 	self.auto_projectile_speed	= self:GetAbilitySpecialValueFor("auto_projectile_speed")
-- 	self.auto_cooldown_reduce	= self:GetAbilitySpecialValueFor("auto_cooldown_reduce")
-- 	self.auto_strength			= self:GetAbilitySpecialValueFor("auto_strength") or 0
-- 	self.auto_agility			= self:GetAbilitySpecialValueFor("auto_agility") or 0
-- 	self.auto_intellect			= self:GetAbilitySpecialValueFor("auto_intellect") or 0
-- 	self.auto_attribute			= self:GetAbilitySpecialValueFor("auto_attribute") or 0
-- end
-- function item_base:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.auto_attackspeed or 0,
-- 		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT = self.auto_movespeed or 0,
-- 		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE = self.auto_attack or 0,
-- 		MODIFIER_PROPERTY_HEALTH_BONUS = self.auto_health or 0,
-- 		MODIFIER_PROPERTY_MANA_BONUS = self.auto_mana or 0,
-- 		-- MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = self.auto_health_regen or 0,
-- 		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT = self.auto_mana_regen or 0,
-- 		MODIFIER_PROPERTY_CAST_RANGE_BONUS = self.auto_cast_range or 0,
-- 	-- MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS = self.auto_armor or 0,
-- 	-- MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS = self.auto_magic_resistance or 0,
-- 	}
-- end
-- function item_base:EDeclareFunctions()
-- 	return {
-- 		EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE = self.auto_strength + self.auto_attribute,
-- 		EOM_MODIFIER_PROPERTY_STATS_AGILITY_BASE = self.auto_agility + self.auto_attribute,
-- 		EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BASE = self.auto_intellect + self.auto_attribute,
-- 		EOM_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
-- 		EOM_MODIFIER_PROPERTY_MAGICAL_ARMOR_BONUS,
-- 		EOM_MODIFIER_PROPERTY_EVASION_CONSTANT,
-- 		EOM_MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
-- 		EOM_MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
-- 		EOM_MODIFIER_PROPERTY_PROJECTILE_DISTANCE_BONUS,
-- 		MODIFIER_EVENT_ON_ROOM_END,
-- 	}
-- end
-- function item_base:EOM_GetModifierPhysicalArmorBonus()
-- 	return self.auto_armor
-- end
-- function item_base:EOM_GetModifierMagicalArmorBonus()
-- 	return self.auto_magic_resistance
-- end
-- function item_base:EOM_GetModifierEvasion_Constant()
-- 	return self.auto_evade
-- end
-- function item_base:EOM_GetModifierPercentageCooldown()
-- 	return self.auto_cooldown_reduce
-- end
-- function item_base:EOM_GetModifierBonusProjectileSpeed()
-- 	return self.auto_projectile_speed
-- end
-- function item_base:EOM_GetModifierBonusProjectileDistance()
-- 	return self.auto_cast_range
-- end
-- function item_base:OnRoomEnd()
-- 	self:GetParent():Heal(self.auto_health_regen, self:GetAbility(), false)
-- end
----------------------------------------出生modifier基类----------------------------------------
if EnemySpawnModifier == nil then
	EnemySpawnModifier = class({})
end
function EnemySpawnModifier:OnDestroy()
	if IsServer() then
		-- FireModifierEvent({
		-- 	event_name = MODIFIER_EVENT_ON_ENEMY_SPAWN,
		-- 	unit = self:GetParent()
		-- })
	end
end
----------------------------------------光环----------------------------------------
if aura_base == nil then
	aura_base = class({})
end
function aura_base:GetAbilitySpecialValue()
	self.aura_radius = self:GetAbilitySpecialValueFor("aura_radius")
end
function aura_base:IsAura()
	return true
end
function aura_base:GetAuraRadius()
	return self.aura_radius
end
function aura_base:GetModifierAura()
	return self:GetName() .. "_buff"
end
function aura_base:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end
function aura_base:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end
function aura_base:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end
----------------------------------------冲刺modifier基类----------------------------------------
if dash_base == nil then
	dash_base = class({})
end
function dash_base:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		FireModifierEvent({
			event_name = MODIFIER_EVENT_ON_DASH,
			unit = hParent
		})
		hParent.GetDashDirection = function(hParent)
			return hParent:GetForwardVector()
		end
		hParent.GetDashDistance = function(hParent)
			return 0
		end
		hParent.GetDashDuration = function(hParent)
			return self:GetDuration()
		end
		if hParent:IsCounterProjectile() then
			self.hCounterModifier = hParent:AddNewModifier(hParent, nil, "modifier_counter_projectile", { duration = self:GetDuration() })
		end
		if hParent:IsDestroyProjectile() then
			self.hDestroyModifier = hParent:AddNewModifier(hParent, nil, "modifier_destroy_projectile", { duration = self:GetDuration() })
		end
	end
end
function dash_base:OnRefresh(params)
	self:OnCreated(params)
end
function dash_base:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		FireModifierEvent({
			event_name = MODIFIER_EVENT_ON_DASH_END,
			unit = hParent
		})
		if self.hCounterModifier then
			self.hCounterModifier:Destroy()
		end
		if self.hDestroyModifier then
			self.hDestroyModifier:Destroy()
		end
	end
end