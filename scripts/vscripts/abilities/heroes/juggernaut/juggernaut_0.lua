---@class juggernaut_0 : eom_ability
juggernaut_0 = eom_ability({})
function juggernaut_0:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_juggernaut_0", { duration = self:GetSpecialValueFor("duration") })
	if hCaster:GetScepterLevel() >= 1 then
		local illusions = Load(hCaster, "manta_illusion_table") or {}
		for i = #illusions, 1, -1 do
			local hIllusion = illusions[i]
			if not hIllusion:IsNull() then
				hIllusion:AddNewModifier(hCaster, self, "modifier_juggernaut_0", { duration = self:GetSpecialValueFor("duration") })
			end
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_juggernaut_0 : eom_modifier
modifier_juggernaut_0 = eom_modifier({
	Name = "modifier_juggernaut_0",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_juggernaut_0:GetAbilitySpecialValue()
	self.critical = self:GetAbilitySpecialValueFor("critical")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
end
function modifier_juggernaut_0:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		self.flAttackTimeReduce = math.min(hParent:GetBaseAgility() * 0.001 + 0.1, 1)
		hParent:SetBaseAttackTime(hParent:GetBaseAttackTime() - self.flAttackTimeReduce)
	end
end
function modifier_juggernaut_0:OnRefresh(params)
	if IsServer() then
		local hParent = self:GetParent()
		hParent:SetBaseAttackTime(hParent:GetBaseAttackTime() + self.flAttackTimeReduce)
		self.flAttackTimeReduce = math.min(hParent:GetBaseAgility() * 0.001 + 0.1, 1)
		hParent:SetBaseAttackTime(hParent:GetBaseAttackTime() - self.flAttackTimeReduce)
	end
end
function modifier_juggernaut_0:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:SetBaseAttackTime(hParent:GetBaseAttackTime() + self.flAttackTimeReduce)
	end
end
function modifier_juggernaut_0:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.attackspeed or 0,
	}
end
function modifier_juggernaut_0:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_PERCENTAGE = self.critical,
	}
end