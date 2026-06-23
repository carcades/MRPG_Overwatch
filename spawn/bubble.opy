#!mainFile "../main.opy"

rule "Enter spawn":
    @Event eachPlayer
    @Condition eventPlayer.in_bubble != true
    @Condition eventPlayer.player_init == true
    @Condition distance(eventPlayer.getPosition(), vect(spawn_bubble_position.x, spawn_bubble_position.y - 1, spawn_bubble_position.z)) < SPAWN_BUBBLE_RADIUS
    
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.startHealingOverTime(eventPlayer, 99999, eventPlayer.stat_health / 4)
    eventPlayer.heal_bubble = getLastHealingOverTimeId()
    eventPlayer.in_bubble = true
    smallMessage(eventPlayer, "enter")


rule "Exit spawn":
    @Event eachPlayer
    @Condition eventPlayer.in_bubble == true
    @Condition distance(eventPlayer.getPosition(), vect(spawn_bubble_position.x, spawn_bubble_position.y - 1, spawn_bubble_position.z)) >= SPAWN_BUBBLE_RADIUS
    
    eventPlayer.in_bubble = false
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    stopHealingOverTime(eventPlayer.heal_bubble)
    smallMessage(eventPlayer, "exit")
