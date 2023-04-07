---@class howl: eom_ability
howl = eom_ability({})
function howl:GetIntrinsicModifierName()
	return "modifier_howl"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_howl : eom_modifier
modifier_howl = eom_modifier({
	Name = "modifier_howl",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_howl:GetAbilitySpecialValue()
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_howl:OnTakeDamage()
	if IsServer() then
		if self:GetAbility():IsCooldownReady() then
			self:GetAbility():UseResources(false, false, true)
			local hParent = self:GetParent()
			hParent:AddNewModifier(hParent, self, "modifier_howl_buff", { duration = self.duration })
			hParent:EmitSound("Hero_Lycan.Howl")
		end
	end
end
function modifier_howl:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() }
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_howl_buff : eom_modifier
modifier_howl_buff = eom_modifier({
	Name = "modifier_howl_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_howl_buff:CheckState()
	return {
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true
	}
end