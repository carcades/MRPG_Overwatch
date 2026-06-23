#!mainFile "../main.opy"

rule "Enter altar":
    @Event eachPlayer
    @Condition eventPlayer.in_bubble == true
    @Condition distance(eventPlayer.getPosition(), vect(enter_altar_pos.x, enter_altar_pos.y - 1, enter_altar_pos.z)) < 1.3
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    if eventPlayer.altar_status == AltarStatus.NONE:
        if eventPlayer.seppuku_level < 3:
            smallMessage(eventPlayer, "you need seppuku level 3 to enter the sacred altar.")
        else:
            smallMessage(eventPlayer, "hold f 3 sec to enter")
            #wait(3, Wait.ABORT_WHEN_FALSE)
            eventPlayer.altar_status = AltarStatus.TIER_2_SELECTION
            enable_display_tier_2_effects()
            eventPlayer.teleport(teleport_to_altar_point)
            eventPlayer.in_altar = true
    elif eventPlayer.altar_status == AltarStatus.TIER_2_SELECTION:
        smallMessage(eventPlayer, "hold f 1 sec to enter")
        wait(1, Wait.ABORT_WHEN_FALSE)
        enable_display_tier_2_effects()
        eventPlayer.teleport(teleport_to_altar_point)
        eventPlayer.in_altar = true


rule "Exit altar":
    @Event eachPlayer
    @Condition eventPlayer.in_altar == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(eventPlayer.getPosition(), vect(exit_altar_point.x, exit_altar_point.y - 2, exit_altar_point.z)) <= 1.3
    
    eventPlayer.teleport(respawn_point)
    eventPlayer.in_altar = false
    disable_altar_effects()
