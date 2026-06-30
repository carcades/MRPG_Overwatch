#!mainFile "../main.opy"

def add_buff():
    @Name "Sub: Add buff to player"
    logToInspector("LIFECYCLE: add_buff called. Args: {0}".format(eventPlayer.buff_append_args))
    eventPlayer.active_buff_ids.append(eventPlayer.buff_append_args[0])
    eventPlayer.active_buff_targets.append(eventPlayer.buff_append_args[1])
    eventPlayer.active_buff_expire_times.append(eventPlayer.buff_append_args[2])
    eventPlayer.active_buff_types.append(eventPlayer.buff_append_args[3])
    eventPlayer.active_buff_actions.append(eventPlayer.buff_append_args[4])
    eventPlayer.active_buff_values.append(eventPlayer.buff_append_args[5])
    if eventPlayer.buff_append_args[3] >= EffectType.SPEED:
        if eventPlayer.buff_append_args[4] == EffectAction.SUBTRACT:
            eventPlayer.mod_stats[eventPlayer.buff_append_args[3]] += eventPlayer.buff_append_args[5]
            eventPlayer.apply_all_stats()
    logToInspector("LIFECYCLE: active_buffs count after add: {0}".format(len(eventPlayer.active_buff_ids)))


def extend_buff():
    @Name "Sub: Extend buffs by array of IDs"
    logToInspector("LIFECYCLE: extend_buff called for IDs: {0}".format(eventPlayer.buff_append_args[0]))
    eventPlayer.temp_var_1 = -1
    eventPlayer.temp_var_2 = 0
    while eventPlayer.temp_var_2 < len(eventPlayer.active_buff_ids):
        if eventPlayer.active_buff_ids[eventPlayer.temp_var_2] in eventPlayer.buff_append_args[0]:
            eventPlayer.temp_var_1 = eventPlayer.temp_var_2
            eventPlayer.active_buff_expire_times[eventPlayer.temp_var_1] = eventPlayer.buff_append_args[1]
            logToInspector("LIFECYCLE: Extended buff ID {0} at index {1}. New exp: {2}".format(eventPlayer.active_buff_ids[eventPlayer.temp_var_1], eventPlayer.temp_var_1, eventPlayer.buff_append_args[1]))
        eventPlayer.temp_var_2++
        wait(0.016)
        
    eventPlayer.temp_var_2 = 0
    while eventPlayer.temp_var_2 < len(eventPlayer.hud_buff_ids):
        if eventPlayer.hud_buff_ids[eventPlayer.temp_var_2] in eventPlayer.buff_append_args[0]:
            eventPlayer.hud_buff_expires[eventPlayer.temp_var_2] = eventPlayer.buff_append_args[1]
        eventPlayer.temp_var_2++
        wait(0.016)
        
    if eventPlayer.temp_var_1 == -1:
        logToInspector("LIFECYCLE: No buffs found from requested IDs.")


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
                if eventPlayer.active_buff_actions[eventPlayer.index_of_etbda_object] == EffectAction.SUBTRACT:
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
            logToInspector("LIFECYCLE: active_buffs count is now: {0}".format(len(eventPlayer.active_buff_ids)))
            eventPlayer.index_of_etbda_object--
        eventPlayer.index_of_etbda_object++
        wait(0.016)
    wait(0.2)
    if ruleCondition:
        loop()


def add_hud_buff():
    @Name "Sub: Add HUD buff to player"
    eventPlayer.buff_append_args[0].hud_buff_expires.append(eventPlayer.buff_append_args[1])
    eventPlayer.buff_append_args[0].hud_buff_names.append(eventPlayer.buff_append_args[2])
    eventPlayer.buff_append_args[0].hud_buff_colors.append(eventPlayer.buff_append_args[3])
    eventPlayer.buff_append_args[0].hud_buff_ids.append(eventPlayer.buff_append_args[4])


rule "Process HUD buffs":
    @Event eachPlayer
    @Condition len(eventPlayer.hud_buff_names) >= 1
    
    eventPlayer.temp_var_1 = 0
    while eventPlayer.temp_var_1 < len(eventPlayer.hud_buff_names):
        if getTotalTimeElapsed() >= eventPlayer.hud_buff_expires[eventPlayer.temp_var_1]:
            del eventPlayer.hud_buff_names[eventPlayer.temp_var_1]
            del eventPlayer.hud_buff_colors[eventPlayer.temp_var_1]
            del eventPlayer.hud_buff_expires[eventPlayer.temp_var_1]
            del eventPlayer.hud_buff_ids[eventPlayer.temp_var_1]
            eventPlayer.temp_var_1--
        eventPlayer.temp_var_1++
        wait(0.016)
    wait(0.2)
    if ruleCondition:
        loop()
