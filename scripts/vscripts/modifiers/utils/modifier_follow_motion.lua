---@class 通用跟随某个东西位移 可以是弹道也可以是单位
modifier_follow_motion = eom_modifier({
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	Type = LUA_MODIFIER_MOTION_BOTH
})

local public = modifier_follow_motion

function public:OnCreated(params)
	if IsServer() then
		self.FOLLOW_TYPE = {
			FOLLOW_TYPE_PROJECTILE = 1,
			FOLLOW_TYPE_ENTITY = 1,
		}
	end
end
function public:FollowProjectile(tInfo)
	if IsServer() then
		self.iFollowType = self.FOLLOW_TYPE.FOLLOW_TYPE_PROJECTILE
		self.GetPosition = function(self)
			return ProjectileSystem:GetProjectilePosition(tInfo)
		end
		self.IsValid = function(self)
			return ProjectileSystem:IsValidProjectile(tInfo)
		end
		if not self:ApplyVerticalMotionController() or not self:ApplyHorizontalMotionController() then
			self:Destroy()
		end
	end
end
function public:FollowEntity(tEntity)
	if IsServer() then
		self.iFollowType = self.FOLLOW_TYPE.FOLLOW_TYPE_ENTITY
		self.GetPosition = function(self)
			return tEntity:GetAbsOrigin()
		end
		self.IsValid = function(self)
			return IsValid(tEntity)
		end
		if not self:ApplyVerticalMotionController() or not self:ApplyHorizontalMotionController() then
			self:Destroy()
		end
	end
end
function public:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:RemoveHorizontalMotionController(self)
		hParent:RemoveVerticalMotionController(self)
		if self.callback then
			self:callback()
		end
		if IsValid(self._hIntrinsicModifier) then
			self._hIntrinsicModifier:Destroy()
		end
	end
end
function public:OnHorizontalMotionInterrupted()
	self:Destroy()
end
function public:OnVerticalMotionInterrupted()
	self:Destroy()
end
function public:UpdateHorizontalMotion(hParent, dt)
	if self:IsValid() then
		hParent:SetAbsOrigin(self:GetPosition())
	else
		self:Destroy()
	end
end
function public:UpdateVerticalMotion(hParent, dt)
	if self:IsValid() then
		hParent:SetAbsOrigin(self:GetPosition())
	else
		self:Destroy()
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end