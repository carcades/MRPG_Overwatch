#!mainFile "../main.opy"

rule "Exit blood shop":
    @Event eachPlayer
    @Condition eventPlayer.in_blood_shop == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(eventPlayer.getPosition(), exit_blood_shop_pos) <= 1
    
    #wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.teleport(vect(136.405, 64.078, -167.114))
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.clearStatusEffect(Status.HACKED)
    eventPlayer.in_blood_shop = false


rule "Enter blood shop":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(eventPlayer.getPosition(), enter_blood_shop_pos) <= 1
    
    #wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.teleport(vect(136.175, 63.946, -175.165))
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.setStatusEffect(null, Status.HACKED, 9999)
    eventPlayer.in_blood_shop = true


rule "Blood wall":
    @Event eachPlayer
    @Condition eventPlayer.in_blood_shop == true
    @Condition distance(eventPlayer.getPosition(), wall_blood_shop_pos) <= 4
    @Disabled
    
    eventPlayer.applyImpulse(vect(0, 0.05, -1), 30, Relativity.TO_WORLD)
    wait()
    if ruleCondition:
        loop()


rule "Blood buy vampire":
    @Event eachPlayer
    @Condition eventPlayer.in_blood_shop == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(buy_blood_vampire_pos, eventPlayer.getPosition()) <= 1
    @Condition eventPlayer.blood_points >= eventPlayer.vampire_cost
    
    if eventPlayer.vampire_level < 3:
        if eventPlayer.passive_vampire == false:
            eventPlayer.vampire_size = 0.2
            eventPlayer.passive_vampire = true
        elif eventPlayer.passive_vampire == true:
            eventPlayer.vampire_size += 0.2
        eventPlayer.vampire_level++
        eventPlayer.blood_points -= eventPlayer.vampire_cost
    else:
        smallMessage(eventPlayer, "you reached the limit vampire")


rule "Blood buy bleeding":
    @Event eachPlayer
    @Condition eventPlayer.in_blood_shop == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(buy_bleeding_blood_pos, eventPlayer.getPosition()) <= 1
    @Condition eventPlayer.blood_points >= eventPlayer.bleeding_cost
    
    if eventPlayer.bleeding_level < 3:
        if eventPlayer.bleeding_passive == false:
            eventPlayer.bleeding_power = 0.6
            eventPlayer.bleeding_duration = 5
            eventPlayer.bleeding_chance_player = 1
            eventPlayer.bleeding_passive = true
        else:
            eventPlayer.bleeding_duration++
            eventPlayer.bleeding_power += 0.3
            eventPlayer.bleeding_chance_player++
        eventPlayer.blood_points -= eventPlayer.bleeding_cost
        eventPlayer.bleeding_level++
    else:
        smallMessage(eventPlayer, "you reached the limit bleeding")


rule "Blood buy xp boost":
    @Event eachPlayer
    @Condition eventPlayer.in_blood_shop == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(buy_blood_xp_multi_pos, eventPlayer.getPosition()) <= 1
    @Condition eventPlayer.blood_points >= eventPlayer.blood_xp_cost
    
    if eventPlayer.xp_multi < 3:
        eventPlayer.xp_multi += 0.2
        eventPlayer.blood_points -= eventPlayer.blood_xp_cost
    else:
        smallMessage(eventPlayer, "you have reached the blood xp multipy limit")
