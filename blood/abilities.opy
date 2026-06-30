#!mainFile "../main.opy"

rule "Ability Vampire":
    @Event playerDealtDamage
    @Condition eventPlayer.passiveVampire == true
    @Condition eventDamage > 0
    
    heal(attacker, attacker, eventDamage * eventPlayer.vampireSize)


rule "Ability Bleeding":
    @Event playerDealtDamage
    @Condition eventPlayer.bleedingPassive == true
    @Condition eventDamage > 0
    @Condition victim.isReceivingBleedDamage == false
    @Condition eventPlayer != victim
    
    if random.uniform(0, 100) <= (eventPlayer.bleedingChancePlayer * 10 * (eventDamage / max(1, (eventPlayer.base_stat_damage + eventPlayer.mod_stat_damage)))):
        victim.bleed_expire_times[eventPlayer.getSlot()] = getTotalTimeElapsed() + eventPlayer.bleedingDuration
        victim.bleed_tick_damages[eventPlayer.getSlot()] = (eventPlayer.base_stat_damage + eventPlayer.mod_stat_damage) / 3 * eventPlayer.bleedingPower
        
        if victim.bleed_effect_ids[eventPlayer.getSlot()] == 0 or victim.bleed_effect_ids[eventPlayer.getSlot()] == null:
            createEffect(getAllPlayers(), Effect.SIGMA_GRAVITIC_FLUX_TARGET, Color.RED, victim, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            victim.bleed_effect_ids[eventPlayer.getSlot()] = getLastCreatedEntity()
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, victim, 1)
            
            victim.trackHud(BuffId.BLEEDING, getTotalTimeElapsed() + eventPlayer.bleedingDuration, "{0} Bleeding".format(iconString(Icon.HEART)), Color.RED)
        else:
            victim.extendBuff(BuffId.BLEEDING, getTotalTimeElapsed() + eventPlayer.bleedingDuration)


rule "Process Bleeding DoT":
    @Event eachPlayer
    @Condition len(eventPlayer.bleed_expire_times.filter(lambda x: x > getTotalTimeElapsed())) > 0
    
    eventPlayer.isReceivingBleedDamage = true
    for eventPlayer.temp_var_2 in range(12):
        if eventPlayer.bleed_expire_times[eventPlayer.temp_var_2] > getTotalTimeElapsed():
            damage(eventPlayer, getPlayersInSlot(eventPlayer.temp_var_2), eventPlayer.bleed_tick_damages[eventPlayer.temp_var_2])
            wait(0.1)
            
    eventPlayer.isReceivingBleedDamage = false
    wait(0.9)
    if ruleCondition:
        loop()


rule "Expire Bleeding Effects":
    @Event eachPlayer
    @Condition len(eventPlayer.bleed_effect_ids.filter(lambda x: x != null and x != 0)) > 0
    
    for eventPlayer.temp_var_2 in range(12):
        if eventPlayer.bleed_effect_ids[eventPlayer.temp_var_2] != null and eventPlayer.bleed_effect_ids[eventPlayer.temp_var_2] != 0:
            if eventPlayer.bleed_expire_times[eventPlayer.temp_var_2] <= getTotalTimeElapsed():
                destroyEffect(eventPlayer.bleed_effect_ids[eventPlayer.temp_var_2])
                eventPlayer.bleed_effect_ids[eventPlayer.temp_var_2] = null
        wait(0.016)
        
    wait(1)
    if ruleCondition:
        loop()


rule "Clear Bleeding on Death or Spawn":
    @Event eachPlayer
    @Condition (eventPlayer.isAlive() == false) or (eventPlayer.current_zone == Zone.BUBBLE)
    
    for eventPlayer.temp_var_2 in range(12):
        eventPlayer.bleed_expire_times[eventPlayer.temp_var_2] = 0
        if eventPlayer.bleed_effect_ids[eventPlayer.temp_var_2] != null and eventPlayer.bleed_effect_ids[eventPlayer.temp_var_2] != 0:
            destroyEffect(eventPlayer.bleed_effect_ids[eventPlayer.temp_var_2])
            eventPlayer.bleed_effect_ids[eventPlayer.temp_var_2] = null
            
    if BuffId.BLEEDING in eventPlayer.hud_buff_ids:
        eventPlayer.extendBuff(BuffId.BLEEDING, 0)

