#!mainFile "../main.opy"

rule "Respawn player":
    @Event playerDied
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.player_init == true
    
    logToInspector("[RESPAWN] Player {0} died. Zone: {1}".format(eventPlayer, eventPlayer.current_zone))
    waitUntil(eventPlayer.isAlive() == true, 99999)
    logToInspector("[RESPAWN] Player {0} alive. Zone: {1}".format(eventPlayer, eventPlayer.current_zone))
    eventPlayer.teleport(respawn_point)
    eventPlayer.current_zone = Zone.NONE
    logToInspector("[RESPAWN] Player {0} current_zone = NONE".format(eventPlayer))


rule "Remove negative effects after death":
    @Event playerDied
    
    eventPlayer.stopAllDamageOverTime()



