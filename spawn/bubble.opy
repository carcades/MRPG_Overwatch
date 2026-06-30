#!mainFile "../main.opy"

rule "Enter spawn":
    @Event eachPlayer
    @Condition eventPlayer.current_zone == Zone.NONE
    @Condition eventPlayer.player_init == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition distance(eventPlayer.getPosition(), vect(spawn_bubble_position.x, spawn_bubble_position.y - 1, spawn_bubble_position.z)) < SPAWN_BUBBLE_RADIUS
    
    logToInspector("[BUBBLE] Enter spawn triggered for {0}. Zone: {1}, Alive: {2}".format(eventPlayer, eventPlayer.current_zone, eventPlayer.isAlive()))
    waitUntil(eventPlayer.isAlive() == true, 99999)
    wait(0.1)
    
    if distance(eventPlayer.getPosition(), vect(spawn_bubble_position.x, spawn_bubble_position.y - 1, spawn_bubble_position.z)) < SPAWN_BUBBLE_RADIUS:
        logToInspector("[BUBBLE] Enter spawn success for {0}".format(eventPlayer))
        eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 99999)
        eventPlayer.startHealingOverTime(eventPlayer, 99999, (eventPlayer.base_stat_health + eventPlayer.mod_stat_health) / 4)
        eventPlayer.heal_bubble = getLastHealingOverTimeId()
        eventPlayer.current_zone = Zone.BUBBLE
        smallMessage(eventPlayer, "enter")


rule "Walk out of spawn":
    @Event eachPlayer
    @Condition eventPlayer.current_zone != Zone.NONE
    @Condition distance(eventPlayer.getPosition(), vect(spawn_bubble_position.x, spawn_bubble_position.y - 1, spawn_bubble_position.z)) >= SPAWN_BUBBLE_RADIUS
    @Condition eventPlayer.is_selection_hero == false
    
    logToInspector("[BUBBLE] Walk out of spawn triggered for {0}. Prev Zone: {1}, Dist: {2}".format(eventPlayer, eventPlayer.current_zone, distance(eventPlayer.getPosition(), spawn_bubble_position)))
    eventPlayer.current_zone = Zone.NONE


rule "Clear spawn effects":
    @Event eachPlayer
    @Condition eventPlayer.current_zone == Zone.NONE
    
    if eventPlayer.current_zone == Zone.NONE:
        logToInspector("[BUBBLE] Clear spawn effects for {0}".format(eventPlayer))
        eventPlayer.clearStatusEffect(Status.PHASED_OUT)
        stopHealingOverTime(eventPlayer.heal_bubble)
        smallMessage(eventPlayer, "exit")
