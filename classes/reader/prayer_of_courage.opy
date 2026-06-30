#!mainFile "../../main.opy"

rule "Reader Ability: prayer of courage":
    @Event eachPlayer
    @Condition eventPlayer.readerAbilities == true
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
            #play one-shot visual/sound effects
            playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer, 8)
            
            #extend all active Courage buffs unconditionally
            eventPlayer.extendBuff(BuffId.COURAGE_VISUAL, getTotalTimeElapsed() + eventPlayer.courageDuration)
            eventPlayer.extendBuff(BuffId.COURAGE_DAMAGE, getTotalTimeElapsed() + eventPlayer.courageDuration)
            eventPlayer.extendBuff(BuffId.COURAGE_ACTIVE_FLAG, getTotalTimeElapsed() + eventPlayer.courageDuration)
            
            #create active flag if not exists
            if eventPlayer.courageIsActive == false:
                eventPlayer.applyVisibleDebuff(BuffId.COURAGE_ACTIVE_FLAG, eventPlayer, getTotalTimeElapsed() + eventPlayer.courageDuration, EffectType.PLAYER_VARIABLE, EffectAction.EXISTENCE_PRAYER_OF_COURAGE, 0, "{0} Prayer of Courage".format(iconString(Icon.FIRE)), Color.YELLOW)

            #if stacks not exceeded max (2 + tier)
            if eventPlayer.courageStacks < (2 + eventPlayer.current_tier):
                eventPlayer.courageStacks++
                smallMessage(eventPlayer, "courage stack added: {0}".format(eventPlayer.courageStacks))
                
                #add damage
                eventPlayer.courageDamageBonus = evalOnce((eventPlayer.base_stat_damage + eventPlayer.mod_stat_damage) * 0.1)
                eventPlayer.trackBuff(BuffId.COURAGE_DAMAGE, eventPlayer, getTotalTimeElapsed() + eventPlayer.courageDuration, EffectType.DAMAGE, EffectAction.MODIFY_STAT, eventPlayer.courageDamageBonus)
            else:
                smallMessage(eventPlayer, "max prayer stacks reached. duration extended.")
                
            #create visual buff if not exists (checked via active flag)
            if eventPlayer.courageIsActive == false:
                createEffect(getAllPlayers(), Effect.TORBJORN_OVERLOADING, Color.ORANGE, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                wait()
                eventPlayer.trackBuff(BuffId.COURAGE_VISUAL, getLastCreatedEntity(), getTotalTimeElapsed() + eventPlayer.courageDuration, EffectType.ENTITY, 0, 0)
                eventPlayer.courageIsActive = true
    eventPlayer.courageProgress = 0
