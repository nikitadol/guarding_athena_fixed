---@class antimage_0: eom_ability
antimage_0 = eom_ability({})
function antimage_0:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	hCaster:AddNewModifier(hCaster, self, "modifier_antimage_0_buff", { duration = duration })
	hCaster:EmitSound("Hero_Antimage.Counterspell.Cast")
end
function antimage_0:GetIntrinsicModifierName()
	return "modifier_antimage_0"
end
function antimage_0:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_antimage_0 : eom_modifier
modifier_antimage_0 = eom_modifier({
	Name = "modifier_antimage_0",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_antimage_0:GetAbilitySpecialValue()
	self.max_count = self:GetAbilitySpecialValueFor("max_count")
	self.scepter_max_count = self:GetAbilitySpecialValueFor("scepter_max_count")
end
function modifier_antimage_0:OnDeath(params)
	local max_count = self:GetParent():GetScepterLevel() >= 2 and self.scepter_max_count or self.max_count
	if self:GetStackCount() < max_count then
		self:IncrementStackCount()
		if self:GetParent():GetScepterLevel() >= 2 and self:GetStackCount() < max_count then
			self:IncrementStackCount()
		end
		if self:GetStackCount() >= max_count and self:GetAbility():GetAutoCastState() == true and not self:GetParent():HasModifier("modifier_antimage_0_buff") then
			ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_CAST_NO_TARGET, self:GetAbility())
		end
	end
end
function modifier_antimage_0:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS = self:GetStackCount()
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_antimage_0_buff : eom_modifier
modifier_antimage_0_buff = eom_modifier({
	Name = "modifier_antimage_0_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_antimage_0_buff:GetAbilitySpecialValue()
	self.all = self:GetAbilitySpecialValueFor("all")
end
function modifier_antimage_0_buff:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_0.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_antimage_0_buff:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:EmitSound("Hero_Terrorblade.Metamorphosis")
		local hModifier = hParent:FindModifierByName("modifier_antimage_0")
		local iStackCount = hModifier:GetStackCount()
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ALL, self.all * iStackCount)
		hModifier:SetStackCount(0)
	end
end