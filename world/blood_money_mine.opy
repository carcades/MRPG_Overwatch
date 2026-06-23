#!mainFile "../main.opy"

rule "Blood money mining":
    @Event eachPlayer
    @Condition eventPlayer.player_init == true
    @Condition eventPlayer.is_selection_hero == false
    @Condition distance(eventPlayer.getPosition(), vect(blood_money_mine_pos.x, blood_money_mine_pos.y - 2, blood_money_mine_pos.z)) <= 5
    @Condition eventPlayer.isAlive() == true
    
    damage(eventPlayer, null, eventPlayer.getMaxHealth() * 0.15)
    eventPlayer.random_blood_money = random.randint(300, 500)
    eventPlayer.gold += eventPlayer.random_blood_money
    smallMessage(eventPlayer, "get {0} gold".format(localPlayer.random_blood_money))
    wait(0.5)
    if ruleCondition:
        loop()
