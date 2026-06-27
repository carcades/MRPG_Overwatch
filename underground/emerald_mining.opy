#!mainFile "../main.opy"

rule "Get Emerald":
    @Event eachPlayer
    @Condition eventPlayer.emerald_mining_progress >= 100
    
    eventPlayer.emerald_mining_progress -= 100
    eventPlayer.emeralds++
    smallMessage(eventPlayer, "get 1 emerald")
    eventPlayer.event_emerald_cost_vector = EmeraldCostVector.UP_PRICE
    update_emrld_economic_parameters()


rule "Mining start":
    @Event eachPlayer
    @Condition eventPlayer.current_zone == Zone.EMERALD_MINE
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.emerald_mining_progress++
    wait(curr_emrld_mining_prgrss_delay)
    if ruleCondition:
        loop()


rule "Enter emerald mine area":
    @Event eachPlayer
    @Condition eventPlayer.is_selection_hero == false
    @Condition distance(eventPlayer.getPosition(), emerald_mine_cord) <= 2
    
    eventPlayer.current_zone = Zone.EMERALD_MINE


rule "Leave emerald mine area":
    @Event eachPlayer
    @Condition distance(eventPlayer.getPosition(), emerald_mine_cord) > 2
    
    eventPlayer.current_zone = Zone.UNDERGROUND
