#!mainFile "../main.opy"

rule "Player HUD text":
    wait(5)
    progressBarHud(getAllPlayers(), localPlayer.xp * 100 / 100, "XP", HudPosition.LEFT, 0, localPlayer.xp_bar_color, Color.BLACK, ProgressHudReeval.VALUES_AND_COLOR)
    hudSubheader(getAllPlayers(), getAverageServerLoad(), HudPosition.RIGHT, 99, Color.RED, HudReeval.STRING)
    hudSubheader(getAllPlayers(), "level up points: {0}".format(localPlayer.level_up_points), HudPosition.RIGHT, 0, Color.VIOLET, HudReeval.STRING)
    hudSubheader(getAllPlayers(), "gold: {0}".format(localPlayer.gold), HudPosition.RIGHT, 1, Color.YELLOW, HudReeval.STRING)
    hudSubheader(getAllPlayers().filter(lambda _: localPlayer.emeralds >= 1), "emeralds: {0}".format(localPlayer.emeralds), HudPosition.RIGHT, 2, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)
