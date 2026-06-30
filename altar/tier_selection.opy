#!mainFile "../main.opy"

rule "Show description":
    @Event eachPlayer
    @Condition eventPlayer.current_zone == Zone.ALTAR
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    eventPlayer.description_visibility_status = 1


rule "Hide description":
    @Event eachPlayer
    @Condition eventPlayer.current_zone == Zone.ALTAR
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false
    
    eventPlayer.description_visibility_status = 0


rule ">>>>>> Selection Tier-2 Race <<<<<<":
    @Event eachPlayer
    @Condition eventPlayer.current_zone == Zone.ALTAR
    @Condition eventPlayer.altar_status == AltarStatus.TIER_2_SELECTION
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    #get reader race
    if distance(vect(altar_left_1_point.x, altar_left_1_point.y - 1, altar_left_1_point.z), eventPlayer.getPosition()) <= 1:
        smallMessage(eventPlayer, "hold interact 5 sec to select this path")
        wait(5, Wait.ABORT_WHEN_FALSE)
        eventPlayer.altar_status = AltarStatus.READER
        eventPlayer.current_race = ["Reader", 2, rgb(125, 155, 235), getAllPlayers()]
        # angelic branch data: [abilities, prayer_iter, holy_circle_iter, holy_circle_iter_plus,
        #                       salv_progress, salv_cast_dur, salv_can_cast_moving, salv_is_active, salv_speed_bonus, salv_duration, salv_original_cast_dur, salv_sound,
        #                       cour_progress, cour_cast_dur, cour_can_cast_moving, cour_added_dmg_received, cour_added_damage, cour_duration, cour_original_cast_dur, cour_sound,
        #                       cour_is_active, cour_iter, salv_stacks, cour_stacks]
        eventPlayer.branch_data = [true, 0, 0, 0, 0, 0, false, false, 0, 0, 0, null, 0, 0, false, 0, 0, 0, 0, null, false, 0, 0, 0]
        
        # nested arrays
        eventPlayer.branch_t1_hud_ids = [null, null]
        eventPlayer.branch_t1_active_effects = []
        eventPlayer.branch_t2_hud_ids = [null, null]
        eventPlayer.branch_t2_active_effects = []
        disable_altar_effects()
        race_change_tp()
    #get demon worshiper race
    elif distance(vect(altar_right_1_point.x, altar_right_1_point.y - 1, altar_right_1_point.z), eventPlayer.getPosition()) <= 1:
        smallMessage(eventPlayer, "hold interact 5 sec to select this path")
        wait(5, Wait.ABORT_WHEN_FALSE)
        eventPlayer.altar_status = AltarStatus.DEMON_WORSHIPER
        eventPlayer.current_race = ["Demon Worshiper", 2, rgb(204, 85, 0), getAllPlayers()]
        # demonic branch data: [is_angelic, base_threshold, duration, damage_bonus]
        eventPlayer.branch_data = [false, 150, 5, 10]
        
        # apply ash layer passive (20% dmg reduction)
        eventPlayer.base_stat_damage_received = 80
        eventPlayer.apply_all_stats()
        
        # Add to HUD buff array
        eventPlayer.trackHud(BuffId.DEMON_ASH_LAYER, 9999999, "{0} Ash Layer".format(iconString(Icon.SKULL)), Color.GRAY)
        
        disable_altar_effects()
        race_change_tp()


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
