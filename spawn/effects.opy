#!mainFile "../main.opy"

rule "Spawn effects":
    wait(3)
    #spawn bubble
    createEffect(getAllPlayers(), Effect.SPHERE, Color.ORANGE, vect(spawn_bubble_position.x, spawn_bubble_position.y - 1, spawn_bubble_position.z), 46, EffectReeval.NONE)
    createInWorldText(getAllPlayers(), "ctrl + f to fast buy\r\n1 level up point to buy" if localPlayer.current_zone == Zone.BUBBLE else " ", spawn_description_pos, 1.5, Clip.SURFACES, WorldTextReeval.STRING)
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
    createInWorldText(getAllPlayers(), "buy speed\r" if localPlayer.current_zone == Zone.BUBBLE else " ", vect(buy_speed_pos.x, buy_speed_pos.y + 0.3, buy_speed_pos.z), 1.5, Clip.SURFACES, WorldTextReeval.STRING, Color.WHITE, SpecVisibility.ALWAYS)
    createInWorldText(getAllPlayers(), "buy damage" if localPlayer.current_zone == Zone.BUBBLE else " ", vect(buy_damage_pos.x, buy_damage_pos.y + 0.3, buy_damage_pos.z), 1.5, Clip.SURFACES, WorldTextReeval.STRING, Color.RED, SpecVisibility.ALWAYS)
    createInWorldText(getAllPlayers(), "buy health" if localPlayer.current_zone == Zone.BUBBLE else " ", vect(buy_health_pos.x, buy_health_pos.y + 0.3, buy_health_pos.z), 1.5, Clip.SURFACES, WorldTextReeval.STRING, Color.GREEN, SpecVisibility.ALWAYS)
    #select hero
    createInWorldText(getAllPlayers(), "select a hero" if localPlayer.current_zone == Zone.BUBBLE else " ", vect(select_hero_point.x, select_hero_point.y + 0.45, select_hero_point.z), 1.2, Clip.SURFACES, WorldTextReeval.STRING)
    #ancient altar
    createInWorldText(getAllPlayers(), "Altar Of Rebirth" if localPlayer.current_zone == Zone.BUBBLE else " ", vect(enter_altar_pos.x, enter_altar_pos.y + 1.5, enter_altar_pos.z), 1.6, Clip.SURFACES, WorldTextReeval.STRING_AND_COLOR, rgb(120 + 80 * sinDeg(getTotalTimeElapsed() * 100), 120 + 80 * cosDeg(getTotalTimeElapsed() * 130), 255), SpecVisibility.DEFAULT)
