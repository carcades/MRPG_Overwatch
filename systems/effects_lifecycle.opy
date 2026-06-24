#!mainFile "../main.opy"

def append_to_del_effects_array():
    @Name "Sub: Append effect to array"
    
    if len(effects_to_be_destroyed_array) == 0:
        effects_to_be_destroyed_array = [effects_array_append_args]
    else:
        effects_to_be_destroyed_array.append(effects_array_append_args)


rule "Checking effects to be destroyed":
    @Condition len(effects_to_be_destroyed_array) >= 1
    
    effects_array_index = 0
    #checking effects array
    while effects_array_index < len(effects_to_be_destroyed_array):
        #if total time >= effect time + total time (when effect created) : destroy effect
        if getTotalTimeElapsed() >= effects_to_be_destroyed_array[effects_array_index][EffectEntry.EXPIRE_TIME]:
            #smallMessage(getAllPlayers(), "1")
            #if object == visual/audio effect
            if effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == EffectType.ENTITY:
                #destroy effect from world
                destroyEffect(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET])
            elif effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == EffectType.HEAL_OVER_TIME:
                #smallMessage(getAllPlayers(), "heal over time")
                #destroy effect from world
                stopHealingOverTime(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET])
            elif effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == EffectType.HEALTH_BAR:
                #destroy effect from world
                removeHealthPool(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET])
            elif effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == EffectType.PLAYER_VARIABLE:
                if effects_to_be_destroyed_array[effects_array_index][EffectEntry.ACTION] == EffectAction.EXISTENCE_PRAYER_OF_SALVATION:
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].prayerIsActive = false
                    #smallMessage(getAllPlayers(), "prayer inactive")
            #if object == temporary stat effect
            elif effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == EffectType.SPEED:
                if effects_to_be_destroyed_array[effects_array_index][EffectEntry.ACTION] == EffectAction.SUBTRACT:
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_speed -= effects_to_be_destroyed_array[effects_array_index][EffectEntry.VALUE]
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].setMoveSpeed(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_speed)
            elif effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == EffectType.DAMAGE:
                if effects_to_be_destroyed_array[effects_array_index][EffectEntry.ACTION] == EffectAction.SUBTRACT:
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_damage -= effects_to_be_destroyed_array[effects_array_index][EffectEntry.VALUE]
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].setDamageDealt(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_damage)
            elif effects_to_be_destroyed_array[effects_array_index][EffectEntry.TYPE] == EffectType.HEALTH:
                if effects_to_be_destroyed_array[effects_array_index][EffectEntry.ACTION] == EffectAction.SUBTRACT:
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_health -= effects_to_be_destroyed_array[effects_array_index][EffectEntry.VALUE]
                    effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].setMaxHealth(effects_to_be_destroyed_array[effects_array_index][EffectEntry.TARGET].stat_health)
            #delete effect from array
            del effects_to_be_destroyed_array[effects_array_index]
            effects_array_index--
        effects_array_index++
        wait(0.016)
    wait(0.2)
    if ruleCondition:
        loop()
