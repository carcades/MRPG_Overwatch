#!mainFile "../main.opy"

#def tier_up_reset():
#    @Name "Sub: tier up reset"
#    pass


def create_status_text():
    @Name "Sub: Create status text"
    
    createInWorldText(([] if eventPlayer.current_zone in [Zone.ALTAR, Zone.BLOOD_SHOP, Zone.UNDERGROUND, Zone.RELIC_TREASURY] else eventPlayer.current_race[3]), "{0}{1}".format(eventPlayer.current_race[0], " {0} x{1}".format(iconString(Icon.SKULL), eventPlayer.cursedMarkStacks) if localPlayer.altar_status == AltarStatus.DEMON_WORSHIPER and eventPlayer.cursedMarkStacks > 0 else ""), eventPlayer, eventPlayer.current_race[1], Clip.SURFACES, WorldTextReeval.VISIBILITY_STRING_AND_COLOR, eventPlayer.current_race[2])
    eventPlayer.trackPersistentEntity(getLastCreatedText(), GcType.IN_WORLD_TEXT)


def race_change_tp():
    @Name "Sub: Race change teleport"
    
    eventPlayer.teleport(vect(155.838, 61.347, -159.493))
    eventPlayer.setFacing(vect(1, 0.05, 0.04), Relativity.TO_WORLD)


def disable_altar_effects():
    @Name "Sub: disable all effects in altar"
    
    eventPlayer.altar_description_text = ["", ""]
    #text
    eventPlayer.altar_left_1_text = false
    eventPlayer.altar_left_2_text = false
    eventPlayer.altar_left_3_text = false
    eventPlayer.altar_right_1_text = false
    eventPlayer.altar_right_2_text = false
    eventPlayer.altar_right_3_text = false
    #rings
    eventPlayer.altar_left_1_ring = [Color.BLACK, false]
    eventPlayer.altar_right_1_ring = [Color.BLACK, false]
