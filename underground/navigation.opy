#!mainFile "../main.opy"

rule "Ug enter":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(eventPlayer.getPosition(), vect(underground_enter_pos.x, underground_enter_pos.y - 1, underground_enter_pos.z)) <= 1
    
    smallMessage(eventPlayer, "hold 1 sec to enter")
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.teleport(vect(131.24, 63.947, -147.323))
    eventPlayer.in_underground = true


rule "Ug exit":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(eventPlayer.getPosition(), vect(underground_exit_pos.x, underground_exit_pos.y - 1, underground_exit_pos.z)) <= 1
    
    eventPlayer.teleport(vect(130.623, 64.078, -152.926))
    eventPlayer.in_underground = false
