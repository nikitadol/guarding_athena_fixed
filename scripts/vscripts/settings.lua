if Settings == nil then
	Settings = {}
end
local public = Settings

-- FORCE_HERO = "npc_dota_hero_phoenix"
MAX_HEALTH = 2 ^ 31 - 1 -- 最大血量
MAX_MANA = 2 ^ 16 - 1 -- 最大蓝量

CORRECT_GOLD = 50000
MAX_GOLD = 9999999
-- 初始金钱
STARTING_GOLD = 0

AI_TIMER_TICK_TIME = 0.25 -- AI的计时器间隔

-- 最大玩家数
MAX_PLAYERS = 4
-------------------------------------------------------
-- 服务器相关
-------------------------------------------------------
PLAYER_XP_PER_LEVEL = 10			-- 玩家每级经验
PET_XP_TABLE = { 0, 5, 15, 30, 50 }		-- 宠物经验表
SCORE_REWARD = { 2, 4, 6, 10, 16 }		-- 每个难度奖励积分
SHARD_REWARD = { 20, 40, 60, 100, 150 }	-- 每个难度奖励碎片
PETXP_REWARD = { 1, 2, 3, 5, 8 }			-- 每个难度奖励宠物经验
-------------------------------------------------------
-- 英雄属性相关
-------------------------------------------------------
-- 自定义英雄等级与经验
HERO_MAX_LEVEL = 500
HERO_XP_PER_LEVEL = 1000
HERO_XP_PER_REBORN = 200
HERO_XP_PER_LEVEL_TABLE = {}
for i = 1, HERO_MAX_LEVEL do
	HERO_XP_PER_LEVEL_TABLE[i] = (i - 1) * (HERO_XP_PER_LEVEL)
end
-- 稀有度颜色
RARITY_COLOR = {
	["n"] = Vector(210, 207, 208),
	["r"] = Vector(136, 179, 241),
	["sr"] = Vector(191, 172, 235),
	["ssr"] = Vector(255, 212, 165)
}

-- 护甲因子
ARMOR_FACTOR = 0.06

-- 攻击速度
MAXIMUM_ATTACK_SPEED = 700
MINIMUM_ATTACK_SPEED = 20

-- 技能吸血普通单位系数
SPELL_LIFESTEAL_CREATURE_FACTOR = 0.2

-- 属性效果
ATTRIBUTE_STRENGTH_ATTACK_DAMAGE = 2				-- 力量增加攻击力
ATTRIBUTE_STRENGTH_HP = 20							-- 力量增加生命值
ATTRIBUTE_STRENGTH_HP_REGEN = 0.16					-- 力量增加生命值
ATTRIBUTE_STRENGTH_DAMAGE_REDUCTION = 0.0005		-- 力量增加伤害减免
-- ATTRIBUTE_STRENGTH_ARMOR = 0.03					-- 力量增加防御
ATTRIBUTE_AGILITY_ATTACK_DAMAGE = 3					-- 敏捷增加攻击力
ATTRIBUTE_AGILITY_IGNORE_DAMAGE = 0.2				-- 敏捷增加伤害格挡
ATTRIBUTE_AGILITY_PHYSICAL_DAMAGE_PERCENT = 0.002	-- 敏捷增加物理伤害加成
-- ATTRIBUTE_AGILITY_ARMOR = 0.02					-- 敏捷增加防御
ATTRIBUTE_INTELLECT_ATTACK_DAMAGE = 1				-- 智力增加攻击力
ATTRIBUTE_INTELLECT_MANA_REGEN = 0.08				-- 每点智力提供魔法回复
ATTRIBUTE_INTELLECT_MANA = 12						-- 每点智力提供魔法
ATTRIBUTE_INTELLECT_MAGICAL_DAMAGE_PERCENT = 0.02	-- 每点智力提供魔法伤害加成

PLAYER_TEAM = DOTA_TEAM_GOODGUYS
ENEMY_TEAM = DOTA_TEAM_BADGUYS

-- 游戏开始时间
PRE_GAME_TIME = 180
-- 选择英雄时间
HERO_SELECTION_TIME = 30
-- 选择英雄时间
HERO_SELECTION_TIME = 30
-- 无敌冷却时间
GLYPH_COOLDOWN = 300
-- 雅典娜最大等级
ATHENA_MAX_LEVEL = 100
-- 雅典娜升级费用
ATHENA_UPGRADE_BASE_GOLD = 3000
ATHENA_UPGRADE_GOLD_PER_LEVEL = 300

DIFFICULTY_GOLD_TICK = {		-- 每秒金钱
	[1] = 9,
	[2] = 6,
	[3] = 3,
	[4] = 0,
	[5] = 0,
}
DIFFICULTY_INIT_GOLD = {		-- 初始金钱
	[1] = 300,
	[2] = 200,
	[3] = 100,
	[4] = 0,
	[5] = 0,
}

TRAINING_MAX_LEVEL = 4
TRAINER_AMOUNT = 10
TRAINER_UNIT_NAME = "practicer"
TRAINER_STATE = {
	{
		AttackDamage = 1,
		AttackRate = 0.5,
		CustomStatusHealth = 55,
		Armor = 10,
		BountyGold = 1,
		BountyXP = 35,
		Model = "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee.vmdl",
		ModelScale = 0.6,
	},
	{
		AttackDamage = 10,
		AttackRate = 0.5,
		CustomStatusHealth = 380,
		Armor = 50,
		BountyGold = 3,
		BountyXP = 35,
		Model = "models/creeps/lane_creeps/creep_radiant_melee/crystal_radiant_melee.vmdl",
		ModelScale = 0.7,
	},
	{
		AttackDamage = 130,
		AttackRate = 0.25,
		CustomStatusHealth = 4500,
		Armor = 150,
		BountyGold = 10,
		BountyXP = 40,
		Model = "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_crystal.vmdl",
		ModelScale = 0.8,
	},
	{
		AttackDamage = 2000,
		AttackRate = 0.25,
		CustomStatusHealth = 30000,
		Armor = 400,
		BountyGold = 18,
		BountyXP = 45,
		Model = "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_mega_crystal.vmdl",
		ModelScale = 0.9,
	},
}

-- 击杀获得荣耀
KILL_SCORE = 1

SETTING_EXTRA_HEALTH = 1 -- 额外生命值%
SETTING_EXTRA_ATTACK_DAMAGE = 2 -- 额外攻击力%
SETTING_DAMAGE_REDUCTION = 3 -- 额外减伤%
SETTING_EXTRA_ARMOR = 4 -- 额外护甲%

-- 根据难度影响敌人数据
DIFFICULTY_ALL_ENEMY_SETTINGS = {
	[1] = {
		[SETTING_EXTRA_HEALTH] = 40,
		[SETTING_EXTRA_ATTACK_DAMAGE] = 40,
		[SETTING_EXTRA_ARMOR] = 40,
	},
	[2] = {
		[SETTING_EXTRA_HEALTH] = 60,
		[SETTING_EXTRA_ATTACK_DAMAGE] = 60,
		[SETTING_EXTRA_ARMOR] = 60,
	},
	[3] = {
		[SETTING_EXTRA_HEALTH] = 80,
		[SETTING_EXTRA_ATTACK_DAMAGE] = 80,
		[SETTING_EXTRA_ARMOR] = 80,
	},
	[4] = {
		[SETTING_EXTRA_HEALTH] = 100,
		[SETTING_EXTRA_ATTACK_DAMAGE] = 100,
		[SETTING_EXTRA_ARMOR] = 100,
	},
	[5] = {
		[SETTING_EXTRA_HEALTH] = 120,
		[SETTING_EXTRA_ATTACK_DAMAGE] = 120,
		[SETTING_EXTRA_ARMOR] = 120,
	}
}
-- 根据玩家数量调整敌人数据
MULTIPLAYER_SPAWNER_ENEMY_SETTINGS = {
	[1] = {
		[SETTING_EXTRA_ATTACK_DAMAGE] = 0,
		[SETTING_DAMAGE_REDUCTION] = 0,
	},
	[2] = {
		[SETTING_EXTRA_ATTACK_DAMAGE] = 20,
		[SETTING_DAMAGE_REDUCTION] = 17,
	},
	[3] = {
		[SETTING_EXTRA_ATTACK_DAMAGE] = 44,
		[SETTING_DAMAGE_REDUCTION] = 30,
	},
	[4] = {
		[SETTING_EXTRA_ATTACK_DAMAGE] = 63,
		[SETTING_DAMAGE_REDUCTION] = 42,
	},
}
-- 根据难度影响进攻敌人数据，key代表难度，次表的key代表阶段波次，最终结果是将所有阶段波次小于当前波次对应的表里的值加法统计起来
DIFFICULTY_SPAWNER_ENEMY_SETTINGS = {
	[1] = {
		[0] = {
			[SETTING_EXTRA_HEALTH] = 0,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 0,
			[SETTING_EXTRA_ARMOR] = 0,
		},
		[10] = {
			[SETTING_EXTRA_HEALTH] = 0,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 0,
			[SETTING_EXTRA_ARMOR] = 0,
		},
		[20] = {
			[SETTING_EXTRA_HEALTH] = 0,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 0,
			[SETTING_EXTRA_ARMOR] = 0,
		},
		[30] = {
			[SETTING_EXTRA_HEALTH] = 0,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 0,
			[SETTING_EXTRA_ARMOR] = 0,
		},
	},
	[2] = {
		[0] = {
			[SETTING_EXTRA_HEALTH] = 5,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 5,
			[SETTING_EXTRA_ARMOR] = 0,
		},
		[10] = {
			[SETTING_EXTRA_HEALTH] = 5,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 5,
			[SETTING_EXTRA_ARMOR] = 5,
		},
		[20] = {
			[SETTING_EXTRA_HEALTH] = 0,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 0,
			[SETTING_EXTRA_ARMOR] = 5,
		},
		[30] = {
			[SETTING_EXTRA_HEALTH] = 5,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 5,
			[SETTING_EXTRA_ARMOR] = 0,
		},
	},
	[3] = {
		[0] = {
			[SETTING_EXTRA_HEALTH] = 5,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 5,
			[SETTING_EXTRA_ARMOR] = 0,
		},
		[10] = {
			[SETTING_EXTRA_HEALTH] = 5,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 5,
			[SETTING_EXTRA_ARMOR] = 5,
		},
		[20] = {
			[SETTING_EXTRA_HEALTH] = 0,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 0,
			[SETTING_EXTRA_ARMOR] = 5,
		},
		[30] = {
			[SETTING_EXTRA_HEALTH] = 5,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 5,
			[SETTING_EXTRA_ARMOR] = 0,
		},
	},
	[4] = {
		[0] = {
			[SETTING_EXTRA_HEALTH] = 10,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 10,
			[SETTING_EXTRA_ARMOR] = 0,
		},
		[10] = {
			[SETTING_EXTRA_HEALTH] = 5,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 5,
			[SETTING_EXTRA_ARMOR] = 10,
		},
		[20] = {
			[SETTING_EXTRA_HEALTH] = 5,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 5,
			[SETTING_EXTRA_ARMOR] = 5,
		},
		[30] = {
			[SETTING_EXTRA_HEALTH] = 5,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 5,
			[SETTING_EXTRA_ARMOR] = 5,
		},
	},
	[5] = {
		[0] = {
			[SETTING_EXTRA_HEALTH] = 150,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 150,
			[SETTING_EXTRA_ARMOR] = 50,
		},
		[10] = {
			[SETTING_EXTRA_HEALTH] = 100,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 100,
			[SETTING_EXTRA_ARMOR] = 30,
		},
		[20] = {
			[SETTING_EXTRA_HEALTH] = 100,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 100,
			[SETTING_EXTRA_ARMOR] = 20,
		},
		[30] = {
			[SETTING_EXTRA_HEALTH] = 50,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 50,
			[SETTING_EXTRA_ARMOR] = 40,
		},
	},
	[6] = {
		[0] = {
			[SETTING_EXTRA_HEALTH] = 250,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 250,
			[SETTING_EXTRA_ARMOR] = 100,
		},
		[10] = {
			[SETTING_EXTRA_HEALTH] = 0,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 0,
			[SETTING_EXTRA_ARMOR] = 0,
		},
		[20] = {
			[SETTING_EXTRA_HEALTH] = 100,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 100,
			[SETTING_EXTRA_ARMOR] = 0,
		},
		[30] = {
			[SETTING_EXTRA_HEALTH] = 200,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 200,
			[SETTING_EXTRA_ARMOR] = 40,
		},
	},
	[7] = {
		[0] = {
			[SETTING_EXTRA_HEALTH] = 400,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 400,
			[SETTING_EXTRA_ARMOR] = 100,
		},
		[10] = {
			[SETTING_EXTRA_HEALTH] = 100,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 100,
			[SETTING_EXTRA_ARMOR] = 50,
		},
		[20] = {
			[SETTING_EXTRA_HEALTH] = 150,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 150,
			[SETTING_EXTRA_ARMOR] = 0,
		},
		[30] = {
			[SETTING_EXTRA_HEALTH] = 130,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 130,
			[SETTING_EXTRA_ARMOR] = 50,
		},
	},
	[8] = {
		[0] = {
			[SETTING_EXTRA_HEALTH] = 1050,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 600,
			[SETTING_EXTRA_ARMOR] = 150,
		},
		[10] = {
			[SETTING_EXTRA_HEALTH] = 262.5,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 100,
			[SETTING_EXTRA_ARMOR] = 50,
		},
		[20] = {
			[SETTING_EXTRA_HEALTH] = 437.5,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 250,
			[SETTING_EXTRA_ARMOR] = 0,
		},
		[30] = {
			[SETTING_EXTRA_HEALTH] = 437.5,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 250,
			[SETTING_EXTRA_ARMOR] = 50,
		},
	},
	[9] = {
		[0] = {
			[SETTING_EXTRA_HEALTH] = 4675,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 2975,
			[SETTING_EXTRA_ARMOR] = 200,
		},
		[10] = {
			[SETTING_EXTRA_HEALTH] = 825,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 525,
			[SETTING_EXTRA_ARMOR] = 50,
		},
		[20] = {
			[SETTING_EXTRA_HEALTH] = 1375,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 875,
			[SETTING_EXTRA_ARMOR] = 50,
		},
		[30] = {
			[SETTING_EXTRA_HEALTH] = 1375,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 875,
			[SETTING_EXTRA_ARMOR] = 0,
		},
	},
	[10] = {
		[0] = {
			[SETTING_EXTRA_HEALTH] = 13500,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 10800,
			[SETTING_EXTRA_ARMOR] = 300,
		},
		[10] = {
			[SETTING_EXTRA_HEALTH] = 3750,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 10800,
			[SETTING_EXTRA_ARMOR] = 75,
		},
		[20] = {
			[SETTING_EXTRA_HEALTH] = 3750,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 10800,
			[SETTING_EXTRA_ARMOR] = 75,
		},
		[30] = {
			[SETTING_EXTRA_HEALTH] = 4500,
			[SETTING_EXTRA_ATTACK_DAMAGE] = 3600,
			[SETTING_EXTRA_ARMOR] = 150,
		},
	},
}

function public:init(bReload)
	local GameMode = GameRules:GetGameModeEntity()
	if not bReload then
		GameMode:SetFogOfWarDisabled(true)
		GameMode:SetUnseenFogOfWarEnabled(false)
	end

	GameRules:SetHeroRespawnEnabled(true)
	GameMode:SetFixedRespawnTime(5)

	GameRules:SetCustomGameAllowBattleMusic(false)
	GameRules:SetCustomGameAllowHeroPickMusic(false)
	GameRules:SetCustomGameAllowMusicAtGameStart(true)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, MAX_PLAYERS)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)
	GameRules:SetFirstBloodActive(false)
	GameRules:SetGoldPerTick(0)
	GameRules:SetGoldTickTime(99999)
	GameRules:SetHeroSelectionTime(99999)
	GameRules:SetHeroSelectPenaltyTime(0)
	GameRules:SetHideKillMessageHeaders(true)
	GameRules:SetPostGameTime(3000)
	GameRules:SetPreGameTime(5)
	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetShowcaseTime(0)
	GameRules:SetStartingGold(STARTING_GOLD)
	GameRules:SetStrategyTime(0)
	GameRules:SetTimeOfDay(0.26)
	GameRules:SetUseBaseGoldBountyOnHeroes(false)
	GameRules:SetUseCustomHeroXPValues(true)
	GameMode:DisableHudFlip(true)
	GameMode:SetAlwaysShowPlayerNames(true)
	GameMode:SetAnnouncerDisabled(true)
	GameMode:SetCameraZRange(0, 4000)
	GameMode:SetCustomBackpackCooldownPercent(1)
	GameMode:SetCustomBackpackSwapCooldown(0)
	GameMode:SetCustomBuybackCooldownEnabled(true)
	GameMode:SetCustomBuybackCostEnabled(true)
	GameMode:SetBuybackEnabled(true)
	-- GameMode:SetCustomGameForceHero("npc_dota_hero_phantom_assassin")
	GameMode:SetUseCustomHeroLevels(true)
	GameMode:SetCustomHeroMaxLevel(HERO_MAX_LEVEL)
	GameMode:SetCustomXPRequiredToReachNextLevel(HERO_XP_PER_LEVEL_TABLE)
	GameMode:SetDaynightCycleDisabled(false)
	GameMode:SetDeathOverlayDisabled(true)
	GameMode:SetGoldSoundDisabled(false)
	-- GameMode:SetSendToStashEnabled(false)
	-- GameMode:SetStashPurchasingDisabled(true)
	GameMode:SetCanSellAnywhere(true)

	GameMode:SetHudCombatEventsDisabled(true)
	GameMode:SetKillingSpreeAnnouncerDisabled(true)
	GameMode:SetLoseGoldOnDeath(false)
	GameMode:SetMaximumAttackSpeed(MAXIMUM_ATTACK_SPEED)
	GameMode:SetMinimumAttackSpeed(MINIMUM_ATTACK_SPEED)
	GameMode:SetPauseEnabled(true)
	GameMode:SetRecommendedItemsDisabled(true)
	GameMode:SetSelectionGoldPenaltyEnabled(false)
	-- GameMode:SetStashPurchasingDisabled(true)
	GameMode:SetStickyItemDisabled(true)
	GameMode:SetTPScrollSlotItemOverride("item_back")
	GameMode:SetGiveFreeTPOnDeath(false)
	GameMode:SetWeatherEffectsDisabled(true)
	-- GameMode:SetAllowEconItemHUDSkins(false)
	-- GameMode:SetCameraDistanceOverride(1134)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_DAMAGE, 0)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP, 0)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP_REGEN, 0)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_DAMAGE, 0)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ARMOR, 0)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED, 0)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_DAMAGE, 0)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA, 0)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN, 0)

	if not IsInToolsMode() then
		GameRules:SetCustomGameSetupAutoLaunchDelay(3)
		GameRules:LockCustomGameSetupTeamAssignment(false)
		GameRules:EnableCustomGameSetupAutoLaunch(false)
	else
		GameRules:SetCustomGameSetupAutoLaunchDelay(0)
		GameRules:LockCustomGameSetupTeamAssignment(true)
		GameRules:EnableCustomGameSetupAutoLaunch(true)
	end
	GameMode:SetBuybackEnabled(false)
	GameRules:SetUseUniversalShopMode(true)

	CustomNetTables:SetTableValue("common", "settings", {
		is_local_host = not IsDedicatedServer(),
		is_in_tools_mode = IsInToolsMode(),
		is_cheat_mode = GameRules:IsCheatMode(),
		HERO_MAX_LEVEL = HERO_MAX_LEVEL,
		HERO_XP_PER_LEVEL_TABLE = HERO_XP_PER_LEVEL_TABLE,
	})

	SendToServerConsole("dota_max_physical_items_purchase_limit 99999")
end

return public