#!mainFile "../main.opy"

rule "Xp mining":
    @Event eachPlayer
    @Condition eventPlayer.player_init == true
    @Condition eventPlayer.is_selection_hero == false
    @Condition distance(xp_mining_pos, eventPlayer.getPosition()) <= 7
    @Condition eventPlayer.isAlive() == true
    
    wait(wait_xp, Wait.ABORT_WHEN_FALSE)
    eventPlayer.xp += eventPlayer.xp_multi * xp_per_mine
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    update_color_xp_bar()
    if ruleCondition:
        loop()


rule "Players in xp mining | WaitXp":
    players_in_xp_mine = getAllPlayers().filter(lambda player: distance(player, xp_mining_pos) < 7)
    wait_xp = 0.002 * len(players_in_xp_mine) + 0.02
    wait(1)
    loop()
