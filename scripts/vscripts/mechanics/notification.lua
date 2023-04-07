if Notification == nil then
	---通知系统模块
	---@module Notification
	Notification = class({})
end
local public = Notification

function public:init(bReload)
	if not bReload then
		self.tPlayersChatLineCount = {}
		for i = 0, DOTA_MAX_PLAYERS do
			self.tPlayersChatLineCount[i] = 2
		end
	end

	self:UpdateNetTables()
end
function public:UpdateNetTables()
end
--[[	表填写内如
	{
		message -> 必填，词条名称
		player_id -> 选填，会将词条内的{s:player_name}替换为此玩家ID的玩家名字以及玩家头像
		player_id2 -> 选填，会将词条内的{s:player_name2}替换为此玩家ID的玩家名字以及玩家头像
		teamnumber -> 选填，将会根据本地玩家与队伍的关系改变颜色
		int_* -> 整数类型，"*"为任意名字，会将词条内的{d:int_*}替换为该数值
		b_int_* -> 整数类型，"*"为任意名字，会将词条内的{s:b_int_*}替换为该数值，并且当数字过大的时候会根据数字大小自动转换成xxx百万这样的格式
		string_* -> 字符串类型，"*"为任意名字，会将词条内的{s:string_*}替换为该数值
			如果字符串内带有"itemname"的话，将视为一个物品，将会自动处理名字词条
			("DOTA_Tooltip_Ability_*")并且显示物品图标，只需要填写物品的名字即
			可，不需要填写完整的物品名字词条。如果不需要显示物品图标的话，字符串
			内不能带有"itemname"，并且参数需要填写完整的物品词条("DOTA_Tooltip
			_Ability_*")
		team_only -> 选填，默认false
	}
]]
--
function public:Upper(tParams)
	CustomGameEventManager:Send_ServerToAllClients("notification_upper", tParams)
end

function public:Combat(tParams)
	CustomGameEventManager:Send_ServerToAllClients("notification_combat", tParams)
end

function public:CombatToPlayer(iPlayerID, tParams)
	local hPlayer = PlayerResource:GetPlayer(iPlayerID)
	if hPlayer then
		CustomGameEventManager:Send_ServerToPlayer(hPlayer, "notification_combat", tParams)
	end
end

function public:ChatLine(tParams)
	local iPlayerID = tParams.player_id
	if iPlayerID ~= nil and iPlayerID ~= -1 then
		if self.tPlayersChatLineCount[iPlayerID] > 0 then
			self.tPlayersChatLineCount[iPlayerID] = self.tPlayersChatLineCount[iPlayerID] - 1
			GameRules:GetGameModeEntity():Timer(2, function()
				self.tPlayersChatLineCount[iPlayerID] = self.tPlayersChatLineCount[iPlayerID] + 1
			end)

			CustomGameEventManager:Send_ServerToAllClients("notification_chat_line", tParams)
		end
	end
end

---@class HelpContent
---@field sText string 文本
---@field tAbilities string[]|nil 技能名列表
---@field tItems string[]|nil 物品名列表
---@field tImages string[]|nil 图片路径列表
---@field sPanoramaClass string[]|nil 顶层添加的样式
---@field flDuration number|nil 可选对话显示持续时间，默认5秒
---@field sPanelID string|nil 面板ID，重复ID会覆盖
---@field sBindPanelID string|nil 绑定的面板ID，不填就是绝对位置
---@field sPosition string|nil 出现的绝对位置比如：135,224TODO:填百分比等功能
---@field sDirection string|nil 出现的位置比如：left，默认为top

---显示一个帮助信息在任意位置或者面板上
---@param iPlayerID number 玩家ID
---@param tContent HelpContent 内容
function public:HelpTip(iPlayerID, tContent)
	local hPlayer = PlayerResource:GetPlayer(iPlayerID)
	tContent.flDuration = tContent.flDuration or 5
	tContent.sDirection = tContent.sDirection or "top"
	if hPlayer then
		CustomGameEventManager:Send_ServerToPlayer(hPlayer, "notification_help", tContent)
	end
end

---关闭指定ID帮助信息面板
---@param iPlayerID number 玩家ID
---@param sPanelID string|nil 面板ID，重复ID会覆盖
function public:CloseHelpTip(iPlayerID, sPanelID)
	if sPanelID then
		local hPlayer = PlayerResource:GetPlayer(iPlayerID)
		CustomGameEventManager:Send_ServerToPlayer(hPlayer, "notification_close_help", { sPanelID = sPanelID })
	end
end

--[[	各个UI事件
]]
--
--[[	监听
]]
--
return public