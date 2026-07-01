#!mainFile "../../main.opy"

rule "Demon Worshiper: Apply Cursed Mark Stack":
    @Event playerDealtDamage
    @Condition eventPlayer.altar_status == AltarStatus.DEMON_WORSHIPER
    @Condition eventDamage > 0
    
    # Accumulate damage dealt to this victim per attacker
    victim.cursedMarkDamagePool[eventPlayer.getSlot()] += eventDamage
    
    # Check if accumulated damage exceeds dynamic threshold
    if victim.cursedMarkDamagePool[eventPlayer.getSlot()] >= (eventPlayer.dwCurseBaseThreshold * ((eventPlayer.base_stat_damage + eventPlayer.mod_stat_damage) / 100)):
        # Reset damage pool
        victim.cursedMarkDamagePool[eventPlayer.getSlot()] = 0
        
        # Create a visual effect if this is the first stack for THIS attacker
        if victim.cursedMarkStacks[eventPlayer.getSlot()] == 0:
            createEffect(getAllPlayers(), Effect.SOMBRA_HACKED_LOOPING, Color.PURPLE, victim, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            victim.cursedMarkVisualIds[eventPlayer.getSlot()] = getLastCreatedEntity()
            playEffect(getAllPlayers(), DynamicEffect.ANA_BIOTIC_GRENADE_EXPLOSION, Color.PURPLE, victim, 2)
            
            # Register visual effect to global system on the victim AND attacker-specific HUD
            victim.applyVisibleAttackerDebuff(BuffId.CURSED_MARK_VISUAL, eventPlayer, victim.cursedMarkVisualIds[eventPlayer.getSlot()], getTotalTimeElapsed() + eventPlayer.dwCurseDuration, EffectType.ENTITY, 0, 0, "{0} Cursed Mark".format(iconString(Icon.SKULL)), Color.PURPLE)
        
        # Add stack (max 3 per attacker)
        if victim.cursedMarkStacks[eventPlayer.getSlot()] < 3:
            victim.cursedMarkStacks[eventPlayer.getSlot()] += 1
            
            # Increase damage received and register/update stat buff to global system
            if victim.cursedMarkStacks[eventPlayer.getSlot()] == 1:
                # Register new stat buff
                victim.trackAttackerBuff(BuffId.CURSED_MARK_STAT, eventPlayer, victim, getTotalTimeElapsed() + eventPlayer.dwCurseDuration, EffectType.DAMAGE_RECEIVED, EffectAction.MODIFY_STAT, eventPlayer.dwCurseDamageBonus)
            else:
                # Update existing stat buff value
                victim.addAttackerBuffValue(BuffId.CURSED_MARK_STAT, eventPlayer, eventPlayer.dwCurseDamageBonus)
                victim.mod_stat_damage_received += eventPlayer.dwCurseDamageBonus
                victim.apply_all_stats()
            
        # Set/refresh expiration timestamp
        victim.cursedMarkExpireTimes[eventPlayer.getSlot()] = getTotalTimeElapsed() + eventPlayer.dwCurseDuration
        
        # Extend Buffs
        victim.extendAttackerBuff(BuffId.CURSED_MARK_VISUAL, eventPlayer, victim.cursedMarkExpireTimes[eventPlayer.getSlot()])
        victim.extendAttackerBuff(BuffId.CURSED_MARK_STAT, eventPlayer, victim.cursedMarkExpireTimes[eventPlayer.getSlot()])
        
        # Audio feedback for stack refresh
        playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, victim, 100)

rule "Demon Worshiper: Expire Cursed Mark":
    @Event eachPlayer
    
    # Process expirations per attacker
    for eventPlayer.dw_iter in range(12):
        if eventPlayer.cursedMarkStacks[eventPlayer.dw_iter] > 0:
            if getTotalTimeElapsed() > eventPlayer.cursedMarkExpireTimes[eventPlayer.dw_iter]:
                # Reset stacks and damage pool for this attacker
                eventPlayer.cursedMarkStacks[eventPlayer.dw_iter] = 0
                eventPlayer.cursedMarkDamagePool[eventPlayer.dw_iter] = 0
                eventPlayer.cursedMarkVisualIds[eventPlayer.dw_iter] = null
    
    wait(0.2)
    if ruleCondition:
        loop()

