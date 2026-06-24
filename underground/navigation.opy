#!mainFile "../main.opy"

rule "Ug enter":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(eventPlayer.getPosition(), vect(underground_enter_pos.x, underground_enter_pos.y - 1, underground_enter_pos.z)) <= 1
    
    eventPlayer.teleport(underground_exit_pos)
    eventPlayer.setFacing(directionTowards(eventPlayer.getPosition(), vect(0, 0, 0)), Relativity.TO_WORLD)
    eventPlayer.current_zone = Zone.UNDERGROUND


rule "Ug exit":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(eventPlayer.getPosition(), vect(underground_exit_pos.x, underground_exit_pos.y - 1, underground_exit_pos.z)) <= 1
    
    eventPlayer.teleport(underground_enter_pos)
    eventPlayer.setFacing(directionTowards(eventPlayer.getPosition(), vect(0, 0, 0)), Relativity.TO_WORLD)
    eventPlayer.current_zone = Zone.BUBBLE
