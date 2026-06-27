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
    if eventPlayer.statLimitDamage >= eventPlayer.stat_damage + eventPlayer.stats_plus:
        eventPlayer.stat_damage += eventPlayer.stats_plus
        eventPlayer.setDamageDealt(eventPlayer.stat_damage)
    elif eventPlayer.stat_damage < eventPlayer.statLimitDamage:
        eventPlayer.stat_damage = eventPlayer.statLimitDamage
        eventPlayer.setDamageDealt(eventPlayer.stat_damage)
    #+STAT MAX HEALTH PER LEVEL
    eventPlayer.stats_plus = random.randint(3, 5)
    if eventPlayer.statLimitHealth >= eventPlayer.stat_health + eventPlayer.stats_plus:
        eventPlayer.stat_health += eventPlayer.stats_plus
        eventPlayer.setMaxHealth(eventPlayer.stat_health)
        heal(eventPlayer, null, 50)
    elif eventPlayer.stat_health < eventPlayer.statLimitHealth:
        eventPlayer.stat_health = eventPlayer.statLimitHealth
        eventPlayer.setMaxHealth(eventPlayer.stat_health)
    #+STAT SPEED PER LEVEL
    if eventPlayer.statLimitSpeed > eventPlayer.stat_speed:
        eventPlayer.stat_speed += 0.5
        eventPlayer.setMoveSpeed(eventPlayer.stat_speed)
    wait(0.5)
    if ruleCondition:
        loop()
