---@class item_dun_1: eom_ability 盾
item_dun_1 = class({})
---@class item_dun_2: eom_ability 盾
item_dun_2 = class({}, nil, item_dun_1)
---@class item_dun_3: eom_ability 盾
item_dun_3 = class({}, nil, item_dun_1)
---@class item_dun_4: eom_ability 盾
item_dun_4 = class({}, nil, item_dun_1)
---@class item_dun_5: eom_ability 盾
item_dun_5 = class({}, nil, item_dun_1)
function item_dun_5:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_dun_active", { duration = self:GetSpecialValueFor("duration") })
	self:GetCaster():EmitSound("Hero_Omniknight.Repel.TI8")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_dun_active : eom_modifier
modifier_dun_active = eom_modifier({
	Name = "modifier_dun_active",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_dun_active:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/omniknight/omni_ti8_head/omniknight_repel_buff_ti8.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_dun_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
end
function modifier_dun_active:GetAbsoluteNoDamagePhysical()
	return 1
end
function modifier_dun_active:GetAbsoluteNoDamageMagical()
	return 1
end
function modifier_dun_active:GetAbsoluteNoDamagePure()
	return 1
end
function modifier_dun_active:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end