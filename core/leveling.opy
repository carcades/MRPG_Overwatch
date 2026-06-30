#!mainFile "../main.opy"

def update_color_xp_bar():
    @Name "Sub: change color of hp bar"
    
    if xp_bar_colors_length <= eventPlayer.xp:
        eventPlayer.xp_bar_color = xp_bar_colors[999]
    else:
        eventPlayer.xp_bar_color = xp_bar_colors[eventPlayer.xp]


rule "Level Up":
    @Event eachPlayer
    @Condition eventPlayer.xp >= XP_TO_LEVEL_UP
    @Condition eventPlayer.player_init == true
    
    eventPlayer.level++
    eventPlayer.xp -= XP_TO_LEVEL_UP
    eventPlayer.level_up_points += random.randint(3, 5)
    eventPlayer.setScore(eventPlayer.level)
    update_color_xp_bar()
    #+ STAT DAMAGE PER LEVEL
    eventPlayer.stats_plus = random.randint(3, 5)
    if eventPlayer.statLimitDamage >= eventPlayer.base_stat_damage + eventPlayer.stats_plus:
        eventPlayer.base_stat_damage += eventPlayer.stats_plus
        eventPlayer.apply_all_stats()
    elif eventPlayer.base_stat_damage < eventPlayer.statLimitDamage:
        eventPlayer.base_stat_damage = eventPlayer.statLimitDamage
        eventPlayer.apply_all_stats()
    #+STAT MAX HEALTH PER LEVEL
    eventPlayer.stats_plus = random.randint(3, 5)
    if eventPlayer.statLimitHealth >= eventPlayer.base_stat_health + eventPlayer.stats_plus:
        eventPlayer.base_stat_health += eventPlayer.stats_plus
        eventPlayer.apply_all_stats()
        heal(eventPlayer, null, 50)
    elif eventPlayer.base_stat_health < eventPlayer.statLimitHealth:
        eventPlayer.base_stat_health = eventPlayer.statLimitHealth
        eventPlayer.apply_all_stats()
    #+STAT SPEED PER LEVEL
    if eventPlayer.statLimitSpeed > eventPlayer.base_stat_speed:
        eventPlayer.base_stat_speed += 0.5
        eventPlayer.apply_all_stats()
    wait(0.5)
    if ruleCondition:
        loop()
