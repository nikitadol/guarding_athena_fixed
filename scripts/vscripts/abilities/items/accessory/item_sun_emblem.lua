---@class item_sun_emblem: eom_ability
item_sun_emblem = class({})
function item_sun_emblem:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function item_sun_emblem:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local duration = self:GetSpecialValueFor("duration")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, radius, self)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_item_sun_emblem", { duration = duration })
		hUnit:SpendHealth(hUnit:GetCustomHealth() * damage * 0.01, self, true)
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	EmitSoundOnLocationWithCaster(vPosition, "Hero_Invoker.SunStrike.Ignite", hCaster)
end
---@class item_sun_emblem_2: eom_ability
item_sun_emblem_2 = class({}, nil, item_sun_emblem)
---@class item_sun_emblem_3: eom_ability
item_sun_emblem_3 = class({}, nil, item_sun_emblem)
---@class item_sun_emblem_4: eom_ability
item_sun_emblem_4 = class({}, nil, item_sun_emblem)
----------------------------------------Modifier----------------------------------------
---@class modifier_item_sun_emblem : eom_modifier
modifier_item_sun_emblem = eom_modifier({
	Name = "modifier_item_sun_emblem",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_sun_emblem:GetAbilitySpecialValue()
	self.reduce_armor = self:GetAbilitySpecialValueFor("reduce_armor")
end
function modifier_item_sun_emblem:ShouldUseOverheadOffset()
	return true
end
function modifier_item_sun_emblem:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/medallion_of_courage.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, true)
	end
end
function modifier_item_sun_emblem:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = self.reduce_armor
	}
end