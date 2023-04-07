---@class privilege_25 : PrivilegeBaseClass 开局解锁觉醒功能
privilege_25 = class({}, nil, PrivilegeBaseClass)

local public = privilege_25

function public:OnCreated(params)
	local hCaster = self:GetCaster()
	local iPlayerID = self:GetPlayerID()
	local hChallenge = EntIndexToHScript(Training.tPlayerTraining[iPlayerID].iChallengeEntIndex or -1)
	if IsValid(hChallenge) then
		local sDialogEventName = "awakening"
		if not NPC:HasDialogEvent(hChallenge, sDialogEventName) and not hCaster:IsAwakened() then
			NPC:AddDialogEvent(hChallenge, sDialogEventName)
		end
	end
end
function public:OnRefresh(params)

end
function public:OnDestroy()
	local hCaster = self:GetCaster()
	local iPlayerID = self:GetPlayerID()
	local hChallenge = EntIndexToHScript(Training.tPlayerTraining[iPlayerID].iChallengeEntIndex or -1)
	if IsValid(hChallenge) then
		local sDialogEventName = "awakening"
		if NPC:HasDialogEvent(hChallenge, sDialogEventName) and hCaster:GetLevel() < 100 then
			NPC:RemoveDialogEvent(hChallenge, sDialogEventName)
		end
	end
end

return public