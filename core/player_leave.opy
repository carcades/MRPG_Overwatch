#!mainFile "../main.opy"

rule "System: Garbage Collection on Player Leave":
    @Event playerLeft
    
    # 1. Clean up temporary visual effects and entities from effects_lifecycle
    eventPlayer.gc_loop_iter = 0
    while eventPlayer.gc_loop_iter < len(eventPlayer.active_buff_targets):
        if eventPlayer.active_buff_types[eventPlayer.gc_loop_iter] == EffectType.ENTITY:
            destroyEffect(eventPlayer.active_buff_targets[eventPlayer.gc_loop_iter])
        elif eventPlayer.active_buff_types[eventPlayer.gc_loop_iter] == EffectType.HEAL_OVER_TIME:
            stopHealingOverTime(eventPlayer.active_buff_targets[eventPlayer.gc_loop_iter])
        elif eventPlayer.active_buff_types[eventPlayer.gc_loop_iter] == EffectType.HEALTH_BAR:
            removeHealthPool(eventPlayer.active_buff_targets[eventPlayer.gc_loop_iter])
        eventPlayer.gc_loop_iter++
        wait(0.016)
        
    # 2. Clean up HUD texts from effects_lifecycle

        
    # 3. Clean up persistent entities from GC array
    eventPlayer.gc_loop_iter = 0
    while eventPlayer.gc_loop_iter < len(eventPlayer.gc_ids):
        if eventPlayer.gc_types[eventPlayer.gc_loop_iter] == GcType.EFFECT:
            destroyEffect(eventPlayer.gc_ids[eventPlayer.gc_loop_iter])
        elif eventPlayer.gc_types[eventPlayer.gc_loop_iter] == GcType.IN_WORLD_TEXT:
            destroyInWorldText(eventPlayer.gc_ids[eventPlayer.gc_loop_iter])
        elif eventPlayer.gc_types[eventPlayer.gc_loop_iter] == GcType.HUD_TEXT:
            destroyHudText(eventPlayer.gc_ids[eventPlayer.gc_loop_iter])
        elif eventPlayer.gc_types[eventPlayer.gc_loop_iter] == GcType.ICON:
            destroyIcon(eventPlayer.gc_ids[eventPlayer.gc_loop_iter])
        elif eventPlayer.gc_types[eventPlayer.gc_loop_iter] == GcType.BEAM:
            destroyEffect(eventPlayer.gc_ids[eventPlayer.gc_loop_iter])
        elif eventPlayer.gc_types[eventPlayer.gc_loop_iter] == GcType.PROGRESS_BAR:
            destroyProgressBarHud(eventPlayer.gc_ids[eventPlayer.gc_loop_iter])
        eventPlayer.gc_loop_iter++
        wait(0.016)
