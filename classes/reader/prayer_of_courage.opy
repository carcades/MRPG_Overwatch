#!mainFile "../../main.opy"

rule "Reader Ability: prayer of courage":
    @Event eachPlayer
    #@Condition eventPlayer.readerAbilities == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.current_zone == Zone.NONE
    
    if eventPlayer.isAlive() == false or eventPlayer.courageCanCastMoving == false and eventPlayer.isMoving():
        smallMessage(eventPlayer, "you cant say a prayer if you die or in motion")
        wait(0.5)
    #start casting the prayer 
    else:
        #create_reader_holy_circle()
        #speed of casting prayer
        eventPlayer.courageCastDuration = 30 - ((eventPlayer.current_tier - 1) * 5 if eventPlayer.current_tier <= 5 else 20)
        eventPlayer.courageOriginalCastDur = eventPlayer.courageCastDuration
        #create casting UI effects
        progressBarHud(eventPlayer, eventPlayer.courageProgress * 100 / eventPlayer.courageCastDuration, "recitation of courage prayer", HudPosition.LEFT, 0, Color.YELLOW, Color.BLACK, ProgressHudReeval.VALUES)
        eventPlayer.courageHudIds = [getLastCreatedText(), null]
        createProgressBarInWorldText(getAllPlayers(), eventPlayer.courageProgress * 100 / eventPlayer.courageCastDuration, "recitation of courage prayer", vect(eventPlayer.getEyePosition().x, eventPlayer.getEyePosition().y + 1, eventPlayer.getEyePosition().z), 0.8, Clip.SURFACES, Color.YELLOW, Color.BLACK, ProgressWorldTextReeval.POSITION_AND_VALUES)
        eventPlayer.courageHudIds = [eventPlayer.courageHudBarId, getLastCreatedText()]
        createEffect(getAllPlayers(), Effect.ENERGY_SOUND, Color.TEAM_1, eventPlayer, 200)
        eventPlayer.courageSoundEffectId = getLastCreatedEntity()
        #if player can casting the prayer in motion
        if eventPlayer.courageCanCastMoving == true:
            eventPlayer.readerCourageIter = 0
            while eventPlayer.readerCourageIter < eventPlayer.courageCastDuration:
                if eventPlayer.isAlive() == true:
                    eventPlayer.courageProgress++
                    wait(0.25)
                else:
                    smallMessage(eventPlayer, "the recitation of the prayer has been discontinued")
                    eventPlayer.courageCastDuration = 0
                    break
                eventPlayer.readerCourageIter++
        #if player cant casting prayer in motion
        else:
            eventPlayer.readerCourageIter = 0
            while eventPlayer.readerCourageIter < eventPlayer.courageCastDuration:
                if eventPlayer.isAlive() == true and eventPlayer.isMoving() == false:
                    wait(0.25)
                    eventPlayer.courageProgress++
                else:
                    smallMessage(eventPlayer, "the recitation of the prayer has been discontinued")
                    eventPlayer.courageCastDuration = 0
                    break
                eventPlayer.readerCourageIter++
        #destroy prayer casting effects
        #destroy_reader_holy_circle()
        destroyEffect(eventPlayer.courageSoundEffectId)
        destroyProgressBarHud(eventPlayer.courageHudBarId)
        destroyProgressBarInWorldText(eventPlayer.courageWorldBarId)
        #if the reading of the prayer is successful
        if eventPlayer.courageProgress == eventPlayer.courageOriginalCastDur:
            eventPlayer.courageDuration = 20 + (5 * (eventPlayer.current_tier - 1))
            #if player has no prayer effects (first cast)
            if eventPlayer.courageIsActive != true:
                smallMessage(eventPlayer, "courage prayer is not alr going")
                #play one-shot visual/sound effects
                playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer, 8)
                #create torbjorn overloading visual buff
                createEffect(getAllPlayers(), Effect.TORBJORN_OVERLOADING, Color.ORANGE, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                wait()
                eventPlayer.buff_append_args = [BuffId.COURAGE_VISUAL, getLastCreatedEntity(), getTotalTimeElapsed() + eventPlayer.courageDuration, EffectType.ENTITY]
                logToInspector("COURAGE: Adding visual buff. Args: {0}".format(eventPlayer.buff_append_args))
                add_buff()
                #add damage
                eventPlayer.courageDamageBonus = evalOnce(eventPlayer.stat_damage * 0.1)
                eventPlayer.stat_damage += eventPlayer.courageDamageBonus
                eventPlayer.setDamageDealt(eventPlayer.stat_damage)
                eventPlayer.buff_append_args = [BuffId.COURAGE_DAMAGE, eventPlayer, getTotalTimeElapsed() + eventPlayer.courageDuration, EffectType.DAMAGE, EffectAction.SUBTRACT, eventPlayer.courageDamageBonus]
                smallMessage(eventPlayer, "courage duration: {0}".format(eventPlayer.courageDuration))
                logToInspector("COURAGE: Adding damage buff. Args: {0}".format(eventPlayer.buff_append_args))
                add_buff()
                #player has prayer effects = True
                eventPlayer.courageIsActive = true
                eventPlayer.buff_append_args = [BuffId.COURAGE_ACTIVE_FLAG, eventPlayer, getTotalTimeElapsed() + eventPlayer.courageDuration, EffectType.PLAYER_VARIABLE, EffectAction.EXISTENCE_PRAYER_OF_COURAGE]
                logToInspector("COURAGE: Adding active flag. Args: {0}".format(eventPlayer.buff_append_args))
                add_buff()
                logToInspector("COURAGE: First cast complete. Active buffs count: {0}".format(len(eventPlayer.active_buff_ids)))
            #if player already has prayer effects (re-cast)
            else:
                smallMessage(eventPlayer, "courage prayer alr going")
                #play one-shot visual/sound effects
                playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer, 8)
                #extend or recreate visual buff
                eventPlayer.buff_append_args = [BuffId.COURAGE_VISUAL, null, getTotalTimeElapsed() + eventPlayer.courageDuration, EffectType.ENTITY]
                logToInspector("COURAGE: Extending visual buff. Args: {0}".format(eventPlayer.buff_append_args))
                extend_buff()
                if eventPlayer.temp_var_1 == -1:
                    logToInspector("COURAGE: Visual buff not found. Re-creating.")
                    #visual buff already expired, recreate it
                    createEffect(getAllPlayers(), Effect.TORBJORN_OVERLOADING, Color.ORANGE, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                    wait()
                    eventPlayer.buff_append_args = [BuffId.COURAGE_VISUAL, getLastCreatedEntity(), getTotalTimeElapsed() + eventPlayer.courageDuration, EffectType.ENTITY]
                    logToInspector("COURAGE: Visual buff recreated args: {0}".format(eventPlayer.buff_append_args))
                    add_buff()
                #stack damage buff (always add new)
                eventPlayer.courageDamageBonus = evalOnce(eventPlayer.stat_damage * 0.1)
                eventPlayer.stat_damage += eventPlayer.courageDamageBonus
                eventPlayer.setDamageDealt(eventPlayer.stat_damage)
                eventPlayer.buff_append_args = [BuffId.COURAGE_DAMAGE, eventPlayer, getTotalTimeElapsed() + eventPlayer.courageDuration, EffectType.DAMAGE, EffectAction.SUBTRACT, eventPlayer.courageDamageBonus]
                logToInspector("COURAGE: Adding stack damage buff args: {0}".format(eventPlayer.buff_append_args))
                add_buff()
                #extend or recreate active flag
                eventPlayer.buff_append_args = [BuffId.COURAGE_ACTIVE_FLAG, eventPlayer, getTotalTimeElapsed() + eventPlayer.courageDuration, EffectType.PLAYER_VARIABLE, EffectAction.EXISTENCE_PRAYER_OF_COURAGE]
                logToInspector("COURAGE: Extending active flag args: {0}".format(eventPlayer.buff_append_args))
                extend_buff()
                if eventPlayer.temp_var_1 == -1:
                    logToInspector("COURAGE: Active flag not found. Re-creating.")
                    #active flag expired, re-set it
                    eventPlayer.courageIsActive = true
                    logToInspector("COURAGE: Active flag recreated.")
                    add_buff()
                logToInspector("COURAGE: Re-cast complete. Active buffs count: {0}".format(len(eventPlayer.active_buff_ids)))
    eventPlayer.courageProgress = 0
