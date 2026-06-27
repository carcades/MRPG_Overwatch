#!mainFile "../main.opy"

rule "Hero Change":
    @Event eachPlayer
    @Condition distance(eventPlayer, vect(select_hero_point.x, select_hero_point.y - 1, select_hero_point.z)) <= 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    logToInspector("[HERO SELECT] Player {0} pressed Interact. Zone: {1}, Dist: {2}".format(eventPlayer, eventPlayer.current_zone, distance(eventPlayer.getPosition(), spawn_bubble_position)))
    eventPlayer.is_selection_hero = true
    eventPlayer.current_zone = Zone.NONE
    eventPlayer.setAllowedHeroes(getAllHeroes().exclude(eventPlayer.getHero()))
    eventPlayer.setAllowedHeroes(getAllHeroes())
    waitUntil(eventPlayer.getHero() in getAllHeroes(), 99999)
    logToInspector("[HERO SELECT] Player {0} selected {1}. Zone: {2}".format(eventPlayer, eventPlayer.getHero(), eventPlayer.current_zone))
    eventPlayer.teleport(respawn_point)
    logToInspector("[HERO SELECT] Player {0} teleported. Zone: {1}".format(eventPlayer, eventPlayer.current_zone))
    eventPlayer.is_selection_hero = false
    if eventPlayer.ability_celestial_fire == true:
        #chance()
        pass
