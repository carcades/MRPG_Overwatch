#!mainFile "../main.opy"

rule "Respawn player":
    @Event playerDied
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.player_init == true
    
    waitUntil(eventPlayer.isAlive() == true, 99999)
    eventPlayer.teleport(respawn_point)
    eventPlayer.current_zone = Zone.NONE


rule "Remove negative effects after death":
    @Event playerDied
    
    eventPlayer.stopAllDamageOverTime()
