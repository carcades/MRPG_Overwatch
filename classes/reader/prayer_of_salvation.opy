#!mainFile "../../main.opy"

rule "Reader Ability: prayer for salvation":
    @Event eachPlayer
    #@Condition eventPlayer.readerAbilities == true
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.current_zone == Zone.NONE
    
    if eventPlayer.isAlive() == false or eventPlayer.prayerCanCastMoving == false and eventPlayer.isMoving():
        smallMessage(eventPlayer, "you cant say a prayer if you die or in motion")
        wait(0.5)
    #start casting the prayer 
    else:
        #create_reader_holy_circle()
        #speed of casting prayer
        eventPlayer.prayerCastDuration = 30 - ((eventPlayer.current_tier - 1) * 5 if eventPlayer.current_tier <= 5 else 20)
        eventPlayer.prayerOriginalCastDur = eventPlayer.prayerCastDuration
        #create casting UI effects
        progressBarHud(eventPlayer, eventPlayer.prayerProgress * 100 / eventPlayer.prayerCastDuration, "recitation of prayer", HudPosition.LEFT, 0, rgb(110, 130, 240), Color.BLACK, ProgressHudReeval.VALUES)
        eventPlayer.prayerHudIds = [getLastCreatedText(), null]
        createProgressBarInWorldText(getAllPlayers(), eventPlayer.prayerProgress * 100 / eventPlayer.prayerCastDuration, "recitation of prayer", vect(eventPlayer.getEyePosition().x, eventPlayer.getEyePosition().y + 1, eventPlayer.getEyePosition().z), 0.8, Clip.SURFACES, rgb(110, 130, 240), Color.BLACK, ProgressWorldTextReeval.POSITION_AND_VALUES)
        eventPlayer.prayerHudIds = [eventPlayer.prayerHudBarId, getLastCreatedText()]
        createEffect(getAllPlayers(), Effect.ENERGY_SOUND, Color.TEAM_1, eventPlayer, 200)
        eventPlayer.prayerSoundEffectId = getLastCreatedEntity()
        #if player can casting the prayer in motion
        if eventPlayer.prayerCanCastMoving == true:
            eventPlayer.readerPrayerIter = 0
            while eventPlayer.readerPrayerIter < eventPlayer.prayerCastDuration:
                if eventPlayer.isAlive() == true:
                    eventPlayer.prayerProgress++
                    wait(0.25)
                else:
                    smallMessage(eventPlayer, "the recitation of the prayer has been discontinued")
                    eventPlayer.prayerCastDuration = 0
                    break
                eventPlayer.readerPrayerIter++
        #if player cant casting prayer in motion
        else:
            eventPlayer.readerPrayerIter = 0
            while eventPlayer.readerPrayerIter < eventPlayer.prayerCastDuration:
                if eventPlayer.isAlive() == true and eventPlayer.isMoving() == false:
                    wait(0.25)
                    eventPlayer.prayerProgress++
                else:
                    smallMessage(eventPlayer, "the recitation of the prayer has been discontinued")
                    eventPlayer.prayerCastDuration = 0
                    break
                eventPlayer.readerPrayerIter++
        #destroy prayer casting effects
        #destroy_reader_holy_circle()
        destroyEffect(eventPlayer.prayerSoundEffectId)
        destroyProgressBarHud(eventPlayer.prayerHudBarId)
        destroyProgressBarInWorldText(eventPlayer.prayerWorldBarId)
        #if the reading of the prayer is successful
        if eventPlayer.prayerProgress == eventPlayer.prayerOriginalCastDur:
            eventPlayer.prayerDuration = 20 + (5 * (eventPlayer.current_tier - 1))
            #if player has no prayer effects (first cast)
            if eventPlayer.prayerIsActive != true:
                smallMessage(eventPlayer, "prayer is not alr going")
                #play one-shot visual/sound effects
                playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.BLUE, eventPlayer, 8)
                #create ana nano boost visual buff
                createEffect(getAllPlayers(), Effect.ANA_NANO_BOOSTED, Color.TEAM_2, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                wait()
                eventPlayer.buff_append_args = [BuffId.PRAYER_VISUAL, getLastCreatedEntity(), getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.ENTITY]
                logToInspector("PRAYER: Adding visual buff. Args: {0}".format(eventPlayer.buff_append_args))
                add_buff()
                #add health pool 
                eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.stat_health / 3, true, false)
                wait()
                eventPlayer.buff_append_args = [BuffId.PRAYER_HEALTH_POOL, getLastCreatedHealthPool(), getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.HEALTH_BAR]
                logToInspector("PRAYER: Adding health pool. Args: {0}".format(eventPlayer.buff_append_args))
                add_buff()
                #heal over time
                eventPlayer.startHealingOverTime(eventPlayer, 100000000, eventPlayer.stat_health / 5 + ((eventPlayer.current_tier - 1) * 10))
                wait()
                eventPlayer.buff_append_args = [BuffId.PRAYER_HEAL_OVER_TIME, getLastHealingOverTimeId(), getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.HEAL_OVER_TIME]
                logToInspector("PRAYER: Adding HOT. Args: {0}".format(eventPlayer.buff_append_args))
                add_buff()
                #add speed
                eventPlayer.prayerSpeedBonus = evalOnce(eventPlayer.stat_speed * (0.2 + ((eventPlayer.current_tier - 1) * 0.1)))
                eventPlayer.stat_speed += eventPlayer.prayerSpeedBonus
                eventPlayer.setMoveSpeed(eventPlayer.stat_speed)
                eventPlayer.buff_append_args = [BuffId.PRAYER_SPEED, eventPlayer, getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.SPEED, EffectAction.SUBTRACT, eventPlayer.prayerSpeedBonus]
                smallMessage(eventPlayer, "prayer duration: {0}".format(eventPlayer.prayerDuration))
                logToInspector("PRAYER: Adding speed buff. Args: {0}".format(eventPlayer.buff_append_args))
                add_buff()
                #player has prayer effects = True
                eventPlayer.prayerIsActive = true
                eventPlayer.buff_append_args = [BuffId.PRAYER_ACTIVE_FLAG, eventPlayer, getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.PLAYER_VARIABLE, EffectAction.EXISTENCE_PRAYER_OF_SALVATION]
                logToInspector("PRAYER: Adding active flag. Args: {0}".format(eventPlayer.buff_append_args))
                add_buff()
                logToInspector("PRAYER: First cast complete. Active buffs count: {0}".format(len(eventPlayer.active_buff_ids)))
            #if player already has prayer effects (re-cast)
            else:
                smallMessage(eventPlayer, "prayer alr going")
                #play one-shot visual/sound effects
                playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.BLUE, eventPlayer, 8)
                #extend or recreate visual buff
                eventPlayer.buff_append_args = [BuffId.PRAYER_VISUAL, null, getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.ENTITY]
                logToInspector("PRAYER: Extending visual buff. Args: {0}".format(eventPlayer.buff_append_args))
                extend_buff()
                if eventPlayer.temp_var_1 == -1:
                    logToInspector("PRAYER: Visual buff not found. Re-creating.")
                    #visual buff already expired, recreate it
                    createEffect(getAllPlayers(), Effect.ANA_NANO_BOOSTED, Color.TEAM_2, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                    wait()
                    eventPlayer.buff_append_args = [BuffId.PRAYER_VISUAL, getLastCreatedEntity(), getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.ENTITY]
                    logToInspector("PRAYER: Visual buff recreated args: {0}".format(eventPlayer.buff_append_args))
                    add_buff()
                #stack health pool (always add new)
                eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.stat_health / 3, true, false)
                wait()
                eventPlayer.buff_append_args = [BuffId.PRAYER_HEALTH_POOL, getLastCreatedHealthPool(), getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.HEALTH_BAR]
                logToInspector("PRAYER: Adding stack health pool args: {0}".format(eventPlayer.buff_append_args))
                add_buff()
                #extend or recreate heal over time
                eventPlayer.buff_append_args = [BuffId.PRAYER_HEAL_OVER_TIME, null, getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.HEAL_OVER_TIME]
                logToInspector("PRAYER: Extending HOT args: {0}".format(eventPlayer.buff_append_args))
                extend_buff()
                if eventPlayer.temp_var_1 == -1:
                    logToInspector("PRAYER: HOT not found. Re-creating.")
                    #heal over time already expired, recreate it
                    eventPlayer.startHealingOverTime(eventPlayer, 100000000, eventPlayer.stat_health / 5 + ((eventPlayer.current_tier - 1) * 10))
                    wait()
                    eventPlayer.buff_append_args = [BuffId.PRAYER_HEAL_OVER_TIME, getLastHealingOverTimeId(), getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.HEAL_OVER_TIME]
                    logToInspector("PRAYER: HOT recreated args: {0}".format(eventPlayer.buff_append_args))
                    add_buff()
                #extend or recreate speed buff
                eventPlayer.buff_append_args = [BuffId.PRAYER_SPEED, eventPlayer, getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.SPEED, EffectAction.SUBTRACT, eventPlayer.prayerSpeedBonus]
                logToInspector("PRAYER: Extending speed buff args: {0}".format(eventPlayer.buff_append_args))
                extend_buff()
                if eventPlayer.temp_var_1 == -1:
                    logToInspector("PRAYER: Speed buff not found. Re-creating.")
                    #speed buff already expired, re-add it
                    eventPlayer.prayerSpeedBonus = evalOnce(eventPlayer.stat_speed * (0.2 + ((eventPlayer.current_tier - 1) * 0.1)))
                    eventPlayer.stat_speed += eventPlayer.prayerSpeedBonus
                    eventPlayer.setMoveSpeed(eventPlayer.stat_speed)
                    eventPlayer.buff_append_args = [BuffId.PRAYER_SPEED, eventPlayer, getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.SPEED, EffectAction.SUBTRACT, eventPlayer.prayerSpeedBonus]
                    logToInspector("PRAYER: Speed buff recreated args: {0}".format(eventPlayer.buff_append_args))
                    add_buff()
                #extend or recreate active flag
                eventPlayer.buff_append_args = [BuffId.PRAYER_ACTIVE_FLAG, eventPlayer, getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.PLAYER_VARIABLE, EffectAction.EXISTENCE_PRAYER_OF_SALVATION]
                logToInspector("PRAYER: Extending active flag args: {0}".format(eventPlayer.buff_append_args))
                extend_buff()
                if eventPlayer.temp_var_1 == -1:
                    logToInspector("PRAYER: Active flag not found. Re-creating.")
                    #active flag expired, re-set it
                    eventPlayer.prayerIsActive = true
                    logToInspector("PRAYER: Active flag recreated.")
                    add_buff()
                logToInspector("PRAYER: Re-cast complete. Active buffs count: {0}".format(len(eventPlayer.active_buff_ids)))
    eventPlayer.prayerProgress = 0
