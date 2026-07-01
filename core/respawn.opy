#!mainFile "../main.opy"

rule "Global Respawn & Teleport":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.player_init == true
    
    eventPlayer.teleport(respawn_point)
    if eventPlayer.is_selection_hero == true:
        eventPlayer.current_zone = Zone.UNDERGROUND
        wait()
        eventPlayer.current_zone = Zone.NONE
        eventPlayer.is_selection_hero = false
    else:
        eventPlayer.current_zone = Zone.NONE


rule "Remove negative effects after death":
    @Event playerDied
    
    eventPlayer.stopAllDamageOverTime()
    # Force active buffs to expire immediately so lifecycle loop cleans them up, unless they are PERSIST_ON_DEATH
    for eventPlayer.temp_var_0 in range(len(eventPlayer.active_buff_ids)):
        if eventPlayer.active_buff_flags[eventPlayer.temp_var_0] != BuffFlag.PERSIST_ON_DEATH:
            eventPlayer.active_buff_expire_times[eventPlayer.temp_var_0] = 0
            
    for eventPlayer.temp_var_0 in range(len(eventPlayer.hud_buff_ids)):
        if eventPlayer.hud_buff_flags[eventPlayer.temp_var_0] != BuffFlag.PERSIST_ON_DEATH:
            eventPlayer.hud_buff_expires[eventPlayer.temp_var_0] = 0
    
    # Clear per-attacker passive states
    eventPlayer.cursedMarkStacks = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    eventPlayer.cursedMarkDamagePool = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    eventPlayer.cursedMarkExpireTimes = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    eventPlayer.cursedMarkVisualIds = [null, null, null, null, null, null, null, null, null, null, null, null]



