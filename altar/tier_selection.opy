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
        # reader data: [abilities, prayer_iter, holy_circle_iter, holy_circle_iter_plus, 
        #               salv_progress, salv_cast_dur, salv_can_cast_moving, salv_is_active, salv_speed_bonus, salv_duration, salv_original_cast_dur, salv_sound,
        #               cour_progress, cour_cast_dur, cour_can_cast_moving, cour_added_dmg_received, cour_added_damage, cour_duration, cour_original_cast_dur, cour_sound]
        eventPlayer.reader_data = [true, 0, 0, 0, 0, 0, false, false, 0, 0, 0, null, 0, 0, false, 0, 0, 0, 0, null]
        
        # nested arrays initialized in separate variables
        eventPlayer.reader_prayer_hud_ids = [null, null]
        eventPlayer.reader_prayer_active_effects = []
        eventPlayer.reader_courage_hud_ids = [null, null]
        eventPlayer.reader_courage_active_effects = []
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
