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
            victim.active_buff_ids.append(BuffId.CURSED_MARK_VISUAL)
            victim.active_buff_targets.append(victim.cursedMarkEffectId)
            victim.active_buff_expire_times.append(getTotalTimeElapsed() + eventPlayer.dwCurseDuration)
            victim.active_buff_types.append(EffectType.ENTITY)
            victim.active_buff_actions.append(0)
            victim.active_buff_values.append(0)
            
            # Add to HUD
            eventPlayer.buff_append_args = [victim, getTotalTimeElapsed() + eventPlayer.dwCurseDuration, "{0} Cursed Mark".format(iconString(Icon.SKULL)), Color.PURPLE, BuffId.CURSED_MARK_VISUAL]
            add_hud_buff()
        
        # Add stack (max 3)
        if victim.cursedMarkStacks < 3:
            victim.cursedMarkStacks++
            
            # Increase damage received and register/update stat buff to global system
            victim.stat_damage_received += eventPlayer.dwCurseDamageBonus
            victim.setDamageReceived(100 if victim.stat_damage_received == 0 else victim.stat_damage_received)
            
            if victim.cursedMarkStacks == 1:
                # Register new stat buff
                victim.active_buff_ids.append(BuffId.CURSED_MARK_STAT)
                victim.active_buff_targets.append(victim)
                victim.active_buff_expire_times.append(getTotalTimeElapsed() + eventPlayer.dwCurseDuration)
                victim.active_buff_types.append(EffectType.DAMAGE_RECEIVED)
                victim.active_buff_actions.append(EffectAction.SUBTRACT)
                victim.active_buff_values.append(eventPlayer.dwCurseDamageBonus)
            else:
                # Update existing stat buff value
                victim.active_buff_values[victim.active_buff_ids.index(BuffId.CURSED_MARK_STAT)] += eventPlayer.dwCurseDamageBonus
            
        # Set/refresh expiration timestamp
        victim.cursedMarkExpire = getTotalTimeElapsed() + eventPlayer.dwCurseDuration
        
        # Extend HUD buff
        if BuffId.CURSED_MARK_VISUAL in victim.hud_buff_ids:
            victim.hud_buff_expires[victim.hud_buff_ids.index(BuffId.CURSED_MARK_VISUAL)] = victim.cursedMarkExpire
            
        # Extend Visual Buff
        if BuffId.CURSED_MARK_VISUAL in victim.active_buff_ids:
            victim.active_buff_expire_times[victim.active_buff_ids.index(BuffId.CURSED_MARK_VISUAL)] = victim.cursedMarkExpire
            
        # Extend Stat Buff
        if BuffId.CURSED_MARK_STAT in victim.active_buff_ids:
            victim.active_buff_expire_times[victim.active_buff_ids.index(BuffId.CURSED_MARK_STAT)] = victim.cursedMarkExpire
        
        # Audio feedback for stack refresh
        playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, victim, 100)

rule "Demon Worshiper: Expire Cursed Mark":
    @Event eachPlayer
    @Condition eventPlayer.cursedMarkStacks > 0
    @Condition getTotalTimeElapsed() > eventPlayer.cursedMarkExpire
    
    # Reset stacks and damage pool
    eventPlayer.cursedMarkStacks = 0
    eventPlayer.cursedMarkDamagePool = 0
    
    # Visual cleanup is handled by effects_lifecycle.opy (EffectType.ENTITY)
    # Stat cleanup is handled by effects_lifecycle.opy (EffectType.DAMAGE_RECEIVED)
    eventPlayer.cursedMarkEffectId = null
