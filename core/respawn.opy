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
    # Force all active buffs to expire immediately so lifecycle loop cleans them up and reverts stats safely
    eventPlayer.active_buff_expire_times = [0 for x in eventPlayer.active_buff_expire_times]
    eventPlayer.hud_buff_expires = [0 for x in eventPlayer.hud_buff_expires]



