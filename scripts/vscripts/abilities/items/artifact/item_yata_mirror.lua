---@class item_yata_mirror: eom_ability 八咫镜
item_yata_mirror = class({})
function item_yata_mirror:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_item_yata_mirror_buff", { duration = self:GetSpecialValueFor("duration") })
	-- sound
	hCaster:EmitSound("Hero_ObsidianDestroyer.EssenceAura")
end
function item_yata_mirror:GetIntrinsicModifierName()
	return "modifier_item_yata_mirror"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_yata_mirror : eom_modifier
modifier_item_yata_mirror = eom_modifier({
	Name = "modifier_item_yata_mirror",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_yata_mirror:OnCreated(params)
	self.bonus_attribute = self:GetAbilitySpecialValueFor("bonus_attribute")
	self.bonus_resistance = self:GetAbilitySpecialValueFor("bonus_resistance")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.ability_critical_chance = self:GetAbilitySpecialValueFor("ability_critical_chance")
	self.ability_critical_damage = self:GetAbilitySpecialValueFor("ability_critical_damage")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	else
		local p = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_desolation/sf_desolation_ambient_blade_energy.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(p, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(p, false, false, -1, false, false)
	end
	-- SetSpellCriticalStrike(self:GetParent(), 100, self.ability_critical_damage, self)
end
function modifier_item_yata_mirror:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_item_yata_mirror_shield")
	end
	-- SetSpellCriticalStrike(self:GetParent(), nil, nil, self)
end
function modifier_item_yata_mirror:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_yata_mirror_shield", { duration = self.duration })
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_yata_mirror_buff : eom_modifier
modifier_item_yata_mirror_buff = eom_modifier({
	Name = "modifier_item_yata_mirror_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_yata_mirror_buff:OnCreated(params)
	self.damage = self:GetAbilitySpecialValueFor("damage")
	local hParent = self:GetParent()
	if IsClient() then
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_top_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(p, false, false, -1, false, false)
	end
end
function modifier_item_yata_mirror_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_DAMAGE_PERCENTAGE = self.damage,
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_yata_mirror_shield : eom_modifier
modifier_item_yata_mirror_shield = eom_modifier({
	Name = "modifier_item_yata_mirror_shield",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_yata_mirror_shield:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
		for i = 1, 8 do
			local vPosition = hParent:GetAbsOrigin() + RotatePosition(Vector(0, 0, 0), QAngle(0, 45 * i, 0), hParent:GetForwardVector()) * 120
			local p = ParticleManager:CreateParticle("particles/items/yata_mirror/yata_mirror.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(p, 0, vPosition)
			ParticleManager:SetParticleControlForward(p, 0, (vPosition - hParent:GetAbsOrigin()):Normalized())
		end
	end
end
function modifier_item_yata_mirror_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	}
end
function modifier_item_yata_mirror:GetAbsoluteNoDamageMagical()
	return 1
end