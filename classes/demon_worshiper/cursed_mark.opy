#!mainFile "../../main.opy"

rule "Demon Worshiper: Apply Cursed Mark Stack":
    @Event playerDealtDamage
    @Condition eventPlayer.altar_status == AltarStatus.DEMON_WORSHIPER
    @Condition eventDamage > 0
    
    # Accumulate damage dealt to this victim
    victim.cursedMarkDamagePool += eventDamage
    
    # Check if accumulated damage exceeds dynamic threshold
    if victim.cursedMarkDamagePool >= (eventPlayer.dwCurseBaseThreshold * ((eventPlayer.base_stat_damage + eventPlayer.mod_stat_damage) / 100)):
        # Reset damage pool
        victim.cursedMarkDamagePool = 0
        
        # Create a visual effect if this is the first stack (Using HACKED status effect for corruption visuals)
        if victim.cursedMarkStacks == 0:
            createEffect(getAllPlayers(), Effect.SOMBRA_HACKED_LOOPING, Color.PURPLE, victim, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            victim.cursedMarkEffectId = getLastCreatedEntity()
            playEffect(getAllPlayers(), DynamicEffect.ANA_BIOTIC_GRENADE_EXPLOSION, Color.PURPLE, victim, 2)
            
            # Register visual effect to global system on the victim and HUD
            victim.applyVisibleDebuff(BuffId.CURSED_MARK_VISUAL, victim.cursedMarkEffectId, getTotalTimeElapsed() + eventPlayer.dwCurseDuration, EffectType.ENTITY, 0, 0, "{0} Cursed Mark".format(iconString(Icon.SKULL)), Color.PURPLE)
        
        # Add stack (max 3)
        if victim.cursedMarkStacks < 3:
            victim.cursedMarkStacks++
            
            # Increase damage received and register/update stat buff to global system
            if victim.cursedMarkStacks == 1:
                # Register new stat buff
                victim.trackBuff(BuffId.CURSED_MARK_STAT, victim, getTotalTimeElapsed() + eventPlayer.dwCurseDuration, EffectType.DAMAGE_RECEIVED, EffectAction.MODIFY_STAT, eventPlayer.dwCurseDamageBonus)
            else:
                # Update existing stat buff value
                victim.active_buff_values[victim.active_buff_ids.index(BuffId.CURSED_MARK_STAT)] += eventPlayer.dwCurseDamageBonus
                victim.mod_stat_damage_received += eventPlayer.dwCurseDamageBonus
                victim.apply_all_stats()
            
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
