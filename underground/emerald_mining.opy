#!mainFile "../main.opy"

rule "Get Emerald":
    @Event eachPlayer
    @Condition eventPlayer.emerald_mining_progress >= 100
    
    eventPlayer.emerald_mining_progress -= 100
    eventPlayer.emeralds++
    smallMessage(eventPlayer, "get 1 emerald")
    eventPlayer.event_emerald_cost_vector = EmeraldCostVector.UP_PRICE
    update_emrld_economic_parameters()


rule "Emerald mining":
    @Event eachPlayer
    @Condition eventPlayer.player_init == true
    @Condition eventPlayer.is_selection_hero == false
    @Condition eventPlayer.in_emerald_mine == true
    #@Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.emerald_mining_progress++
    wait(curr_emrld_mining_prgrss_delay)
    if ruleCondition:
        loop()


rule "Player enter emerald mine":
    @Event eachPlayer
    @Condition distance(eventPlayer.getPosition(), emerald_mine_cord) <= 4
    
    eventPlayer.in_emerald_mine = true


rule "Player leave emerald mine":
    @Event eachPlayer
    @Condition distance(eventPlayer.getPosition(), emerald_mine_cord) > 4
    
    eventPlayer.in_emerald_mine = false
