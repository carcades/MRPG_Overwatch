#!mainFile "../main.opy"

rule "Update description visibility status":
    @Event eachPlayer
    @Condition eventPlayer.in_altar == true
    
    if eventPlayer.isHoldingButton(Button.CROUCH) == true:
        eventPlayer.description_visibility_status = 1
    else:
        eventPlayer.description_visibility_status = 0
    wait(0.05)
    if ruleCondition:
        loop()


rule ">>>>>> Selection Tier-2 Race <<<<<<":
    @Event eachPlayer
    @Condition eventPlayer.in_altar == true
    @Condition eventPlayer.altar_status == AltarStatus.TIER_2_SELECTION
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    #get reader race
    if distance(vect(altar_left_1_point.x, altar_left_1_point.y - 1, altar_left_1_point.z), eventPlayer.getPosition()) <= 1:
        smallMessage(eventPlayer, "hold interact 5 sec to select this path")
        wait(5, Wait.ABORT_WHEN_FALSE)
        eventPlayer.altar_status = AltarStatus.READER
        eventPlayer.current_race = ["Reader", 2, rgb(125, 155, 235), eventPlayer]
        #reader prayer of salvation: [casting_progress, [prayer_hud_progress_id, prayer_in-world_progress_id], speed_prayer_casting,
        #start_cast_pos, casting_in_motion, has_pr_effects, added_to_speed, duration_of_prayer_fight_effects, speed_casting_duplicat, sound]
        eventPlayer.reader_prayer_of_salvation = [0, [null, null], null, null, false, false, null, null, null, null, null]
        #reader prayer of salvation: [prayer_progress, [prayer_hud_progress_id, prayer_in-world_progress_id], speed_prayer_casting,
        #start_cast_pos, casting_in_motion, added_to_dmg_received, added_to_damage, duration_of_prayer_fight_effects, speed_casting_duplicat]
        eventPlayer.reader_prayer_for_courage = [0, [null, null], null, null, false, null, null, null, null]
        eventPlayer.reader_abilities = true
        disable_altar_effects()
        race_change_tp()
    #get demon worshiper race
    elif distance(vect(altar_right_1_point.x, altar_right_1_point.y - 1, altar_right_1_point.z), eventPlayer.getPosition()) <= 1:
        smallMessage(eventPlayer, "2")


def enable_display_tier_2_effects():
    @Name "Sub: enable display of tier 2 selection effects"
    
    #altar text init; array[text_1, text_2, text_1_size, text_2_size]
    eventPlayer.altar_description_text = ["hold ctrl \r\nto see description", "now you can reset\r\nyour stats by choosing\r\na tier 2 race\r"]
    #races text
    eventPlayer.altar_left_1_text = ["reader", "the path represented by the\r\nranks of the church hierarchy \r\nwho possess various divine powers:\r\nTier 2 - reader", rgb(120, 150, 235), rgb(140, 175, 235)]
    eventPlayer.altar_right_1_text = ["demon worshiper", "the sequence consists of \r\nvarious races using black magic \r\nand the powers of the devil\r:\ntier 2 - demon worshiper\r", rgb(204, 85, 0), rgb(255, 127, 80)]
    #ring color init
    eventPlayer.altar_left_1_ring = [Color.BLUE, true]
    eventPlayer.altar_right_1_ring = [Color.RED, true]
