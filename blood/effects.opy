#!mainFile "../main.opy"

rule "B&s text":
    wait(3)
    #Seppuku
    createInWorldText(getAllPlayers(), "SEPPUKU (reset lvl & stats)\r\n   give you blood points.", vect(seppuku_pos.x, seppuku_pos.y + 1.25, seppuku_pos.z), 2, Clip.SURFACES, WorldTextReeval.NONE, Color.RED, SpecVisibility.ALWAYS)
    createInWorldText(getAllPlayers().filter(lambda player: player.in_bubble == true and distance(player.getPosition(), vect(132.2, 64.3, -170.147)) <= 6), "level to next seppuku: {0}\r\ncurrent seppuku level: {1}".format(localPlayer.level_to_seppuku, localPlayer.seppuku_level), vect(132.2, 64.3, -170.147), 1.75, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.ORANGE)
    #blood shop spawn text
    createInWorldText(getAllPlayers(), "BLOOD SHOP", vect(136.408, 66, -170.686), 2.25, Clip.SURFACES, WorldTextReeval.NONE, Color.RED)
    createInWorldText(getAllPlayers().filter(lambda player: player.in_blood_shop == true), "CURRENT BLOOD: {0}".format(localPlayer.blood_points), vect(136.112, 65.5, -173.297), 2, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.RED)
    #blood buy
    createInWorldText(getAllPlayers().filter(lambda player: player.in_blood_shop == true), "buy vampire\r\ncur. level: {0}\r\ncost: {1} blood".format(localPlayer.vampire_level, localPlayer.vampire_cost), vect(buy_blood_vampire_pos.x, buy_blood_vampire_pos.y + 1.5, buy_blood_vampire_pos.z), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.RED)
    createInWorldText(getAllPlayers().filter(lambda player: player.in_blood_shop == true), "buy bleeding\ncur. level: {0}\r\ncost: {1} blood".format(localPlayer.bleeding_level, localPlayer.bleeding_cost), vect(buy_bleeding_blood_pos.x, buy_bleeding_blood_pos.y + 2.4, buy_bleeding_blood_pos.z), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.RED)
    createInWorldText(getAllPlayers().filter(lambda player: player.in_blood_shop == true), "buy bloody xp boost\r (0.2)\ncur. xp multipy: {0}\r\ncost: {1} blood".format(localPlayer.xp_multi, localPlayer.blood_xp_cost), vect(buy_blood_xp_multi_pos.x, buy_blood_xp_multi_pos.y + 1.5, buy_blood_xp_multi_pos.z), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.RED)


rule "B&s effects":
    wait(3.1)
    createEffect(getAllPlayers(), Effect.RING, Color.RED, seppuku_pos, 1, EffectReeval.NONE)
    #BLOOD shop
    createEffect(getAllPlayers(), Effect.RING, Color.RED, enter_blood_shop_pos, 1, EffectReeval.NONE)
    createEffect(getAllPlayers().filter(lambda _: localPlayer.in_altar == false), Effect.RING, Color.RED, exit_blood_shop_pos, 1, EffectReeval.VISIBILITY)
    #BLOOD wall
    #createEffect(getAllPlayers().filter(lambda _: localPlayer.in_blood_shop == true), Effect.LIGHT_SHAFT, Color.RED, vect(150.499, 60, -170.734), 1, EffectReeval.VISIBILITY)
    createEffect(getAllPlayers().filter(lambda _: localPlayer.in_blood_shop == true), Effect.BAD_AURA, Color.GRAY, vect(149.529, 61.947, -170.663), 4, EffectReeval.VISIBILITY)
    #createEffect(getAllPlayers().filter(lambda _: localPlayer.in_blood_shop == true), Effect.LIGHT_SHAFT, Color.RED, vect(148.537, 60, -170.734), 1, EffectReeval.VISIBILITY)
    #blood shop
    createEffect(getAllPlayers().filter(lambda player: player.in_blood_shop == true), Effect.RING, Color.ROSE, buy_blood_xp_multi_pos, 1, EffectReeval.VISIBILITY)
    createEffect(getAllPlayers().filter(lambda player: player.in_blood_shop == true), Effect.RING, Color.ROSE, buy_blood_vampire_pos, 1, EffectReeval.VISIBILITY)
    createEffect(getAllPlayers().filter(lambda player: player.in_blood_shop == true), Effect.RING, Color.ROSE, buy_bleeding_blood_pos, 1, EffectReeval.VISIBILITY)
