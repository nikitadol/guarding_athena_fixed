---@class item_visage_2: eom_ability
item_visage_2 = class({})
function item_visage_2:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function item_visage_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, radius, self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_item_visage_2_debuff", { duration = duration * hUnit:GetStatusResistanceFactor() })
	end
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/veil_of_discord.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, 1))
	-- sound
	hCaster:EmitSound("DOTA_Item.VeilofDiscord.Activate")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_visage_2_debuff : eom_modifier
modifier_item_visage_2_debuff = eom_modifier({
	Name = "modifier_item_visage_2_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_visage_2_debuff:OnCreated(params)
	self.reduce_armor = self:GetAbilitySpecialValueFor("reduce_armor")
	self.increase_damage = self:GetAbilitySpecialValueFor("increase_damage")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/veil_of_discord_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_visage_2_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BASE_PERCENTAGE = self.reduce_armor,
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = self.increase_damage
	}
end