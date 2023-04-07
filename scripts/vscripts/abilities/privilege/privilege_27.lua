---@class privilege_27 : PrivilegeBaseClass 将军令
privilege_27 = class({}, nil, PrivilegeBaseClass)

local public = privilege_27

function public:OnCreated(params)
	local iPlayerID = self:GetPlayerID()
	local tPlayerTraining = Training.tPlayerTraining[iPlayerID]
	local n = Game:GetNthByPlayerID(iPlayerID)
	if n >= 1 and n <= #TRAINING_ORIGIN then
		local vPosition = TRAINING_ORIGIN[n]
		-- 抽奖NPC
		local hDraw = EntIndexToHScript(tPlayerTraining.iDrawEntIndex or -1)
		if not IsValid(hDraw) then
			local vOffset = Vector(768, 384, 0)
			hDraw = NPC:CreateNPC("npc_draw", vPosition + vOffset, iPlayerID)
			hDraw:SetForwardVector(-vOffset:Normalized())
			tPlayerTraining.iDrawEntIndex = IsValid(hDraw) and hDraw:entindex() or -1
		end
		-- 锁妖塔NPC
		local hDungeon = EntIndexToHScript(tPlayerTraining.iDungeonEntIndex or -1)
		if not IsValid(hDungeon) then
			local vOffset = Vector(-768, -384, 0)
			hDungeon = NPC:CreateNPC("npc_dungeon", vPosition + vOffset, iPlayerID)
			hDungeon:SetForwardVector(-vOffset:Normalized())
			tPlayerTraining.iDungeonEntIndex = IsValid(hDungeon) and hDungeon:entindex() or -1
		end
		-- 杀敌兑换NPC
		local hExchanger = EntIndexToHScript(tPlayerTraining.iExchangerEntIndex or -1)
		if not IsValid(hExchanger) then
			local vOffset = Vector(768, -384, 0)
			hExchanger = NPC:CreateNPC("npc_exchange", vPosition + vOffset, iPlayerID)
			hExchanger:SetForwardVector(-vOffset:Normalized())
			tPlayerTraining.iExchangerEntIndex = IsValid(hExchanger) and hExchanger:entindex() or -1
		end
		Training:UpdateNetTables(iPlayerID)
	end
end
function public:OnRefresh(params)

end
function public:OnDestroy()

end

return public