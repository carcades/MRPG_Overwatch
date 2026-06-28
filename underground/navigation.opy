#!mainFile "../main.opy"

rule "Ug enter":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(eventPlayer.getPosition(), vect(underground_enter_pos.x, underground_enter_pos.y - 1, underground_enter_pos.z)) <= 1
    
    smallMessage(eventPlayer, "hold f 1 sec to enter")
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.teleport(underground_exit_pos)
    eventPlayer.setFacing(directionTowards(eventPlayer.getPosition(), vect(0, 0, 0)), Relativity.TO_WORLD)
    eventPlayer.current_zone = Zone.UNDERGROUND


rule "Ug exit":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(eventPlayer.getPosition(), vect(underground_exit_pos.x, underground_exit_pos.y - 1, underground_exit_pos.z)) <= 1
    
    smallMessage(eventPlayer, "hold f 1 sec to exit")
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.teleport(underground_enter_pos)
    eventPlayer.setFacing(directionTowards(eventPlayer.getPosition(), vect(0, 0, 0)), Relativity.TO_WORLD)
    eventPlayer.current_zone = Zone.BUBBLE


rule "Underground wall":
    @Event eachPlayer
    @Condition eventPlayer.current_zone == Zone.UNDERGROUND
    @Condition distance(eventPlayer.getPosition(), wall_underground_pos) <= 4
    
    smallMessage(eventPlayer, "Access Denied")
    playEffect(eventPlayer, DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.getPosition(), 1)
    eventPlayer.teleport(underground_exit_pos)
