#!mainFile "../main.opy"

rule "World Objects effects":
    wait(4)
    createEffect(getAllPlayers(), Effect.RING, Color.VIOLET, vect(xp_mining_pos.x, xp_mining_pos.y - 1, xp_mining_pos.z), 7, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.RED, vect(blood_money_mine_pos.x, blood_money_mine_pos.y - 2, blood_money_mine_pos.z), 5, EffectReeval.NONE)
    #emerald mine ring
    createEffect(getAllPlayers(), Effect.RING, Color.GREEN, vect(emerald_mine_cord.x, emerald_mine_cord.y + -0.18, emerald_mine_cord.z), 4, EffectReeval.NONE)


rule "World Objects text":
    wait(4)
    #Xp mining text
    createInWorldText(getAllPlayers(), "                                             xp mining\n+0.002 waiting time 1 xp per person in a circle\n                      \r\n\u0009" if distance(xp_mining_pos, localPlayer) <= 30 else " ", vect(xp_mining_pos.x, xp_mining_pos.y + 3, xp_mining_pos.z), 2, Clip.SURFACES, WorldTextReeval.STRING, Color.WHITE, SpecVisibility.ALWAYS)
    #emerald mine effect 
    createProgressBarInWorldText(getAllPlayers(), localPlayer.emerald_mining_progress * 100 / 100 if localPlayer.current_zone == Zone.EMERALD_MINE else 0, "emerald mine" if localPlayer.current_zone == Zone.EMERALD_MINE else " ", vect(emerald_mine_cord.x, emerald_mine_cord.y + 0.7, emerald_mine_cord.z) if localPlayer.current_zone == Zone.EMERALD_MINE else vect(0, -999, 0), 1.7, Clip.SURFACES, rgb(50, 145, 70), rgb(40, 130, 70), ProgressWorldTextReeval.POSITION_AND_VALUES)
    createInWorldText(getAllPlayers(), "Emerald Mine" if localPlayer.current_zone != Zone.EMERALD_MINE else " ", vect(emerald_mine_cord.x, emerald_mine_cord.y + 0.85, emerald_mine_cord.z), 2, Clip.SURFACES, WorldTextReeval.STRING, rgb(60, 175, 90))
    createInWorldText(getAllPlayers(), "emerald course: {0}".format(current_emerald_cost), vect(69.488, 65.836, -177.297), 1.5, Clip.SURFACES, WorldTextReeval.STRING, rgb(80, 175, 120))
