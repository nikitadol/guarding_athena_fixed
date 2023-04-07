if Mechanics == nil then
	Mechanics = class({})
end
local public = Mechanics

local classes = {
	require("class/round"),
	require("class/spawner"),
	require("class/pet"),
}

local mechanics = {
	require("mechanics/asset_modifiers"),
	require("mechanics/demo"),
	require("mechanics/ability_upgrades"),
	require("mechanics/notification"),
	-- require("mechanics/chapter"),
	require("mechanics/projectile_system"),
	-- require("mechanics/passive_ability"),
	-- require("mechanics/keyboard_control"),
	-- require("mechanics/faith"),
	-- require("mechanics/buff_manager"),
	require("mechanics/player_data"),
	require("mechanics/rounds"),
	require("mechanics/npc"),
	require("mechanics/training"),
	require("mechanics/items"),
	require("mechanics/neutral_spawners"),
	require("mechanics/task"),
	require("mechanics/selection"),
	require("mechanics/privilege"),
	require("mechanics/special_spawner"),
-- require("mechanics/hercules"),
}

function public:init(bReload)
	-- 初始化类
	for k, v in pairs(classes) do
		if v ~= nil and type(v) == "table" then
			_G[k] = v
			if v.init ~= nil then
				v.init(bReload)
			end
		end
	end

	-- 初始化系统
	for k, v in pairs(mechanics) do
		if v ~= nil and type(v) == "table" then
			_G[k] = v
			if v.init ~= nil then
				v:init(bReload)
			end
		end
	end
end

return public