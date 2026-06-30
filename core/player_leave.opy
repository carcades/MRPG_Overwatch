#!mainFile "../main.opy"

rule "System: Garbage Collection on Player Leave":
    @Event playerLeft
    
    # 1. Clean up temporary visual effects and entities from effects_lifecycle
    eventPlayer.temp_var_1 = 0
    while eventPlayer.temp_var_1 < len(eventPlayer.active_buff_targets):
        if eventPlayer.active_buff_types[eventPlayer.temp_var_1] == EffectType.ENTITY:
            destroyEffect(eventPlayer.active_buff_targets[eventPlayer.temp_var_1])
        elif eventPlayer.active_buff_types[eventPlayer.temp_var_1] == EffectType.HEAL_OVER_TIME:
            stopHealingOverTime(eventPlayer.active_buff_targets[eventPlayer.temp_var_1])
        elif eventPlayer.active_buff_types[eventPlayer.temp_var_1] == EffectType.HEALTH_BAR:
            removeHealthPool(eventPlayer.active_buff_targets[eventPlayer.temp_var_1])
        eventPlayer.temp_var_1++
        wait(0.016)
        
    # 2. Clean up HUD texts from effects_lifecycle
    eventPlayer.temp_var_1 = 0
    while eventPlayer.temp_var_1 < len(eventPlayer.hud_buff_ids):
        # We don't actually have a destroyHudText for these because they are created globally and dynamically evaluate visibility.
        # So we don't need to destroy the entities, just wait for variables to clear.
        # But wait, wait! The HUD buff texts in core/hud.opy are GLOBAL! They are NOT created per-player.
        # Thus, there are NO HUD texts to destroy here. They will just stop rendering for this player.
        # So this step is actually empty.
        break
        
    # 3. Clean up persistent entities from GC array
    eventPlayer.temp_var_1 = 0
    while eventPlayer.temp_var_1 < len(eventPlayer.gc_ids):
        if eventPlayer.gc_types[eventPlayer.temp_var_1] == GcType.EFFECT:
            destroyEffect(eventPlayer.gc_ids[eventPlayer.temp_var_1])
        elif eventPlayer.gc_types[eventPlayer.temp_var_1] == GcType.IN_WORLD_TEXT:
            destroyInWorldText(eventPlayer.gc_ids[eventPlayer.temp_var_1])
        elif eventPlayer.gc_types[eventPlayer.temp_var_1] == GcType.HUD_TEXT:
            destroyHudText(eventPlayer.gc_ids[eventPlayer.temp_var_1])
        elif eventPlayer.gc_types[eventPlayer.temp_var_1] == GcType.ICON:
            destroyIcon(eventPlayer.gc_ids[eventPlayer.temp_var_1])
        elif eventPlayer.gc_types[eventPlayer.temp_var_1] == GcType.BEAM:
            destroyEffect(eventPlayer.gc_ids[eventPlayer.temp_var_1])
        elif eventPlayer.gc_types[eventPlayer.temp_var_1] == GcType.PROGRESS_BAR:
            destroyProgressBarHud(eventPlayer.gc_ids[eventPlayer.temp_var_1])
        eventPlayer.temp_var_1++
        wait(0.016)
