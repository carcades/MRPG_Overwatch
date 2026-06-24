#!mainFile "../main.opy"

rule "Enter spawn":
    @Event eachPlayer
    @Condition eventPlayer.current_zone == Zone.NONE
    @Condition eventPlayer.player_init == true
    @Condition distance(eventPlayer.getPosition(), vect(spawn_bubble_position.x, spawn_bubble_position.y - 1, spawn_bubble_position.z)) < SPAWN_BUBBLE_RADIUS
    
    waitUntil(eventPlayer.isAlive() == true, 99999)
    wait(0.1)
    
    if distance(eventPlayer.getPosition(), vect(spawn_bubble_position.x, spawn_bubble_position.y - 1, spawn_bubble_position.z)) < SPAWN_BUBBLE_RADIUS:
        eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 99999)
        eventPlayer.startHealingOverTime(eventPlayer, 99999, eventPlayer.stat_health / 4)
        eventPlayer.heal_bubble = getLastHealingOverTimeId()
        eventPlayer.current_zone = Zone.BUBBLE
        smallMessage(eventPlayer, "enter")


rule "Walk out of spawn":
    @Event eachPlayer
    @Condition eventPlayer.current_zone != Zone.NONE
    @Condition distance(eventPlayer.getPosition(), vect(spawn_bubble_position.x, spawn_bubble_position.y - 1, spawn_bubble_position.z)) >= SPAWN_BUBBLE_RADIUS
    
    eventPlayer.current_zone = Zone.NONE


rule "Clear spawn effects":
    @Event eachPlayer
    @Condition eventPlayer.current_zone == Zone.NONE
    
    if eventPlayer.current_zone == Zone.NONE:
        eventPlayer.clearStatusEffect(Status.PHASED_OUT)
        stopHealingOverTime(eventPlayer.heal_bubble)
        smallMessage(eventPlayer, "exit")
