#!mainFile "../main.opy"

rule "Rt_enter":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(eventPlayer.getPosition(), rt_enter_pos) <= 1
    
    smallMessage(eventPlayer, "hold 2 seconds to enter")
    wait(2, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.setStatusEffect(null, Status.HACKED, 9999)
    eventPlayer.teleport(vect(-93.307, 61.947, -160.003))
    eventPlayer.current_zone = Zone.RELIC_TREASURY


rule "Rt_exit":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(eventPlayer.getPosition(), rt_exit_pos) <= 1
    
    eventPlayer.teleport(vect(-76.362, 64.308, -160.093))
    wait(0.25)
    eventPlayer.clearStatusEffect(Status.HACKED)
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.current_zone = Zone.BUBBLE
