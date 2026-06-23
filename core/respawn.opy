#!mainFile "../main.opy"

rule "Respawn player":
    @Event playerDied
    @Condition eventPlayer.isDummy() == false
    
    waitUntil(eventPlayer.isAlive() == true, 99999)
    eventPlayer.teleport(respawn_point)


rule "Remove negative effects after death":
    @Event playerDied
    
    eventPlayer.stopAllDamageOverTime()
