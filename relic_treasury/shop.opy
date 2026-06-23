#!mainFile "../main.opy"

rule "Rt cost of goods":
    cost_vial_exp = 10000


rule "buy a vial of exp":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(eventPlayer.getPosition(), vect(rt_left_1_pos.x, -1 + rt_left_1_pos.y, rt_left_1_pos.z)) <= 1
    
    if eventPlayer.gold >= cost_vial_exp:
        eventPlayer.gold -= cost_vial_exp
        eventPlayer.xp += 10000 * eventPlayer.xp_multi
        update_color_xp_bar()
        smallMessage(eventPlayer, "you bought the vial of experience")
    else:
        smallMessage(eventPlayer, "not enough money")
