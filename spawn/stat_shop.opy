#!mainFile "../main.opy"

rule "Shop buy damage":
    @Event eachPlayer
    @Condition distance(vect(buy_damage_pos.x, buy_damage_pos.y + -1, buy_damage_pos.z), eventPlayer.getPosition()) <= 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.level_up_points >= 1
    
    if eventPlayer.stat_damage < eventPlayer.statLimitDamage:
        if eventPlayer.isHoldingButton(Button.CROUCH):
            eventPlayer.stat_damage++
            eventPlayer.level_up_points--
            eventPlayer.setDamageDealt(eventPlayer.stat_damage)
            wait(0.016)
            if ruleCondition:
                loop()
        else:
            eventPlayer.stat_damage++
            eventPlayer.level_up_points--
            eventPlayer.setDamageDealt(eventPlayer.stat_damage)
    else:
        smallMessage(eventPlayer, "You have reached the limit of your race")


rule "Shop buy health":
    @Event eachPlayer
    @Condition distance(vect(buy_health_pos.x, buy_health_pos.y + -1, buy_health_pos.z), eventPlayer.getPosition()) <= 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.level_up_points >= 1
    
    if eventPlayer.stat_health < eventPlayer.statLimitHealth:
        if eventPlayer.isHoldingButton(Button.CROUCH):
            eventPlayer.stat_health++
            eventPlayer.level_up_points--
            eventPlayer.setMaxHealth(eventPlayer.stat_health)
            wait(0.016)
            if ruleCondition:
                loop()
        else:
            eventPlayer.stat_health++
            eventPlayer.level_up_points--
            eventPlayer.setMaxHealth(eventPlayer.stat_health)
    else:
        smallMessage(eventPlayer, "You have reached the limit of your race")


rule "Shop buy speed":
    @Event eachPlayer
    @Condition distance(vect(buy_speed_pos.x, buy_speed_pos.y + -1, buy_speed_pos.z), eventPlayer.getPosition()) <= 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.level_up_points >= 1
    
    if eventPlayer.stat_speed < eventPlayer.statLimitSpeed:
        if eventPlayer.isHoldingButton(Button.CROUCH):
            eventPlayer.stat_speed += 0.25
            eventPlayer.level_up_points--
            eventPlayer.setMoveSpeed(eventPlayer.stat_speed)
            wait(0.016)
            if ruleCondition:
                loop()
        else:
            eventPlayer.stat_speed += 0.25
            eventPlayer.level_up_points--
            eventPlayer.setMoveSpeed(eventPlayer.stat_speed)
    else:
        smallMessage(eventPlayer, "You have reached the limit of your race")
