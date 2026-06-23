#!mainFile "../../main.opy"

rule "Reader Ability: prayer for salvation":
    @Event eachPlayer
    #@Condition eventPlayer.reader_abilities == true
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.in_altar == false
    @Condition eventPlayer.in_underground == false
    @Condition eventPlayer.in_blood_shop == false
    
    if eventPlayer.isAlive() == false or eventPlayer.prayerCanCastMoving == false and eventPlayer.isMoving():
        smallMessage(eventPlayer, "you cant say a prayer if you die or in motion")
        wait(0.5)
    #start casting the prayer 
    else:
        create_reader_holy_circle()
        #speed of casting parayer
        eventPlayer.prayerCastDuration = 30 - ((eventPlayer.current_tier - 1) * 5 if eventPlayer.current_tier <= 5 else 20)
        eventPlayer.prayerOriginalCastDur = eventPlayer.prayerCastDuration
        #create effects
        progressBarHud(eventPlayer, eventPlayer.prayerProgress * 100 / eventPlayer.prayerCastDuration, "recitation of prayer", HudPosition.LEFT, 0, rgb(110, 130, 240), Color.BLACK, ProgressHudReeval.VALUES)
        eventPlayer.prayerHudIds = [getLastCreatedText(), null]
        createProgressBarInWorldText(getAllPlayers(), eventPlayer.prayerProgress * 100 / eventPlayer.prayerCastDuration, "recitation of prayer", vect(eventPlayer.getEyePosition().x, eventPlayer.getEyePosition().y + 1, eventPlayer.getEyePosition().z), 0.8, Clip.SURFACES, rgb(110, 130, 240), Color.BLACK, ProgressWorldTextReeval.POSITION_AND_VALUES)
        eventPlayer.prayerHudIds = [eventPlayer.prayerHudBarId, getLastCreatedText()]
        createEffect(getAllPlayers(), Effect.ENERGY_SOUND, Color.TEAM_1, eventPlayer, 200)
        eventPlayer.prayerSoundEffectId = getLastCreatedEntity()
        #if player can casting the prayer in motion
        if eventPlayer.prayerCanCastMoving == true:
            for eventPlayer.reader_prayer_iter in range(eventPlayer.prayerCastDuration):
                if eventPlayer.isAlive() == true:
                    eventPlayer.prayerProgress++
                    wait(0.25)
                else:
                    smallMessage(eventPlayer, "the recitation of the prayer has been discontinued")
                    eventPlayer.prayerCastDuration = 0
                    break
        #if player cant casting prayer in motion
        else:
            for eventPlayer.reader_prayer_iter in range(eventPlayer.prayerCastDuration):
                if eventPlayer.isAlive() == true and eventPlayer.isMoving() == false:
                    wait(0.25)
                    eventPlayer.prayerProgress++
                else:
                    smallMessage(eventPlayer, "the recitation of the prayer has been discontinued")
                    eventPlayer.prayerCastDuration = 0
                    break
        #destroy prayer casting effects
        destroy_reader_holy_circle()
        destroyEffect(eventPlayer.prayerSoundEffectId)
        destroyProgressBarHud(eventPlayer.prayerHudBarId)
        destroyProgressBarInWorldText(eventPlayer.prayerWorldBarId)
        #if the reading of the prayer is successful
        if eventPlayer.prayerProgress == eventPlayer.prayerOriginalCastDur:
            eventPlayer.prayerDuration = 20 + (5 * (eventPlayer.current_tier - 1))
            #if player has no prayer effects
            if eventPlayer.prayerIsActive != true:
                smallMessage(eventPlayer, "prayer is not alr going")
                #effects
                playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.BLUE, eventPlayer, 8)
                createEffect(getAllPlayers(), Effect.ANA_NANO_BOOSTED, Color.TEAM_2, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                #add effects to effects_to_be_destroyed_array
                effects_array_append_args = [getLastCreatedEntity(), getTotalTimeElapsed() + eventPlayer.prayerDuration, "entity"]
                append_to_del_effects_array()
                eventPlayer.prayerActiveEffects = [effects_array_append_args]
                #add health pool 
                eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.getMaxHealth() / 3, true, false)
                #add health pool to effects_to_be_destroyed_array
                effects_array_append_args = [getLastCreatedHealthPool(), getTotalTimeElapsed() + eventPlayer.prayerDuration, "health_bar"]
                append_to_del_effects_array()
                eventPlayer.prayerActiveEffects.append(effects_array_append_args)
                #heal over time
                eventPlayer.startHealingOverTime(eventPlayer, 100000000, eventPlayer.getMaxHealth() / 5 + ((eventPlayer.current_tier - 1) * 10))
                #add heal over time to effects_to_be_destroyed_array
                effects_array_append_args = [getLastHealingOverTimeId(), getTotalTimeElapsed() + eventPlayer.prayerDuration, "heal_over_time"]
                append_to_del_effects_array()
                eventPlayer.prayerActiveEffects.append(effects_array_append_args)
                #add speed
                eventPlayer.prayerSpeedBonus = evalOnce(eventPlayer.stat_speed * (0.2 + ((eventPlayer.current_tier - 1) * 0.1)))
                eventPlayer.stat_speed += eventPlayer.prayerSpeedBonus
                eventPlayer.setMoveSpeed(eventPlayer.stat_speed)
                #add speed to effects_to_be_destroyed_array
                effects_array_append_args = [eventPlayer, getTotalTimeElapsed() + eventPlayer.prayerDuration, "speed", "subtract", eventPlayer.prayerSpeedBonus]
                smallMessage(eventPlayer, "prayer duration: {0}".format(eventPlayer.prayerDuration))
                append_to_del_effects_array()
                eventPlayer.prayerActiveEffects.append(effects_array_append_args)
                #player has prayer effects = True
                eventPlayer.prayerIsActive = true
                effects_array_append_args = [eventPlayer, getTotalTimeElapsed() + eventPlayer.prayerDuration, "player_variable", "existence_prayer_of_salvation"]
                append_to_del_effects_array()
                eventPlayer.prayerActiveEffects.append(effects_array_append_args)
            # if player already has praeyr effects 
            else:
                smallMessage(eventPlayer, "prayer alr going")
                
                # visual effects for re-cast
                playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.BLUE, eventPlayer, 8)

                # extension prayer effects (ana visual buff effect [0])
                eventPlayer.temp_array = eventPlayer.prayerActiveEffects[0]
                eventPlayer.temp_var_0 = effects_to_be_destroyed_array.map(lambda x: "{0}{1}".format(x[EffectEntry.TARGET], x[EffectEntry.TYPE])).index("{0}{1}".format(eventPlayer.temp_array[EffectEntry.TARGET], eventPlayer.temp_array[EffectEntry.TYPE]))
                eventPlayer.temp_array[EffectEntry.EXPIRE_TIME] = getTotalTimeElapsed() + eventPlayer.prayerDuration
                if eventPlayer.temp_var_0 != -1:
                    effects_to_be_destroyed_array[eventPlayer.temp_var_0] = eventPlayer.temp_array
                eventPlayer.prayerActiveEffects[0] = eventPlayer.temp_array

                # stack health pool [1]
                eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.getMaxHealth() / 3, true, false)
                effects_array_append_args = [getLastCreatedHealthPool(), getTotalTimeElapsed() + eventPlayer.prayerDuration, "health_bar"]
                append_to_del_effects_array()

                # extension prayer heal over time [2]
                eventPlayer.temp_array = eventPlayer.prayerActiveEffects[2]
                eventPlayer.temp_var_0 = effects_to_be_destroyed_array.map(lambda x: "{0}{1}".format(x[EffectEntry.TARGET], x[EffectEntry.TYPE])).index("{0}{1}".format(eventPlayer.temp_array[EffectEntry.TARGET], eventPlayer.temp_array[EffectEntry.TYPE]))
                eventPlayer.temp_array[EffectEntry.EXPIRE_TIME] = getTotalTimeElapsed() + eventPlayer.prayerDuration
                if eventPlayer.temp_var_0 != -1:
                    effects_to_be_destroyed_array[eventPlayer.temp_var_0] = eventPlayer.temp_array
                eventPlayer.prayerActiveEffects[2] = eventPlayer.temp_array

                # extension prayer speed effect [3]
                eventPlayer.temp_array = eventPlayer.prayerActiveEffects[3]
                eventPlayer.temp_var_0 = effects_to_be_destroyed_array.map(lambda x: "{0}{1}".format(x[EffectEntry.TARGET], x[EffectEntry.TYPE])).index("{0}{1}".format(eventPlayer.temp_array[EffectEntry.TARGET], eventPlayer.temp_array[EffectEntry.TYPE]))
                eventPlayer.temp_array[EffectEntry.EXPIRE_TIME] = getTotalTimeElapsed() + eventPlayer.prayerDuration
                if eventPlayer.temp_var_0 != -1:
                    effects_to_be_destroyed_array[eventPlayer.temp_var_0] = eventPlayer.temp_array
                eventPlayer.prayerActiveEffects[3] = eventPlayer.temp_array

                # extension variable prayer effects [4]
                eventPlayer.temp_array = eventPlayer.prayerActiveEffects[4]
                eventPlayer.temp_var_0 = effects_to_be_destroyed_array.map(lambda x: "{0}{1}".format(x[EffectEntry.TARGET], x[EffectEntry.TYPE])).index("{0}{1}".format(eventPlayer.temp_array[EffectEntry.TARGET], eventPlayer.temp_array[EffectEntry.TYPE]))
                eventPlayer.temp_array[EffectEntry.EXPIRE_TIME] = getTotalTimeElapsed() + eventPlayer.prayerDuration
                if eventPlayer.temp_var_0 != -1:
                    effects_to_be_destroyed_array[eventPlayer.temp_var_0] = eventPlayer.temp_array
                eventPlayer.prayerActiveEffects[4] = eventPlayer.temp_array
    eventPlayer.prayerProgress = 0
