---@alias CustomEventName string | "'trigger_start_touch'" | "'trigger_end_touch'" | "'custom_npc_first_spawned'" | "'custom_trigger_event'" | "'custom_entity_removed'" | "'custom_round_state_change'" | "'custom_player_first_spawned'" | "'custom_player_reconnect'"
---当自定义攻击命中，远程攻击还会附带弹道索引
---@param params {unit:CDOTA_BaseNPC,iProjectileIndex:number,record:number}
---@return void
function CDOTA_Modifier_Lua:OnCustomAttack(params) end

---当自定义攻击命中，远程攻击还会附带弹道索引
---@param params {unit:CDOTA_BaseNPC,target:CDOTA_BaseNPC,iProjectileIndex:number,record:number}
---@return void
function CDOTA_Modifier_Lua:OnCustomAttackHit(params) end

---当攻击记录
---@param params {locket_amp_applied:boolean,new_pos:Vector,process_procs:boolean,order_type:number,octarine_tested:boolean,issuer_player_index:number,stout_tested:boolean,activity:number,target:CDOTA_BaseNPC,damage_category:number,reincarnate:boolean,ability_special_level:number,damage:number,ignore_invis:boolean,attacker:CDOTA_BaseNPC,ranged_attack:boolean,record:number,sange_amp_applied:boolean,do_not_consume:boolean,damage_type:number,heart_regen_applied:boolean,diffusal_applied:boolean,mkb_tested:boolean,distance:number,no_attack_cooldown:boolean,damage_flags:number,original_damage:number,cost:number,gain:number,basher_tested:boolean,fail_type:number}
---@return void
function CDOTA_Modifier_Lua:OnAttackRecord(params) end

---当攻击记录销毁
---@param params {locket_amp_applied:boolean,new_pos:Vector,process_procs:boolean,order_type:number,octarine_tested:boolean,issuer_player_index:number,stout_tested:boolean,activity:number,target:CDOTA_BaseNPC,damage_category:number,reincarnate:boolean,ability_special_level:number,damage:number,ignore_invis:boolean,attacker:CDOTA_BaseNPC,ranged_attack:boolean,record:number,sange_amp_applied:boolean,do_not_consume:boolean,damage_type:number,heart_regen_applied:boolean,diffusal_applied:boolean,mkb_tested:boolean,distance:number,no_attack_cooldown:boolean,damage_flags:number,original_damage:number,cost:number,gain:number,basher_tested:boolean,fail_type:number}
---@return void
function CDOTA_Modifier_Lua:OnAttackRecordDestroy(params) end

---当攻击命中
---@param params {locket_amp_applied:boolean,new_pos:Vector,process_procs:boolean,order_type:number,octarine_tested:boolean,issuer_player_index:number,stout_tested:boolean,activity:number,target:CDOTA_BaseNPC,damage_category:number,reincarnate:boolean,ability_special_level:number,damage:number,ignore_invis:boolean,attacker:CDOTA_BaseNPC,ranged_attack:boolean,record:number,sange_amp_applied:boolean,do_not_consume:boolean,damage_type:number,heart_regen_applied:boolean,diffusal_applied:boolean,mkb_tested:boolean,distance:number,no_attack_cooldown:boolean,damage_flags:number,original_damage:number,cost:number,gain:number,basher_tested:boolean,fail_type:number}
---@return void
function CDOTA_Modifier_Lua:OnAttackLanded(params) end

---当攻击伤害计算
---@param params {locket_amp_applied:boolean,new_pos:Vector,process_procs:boolean,order_type:number,octarine_tested:boolean,issuer_player_index:number,stout_tested:boolean,activity:number,target:CDOTA_BaseNPC,damage_category:number,reincarnate:boolean,ability_special_level:number,damage:number,ignore_invis:boolean,attacker:CDOTA_BaseNPC,ranged_attack:boolean,record:number,sange_amp_applied:boolean,do_not_consume:boolean,damage_type:number,heart_regen_applied:boolean,diffusal_applied:boolean,mkb_tested:boolean,distance:number,no_attack_cooldown:boolean,damage_flags:number,original_damage:number,cost:number,gain:number,basher_tested:boolean,fail_type:number}
---@return void
function CDOTA_Modifier_Lua:OnDamageCalculated(params) end

---当受到伤害
---@param params {locket_amp_applied:boolean,new_pos:Vector,process_procs:boolean,order_type:number,octarine_tested:boolean,issuer_player_index:number,stout_tested:boolean,activity:number,unit:CDOTA_BaseNPC,damage_category:number,reincarnate:boolean,ability_special_level:number,damage:number,ignore_invis:boolean,attacker:CDOTA_BaseNPC,ranged_attack:boolean,record:number,sange_amp_applied:boolean,do_not_consume:boolean,damage_type:number,heart_regen_applied:boolean,diffusal_applied:boolean,mkb_tested:boolean,distance:number,no_attack_cooldown:boolean,damage_flags:number,original_damage:number,cost:number,gain:number,basher_tested:boolean,fail_type:number}
---@return void
function CDOTA_Modifier_Lua:OnTakeDamage(params) end

---当冲锋开始
---@param params {event_name:number,unit:CDOTA_BaseNPC}
---@return void
function CDOTA_Modifier_Lua:OnDash(params) end

---当冲锋结束
---@param params {event_name:number,unit:CDOTA_BaseNPC}
---@return void
function CDOTA_Modifier_Lua:OnDashEnd(params) end

---当敌人出生
---@param params {event_name:number,unit:CDOTA_BaseNPC}
---@return void
function CDOTA_Modifier_Lua:OnEnemySpawn(params) end

---当章节小节开始
---@param params {event_name:number,level:number}
---@return void
function CDOTA_Modifier_Lua:OnChapterStart(params) end

---当章节小节结束
---@param params {event_name:number,level:number}
---@return void
function CDOTA_Modifier_Lua:OnChapterEnd(params) end

---当房间开始
---@param params {event_name:number,room:CMapRoom}
---@return void
function CDOTA_Modifier_Lua:OnRoomStart(params) end

---当房间结束
---@param params {event_name:number,room:CMapRoom}
---@return void
function CDOTA_Modifier_Lua:OnRoomEnd(params) end

---当有效技能施放
---@param params {new_pos:Vector,process_procs:boolean,order_type:number,distance:number,octarine_tested:boolean,issuer_player_index:number,stout_tested:boolean,locket_amp_applied:boolean,fail_type:number,damage_category:number,reincarnate:boolean,ability_special_level:number,damage:number,ignore_invis:boolean,ability:CDOTA_Ability_Lua,ranged_attack:boolean,record:number,unit:CDOTA_BaseNPC,do_not_consume:boolean,damage_type:number,cost:number,gain:number,diffusal_applied:boolean,mkb_tested:boolean,no_attack_cooldown:boolean,damage_flags:number,original_damage:number,heart_regen_applied:boolean,sange_amp_applied:boolean,basher_tested:boolean,activity:number}
---@return void
function CDOTA_Modifier_Lua:OnValidAbilityExecuted(params) end

---当有效技能施放
---@param params {new_pos:Vector,process_procs:boolean,order_type:number,distance:number,octarine_tested:boolean,issuer_player_index:number,stout_tested:boolean,locket_amp_applied:boolean,fail_type:number,damage_category:number,reincarnate:boolean,ability_special_level:number,damage:number,ignore_invis:boolean,ability:CDOTA_Ability_Lua,ranged_attack:boolean,record:number,unit:CDOTA_BaseNPC,do_not_consume:boolean,damage_type:number,cost:number,gain:number,diffusal_applied:boolean,mkb_tested:boolean,no_attack_cooldown:boolean,damage_flags:number,original_damage:number,heart_regen_applied:boolean,sange_amp_applied:boolean,basher_tested:boolean,activity:number}
---@return void
function CDOTA_Modifier_Lua:OnSpentMana(params) end

---物品栏变更时间
---@param params {event_name:number,unit:CDOTA_BaseNPC}
---@return void
function CDOTA_Modifier_Lua:OnInventoryContentsChanged(params) end

---敌人出生
---@param params {event_name:number,unit:CDOTA_BaseNPC}
---@return void
function CDOTA_Modifier_Lua:OnEnemySpawn(params) end

---重生
---@param params {active:number}
---@return void
function CDOTA_Modifier_Lua:EOM_ReincarnateTime(params) end

---每秒或每分钟触发的事件
---@param params {tick_time:number}
---@return void
function CDOTA_Modifier_Lua:OnTickTime(params) end

---技能能量点变更事件
---@param params {unit:CDOTA_BaseNPC,ability:CDOTA_Modifier_Lua,charge:number,old_charge:number}
---@return void
function CDOTA_Modifier_Lua:OnAbilityChargeChanged(params) end