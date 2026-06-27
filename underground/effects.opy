#!mainFile "../main.opy"

rule "Ug effects":
    wait(4)
    #enter&exit
    createEffect(getAllPlayers(), Effect.RING, Color.BLUE, vect(underground_enter_pos.x, underground_enter_pos.y - 1.5, underground_enter_pos.z), 1, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.BLUE, vect(underground_exit_pos.x, underground_exit_pos.y - 1.5, underground_exit_pos.z), 1, EffectReeval.NONE)
    #emeralds
    createEffect(getAllPlayers(), Effect.RING, Color.GREEN, sell_emeralds_pos if localPlayer.current_zone == Zone.UNDERGROUND else vect(0, -999, 0), 1, EffectReeval.POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.RING, Color.GREEN, buy_emeralds_pos if localPlayer.current_zone == Zone.UNDERGROUND else vect(0, -999, 0), 1, EffectReeval.POSITION_AND_RADIUS)
    #wall
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.GRAY, wall_underground_pos if localPlayer.current_zone == Zone.UNDERGROUND else vect(0, -999, 0), 4, EffectReeval.POSITION_AND_RADIUS)


rule "Ug text":
    wait(4)
    #Ug enter&exit
    createInWorldText(getAllPlayers(), "Enter underground" if localPlayer.current_zone == Zone.BUBBLE else " ", vect(underground_enter_pos.x, underground_enter_pos.y + 0.3, underground_enter_pos.z), 1.3, Clip.SURFACES, WorldTextReeval.STRING, Color.BLUE)
    createInWorldText(getAllPlayers(), "exit" if localPlayer.current_zone == Zone.UNDERGROUND else " ", underground_exit_pos, 1.7, Clip.SURFACES, WorldTextReeval.STRING, Color.BLUE)
    #emeradls
    createInWorldText(getAllPlayers(), "sell emeralds \r\nfor: {0}".format(current_emerald_cost) if localPlayer.current_zone == Zone.UNDERGROUND else " ", sell_emeralds_pos, 1.4, Clip.SURFACES, WorldTextReeval.STRING, rgb(60, 175, 90))
    createInWorldText(getAllPlayers(), "buy emeralds\r\nfor: {0}".format(buy_emerald_cost) if localPlayer.current_zone == Zone.UNDERGROUND else " ", buy_emeralds_pos, 1.4, Clip.SURFACES, WorldTextReeval.STRING, rgb(60, 175, 90))
