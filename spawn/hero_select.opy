#!mainFile "../main.opy"

rule "Hero Change":
    @Event eachPlayer
    @Condition distance(eventPlayer, vect(select_hero_point.x, select_hero_point.y - 1, select_hero_point.z)) <= 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    eventPlayer.is_selection_hero = true
    eventPlayer.setAllowedHeroes(getAllHeroes().exclude(eventPlayer.getHero()))
    eventPlayer.setAllowedHeroes(getAllHeroes())
    waitUntil(eventPlayer.getHero() in getAllHeroes(), 99999)
    eventPlayer.teleport(respawn_point)
    eventPlayer.is_selection_hero = false
    if eventPlayer.ability_celestial_fire == true:
        #chance()
        pass
