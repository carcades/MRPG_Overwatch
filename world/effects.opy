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
    createInWorldText(getAllPlayers().filter(lambda player: distance(xp_mining_pos, player) <= 30), "                                             xp mining\n+0.002 waiting time 1 xp per person in a circle\n                      \r\n\u0009", vect(xp_mining_pos.x, xp_mining_pos.y + 3, xp_mining_pos.z), 2, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.WHITE, SpecVisibility.ALWAYS)
    #emerald mine effect 
    createProgressBarInWorldText(getAllPlayers().filter(lambda _: localPlayer.current_zone == Zone.EMERALD_MINE), localPlayer.emerald_mining_progress * 100 / 100, "emerald mine", vect(emerald_mine_cord.x, emerald_mine_cord.y + 0.7, emerald_mine_cord.z), 1.7, Clip.NONE, rgb(50, 145, 70), rgb(40, 130, 70), ProgressWorldTextReeval.VISIBILITY_AND_VALUES)
    createInWorldText(getAllPlayers().filter(lambda _: localPlayer.current_zone != Zone.EMERALD_MINE), "Emerald Mine", vect(emerald_mine_cord.x, emerald_mine_cord.y + 0.85, emerald_mine_cord.z), 2, Clip.SURFACES, WorldTextReeval.VISIBILITY, rgb(60, 175, 90))
    createInWorldText(getAllPlayers(), "emerald course: {0}".format(current_emerald_cost), vect(69.488, 65.836, -177.297), 1.5, Clip.SURFACES, WorldTextReeval.STRING, rgb(80, 175, 120))
