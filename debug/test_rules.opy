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
    @Disabled
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    
    eventPlayer.facingdirection = eventPlayer.getFacingDirection()
    eventPlayer.teleport(eventPlayer + eventPlayer.getFacingDirection() * 10)
    eventPlayer.applyImpulse(Vector.UP, 2, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setFacing(eventPlayer.facingdirection, Relativity.TO_WORLD)


rule "effects":
    @Disabled
    @Event eachPlayer
    
    #createEffect(getAllPlayers(), Effect.SPHERE, Color.WHITE, updateEveryFrame(eventPlayer.getEyePosition()), 0.2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Правило 100":
    @Disabled
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    
    #destroy_reader_holy_circle()
    eventPlayer.current_tier = 3
    eventPlayer.prayerCanCastMoving = true


rule "Правило 88":
    @Disabled
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Disabled
    
    createEffect(getAllPlayers(), Effect.ANA_NANO_BOOSTED, Color.TEAM_1, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Правило 89":
    @Disabled
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Disabled
    
    createProjectile(Projectile.BASTION_TACTICAL_GRENADE, eventPlayer, eventPlayer.getEyePosition(), eventPlayer.getFacingDirection(), Relativity.TO_WORLD, ModifyHealth.DAMAGE, getAllPlayers().filter(lambda player: player != eventPlayer), 50, 1, 4, DynamicEffect.PHARAH_BARRAGE_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 1, 1000, 5, 70, 20)
    wait(0.25)


rule "Правило 93":
    @Disabled
    #hudHeader(getAllPlayers(), "{0}".format(len(effects_to_be_destroyed_array)), HudPosition.LEFT, 100, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "Правило 96":
    @Disabled
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    smallMessage(eventPlayer, "{0} {1}".format("len [10][0] prayer effects:", len(eventPlayer.prayerActiveEffects[0])))


rule "Правило 97":
    @Disabled
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    #smallMessage(getAllPlayers(), effects_to_be_destroyed_array.index(eventPlayer.prayerActiveEffects[1]))
    #a
    #eventPlayer.index_of_etbda_object = effects_to_be_destroyed_array.index(eventPlayer.prayerActiveEffects[0])
    smallMessage(eventPlayer, "{0} {1}".format("len player prayer effects", len(eventPlayer.prayerActiveEffects)))


rule "Правило 98":
    @Disabled
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    #smallMessage(eventPlayer, "{0} {1}".format("index in etbda player[10][0] object", effects_to_be_destroyed_array.index(eventPlayer.prayerActiveEffects[0])))


rule "Правило 99":
    @Disabled
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    smallMessage(eventPlayer, "{0} {1}".format("player temp array len", len(eventPlayer.temp_array)))
    wait(1)
    smallMessage(eventPlayer, "{0} {1}".format("player temp array [0]:", eventPlayer.temp_array[EffectEntry.TARGET]))
    wait(1)
    smallMessage(eventPlayer, "{0} {1}".format("player temp array [1]:", eventPlayer.temp_array[EffectEntry.EXPIRE_TIME]))


rule "Правило 100":
    @Disabled
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    #hudHeader(getAllPlayers(), "{0} {1} {2} <0>".format(effects_to_be_destroyed_array[0][EffectEntry.TARGET], effects_to_be_destroyed_array[0][EffectEntry.EXPIRE_TIME], effects_to_be_destroyed_array[0][EffectEntry.TYPE]), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY)

rule "Test 5D Array Mechanics":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    
    # --- ЭКСПЕРИМЕНТ 0: Инициализация ---
    # Создаем 5-мерный массив: test_arr_5[0][0][0][0][0] = "A"
    eventPlayer.test_arr_5 = [[[[["A"]]]]]
    wait()
    logToInspector("TEST: Exp 0 (Init) - 5D val is {0}".format(eventPlayer.test_arr_5[0][0][0][0][0]))
    
    # --- ЭКСПЕРИМЕНТ 1: Добавление в корень ---
    # Функция .append() в Overpy всегда работает только с корневым массивом.
    # Посмотрим, не сломает ли это существующую вложенность.
    eventPlayer.test_arr_5.append("B")
    wait()
    logToInspector("TEST: Exp 1 (Append to root) - arr5[1] is {0}, 5D val is still {1}".format(eventPlayer.test_arr_5[1], eventPlayer.test_arr_5[0][0][0][0][0]))
    
    # --- ЭКСПЕРИМЕНТ 2: Модификация внутреннего массива ---
    # Прямая запись test_arr_5[0][0][0][0][0] = "C" не компилируется из-за лимитов Overpy.
    # Но мы перезапишем кусок массива на уровне 3D, заменив "A" на "C" и добавив "D".
    eventPlayer.test_arr_5[0][0][0] = [["C", "D"]]
    wait()
    logToInspector("TEST: Exp 2 (Modify inner via 3D) - [0] is {0}, [1] is {1}".format(eventPlayer.test_arr_5[0][0][0][0][0], eventPlayer.test_arr_5[0][0][0][0][1]))
    
    # --- ЭКСПЕРИМЕНТ 3: Чтение несуществующего индекса (Out of bounds) ---
    # Проверим, крашится ли Workshop, если запросить 3-й элемент из 2-элементного массива на 5-й глубине.
    logToInspector("TEST: Exp 3 (Out of bounds inner) - [2] is {0}".format(eventPlayer.test_arr_5[0][0][0][0][2]))
    
    # --- ЭКСПЕРИМЕНТ 4: Длина внутреннего массива ---
    # Сможет ли Workshop корректно посчитать длину массива 4-го уровня? (ожидаем 2)
    logToInspector("TEST: Exp 4 (Length of inner array) - len is {0}".format(len(eventPlayer.test_arr_5[0][0][0][0])))
    
    # --- ЭКСПЕРИМЕНТ 5: Фильтрация глубокого массива ---
    # Попробуем применить lambda-функцию к внутреннему массиву.
    eventPlayer.temp_array = eventPlayer.test_arr_5[0][0][0][0].filter(lambda x: x == "C")
    wait()
    logToInspector("TEST: Exp 5 (Filter inner array) - result is {0}".format(eventPlayer.temp_array[0]))

    # --- ЭКСПЕРИМЕНТ 6: Смешанная вложенность ---
    # Попробуем создать массив, где лежат элементы разной вложенности.
    eventPlayer.test_arr_5 = [[[[["Deep"]]]], "Shallow", [["Medium"]]]
    wait()
    logToInspector("TEST: Exp 6 (Mixed depth) - 5D: {0}, 1D: {1}, 3D: {2}".format(eventPlayer.test_arr_5[0][0][0][0][0], eventPlayer.test_arr_5[1], eventPlayer.test_arr_5[2][0][0]))
    
    # --- ЭКСПЕРИМЕНТ 7: Удаление ---
    # Workshop не умеет удалять элементы из внутренних массивов напрямую (нет такого action).
    # Но мы можем удалить корневой элемент, где лежал 5D массив.
    del eventPlayer.test_arr_5[0]
    wait()
    # Теперь на индексе 0 должен оказаться "Shallow".
    logToInspector("TEST: Exp 7 (Delete root) - arr5[0] is {0}, len is {1}".format(eventPlayer.test_arr_5[0], len(eventPlayer.test_arr_5)))


