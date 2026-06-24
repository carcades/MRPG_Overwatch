#!mainFile "../main.opy"

rule "Exit blood shop":
    @Event eachPlayer
    @Condition eventPlayer.current_zone == Zone.BLOOD_SHOP
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(eventPlayer.getPosition(), exit_blood_shop_pos) <= 1
    
    eventPlayer.teleport(vect(136.405, 64.078, -167.114))
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.clearStatusEffect(Status.HACKED)
    eventPlayer.current_zone = Zone.NONE


rule "Enter blood shop":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(eventPlayer.getPosition(), enter_blood_shop_pos) <= 1
    
    eventPlayer.teleport(vect(136.175, 63.946, -175.165))
    eventPlayer.setInvisibility(Invis.ALL)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.RED, eventPlayer.getPosition(), 100)
    eventPlayer.current_zone = Zone.BLOOD_SHOP
    wait(1)


rule "Blood shop wall":
    @Event eachPlayer
    @Condition eventPlayer.current_zone == Zone.BLOOD_SHOP
    @Condition distance(eventPlayer.getPosition(), wall_blood_shop_pos) <= 4
    @Disabled
    
    eventPlayer.applyImpulse(vect(0, 0.05, -1), 30, Relativity.TO_WORLD)
    wait()
    if ruleCondition:
        loop()


rule "Blood buy vampire":
    @Event eachPlayer
    @Condition eventPlayer.current_zone == Zone.BLOOD_SHOP
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(buy_blood_vampire_pos, eventPlayer.getPosition()) <= 1
    @Condition eventPlayer.blood_points >= eventPlayer.vampire_cost
    
    if eventPlayer.vampireLevel < 3:
        if eventPlayer.passiveVampire == false:
            eventPlayer.vampireSize = 0.2
            eventPlayer.passiveVampire = true
        elif eventPlayer.passiveVampire == true:
            eventPlayer.vampireSize += 0.2
        eventPlayer.vampireLevel++
        eventPlayer.blood_points -= eventPlayer.vampire_cost
    else:
        smallMessage(eventPlayer, "you reached the limit vampire")


rule "Blood buy bleeding":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.current_zone == Zone.BLOOD_SHOP
    @Condition distance(buy_bleeding_blood_pos, eventPlayer.getPosition()) <= 1
    @Condition eventPlayer.blood_points >= eventPlayer.bleeding_cost
    
    if eventPlayer.bleedingLevel < 3:
        if eventPlayer.bleedingPassive == false:
            eventPlayer.bleedingPower = 0.6
            eventPlayer.bleedingDuration = 5
            eventPlayer.bleedingChancePlayer = 1
            eventPlayer.bleedingPassive = true
        else:
            eventPlayer.bleedingDuration++
            eventPlayer.bleedingPower += 0.3
            eventPlayer.bleedingChancePlayer++
        eventPlayer.blood_points -= eventPlayer.bleeding_cost
        eventPlayer.bleedingLevel++
    else:
        smallMessage(eventPlayer, "you reached the limit bleeding")


rule "Blood buy xp boost":
    @Event eachPlayer
    @Condition eventPlayer.current_zone == Zone.BLOOD_SHOP
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(buy_blood_xp_multi_pos, eventPlayer.getPosition()) <= 1
    @Condition eventPlayer.blood_points >= eventPlayer.blood_xp_cost
    
    if eventPlayer.xp_multi < 3:
        eventPlayer.xp_multi += 0.2
        eventPlayer.blood_points -= eventPlayer.blood_xp_cost
    else:
        smallMessage(eventPlayer, "you have reached the blood xp multipy limit")

rule "Blood shop heal passive":
    @Event eachPlayer
    @Condition eventPlayer.current_zone == Zone.BLOOD_SHOP
    @Condition eventPlayer.getHealth() < eventPlayer.getMaxHealth()

    heal(eventPlayer, null, 1)
    wait(1)
    if ruleCondition:
        loop()
