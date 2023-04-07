---@class crystal_maiden_0 : eom_ability
crystal_maiden_0 = eom_ability({})
function crystal_maiden_0:Spawn()
	local hCaster = self:GetCaster()
	hCaster.GetColdStackCount = function(hCaster)
		local iStackCount = hCaster:HasModifier("modifier_crystal_maiden_0_cold") and hCaster:FindModifierByName("modifier_crystal_maiden_0_cold"):GetStackCount() or 0
		return iStackCount
	end
end
function crystal_maiden_0:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_crystal_maiden_0_buff", { duration = self:GetSpecialValueFor("duration") * hTarget:GetStatusResistanceFactor() })
end
function crystal_maiden_0:GetIntrinsicModifierName()
	return "modifier_crystal_maiden_0"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_crystal_maiden_0 : eom_modifier
modifier_crystal_maiden_0 = eom_modifier({
	Name = "modifier_crystal_maiden_0",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_crystal_maiden_0:GetAbilitySpecialValue()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.cold_radius = self:GetAbilitySpecialValueFor("cold_radius")
	self.mark_duration = self:GetAbilitySpecialValueFor("mark_duration")
	self.max_count = self:GetAbilitySpecialValueFor("max_count")
end
function modifier_crystal_maiden_0:OnCreated(params)
	if IsServer() then
		self:GetCaster().tThinker = {}
		self.flTick = 0.2	-- 计算间隔
		self:StartIntervalThink(self.flTick)
	end
end
function modifier_crystal_maiden_0:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED = { self:GetParent() }
	}
end
function modifier_crystal_maiden_0:OnIntervalThink()
	-- 用一个计时器模拟所有冰霜魔印的光环效果，减少消耗
	local hParent = self:GetParent()
	-- 计算出所有冰霜魔印的中心店
	local vCenter = Vector(0, 0, 0)
	for _, hThinker in ipairs(self:GetCaster().tThinker) do
		local vLocation = hThinker:GetAbsOrigin()
		vCenter.x = vCenter.x + vLocation.x
		vCenter.y = vCenter.y + vLocation.y
	end
	vCenter = Vector(vCenter.x / #self:GetCaster().tThinker, vCenter.y / #self:GetCaster().tThinker, 0)
	-- 计算需要搜寻的半径
	local flRadius = 0
	for _, hThinker in ipairs(self:GetCaster().tThinker) do
		flRadius = math.max(flRadius, (hThinker:GetAbsOrigin() - vCenter):Length2D())
	end
	-- 遍历计算出冰霜魔印周围的单位
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), vCenter, nil, flRadius + self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		for _, hThinker in ipairs(self:GetCaster().tThinker) do
			if (hUnit:GetAbsOrigin() - hThinker:GetAbsOrigin()):Length2D() <= self.radius then
				hUnit:AddNewModifier(hParent, self:GetAbility(), "modifier_crystal_maiden_0_debuff", nil)
				break
			end
		end
	end
	-- 判断冰女是否在这个圆里面
	for _, hThinker in ipairs(self:GetCaster().tThinker) do
		if (hParent:GetAbsOrigin() - hThinker:GetAbsOrigin()):Length2D() <= self.cold_radius then
			hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_crystal_maiden_0_cold", { iStackCount = #self:GetCaster().tThinker })
			break
		end
	end
end
function modifier_crystal_maiden_0:OnDestroy()
	if IsServer() then
		self:GetCaster().tThinker = nil
	end
end
function modifier_crystal_maiden_0:OnAbilityExecuted(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			local hParent = self:GetParent()
			local hAbility = params.ability
			if hAbility == nil or hAbility:IsItem() or hAbility:IsToggle() or not hAbility:ProcsMagicStick() then
				return
			end
			-- 删除旧的冰霜魔印
			if #self:GetCaster().tThinker >= self.max_count then
				self:GetCaster().tThinker[1]:RemoveModifierByName("modifier_crystal_maiden_0_thinker")
			end
			-- 尽量不重叠冰霜魔印
			local vPosition = hParent:GetAbsOrigin()
			if vPosition == self:GetCaster().tThinker[#self:GetCaster().tThinker] then
				vPosition = vPosition + RandomVector(self.radius)
			end
			for _, hThinker in ipairs(self:GetCaster().tThinker) do
				if (vPosition - hThinker:GetAbsOrigin()):Length2D() < self.radius * 2 then
					vPosition = hThinker:GetAbsOrigin() + (vPosition - hThinker:GetAbsOrigin()):Normalized() * self.radius * 2
				end
			end
			local hThinker = CreateModifierThinker(hParent, self:GetAbility(), "modifier_crystal_maiden_0_thinker", { duration = self.mark_duration }, GetGroundPosition(vPosition, hParent), hParent:GetTeamNumber(), false)
			table.insert(self:GetCaster().tThinker, hThinker)
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_crystal_maiden_0_buff : eom_modifier
modifier_crystal_maiden_0_buff = eom_modifier({
	Name = "modifier_crystal_maiden_0_buff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_crystal_maiden_0_buff:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_crystal_maiden_0_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL
	}
end
function modifier_crystal_maiden_0_buff:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = (self:GetCaster():GetScepterLevel() >= 3 and self:GetParent():IsFriendly(self:GetCaster())) and true or false,
	}
end
function modifier_crystal_maiden_0_buff:GetAbsoluteNoDamagePhysical()
	return 1
end
----------------------------------------Modifier----------------------------------------
---@class modifier_crystal_maiden_0_thinker : eom_modifier
modifier_crystal_maiden_0_thinker = eom_modifier({
	Name = "modifier_crystal_maiden_0_thinker",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
}, nil, ModifierThinker)

function modifier_crystal_maiden_0_thinker:GetAbilitySpecialValue()
	self.cold_radius = self:GetAbilitySpecialValueFor("cold_radius")
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
function modifier_crystal_maiden_0_thinker:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_crystal_maiden/crystal_maiden_0.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_crystal_maiden_0_thinker:OnDestroy()
	if IsServer() then
		ArrayRemove(self:GetCaster().tThinker, self:GetParent())
		if IsValid(self:GetParent()) then
			UTIL_Remove(self:GetParent())
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_crystal_maiden_0_debuff : eom_modifier
modifier_crystal_maiden_0_debuff = eom_modifier({
	Name = "modifier_crystal_maiden_0_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_crystal_maiden_0_debuff:GetAbilitySpecialValue()
	self.movespeed_reduce_pct = self:GetAbilitySpecialValueFor("movespeed_reduce_pct")
	self.scepter_freeze_duration = self:GetAbilitySpecialValueFor("scepter_freeze_duration")
end
function modifier_crystal_maiden_0_debuff:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
		if self:GetCaster():GetScepterLevel() >= 1 then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_crystal_maiden_0_freeze", { duration = self.scepter_freeze_duration })
		end
	end
end
function modifier_crystal_maiden_0_debuff:OnRefresh(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_crystal_maiden_0_debuff:OnIntervalThink()
	self:Destroy()
	return
end
function modifier_crystal_maiden_0_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end
function modifier_crystal_maiden_0_debuff:GetModifierMoveSpeedBonus_Percentage()
	if self:GetParent() ~= self:GetAbility():GetCaster() then
		return -self.movespeed_reduce_pct
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_crystal_maiden_0_cold : eom_modifier
modifier_crystal_maiden_0_cold = eom_modifier({
	Name = "modifier_crystal_maiden_0_cold",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_crystal_maiden_0_cold:OnCreated(params)
	if IsServer() then
		self:SetStackCount(params.iStackCount)
		self:StartIntervalThink(1)
	end
end
function modifier_crystal_maiden_0_cold:OnRefresh(params)
	if IsServer() then
		self:SetStackCount(params.iStackCount)
		self:StartIntervalThink(1)
	end
end
function modifier_crystal_maiden_0_cold:OnIntervalThink()
	self:Destroy()
	return
end
----------------------------------------Modifier----------------------------------------
---@class modifier_crystal_maiden_0_freeze : eom_modifier
modifier_crystal_maiden_0_freeze = eom_modifier({
	Name = "modifier_crystal_maiden_0_freeze",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_crystal_maiden_0_freeze:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end