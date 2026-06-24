#!mainFile "../main.opy"

rule "Ug effects":
    wait(4)
    #enter&exit
    createEffect(getAllPlayers(), Effect.RING, Color.BLUE, vect(underground_enter_pos.x, underground_enter_pos.y - 1.5, underground_enter_pos.z), 1, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.BLUE, vect(underground_exit_pos.x, underground_exit_pos.y - 1.5, underground_exit_pos.z), 1, EffectReeval.NONE)
    #emeralds
    createEffect(getAllPlayers().filter(lambda _: localPlayer.current_zone == Zone.UNDERGROUND), Effect.RING, Color.GREEN, sell_emeralds_pos, 1, EffectReeval.VISIBILITY)
    createEffect(getAllPlayers().filter(lambda _: localPlayer.current_zone == Zone.UNDERGROUND), Effect.RING, Color.GREEN, buy_emeralds_pos, 1, EffectReeval.VISIBILITY)


rule "Ug text":
    wait(4)
    #Ug enter&exit
    createInWorldText(getAllPlayers(), "Enter underground", underground_enter_pos, 1.3, Clip.SURFACES, WorldTextReeval.NONE, Color.BLUE)
    createInWorldText(getAllPlayers().filter(lambda _: localPlayer.current_zone == Zone.UNDERGROUND), "exit", underground_exit_pos, 1.7, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.BLUE)
    #emeradls
    createInWorldText(getAllPlayers().filter(lambda _: localPlayer.current_zone == Zone.UNDERGROUND), "sell emeralds \r\nfor: {0}".format(current_emerald_cost), sell_emeralds_pos, 1.4, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, rgb(60, 175, 90))
    createInWorldText(getAllPlayers().filter(lambda _: localPlayer.current_zone == Zone.UNDERGROUND), "buy emeralds\r\nfor: {0}".format(buy_emerald_cost), buy_emeralds_pos, 1.4, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, rgb(60, 175, 90))
