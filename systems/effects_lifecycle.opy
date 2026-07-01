#!mainFile "../main.opy"

# NOTE: низкоуровневые подпрограммы add_buff / extend_buff / add_hud_buff удалены.
# Вся регистрация баффов проходит через макросы trackBuff / applyVisibleDebuff /
# extendBuff / extendBuffAll в settings/array_schemas.opy (работают на любой цели,
# атомарны, без wait-циклов). Старые def-ы использовали temp_var_1/2 и могли
# гоняться с другими suspendable-циклами (см. CODESTYLE §6.9).


rule "Process player buffs":
    @Event eachPlayer
    @Condition len(eventPlayer.active_buff_ids) >= 1
    
    #using index_of_etbda_object as loop counter to avoid conflicts with temp_var used by abilities
    eventPlayer.index_of_etbda_object = 0
    while eventPlayer.index_of_etbda_object < len(eventPlayer.active_buff_ids):
        #if total time >= effect expire time : destroy effect
        if getTotalTimeElapsed() >= eventPlayer.active_buff_expire_times[eventPlayer.index_of_etbda_object]:
            logToInspector("LIFECYCLE: Expiring buff at index {0} with id {1}".format(eventPlayer.index_of_etbda_object, eventPlayer.active_buff_ids[eventPlayer.index_of_etbda_object]))
            #if object == visual/audio effect
            if eventPlayer.active_buff_types[eventPlayer.index_of_etbda_object] == EffectType.ENTITY:
                logToInspector("LIFECYCLE: Destroying ENTITY target: {0}".format(eventPlayer.active_buff_targets[eventPlayer.index_of_etbda_object]))
                destroyEffect(eventPlayer.active_buff_targets[eventPlayer.index_of_etbda_object])
            elif eventPlayer.active_buff_types[eventPlayer.index_of_etbda_object] == EffectType.HEAL_OVER_TIME:
                logToInspector("LIFECYCLE: Stopping HEAL_OVER_TIME target: {0}".format(eventPlayer.active_buff_targets[eventPlayer.index_of_etbda_object]))
                stopHealingOverTime(eventPlayer.active_buff_targets[eventPlayer.index_of_etbda_object])
            elif eventPlayer.active_buff_types[eventPlayer.index_of_etbda_object] == EffectType.HEALTH_BAR:
                logToInspector("LIFECYCLE: Removing HEALTH_BAR target: {0}".format(eventPlayer.active_buff_targets[eventPlayer.index_of_etbda_object]))
                removeHealthPool(eventPlayer.active_buff_targets[eventPlayer.index_of_etbda_object])
            elif eventPlayer.active_buff_types[eventPlayer.index_of_etbda_object] == EffectType.PLAYER_VARIABLE:
                if eventPlayer.active_buff_actions[eventPlayer.index_of_etbda_object] == EffectAction.EXISTENCE_PRAYER_OF_SALVATION:
                    logToInspector("LIFECYCLE: Removing EXISTENCE_PRAYER_OF_SALVATION flag")
                    eventPlayer.prayerIsActive = false
                    eventPlayer.salvationStacks = 0
                elif eventPlayer.active_buff_actions[eventPlayer.index_of_etbda_object] == EffectAction.EXISTENCE_PRAYER_OF_COURAGE:
                    logToInspector("LIFECYCLE: Removing EXISTENCE_PRAYER_OF_COURAGE flag")
                    eventPlayer.courageIsActive = false
                    eventPlayer.courageStacks = 0
            elif eventPlayer.active_buff_types[eventPlayer.index_of_etbda_object] >= EffectType.SPEED:
                logToInspector("LIFECYCLE: Reverting STAT change")
                eventPlayer.mod_stats[eventPlayer.active_buff_types[eventPlayer.index_of_etbda_object]] -= eventPlayer.active_buff_values[eventPlayer.index_of_etbda_object]
                eventPlayer.apply_all_stats()
            #delete expired buff from array
            logToInspector("LIFECYCLE: Deleting from active_buffs index {0}".format(eventPlayer.index_of_etbda_object))
            del eventPlayer.active_buff_ids[eventPlayer.index_of_etbda_object]
            del eventPlayer.active_buff_targets[eventPlayer.index_of_etbda_object]
            del eventPlayer.active_buff_expire_times[eventPlayer.index_of_etbda_object]
            del eventPlayer.active_buff_types[eventPlayer.index_of_etbda_object]
            del eventPlayer.active_buff_actions[eventPlayer.index_of_etbda_object]
            del eventPlayer.active_buff_values[eventPlayer.index_of_etbda_object]
            del eventPlayer.active_buff_sources[eventPlayer.index_of_etbda_object]
            del eventPlayer.active_buff_flags[eventPlayer.index_of_etbda_object]
            logToInspector("LIFECYCLE: active_buffs count is now: {0}".format(len(eventPlayer.active_buff_ids)))
            eventPlayer.index_of_etbda_object--
        eventPlayer.index_of_etbda_object++
        wait(0.016)
    wait(0.2)
    if ruleCondition:
        loop()


rule "Process HUD buffs":
    @Event eachPlayer
    @Condition len(eventPlayer.hud_buff_names) >= 1
    
    eventPlayer.hud_loop_iter = 0
    while eventPlayer.hud_loop_iter < len(eventPlayer.hud_buff_names):
        if getTotalTimeElapsed() >= eventPlayer.hud_buff_expires[eventPlayer.hud_loop_iter]:
            del eventPlayer.hud_buff_names[eventPlayer.hud_loop_iter]
            del eventPlayer.hud_buff_colors[eventPlayer.hud_loop_iter]
            del eventPlayer.hud_buff_expires[eventPlayer.hud_loop_iter]
            del eventPlayer.hud_buff_ids[eventPlayer.hud_loop_iter]
            del eventPlayer.hud_buff_sources[eventPlayer.hud_loop_iter]
            del eventPlayer.hud_buff_flags[eventPlayer.hud_loop_iter]
            eventPlayer.hud_loop_iter--
        eventPlayer.hud_loop_iter++
        wait(0.016)
    wait(0.2)
    if ruleCondition:
        loop()
