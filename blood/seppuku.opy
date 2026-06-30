#!mainFile "../main.opy"

rule "Shop seppuku":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(seppuku_pos, eventPlayer.getPosition()) <= 1
    
    if eventPlayer.level >= eventPlayer.level_to_seppuku:
        smallMessage(eventPlayer, "hold interact for 5 seconds to do seppuku")
        if eventPlayer.seppuku_level > 0:
            goto lbl_0
        eventPlayer.status_text_pluses = " "
        lbl_0:
        wait(5, Wait.ABORT_WHEN_FALSE)
        kill(eventPlayer, eventPlayer)
        eventPlayer.seppuku_level++
        eventPlayer.blood_points = round(eventPlayer.level_to_seppuku / 4 + eventPlayer.blood_points + ((eventPlayer.level - eventPlayer.level_to_seppuku) * 0.1))
        eventPlayer.level_to_seppuku += 10
        #Reset
        eventPlayer.base_stats = [0, 0, 0, 0, 100, 100, 100, 100, 100, 100]
        eventPlayer.level = 0
        eventPlayer.level_up_points = 0
        eventPlayer.gold = 0
        eventPlayer.xp = 0
        #Upgrade stats limits
        eventPlayer.stats_limit[0] += 100
        eventPlayer.stats_limit[1] += 100
        eventPlayer.stats_limit[2] += 10
        #update stats
        eventPlayer.apply_all_stats()
        eventPlayer.setScore(eventPlayer.level)
        #Respawn
        waitUntil(eventPlayer.isAlive(), 99999)
        eventPlayer.teleport(respawn_point)
        #+ to race
        eventPlayer.status_text_pluses = "{0}+".format(eventPlayer.status_text_pluses)
        smallMessage(eventPlayer, "YOU KILLED YOURSELF AND GET SOME BLOOD")
    else:
        smallMessage(eventPlayer, "you need level {0} to do seppuku".format(eventPlayer.level_to_seppuku))
