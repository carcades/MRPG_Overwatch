#!mainFile "../../main.opy"

rule "Demon Worshiper: Apply Cursed Mark Stack":
    @Event playerDealtDamage
    @Condition eventPlayer.altar_status == AltarStatus.DEMON_WORSHIPER
    @Condition eventDamage > 0
    
    # Accumulate damage dealt to this victim
    victim.cursedMarkDamagePool += eventDamage
    
    # Check if accumulated damage exceeds dynamic threshold
    if victim.cursedMarkDamagePool >= (eventPlayer.dwCurseBaseThreshold * (eventPlayer.stat_damage / 100)):
        # Reset damage pool
        victim.cursedMarkDamagePool = 0
        
        # Create a visual effect if this is the first stack (Using HACKED status effect for corruption visuals)
        if victim.cursedMarkStacks == 0:
            createEffect(getAllPlayers(), Effect.SOMBRA_HACKED_LOOPING, Color.PURPLE, victim, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            victim.cursedMarkEffectId = getLastCreatedEntity()
            playEffect(getAllPlayers(), DynamicEffect.ANA_BIOTIC_GRENADE_EXPLOSION, Color.PURPLE, victim, 2)
            
            # Register visual effect to global system on the victim
            victim.active_buff_ids.append(BuffId.CURSED_MARK)
            victim.active_buff_targets.append(victim.cursedMarkEffectId)
            victim.active_buff_expire_times.append(getTotalTimeElapsed() + eventPlayer.dwCurseDuration)
            victim.active_buff_types.append(EffectType.ENTITY)
            victim.active_buff_actions.append(0)
            victim.active_buff_values.append(0)
            
            # Add to HUD
            eventPlayer.buff_append_args = [victim, getTotalTimeElapsed() + eventPlayer.dwCurseDuration, "{0} Cursed Mark".format(iconString(Icon.SKULL)), Color.PURPLE, BuffId.CURSED_MARK]
            add_hud_buff()
        
        # Add stack (max 3)
        if victim.cursedMarkStacks < 3:
            victim.cursedMarkStacks++
            
        # Increase damage received (base stats + debuff). Dummy bots have stat_damage_received = 0, so we fallback to 100.
        victim.setDamageReceived((100 if victim.stat_damage_received == 0 else victim.stat_damage_received) + (victim.cursedMarkStacks * eventPlayer.dwCurseDamageBonus))
        
        # Set/refresh expiration timestamp
        victim.cursedMarkExpire = getTotalTimeElapsed() + eventPlayer.dwCurseDuration
        
        # Extend HUD buff
        if BuffId.CURSED_MARK in victim.hud_buff_ids:
            victim.hud_buff_expires[victim.hud_buff_ids.index(BuffId.CURSED_MARK)] = victim.cursedMarkExpire
            
        # Extend global system entity buff
        if BuffId.CURSED_MARK in victim.active_buff_ids:
            victim.active_buff_expire_times[victim.active_buff_ids.index(BuffId.CURSED_MARK)] = victim.cursedMarkExpire
        
        # Audio feedback for stack refresh
        playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, victim, 100)

rule "Demon Worshiper: Expire Cursed Mark":
    @Event eachPlayer
    @Condition eventPlayer.cursedMarkStacks > 0
    @Condition getTotalTimeElapsed() > eventPlayer.cursedMarkExpire
    
    # Reset stacks and damage pool
    eventPlayer.cursedMarkStacks = 0
    eventPlayer.cursedMarkDamagePool = 0
    
    # Restore base damage received stat. Dummy bots have 0, so fallback to 100.
    eventPlayer.setDamageReceived(100 if eventPlayer.stat_damage_received == 0 else eventPlayer.stat_damage_received)
    eventPlayer.cursedMarkEffectId = null
