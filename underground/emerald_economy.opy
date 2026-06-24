#!mainFile "../main.opy"

def update_emrld_economic_parameters():
    @Name "Sub: update of emeralds economic parameters"
    
    if eventPlayer.event_emerald_cost_vector == EmeraldCostVector.UP_PRICE:
        current_emerald_cost += round(start_emerald_cost * 0.1)
        curr_emrld_mining_prgrss_delay += start_emrld_mining_prgrss_delay * 0.08
    elif eventPlayer.event_emerald_cost_vector == EmeraldCostVector.DOWN_PRICE:
        if round(current_emerald_cost - start_emerald_cost * 0.1) >= emerald_min_cost:
            current_emerald_cost -= round(start_emerald_cost * 0.1)
        if curr_emrld_mining_prgrss_delay - start_emrld_mining_prgrss_delay * 0.08 >= start_emrld_mining_prgrss_delay:
            curr_emrld_mining_prgrss_delay -= start_emrld_mining_prgrss_delay * 0.08
    buy_emerald_cost = round(current_emerald_cost * 1.15)


rule "buy emeralds":
    @Event eachPlayer
    @Condition eventPlayer.current_zone == Zone.UNDERGROUND
    @Condition distance(eventPlayer.getPosition(), vect(buy_emeralds_pos.x, buy_emeralds_pos.y - 1, buy_emeralds_pos.z)) <= 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    if eventPlayer.gold >= buy_emerald_cost:
        if eventPlayer.isHoldingButton(Button.CROUCH) == true:
            eventPlayer.emeralds++
            eventPlayer.gold -= buy_emerald_cost
            eventPlayer.event_emerald_cost_vector = EmeraldCostVector.UP_PRICE
            update_emrld_economic_parameters()
            wait(0.1)
            if ruleCondition:
                loop()
        else:
            eventPlayer.emeralds++
            eventPlayer.gold -= buy_emerald_cost
            eventPlayer.event_emerald_cost_vector = EmeraldCostVector.UP_PRICE
            update_emrld_economic_parameters()
    else:
        smallMessage(eventPlayer, "not enough gold")


rule "sell emeralds":
    @Event eachPlayer
    @Condition eventPlayer.current_zone == Zone.UNDERGROUND
    @Condition distance(eventPlayer.getPosition(), vect(sell_emeralds_pos.x, sell_emeralds_pos.y - 1, sell_emeralds_pos.z)) <= 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    if eventPlayer.emeralds >= 1:
        if eventPlayer.isHoldingButton(Button.CROUCH) == true:
            eventPlayer.emeralds--
            eventPlayer.gold += current_emerald_cost
            eventPlayer.event_emerald_cost_vector = EmeraldCostVector.DOWN_PRICE
            update_emrld_economic_parameters()
            wait(0.1)
            if ruleCondition:
                loop()
        else:
            eventPlayer.emeralds--
            eventPlayer.gold += current_emerald_cost
            eventPlayer.event_emerald_cost_vector = EmeraldCostVector.DOWN_PRICE
            update_emrld_economic_parameters()
    else:
        smallMessage(eventPlayer, "not enough emeralds")
