#!mainFile "../main.opy"

rule "Player HUD text":
    wait(5)
    progressBarHud(getAllPlayers(), localPlayer.xp * 100 / 100, "XP", HudPosition.LEFT, 0, localPlayer.xp_bar_color, Color.BLACK, ProgressHudReeval.VALUES_AND_COLOR)
    hudSubheader(getAllPlayers(), getAverageServerLoad(), HudPosition.RIGHT, 99, Color.RED, HudReeval.STRING)
    hudSubheader(getAllPlayers(), "level up points: {0}".format(localPlayer.level_up_points), HudPosition.RIGHT, 0, Color.VIOLET, HudReeval.STRING)
    hudSubheader(getAllPlayers(), "gold: {0}".format(localPlayer.gold), HudPosition.RIGHT, 1, Color.YELLOW, HudReeval.STRING)
    hudSubheader(getAllPlayers().filter(lambda _: localPlayer.emeralds >= 1), "emeralds: {0}".format(localPlayer.emeralds), HudPosition.RIGHT, 2, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)
    
    hudSubheader(localPlayer if len(localPlayer.hud_buff_names) > 0 else null, "[ {0} ] - {1}".format(localPlayer.hud_buff_names[0], "permanent" if localPlayer.hud_buff_expires[0] > 900000 else "{0}s".format(max(0, round(localPlayer.hud_buff_expires[0] - getTotalTimeElapsed())))), HudPosition.RIGHT, 100, localPlayer.hud_buff_colors[0], HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR)
    hudSubheader(localPlayer if len(localPlayer.hud_buff_names) > 1 else null, "[ {0} ] - {1}".format(localPlayer.hud_buff_names[1], "permanent" if localPlayer.hud_buff_expires[1] > 900000 else "{0}s".format(max(0, round(localPlayer.hud_buff_expires[1] - getTotalTimeElapsed())))), HudPosition.RIGHT, 101, localPlayer.hud_buff_colors[1], HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR)
    hudSubheader(localPlayer if len(localPlayer.hud_buff_names) > 2 else null, "[ {0} ] - {1}".format(localPlayer.hud_buff_names[2], "permanent" if localPlayer.hud_buff_expires[2] > 900000 else "{0}s".format(max(0, round(localPlayer.hud_buff_expires[2] - getTotalTimeElapsed())))), HudPosition.RIGHT, 102, localPlayer.hud_buff_colors[2], HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR)
    hudSubheader(localPlayer if len(localPlayer.hud_buff_names) > 3 else null, "[ {0} ] - {1}".format(localPlayer.hud_buff_names[3], "permanent" if localPlayer.hud_buff_expires[3] > 900000 else "{0}s".format(max(0, round(localPlayer.hud_buff_expires[3] - getTotalTimeElapsed())))), HudPosition.RIGHT, 103, localPlayer.hud_buff_colors[3], HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR)
    hudSubheader(localPlayer if len(localPlayer.hud_buff_names) > 4 else null, "[ {0} ] - {1}".format(localPlayer.hud_buff_names[4], "permanent" if localPlayer.hud_buff_expires[4] > 900000 else "{0}s".format(max(0, round(localPlayer.hud_buff_expires[4] - getTotalTimeElapsed())))), HudPosition.RIGHT, 104, localPlayer.hud_buff_colors[4], HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR)
