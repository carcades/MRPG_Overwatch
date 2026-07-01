#!mainFile "../../main.opy"

rule "Reader Ability: prayer for salvation":
    @Event eachPlayer
    @Condition eventPlayer.readerAbilities == true
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
            #play one-shot visual/sound effects
            playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.BLUE, eventPlayer, 8)
            
            # 1. ALWAYS: extend all existing prayer buffs
            eventPlayer.extendBuffAll(BuffId.PRAYER_HEALTH_POOL, getTotalTimeElapsed() + eventPlayer.prayerDuration)
            eventPlayer.extendBuff(BuffId.PRAYER_VISUAL, getTotalTimeElapsed() + eventPlayer.prayerDuration)
            eventPlayer.extendBuff(BuffId.PRAYER_HEAL_OVER_TIME, getTotalTimeElapsed() + eventPlayer.prayerDuration)
            eventPlayer.extendBuff(BuffId.PRAYER_SPEED, getTotalTimeElapsed() + eventPlayer.prayerDuration)
            eventPlayer.extendBuff(BuffId.PRAYER_ACTIVE_FLAG, getTotalTimeElapsed() + eventPlayer.prayerDuration)
            
            # 2. On FIRST stack (stacks == 0): create singletons + speed/heal
            if eventPlayer.salvationStacks == 0:
                createEffect(getAllPlayers(), Effect.ANA_NANO_BOOSTED, Color.TEAM_2, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                wait()
                eventPlayer.trackBuff(BuffId.PRAYER_VISUAL, getLastCreatedEntity(), getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.ENTITY, 0, 0)
                
                eventPlayer.applyVisibleDebuff(BuffId.PRAYER_ACTIVE_FLAG, eventPlayer, getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.PLAYER_VARIABLE, EffectAction.EXISTENCE_PRAYER_OF_SALVATION, 0, "{0} Prayer of Salvation".format(iconString(Icon.HALO)), Color.AQUA)
                
                eventPlayer.startHealingOverTime(eventPlayer, 100000000, (eventPlayer.base_stat_health + eventPlayer.mod_stat_health) / 5 + ((eventPlayer.current_tier - 1) * 10))
                wait()
                eventPlayer.trackBuff(BuffId.PRAYER_HEAL_OVER_TIME, getLastHealingOverTimeId(), getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.HEAL_OVER_TIME, 0, 0)
                
                eventPlayer.prayerSpeedBonus = evalOnce((eventPlayer.base_stat_speed + eventPlayer.mod_stat_speed) * (0.2 + ((eventPlayer.current_tier - 1) * 0.1)))
                eventPlayer.trackBuff(BuffId.PRAYER_SPEED, eventPlayer, getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.SPEED, EffectAction.MODIFY_STAT, eventPlayer.prayerSpeedBonus)
                
                eventPlayer.prayerIsActive = true
                
            # 3. Stackable health pool: add until stacks < limit
            if eventPlayer.salvationStacks < (2 + eventPlayer.current_tier):
                eventPlayer.salvationStacks++
                smallMessage(eventPlayer, "salvation stack added: {0}".format(eventPlayer.salvationStacks))
                
                eventPlayer.addHealthPool(Health.SHIELDS, (eventPlayer.base_stat_health + eventPlayer.mod_stat_health) / 3, true, false)
                wait()
                eventPlayer.trackBuff(BuffId.PRAYER_HEALTH_POOL, getLastCreatedHealthPool(), getTotalTimeElapsed() + eventPlayer.prayerDuration, EffectType.HEALTH_BAR, 0, 0)
            else:
                smallMessage(eventPlayer, "max prayer stacks reached. duration extended.")
    eventPlayer.prayerProgress = 0
