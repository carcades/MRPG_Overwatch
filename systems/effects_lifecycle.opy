#!mainFile "../main.opy"

rule "Checking effects to be destroyed":
    @Condition len(effects_to_be_destroyed_array) >= 1
    @Disabled
    
    effects_to_be_destroyed_temp_arr = effects_to_be_destroyed_array
    #checking effects array
    for effects_array_index in range(len(effects_to_be_destroyed_array)):
        #smallMessage(getAllPlayers(), "{0} | {1}".format(len(effects_to_be_destroyed_array[effects_array_index]), effects_to_be_destroyed_array[effects_array_index][EffectEntry.EXPIRE_TIME]))
        #if total time >= effect time + total time (when effect created) : destroy effect
        if getTotalTimeElapsed() >= effects_to_be_destroyed_array[effects_array_index][EffectEntry.EXPIRE_TIME]:
            smallMessage(getAllPlayers(), "1")
            #if object == visual/audio effect
            if effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == "entity":
                #destroy effect from world
                destroyEffect(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET])
            elif effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == "health_bar":
                #destroy effect from world
                removeHealthPool(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET])
            #if object == temporary stat effect
            elif effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == "speed":
                if effects_to_be_destroyed_array[effects_array_index][EffectEntry.ACTION] == "subtract":
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_speed -= effects_to_be_destroyed_array[effects_array_index][EffectEntry.VALUE]
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].setMoveSpeed(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_speed)
            elif effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == "damage":
                if effects_to_be_destroyed_array[effects_array_index][EffectEntry.ACTION] == "subtract":
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_damage -= effects_to_be_destroyed_array[effects_array_index][EffectEntry.VALUE]
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].setMoveSpeed(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_damage)
            elif effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == "health":
                if effects_to_be_destroyed_array[effects_array_index][EffectEntry.ACTION] == "subtract":
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_health -= effects_to_be_destroyed_array[effects_array_index][EffectEntry.VALUE]
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].setMoveSpeed(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_health)
            #delete effect from array
            eff_arr_current_deleted_element = effects_to_be_destroyed_array[effects_array_index]
            effects_to_be_destroyed_temp_arr = effects_to_be_destroyed_temp_arr.filter(lambda x: x != eff_arr_current_deleted_element)
        wait(1)
    effects_to_be_destroyed_array = effects_to_be_destroyed_temp_arr
    if ruleCondition:
        loop()


def append_to_del_effects_array():
    @Name "Sub: Append effect to array"
    
    if len(effects_to_be_destroyed_array) == 0:
        effects_to_be_destroyed_array = [effects_array_append_args]
        #effects_to_be_destroyed_temp_arr = [effects_array_append_args]
    else:
        effects_to_be_destroyed_array.append([effects_array_append_args])
        #effects_to_be_destroyed_temp_arr.append([effects_array_append_args])


rule "Checking effects to be destroyed":
    @Condition len(effects_to_be_destroyed_array) >= 1
    
    effects_array_index = 0
    #checking effects array
    while effects_array_index < len(effects_to_be_destroyed_array):
        #if total time >= effect time + total time (when effect created) : destroy effect
        if getTotalTimeElapsed() >= effects_to_be_destroyed_array[effects_array_index][EffectEntry.EXPIRE_TIME]:
            #smallMessage(getAllPlayers(), "1")
            #if object == visual/audio effect
            if effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == "entity":
                #destroy effect from world
                destroyEffect(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET])
            elif effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == "heal_over_time":
                #smallMessage(getAllPlayers(), "heal over time")
                #destroy effect from world
                stopHealingOverTime(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET])
            elif effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == "health_bar":
                #destroy effect from world
                removeHealthPool(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET])
            elif effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == "player_variable":
                if effects_to_be_destroyed_array[effects_array_index][EffectEntry.ACTION] == "existence_prayer_of_salvation":
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].prayerIsActive = false
                    #smallMessage(getAllPlayers(), "prayer inactive")
            #if object == temporary stat effect
            elif effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == "speed":
                if effects_to_be_destroyed_array[effects_array_index][EffectEntry.ACTION] == "subtract":
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_speed -= effects_to_be_destroyed_array[effects_array_index][EffectEntry.VALUE]
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].setMoveSpeed(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_speed)
            elif effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == "damage":
                if effects_to_be_destroyed_array[effects_array_index][EffectEntry.ACTION] == "subtract":
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_damage -= effects_to_be_destroyed_array[effects_array_index][EffectEntry.VALUE]
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].setDamageDealt(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_damage)
            elif effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == "health":
                if effects_to_be_destroyed_array[effects_array_index][EffectEntry.ACTION] == "subtract":
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_health -= effects_to_be_destroyed_array[effects_array_index][EffectEntry.VALUE]
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].setMaxHealth(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_health)
            #delete effect from array
            del effects_to_be_destroyed_array[effects_array_index]
            effects_array_index--
        effects_array_index++
    wait(0.2)
    if ruleCondition:
        loop()
