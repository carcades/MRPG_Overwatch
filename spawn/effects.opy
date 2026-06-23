#!mainFile "../main.opy"

rule "Spawn effects":
    wait(3)
    #spawn bubble
    createEffect(getAllPlayers(), Effect.SPHERE, Color.ORANGE, vect(spawn_bubble_position.x, spawn_bubble_position.y - 1, spawn_bubble_position.z), 46, EffectReeval.NONE)
    createInWorldText(getAllPlayers().filter(lambda _: localPlayer.in_bubble == true), "ctrl + f to fast buy\r\n1 level up point to buy", spawn_description_pos, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #stats shop
    createEffect(getAllPlayers(), Effect.RING, Color.RED, vect(buy_damage_pos.x, buy_damage_pos.y + -1, buy_damage_pos.z), 1, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.GREEN, vect(buy_health_pos.x, buy_health_pos.y + -1, buy_health_pos.z), 1, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.WHITE, vect(buy_speed_pos.x, buy_speed_pos.y + -1, buy_speed_pos.z), 1, EffectReeval.NONE)
    #select hero
    createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, vect(select_hero_point.x, select_hero_point.y - 1, select_hero_point.z), 1, EffectReeval.NONE)
    #ancient altar
    createEffect(getAllPlayers(), Effect.RING, Color.TURQUOISE, enter_altar_pos, 1.3, EffectReeval.VISIBILITY)


rule "Spawn text":
    wait(3)
    #Stats
    createInWorldText(getAllPlayers(), "buy speed\r", vect(buy_speed_pos.x, buy_speed_pos.y + 0, buy_speed_pos.z), 1.5, Clip.SURFACES, WorldTextReeval.NONE, Color.WHITE, SpecVisibility.ALWAYS)
    createInWorldText(getAllPlayers(), "buy damage", vect(buy_damage_pos.x, buy_damage_pos.y + 0, buy_damage_pos.z), 1.5, Clip.SURFACES, WorldTextReeval.NONE, Color.RED, SpecVisibility.ALWAYS)
    createInWorldText(getAllPlayers(), "buy health", vect(buy_health_pos.x, buy_health_pos.y + 0, buy_health_pos.z), 1.5, Clip.SURFACES, WorldTextReeval.NONE, Color.GREEN, SpecVisibility.ALWAYS)
    #select hero
    createInWorldText(getAllPlayers(), "select a hero", vect(select_hero_point.x, select_hero_point.y + 0.15, select_hero_point.z), 1.2, Clip.SURFACES, WorldTextReeval.NONE)
