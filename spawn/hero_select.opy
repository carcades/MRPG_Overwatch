#!mainFile "../main.opy"

rule "Hero Change":
    @Event eachPlayer
    @Condition distance(eventPlayer, vect(select_hero_point.x, select_hero_point.y - 1, select_hero_point.z)) <= 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    logToInspector("[HERO SELECT] Player {0} pressed Interact. Zone: {1}, Dist: {2}".format(eventPlayer, eventPlayer.current_zone, distance(eventPlayer.getPosition(), spawn_bubble_position)))
    eventPlayer.is_selection_hero = true
    eventPlayer.setAllowedHeroes(getAllHeroes().exclude(eventPlayer.getHero()))
    eventPlayer.setAllowedHeroes(getAllHeroes())
    if eventPlayer.ability_celestial_fire == true:
        #chance()
        pass
