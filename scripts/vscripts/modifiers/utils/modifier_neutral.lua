---@class modifier_neutral:eom_modifier
modifier_neutral = eom_modifier({
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	RemoveOnDeath = false
})

local public = modifier_neutral
function public:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
function public:OnCreated(params)
	if IsServer() then
		if self:GetParent():HasMovementCapability() then
			self.vCamp = self:GetParent():GetAbsOrigin()
			self:StartIntervalThink(0.1)
		end
	end
end
function public:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		if not HasFear(hParent) then
			if hParent:GetAggroTarget() then
				if (hParent:GetAbsOrigin() - self.vCamp):Length2D() > 400 then
					if self.timer == nil then
						self.timer = hParent:GameTimer("return_camp", 5, function()
							ExecuteOrder(hParent, DOTA_UNIT_ORDER_MOVE_TO_POSITION, self.vCamp)
							self.timer = nil
						end)
					end
				else
					if self.timer then
						hParent:StopTimer(self.timer)
						self.timer = nil
					end
				end
			elseif hParent:GetAbsOrigin() ~= self.vCamp then
				local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, GetAttackRange(hParent), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				if #tTargets == 0 then
					ExecuteOrder(hParent, DOTA_UNIT_ORDER_MOVE_TO_POSITION, self.vCamp)
				else
					ExecuteOrder(hParent, DOTA_UNIT_ORDER_ATTACK_MOVE, hParent:GetAbsOrigin())
				end
			end
		end
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = false
	}
end
function public:ECheckState()
	return {
		[EOM_MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
end