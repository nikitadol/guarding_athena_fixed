---@class item_world_editor: eom_ability 锻世之锤
item_world_editor = class({})
function item_world_editor:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_item_world_editor_buff", { duration = self:GetSpecialValueFor("duration") })
	-- sound
	hCaster:EmitSound("DOTA_Item.BlackKingBar.Activate")
end
function item_world_editor:GetIntrinsicModifierName()
	return "modifier_item_world_editor"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_world_editor : eom_modifier
modifier_item_world_editor = eom_modifier({
	Name = "modifier_item_world_editor",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_world_editor:GetAbilitySpecialValue()
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
function modifier_item_world_editor:IsAura()
	return true
end
function modifier_item_world_editor:GetAuraRadius()
	return self.radius
end
function modifier_item_world_editor:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_item_world_editor:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_item_world_editor:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_item_world_editor:GetModifierAura()
	return "modifier_item_world_editor_debuff"
end
function modifier_item_world_editor:OnCreated(params)
	if IsClient() then
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_natural_order_magical.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(p, false, false, -1, false, false)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_world_editor_debuff : eom_modifier
modifier_item_world_editor_debuff = eom_modifier({
	Name = "modifier_item_world_editor_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_world_editor_debuff:GetAbilitySpecialValue()
	self.damage_reduce = self:GetAbilitySpecialValueFor("damage_reduce")
end
function modifier_item_world_editor_debuff:OnCreated(params)
	local hParent = self:GetParent()
	if IsClient() then
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_natural_order_physical.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(p, false, false, -1, false, false)
	end
end
function modifier_item_world_editor_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE = -self.damage_reduce,
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_world_editor_buff : eom_modifier
modifier_item_world_editor_buff = eom_modifier({
	Name = "modifier_item_world_editor_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_world_editor_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_SCALE = self.model_scale or 0,
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	}
end
function modifier_item_world_editor_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_PERCENTAGE = (self.health - 1) * 100,
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = self.regen,
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = -90
	}
end
function modifier_item_world_editor_buff:GetEffectName()
	return "particles/items2_fx/urn_of_shadows_heal.vpcf"
end
function modifier_item_world_editor_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_item_world_editor_buff:GetAbilitySpecialValue(params)
	self.health = self:GetAbilitySpecialValueFor("health")
	self.regen = self:GetAbilitySpecialValueFor("regen")
	self.model_scale = 150
end
function modifier_item_world_editor_buff:GetModifierAvoidDamage(params)
	if IsServer() then
		local caster = self:GetCaster()
		if params.damage < caster:GetCustomMaxHealth() * 0.1 then
			return 1
		end
	end
end