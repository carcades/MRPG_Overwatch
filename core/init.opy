#!mainFile "../main.opy"

rule "Init":
    getAllPlayers().disableRespawn()
    disableMusic()
    disableScoring()
    disableAnnouncer()
    disableGamemodeCompletion()
    setMatchTime(0)
    #general
    xp_to_level_up = 100
    xp_per_mine = 10
    #emeralds
    start_emerald_cost = 150
    current_emerald_cost = start_emerald_cost
    buy_emerald_cost = round(current_emerald_cost * 1.15)
    emerald_min_cost = start_emerald_cost
    start_emrld_mining_prgrss_delay = 0.016
    curr_emrld_mining_prgrss_delay = start_emrld_mining_prgrss_delay



rule "Player Init":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.player_init == false
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.teleport(respawn_point)
    #STATS limit: health, damage, speed
    eventPlayer.stats_limit = [500, 500, 125]
    #stats init
    eventPlayer.stat_healing_received = 100
    eventPlayer.stat_damage = 100
    eventPlayer.stat_health = 100
    eventPlayer.stat_speed = 100
    eventPlayer.stat_damage_received = 100
    eventPlayer.stat_projectiles_speed = 100
    #currency
    eventPlayer.level_up_points = 100
    #xp mining init
    eventPlayer.xp_multi = 1
    #race init [race_name, race_text_size, race_text_color]
    eventPlayer.current_race = ["Human", 2, rgb(180, 190, 185), getAllPlayers()]
    eventPlayer.current_tier = 1
    create_status_text()
    #seppuku init
    eventPlayer.seppuku_level = 3
    eventPlayer.level_to_seppuku = 40
    #blood upgrades cost
    eventPlayer.blood_xp_cost = 5
    eventPlayer.bleeding_cost = 10
    eventPlayer.vampire_cost = 10
    #altar rings initiate
    eventPlayer.altar_left_1_ring = [rgb(0, 0, 0), false]
    eventPlayer.altar_left_2_ring = [rgb(0, 0, 0), false]
    #player init = true
    eventPlayer.current_zone = Zone.NONE
    eventPlayer.active_buff_ids = []
    eventPlayer.active_buff_targets = []
    eventPlayer.active_buff_expire_times = []
    eventPlayer.active_buff_types = []
    eventPlayer.active_buff_actions = []
    eventPlayer.active_buff_values = []
    eventPlayer.player_init = true


rule "Init xp bar colors":
    #colors of xp bar init: r, g, b; start, end
    rgb_start_xp_bar = [0, 0, 0]
    rgb_end_xp_bar = [238, 32, 77]
    #rgb: r, g, b; min, max
    rgb_min_xp_bar = [min(rgb_start_xp_bar[0], rgb_end_xp_bar[0]), min(rgb_start_xp_bar[1], rgb_end_xp_bar[1]), min(rgb_start_xp_bar[2], rgb_end_xp_bar[2])]
    rgb_max_xp_bar = [max(rgb_start_xp_bar[0], rgb_end_xp_bar[0]), max(rgb_start_xp_bar[1], rgb_end_xp_bar[1]), max(rgb_start_xp_bar[2], rgb_end_xp_bar[2])]
    #get vector R (rgb[0])
    if rgb_min_xp_bar[0] != rgb_start_xp_bar[0]:
        rgb_vector_xp_bar = [1]
    else:
        rgb_vector_xp_bar = [-1]
    #get vector G (rgb[1])
    if rgb_min_xp_bar[1] != rgb_start_xp_bar[1]:
        rgb_vector_xp_bar.append(1)
    else:
        rgb_vector_xp_bar.append(-1)
    #get vector B (rgb[2])
    if rgb_min_xp_bar[2] != rgb_start_xp_bar[2]:
        rgb_vector_xp_bar.append(1)
    else:
        rgb_vector_xp_bar.append(-1)
    xp_bar_colors_length = xp_to_level_up + 900
    #get xp_bar colors 0-100
    xp_bar_colors = [null]
    for iterations in range(1, xp_to_level_up + 1):
        xp_bar_colors.append(rgb(rgb_start_xp_bar[0] - (iterations * ((rgb_max_xp_bar[0] - rgb_min_xp_bar[0]) / xp_to_level_up)) if rgb_vector_xp_bar[0] == 1 else rgb_start_xp_bar[0] + (iterations * ((rgb_max_xp_bar[0] - rgb_min_xp_bar[0]) / xp_to_level_up)), rgb_start_xp_bar[1] - (iterations * ((rgb_max_xp_bar[1] - rgb_min_xp_bar[1]) / xp_to_level_up)) if rgb_vector_xp_bar[1] == 1 else rgb_start_xp_bar[1] + (iterations * ((rgb_max_xp_bar[1] - rgb_min_xp_bar[1]) / xp_to_level_up)), rgb_start_xp_bar[2] - (iterations * ((rgb_max_xp_bar[2] - rgb_min_xp_bar[2]) / xp_to_level_up)) if rgb_vector_xp_bar[2] == 1 else rgb_start_xp_bar[2] + (iterations * ((rgb_max_xp_bar[2] - rgb_min_xp_bar[2]) / xp_to_level_up))))
        wait(0.05)
    #get high xp colors to dark
    if rgb_start_xp_bar[0] + rgb_start_xp_bar[1] + rgb_start_xp_bar[2] >= rgb_end_xp_bar[0] + rgb_end_xp_bar[1] + rgb_end_xp_bar[2]:
        for iterations in range(xp_to_level_up + 1, xp_to_level_up + 902):
            xp_bar_colors.append(rgb(rgb_end_xp_bar[0] - iterations * (rgb_end_xp_bar[0] / 1000), rgb_end_xp_bar[1] - iterations * (rgb_end_xp_bar[1] / 1000), rgb_end_xp_bar[2] - iterations * (rgb_end_xp_bar[2] / 1000)))
            wait(0.05)
    #get high xp colors to light
    else:
        for iterations in range(xp_to_level_up + 1, xp_to_level_up + 902):
            xp_bar_colors.append(rgb(rgb_end_xp_bar[0] + (iterations * ((255 - rgb_end_xp_bar[0]) / 1000)), rgb_end_xp_bar[1] + (iterations * ((255 - rgb_end_xp_bar[1]) / 1000)), rgb_end_xp_bar[2] + (iterations * ((255 - rgb_end_xp_bar[2]) / 1000))))
            wait(0.05)


rule "Color: yellow-gold":
    @Disabled
    
    color_yellow_gold = rgb(255, 215, 0)
    wait(0.1)
    color_yellow_gold = rgb(251, 210, 3)
    wait(0.1)
    color_yellow_gold = rgb(248, 205, 6)
    wait(0.1)
    color_yellow_gold = rgb(244, 200, 10)
    wait(0.1)
    color_yellow_gold = rgb(240, 195, 13)
    wait(0.1)
    color_yellow_gold = rgb(236, 190, 16)
    wait(0.1)
    color_yellow_gold = rgb(233, 185, 19)
    wait(0.1)
    color_yellow_gold = rgb(229, 180, 22)
    wait(0.1)
    color_yellow_gold = rgb(225, 175, 26)
    wait(0.1)
    color_yellow_gold = rgb(222, 170, 29)
    wait(0.1)
    color_yellow_gold = rgb(218, 165, 32)
    wait(0.1)
    loop()

rule "Init Dummy Bot for Testing":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.player_init == false
    
    wait(1, Wait.IGNORE_CONDITION)
    createInWorldText(getAllPlayers(), "Dummy{0}".format(" {0} x{1}".format(iconString(Icon.SKULL), eventPlayer.cursedMarkStacks) if eventPlayer.cursedMarkStacks > 0 else ""), eventPlayer, 2, Clip.SURFACES, WorldTextReeval.VISIBILITY_STRING_AND_COLOR, Color.WHITE)
    eventPlayer.player_init = true
