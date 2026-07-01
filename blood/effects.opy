#!mainFile "../main.opy"

rule "Blood texts and rings":
    @Event global
    wait(3)
    #Seppuku
    createInWorldText(getAllPlayers(), "SEPPUKU (reset lvl & stats)\r\n   give you blood points." if localPlayer.current_zone == Zone.BUBBLE else " ", vect(seppuku_pos.x, seppuku_pos.y + 1.55, seppuku_pos.z), 2, Clip.SURFACES, WorldTextReeval.STRING, Color.RED, SpecVisibility.ALWAYS)
    createInWorldText(getAllPlayers(), "level to next seppuku: {0}\r\ncurrent seppuku level: {1}".format(localPlayer.level_to_seppuku, localPlayer.seppuku_level) if localPlayer.current_zone == Zone.BUBBLE and distance(localPlayer.getPosition(), seppuku_pos) <= 6 else " ", vect(seppuku_pos.x, seppuku_pos.y + 1.6, seppuku_pos.z), 1.75, Clip.SURFACES, WorldTextReeval.STRING, Color.ORANGE)
    #blood shop spawn text
    createInWorldText(getAllPlayers(), "BLOOD SHOP" if localPlayer.current_zone == Zone.BUBBLE else " ", vect(136.408, 66, -170.686), 2.25, Clip.SURFACES, WorldTextReeval.STRING, Color.RED)
    createInWorldText(getAllPlayers(), "CURRENT BLOOD: {0}".format(localPlayer.blood_points) if localPlayer.current_zone == Zone.BLOOD_SHOP else " ", vect(136.112, 65.5, -173.297), 2, Clip.SURFACES, WorldTextReeval.STRING, Color.RED)
    #blood buy
    createInWorldText(getAllPlayers(), "buy vampire\r\ncur. level: {0}\r\ncost: {1} blood".format(localPlayer.vampireLevel, localPlayer.vampire_cost) if localPlayer.current_zone == Zone.BLOOD_SHOP else " ", vect(buy_blood_vampire_pos.x, buy_blood_vampire_pos.y + 1.5, buy_blood_vampire_pos.z), 1, Clip.SURFACES, WorldTextReeval.STRING, Color.RED)
    createInWorldText(getAllPlayers(), "buy bleeding\ncur. level: {0}\r\ncost: {1} blood".format(localPlayer.bleedingLevel, localPlayer.bleeding_cost) if localPlayer.current_zone == Zone.BLOOD_SHOP else " ", vect(buy_bleeding_blood_pos.x, buy_bleeding_blood_pos.y + 2.4, buy_bleeding_blood_pos.z), 1, Clip.SURFACES, WorldTextReeval.STRING, Color.RED)
    createInWorldText(getAllPlayers(), "buy bloody xp boost\r (0.2)\ncur. xp multipy: {0}\r\ncost: {1} blood".format(localPlayer.xp_multi, localPlayer.blood_xp_cost) if localPlayer.current_zone == Zone.BLOOD_SHOP else " ", vect(buy_blood_xp_multi_pos.x, buy_blood_xp_multi_pos.y + 1.5, buy_blood_xp_multi_pos.z), 1, Clip.SURFACES, WorldTextReeval.STRING, Color.RED)

    #BLOOD shop effects
    createEffect(getAllPlayers(), Effect.RING, Color.RED, seppuku_pos, 1, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.RED, enter_blood_shop_pos, 1, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.RED, exit_blood_shop_pos if localPlayer.current_zone != Zone.ALTAR else vect(0, -999, 0), 1, EffectReeval.POSITION_AND_RADIUS)
    #BLOOD wall
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.GRAY, vect(149.529, 61.947, -170.663) if localPlayer.current_zone == Zone.BLOOD_SHOP else vect(0, -999, 0), 4, EffectReeval.POSITION_AND_RADIUS)
    #blood shop
    createEffect(getAllPlayers(), Effect.RING, Color.ROSE, buy_blood_xp_multi_pos if localPlayer.current_zone == Zone.BLOOD_SHOP else vect(0, -999, 0), 1, EffectReeval.POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.RING, Color.ROSE, buy_blood_vampire_pos if localPlayer.current_zone == Zone.BLOOD_SHOP else vect(0, -999, 0), 1, EffectReeval.POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.RING, Color.ROSE, buy_bleeding_blood_pos if localPlayer.current_zone == Zone.BLOOD_SHOP else vect(0, -999, 0), 1, EffectReeval.POSITION_AND_RADIUS)
