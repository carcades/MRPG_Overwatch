#!mainFile "../main.opy"

rule "bot":
    createDummy(Hero.ROADHOG, Team.ALL, 2, vect(82.617, 59.717, -155.01), vect(82.617, 59.717, -155.01))
    #getPlayersInSlot(2, Team.ALL).setDamageReceived(70)


rule "bot regen":
    @Event playerTookDamage
    @Condition eventPlayer.isDummy() == true
    
    heal(eventPlayer, eventPlayer, 400)


rule "bot respawn":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.isDead() == true
    
    waitUntil(eventPlayer.isAlive(), 99999)
    eventPlayer.teleport(vect(82.998, 59.926, -154.191))


rule "teleport":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    
    eventPlayer.facingdirection = eventPlayer.getFacingDirection()
    eventPlayer.teleport(eventPlayer + eventPlayer.getFacingDirection() * 10)
    eventPlayer.applyImpulse(Vector.UP, 2, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setFacing(eventPlayer.facingdirection, Relativity.TO_WORLD)


rule "effects":
    @Event eachPlayer
    
    #createEffect(getAllPlayers(), Effect.SPHERE, Color.WHITE, updateEveryFrame(eventPlayer.getEyePosition()), 0.2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Правило 100":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    
    #destroy_reader_holy_circle()
    eventPlayer.current_tier = 3
    eventPlayer.prayerCanCastMoving = true


rule "Правило 88":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Disabled
    
    createEffect(getAllPlayers(), Effect.ANA_NANO_BOOSTED, Color.TEAM_1, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Правило 89":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Disabled
    
    createProjectile(Projectile.BASTION_TACTICAL_GRENADE, eventPlayer, eventPlayer.getEyePosition(), eventPlayer.getFacingDirection(), Relativity.TO_WORLD, ModifyHealth.DAMAGE, getAllPlayers().filter(lambda player: player != eventPlayer), 50, 1, 4, DynamicEffect.PHARAH_BARRAGE_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 1, 1000, 5, 70, 20)
    wait(0.25)


rule "Правило 93":
    hudHeader(getAllPlayers(), "{0}".format(len(effects_to_be_destroyed_array)), HudPosition.LEFT, 100, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "Правило 96":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    smallMessage(eventPlayer, "{0} {1}".format("len [10][0] prayer effects:", len(eventPlayer.prayerActiveEffects[0])))


rule "Правило 97":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    #smallMessage(getAllPlayers(), effects_to_be_destroyed_array.index(eventPlayer.prayerActiveEffects[1]))
    #a
    #eventPlayer.index_of_etbda_object = effects_to_be_destroyed_array.index(eventPlayer.prayerActiveEffects[0])
    smallMessage(eventPlayer, "{0} {1}".format("len player prayer effects", len(eventPlayer.prayerActiveEffects)))


rule "Правило 98":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    smallMessage(eventPlayer, "{0} {1}".format("index in etbda player[10][0] object", effects_to_be_destroyed_array.index(eventPlayer.prayerActiveEffects[0])))


rule "Правило 99":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    smallMessage(eventPlayer, "{0} {1}".format("player temp array len", len(eventPlayer.temp_array)))
    wait(1)
    smallMessage(eventPlayer, "{0} {1}".format("player temp array [0]:", eventPlayer.temp_array[EffectEntry.TARGET]))
    wait(1)
    smallMessage(eventPlayer, "{0} {1}".format("player temp array [1]:", eventPlayer.temp_array[EffectEntry.EXPIRE_TIME]))


rule "Правило 100":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    hudHeader(getAllPlayers(), "{0} {1} {2} <0>".format(effects_to_be_destroyed_array[0][EffectEntry.TARGET], effects_to_be_destroyed_array[0][EffectEntry.EXPIRE_TIME], effects_to_be_destroyed_array[0][EffectEntry.TYPE]), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY)
