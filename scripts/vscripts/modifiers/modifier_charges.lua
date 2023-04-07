---@class modifier_charges : eom_modifier
modifier_charges = eom_modifier({
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	RemoveOnDeath = false,
	DestroyOnExpire = false,
})
local public = modifier_charges
function public:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function public:OnCreated(params)
	if IsServer() then
		local hAbility = self:GetAbility()
		if not IsValid(hAbility) or hAbility:GetLevel() == 0 then
			self:Destroy()
			return
		end
		self.max_charges = params.max_charges
		self.charge_restore_time = params.charge_restore_time

		if self.max_charges <= 1 then
			self:Destroy()
			return
		end

		self:SetStackCount(self.max_charges)

		local charge_restore_time = hAbility:GetCooldownTime()
		if charge_restore_time > 0 then
			self:DecrementStackCount()
			self:SetDuration(charge_restore_time, true)
			self:StartIntervalThink(charge_restore_time)

			hAbility:EndCooldown()
		end
	end
end
function public:OnRefresh(params)
	if IsServer() then
		local hAbility = self:GetAbility()
		if not IsValid(hAbility) or hAbility:GetLevel() == 0 then
			self:Destroy()
			return
		end
		local old_max_charges = self.max_charges
		self.max_charges = params.max_charges
		self.charge_restore_time = params.charge_restore_time

		if self.max_charges <= 1 then
			self:Destroy()
			return
		end

		local iStackCount = Clamp(self:GetStackCount() + self.max_charges - old_max_charges, 0, self.max_charges)

		self:SetStackCount(iStackCount)

		if self.max_charges - old_max_charges > 0 then
			hAbility:EndCooldown()
		elseif self.max_charges - old_max_charges < 0 and iStackCount == 0 then
			hAbility:StartCooldown(self:GetRemainingTime())
		end
	end
end
function public:RefreshCharges()
	if IsServer() then
		self:SetStackCount(self.max_charges)
		self:StartIntervalThink(-1)
		self:SetDuration(-1, true)
	end
end
function public:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		if not IsValid(hAbility) or hAbility:GetLevel() == 0 then
			self:Destroy()
			return
		end
		if self:GetStackCount() < self.max_charges then
			self:IncrementStackCount()
		end
		if self:GetStackCount() >= self.max_charges then
			self:SetDuration(-1, true)
			self:StartIntervalThink(-1)
		else
			local charge_restore_time = self.charge_restore_time and self.charge_restore_time * hParent:GetCooldownReduction() or hAbility:GetEffectiveCooldown(-1)
			self:SetDuration(charge_restore_time, true)
			self:StartIntervalThink(charge_restore_time)
		end
	end
end
function public:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = { self:GetParent() },
	}
end
function public:OnStackCountChanged(iStackCount)
	FireModifierEvent(MODIFIER_EVENT_ON_ABILITY_CHARGE_CHANGED, {
		unit = self:GetParent(),
		ability = self:GetAbility(),
		charge = self:GetStackCount(),
		old_charge = iStackCount
	}, self:GetParent())
	local hAbility = self:GetAbility()
	if hAbility.OnAbilityChargeChanged then
		hAbility:OnAbilityChargeChanged(self:GetStackCount(), iStackCount)
	end
end
function public:OnAbilityFullyCast(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if not IsValid(hAbility) or hAbility:GetLevel() == 0 then
		self:Destroy()
		return
	end
	if params.unit == hParent then
		if params.ability == hAbility and hAbility:GetCooldownTime() > 0 then
			local charge_restore_time = self.charge_restore_time and self.charge_restore_time * hParent:GetCooldownReduction() or hAbility:GetEffectiveCooldown(-1)
			if self:GetDuration() == -1 then
				self:SetDuration(charge_restore_time, true)
				self:StartIntervalThink(charge_restore_time)
			end

			self:DecrementStackCount()

			hAbility:EndCooldown()

			if self:GetStackCount() == 0 then
				hAbility:StartCooldown(self:GetRemainingTime())
			end
		end
	end
end