#!mainFile "../main.opy"

# ============================================================
# СХЕМЫ МАССИВОВ — ALTAR
# ============================================================
enum AltarRaceText:
    TITLE = 0,
    DESCRIPTION,
    TITLE_COLOR,
    DESC_COLOR

enum AltarRing:
    COLOR = 0,
    VISIBLE

enum AltarDescVisibility:
    TITLE = 0,
    DESCRIPTION

macro Player.descriptionVisibility = self.description_visibility_status
macro Player.altarLeft1RingColor = self.altar_left_1_ring[AltarRing.COLOR]
macro Player.altarLeft1RingVisible = self.altar_left_1_ring[AltarRing.VISIBLE]
macro Player.altarRight1RingColor = self.altar_right_1_ring[AltarRing.COLOR]
macro Player.altarRight1RingVisible = self.altar_right_1_ring[AltarRing.VISIBLE]
# ============================================================
# СХЕМЫ МАССИВОВ — BRANCH DATA
# ============================================================
# branch_data — универсальный массив для текущей ветки игрока
# Если ветка ангельская, используются следующие индексы:
enum AngelicBranchData:
    # --- Tier 1: Reader ---
    ABILITIES_UNLOCKED = 0,
    PRAYER_ITER,
    HOLY_CIRCLE_ITER,
    HOLY_CIRCLE_ITER_PLUS,
    SALV_PROGRESS,
    SALV_CAST_DURATION,
    SALV_CAN_CAST_MOVING,
    SALV_IS_ACTIVE,
    SALV_SPEED_BONUS,
    SALV_DURATION,
    SALV_ORIGINAL_CAST_DUR,
    SALV_SOUND_EFFECT_ID,
    
    # --- Tier 2: Priest / Courage ---
    COUR_PROGRESS,
    COUR_CAST_DURATION,
    COUR_CAN_CAST_MOVING,
    COUR_ADDED_DMG_RECEIVED,
    COUR_ADDED_DAMAGE,
    COUR_DURATION,
    COUR_ORIGINAL_CAST_DUR,
    COUR_SOUND_EFFECT_ID,
    COUR_IS_ACTIVE,
    COUR_ITER,
    SALV_STACKS,
    COUR_STACKS

# ----- Member-макросы для Angelic Branch Data -----
macro Player.readerAbilities = self.branch_data[AngelicBranchData.ABILITIES_UNLOCKED]
macro Player.salvationStacks = self.branch_data[AngelicBranchData.SALV_STACKS]
macro Player.courageStacks = self.branch_data[AngelicBranchData.COUR_STACKS]
macro Player.readerPrayerIter = self.branch_data[AngelicBranchData.PRAYER_ITER]
macro Player.readerHolyCircleIter = self.branch_data[AngelicBranchData.HOLY_CIRCLE_ITER]
macro Player.readerHolyCircleIterPlus = self.branch_data[AngelicBranchData.HOLY_CIRCLE_ITER_PLUS]

macro Player.prayerProgress = self.branch_data[AngelicBranchData.SALV_PROGRESS]
macro Player.prayerCastDuration = self.branch_data[AngelicBranchData.SALV_CAST_DURATION]
macro Player.prayerCanCastMoving = self.branch_data[AngelicBranchData.SALV_CAN_CAST_MOVING]
macro Player.prayerIsActive = self.branch_data[AngelicBranchData.SALV_IS_ACTIVE]
macro Player.prayerSpeedBonus = self.branch_data[AngelicBranchData.SALV_SPEED_BONUS]
macro Player.prayerDuration = self.branch_data[AngelicBranchData.SALV_DURATION]
macro Player.prayerOriginalCastDur = self.branch_data[AngelicBranchData.SALV_ORIGINAL_CAST_DUR]
macro Player.prayerSoundEffectId = self.branch_data[AngelicBranchData.SALV_SOUND_EFFECT_ID]

# Вложенные переменные вынесены в слоты t1 (Tier 1)
macro Player.prayerHudIds = self.branch_t1_hud_ids
macro Player.prayerActiveEffects = self.branch_t1_active_effects
macro Player.prayerHudBarId = self.branch_t1_hud_ids[0]
macro Player.prayerWorldBarId = self.branch_t1_hud_ids[1]

# Макросы для Courage (Tier 2)
macro Player.readerCourageIter = self.branch_data[AngelicBranchData.COUR_ITER]
macro Player.courageProgress = self.branch_data[AngelicBranchData.COUR_PROGRESS]
macro Player.courageCastDuration = self.branch_data[AngelicBranchData.COUR_CAST_DURATION]
macro Player.courageCanCastMoving = self.branch_data[AngelicBranchData.COUR_CAN_CAST_MOVING]
macro Player.courageIsActive = self.branch_data[AngelicBranchData.COUR_IS_ACTIVE]
macro Player.courageDuration = self.branch_data[AngelicBranchData.COUR_DURATION]
macro Player.courageOriginalCastDur = self.branch_data[AngelicBranchData.COUR_ORIGINAL_CAST_DUR]
macro Player.courageSoundEffectId = self.branch_data[AngelicBranchData.COUR_SOUND_EFFECT_ID]
macro Player.courageDamageBonus = self.branch_data[AngelicBranchData.COUR_ADDED_DAMAGE]

macro Player.courageHudIds = self.branch_t2_hud_ids
macro Player.courageActiveEffects = self.branch_t2_active_effects
macro Player.courageHudBarId = self.branch_t2_hud_ids[0]
macro Player.courageWorldBarId = self.branch_t2_hud_ids[1]


# ============================================================
# СХЕМЫ МАССИВОВ — PASSIVES DATA
# ============================================================
enum PassivesData:
    VAMP_PASSIVE = 0,
    VAMP_SIZE,
    VAMP_LEVEL,
    BLEED_PASSIVE,
    BLEED_CHANCE,
    BLEED_CD,
    BLEED_DURATION,
    BLEED_POWER,
    BLEED_CHANCE_PLAYER,
    BLEED_LEVEL,
    IS_RECEIVING_BLEED_DAMAGE

macro Player.passiveVampire = self.passives_data[PassivesData.VAMP_PASSIVE]
macro Player.vampireSize = self.passives_data[PassivesData.VAMP_SIZE]
macro Player.vampireLevel = self.passives_data[PassivesData.VAMP_LEVEL]

macro Player.bleedingPassive = self.passives_data[PassivesData.BLEED_PASSIVE]
macro Player.bleedingChance = self.passives_data[PassivesData.BLEED_CHANCE]
macro Player.bleedingCd = self.passives_data[PassivesData.BLEED_CD]
macro Player.bleedingDuration = self.passives_data[PassivesData.BLEED_DURATION]
macro Player.bleedingPower = self.passives_data[PassivesData.BLEED_POWER]
macro Player.bleedingChancePlayer = self.passives_data[PassivesData.BLEED_CHANCE_PLAYER]
macro Player.bleedingLevel = self.passives_data[PassivesData.BLEED_LEVEL]
macro Player.isReceivingBleedDamage = self.passives_data[PassivesData.IS_RECEIVING_BLEED_DAMAGE]

# СХЕМЫ МАССИВОВ — EFFECTS TO BE DESTROYED
# ============================================================
# effects_to_be_destroyed_array[i] — массив из 3-5 элементов
enum EffectEntry:
    BUFF_ID = 0,
    TARGET,
    EXPIRE_TIME,
    TYPE,
    ACTION,
    VALUE,
    SOURCE,
    FLAG

enum BuffFlag:
    NORMAL = 0,
    PERSIST_ON_DEATH


# ============================================================
# СХЕМЫ МАССИВОВ — STATS LIMIT
# ============================================================
# stats_limit — хранит лимиты прокачиваемых статов игрока
enum StatLimit:
    HEALTH = 0,
    DAMAGE,
    SPEED

# ----- Member-макросы для Stats Limit -----
macro Player.statLimitHealth = self.stats_limit[StatLimit.HEALTH]
macro Player.statLimitDamage = self.stats_limit[StatLimit.DAMAGE]
macro Player.statLimitSpeed = self.stats_limit[StatLimit.SPEED]


enum DemonicBranchData:
    IS_ANGELIC_FLAG = 0, # Must be false for Demons to prevent unlocking Reader abilities
    CURSE_BASE_THRESHOLD,
    CURSE_DURATION,
    CURSE_DAMAGE_BONUS

macro Player.dwCurseBaseThreshold = self.branch_data[DemonicBranchData.CURSE_BASE_THRESHOLD]
macro Player.dwCurseDuration = self.branch_data[DemonicBranchData.CURSE_DURATION]
macro Player.dwCurseDamageBonus = self.branch_data[DemonicBranchData.CURSE_DAMAGE_BONUS]


# ============================================================
# СХЕМЫ МАССИВОВ — PLAYER STATS (Base + Modifiers)
# ============================================================
# base_stats and mod_stats are 10-element arrays indexed by EffectType
macro Player.base_stat_speed = self.base_stats[EffectType.SPEED]
macro Player.base_stat_damage = self.base_stats[EffectType.DAMAGE]
macro Player.base_stat_health = self.base_stats[EffectType.HEALTH]
macro Player.base_stat_damage_received = self.base_stats[EffectType.DAMAGE_RECEIVED]
macro Player.base_stat_healing_received = self.base_stats[EffectType.HEALING_RECEIVED]
macro Player.base_stat_projectiles_speed = self.base_stats[EffectType.PROJECTILE_SPEED]

macro Player.mod_stat_speed = self.mod_stats[EffectType.SPEED]
macro Player.mod_stat_damage = self.mod_stats[EffectType.DAMAGE]
macro Player.mod_stat_health = self.mod_stats[EffectType.HEALTH]
macro Player.mod_stat_damage_received = self.mod_stats[EffectType.DAMAGE_RECEIVED]
macro Player.mod_stat_healing_received = self.mod_stats[EffectType.HEALING_RECEIVED]
macro Player.mod_stat_projectiles_speed = self.mod_stats[EffectType.PROJECTILE_SPEED]

macro Player.apply_all_stats():
    self.setMoveSpeed(max(0, self.base_stat_speed + self.mod_stat_speed))
    self.setDamageDealt(max(0, self.base_stat_damage + self.mod_stat_damage))
    self.setMaxHealth(max(1, self.base_stat_health + self.mod_stat_health))
    self.setDamageReceived(max(0, self.base_stat_damage_received + self.mod_stat_damage_received))
    self.setHealingReceived(max(0, self.base_stat_healing_received + self.mod_stat_healing_received))
    self.setProjectileSpeed(max(0, self.base_stat_projectiles_speed + self.mod_stat_projectiles_speed))


# ============================================================
# ЕДИНЫЙ API ЭФФЕКТОВ — макросы регистрации баффов/дебаффов
# ============================================================
# ЗАЧЕМ: централизованный add_buff() умеет работать только над eventPlayer,
# поэтому любой дебафф на ЧУЖОГО игрока (victim) раньше требовал 6-12 ручных
# .append (см. историю cursed_mark) — и любой из них можно было забыть.
# Эти макросы работают на self -> вызывай на ЛЮБОЙ цели:
#     victim.applyVisibleDebuff(...)   eventPlayer.trackBuff(...)   bot.trackBuff(...)
# Нулевой оверхед: макрос = текстовая подстановка, разворачивается в те же .append.
#
# >>> ПОСЛЕ добавления этих макросов ОБЯЗАТЕЛЬНО скомпилируй проект один раз
# >>> в OverPy (VS Code) и убедись, что нет ошибок синтаксиса макросов. <<<
#
# КОНТРАКТ длины (тот же, что проверяет tools/validate.py):
#   тип эффекта -> сколько полей реально нужно
#     ENTITY / HEALTH_BAR / HEAL_OVER_TIME : action/value не используются (передавай 0, 0)
#     PLAYER_VARIABLE                      : нужен action (value = 0)
#     стат-типы (SPEED/DAMAGE/HEALTH/...)   : нужны И action, И value (иначе стат
#                                            «восстановится на 0» = тихая порча стата)

# --- Механическая регистрация эффекта в системе жизненного цикла ---
# Эквивалент add_buff(), но на любой цели. Всегда передавай ВСЕ 6 аргументов
# (для не-стат-типов action=0, value=0) — это убирает зависимость от тихого OOB→0.
macro Player.trackBuff(buffId, target, expire, type, action, value):
    self.active_buff_ids.append(buffId)
    self.active_buff_targets.append(target)
    self.active_buff_expire_times.append(expire)
    self.active_buff_types.append(type)
    self.active_buff_actions.append(action)
    self.active_buff_values.append(value)
    self.active_buff_sources.append(null)
    self.active_buff_flags.append(BuffFlag.NORMAL)
    if type >= EffectType.SPEED:
        self.mod_stats[type] += value
        self.apply_all_stats()

# --- Регистрация HUD-надписи об эффекте (правый список) ---
macro Player.trackHud(buffId, expire, name, color):
    self.hud_buff_ids.append(buffId)
    self.hud_buff_expires.append(expire)
    self.hud_buff_names.append(name)
    self.hud_buff_colors.append(color)
    self.hud_buff_sources.append(null)
    self.hud_buff_flags.append(BuffFlag.NORMAL)

# --- ВИДИМЫЙ дебафф/бафф: механика + HUD за ОДИН вызов ---
# Используй ЭТО для любого эффекта, который игрок должен видеть. HUD физически
# невозможно забыть — он в том же макросе. Инлайнит trackBuff+trackHud (без
# вложенных вызовов макросов — максимально безопасно для компилятора).
macro Player.applyVisibleDebuff(buffId, target, expire, type, action, value, name, color):
    self.active_buff_ids.append(buffId)
    self.active_buff_targets.append(target)
    self.active_buff_expire_times.append(expire)
    self.active_buff_types.append(type)
    self.active_buff_actions.append(action)
    self.active_buff_values.append(value)
    self.hud_buff_ids.append(buffId)
    self.hud_buff_expires.append(expire)
    self.hud_buff_names.append(name)
    self.hud_buff_colors.append(color)
    self.active_buff_sources.append(null)
    self.hud_buff_sources.append(null)
    self.active_buff_flags.append(BuffFlag.NORMAL)
    self.hud_buff_flags.append(BuffFlag.NORMAL)
    if type >= EffectType.SPEED:
        self.mod_stats[type] += value
        self.apply_all_stats()

# --- Продление баффа по ID ---
# Безопасное атомарное продление баффа и HUD-надписи по индексу.
macro Player.extendBuff(buffId, newExpire):
    if buffId in self.hud_buff_ids:
        self.hud_buff_expires[self.hud_buff_ids.index(buffId)] = newExpire
    if buffId in self.active_buff_ids:
        self.active_buff_expire_times[self.active_buff_ids.index(buffId)] = newExpire

# --- Продление ВСЕХ стаков баффа по ID ---
macro Player.extendBuffAll(buffId, newExpire):
    for self.extend_all_buffs_iter in range(len(self.active_buff_ids)):
        if self.active_buff_ids[self.extend_all_buffs_iter] == buffId:
            self.active_buff_expire_times[self.extend_all_buffs_iter] = newExpire

# --- Регистрация перманентного эффекта (Garbage Collector) ---
macro Player.trackPersistentEntity(entity_id, gc_type):
    self.gc_ids.append(entity_id)
    self.gc_types.append(gc_type)

# --- НОВЫЙ API ДЛЯ PER-ATTACKER БАФФОВ ---
macro Player.trackAttackerBuff(buffId, source, target, expire, type, action, value):
    self.active_buff_ids.append(buffId)
    self.active_buff_targets.append(target)
    self.active_buff_expire_times.append(expire)
    self.active_buff_types.append(type)
    self.active_buff_actions.append(action)
    self.active_buff_values.append(value)
    self.active_buff_sources.append(source)
    self.active_buff_flags.append(BuffFlag.NORMAL)
    if type >= EffectType.SPEED:
        self.mod_stats[type] += value
        self.apply_all_stats()

macro Player.trackAttackerHud(buffId, source, expire, name, color):
    self.hud_buff_ids.append(buffId)
    self.hud_buff_expires.append(expire)
    self.hud_buff_names.append(name)
    self.hud_buff_colors.append(color)
    self.hud_buff_sources.append(source)
    self.hud_buff_flags.append(BuffFlag.NORMAL)

macro Player.applyVisibleAttackerDebuff(buffId, source, target, expire, type, action, value, name, color):
    self.active_buff_ids.append(buffId)
    self.active_buff_targets.append(target)
    self.active_buff_expire_times.append(expire)
    self.active_buff_types.append(type)
    self.active_buff_actions.append(action)
    self.active_buff_values.append(value)
    self.active_buff_sources.append(source)
    self.hud_buff_ids.append(buffId)
    self.hud_buff_expires.append(expire)
    self.hud_buff_names.append(name)
    self.hud_buff_colors.append(color)
    self.hud_buff_sources.append(source)
    self.active_buff_flags.append(BuffFlag.NORMAL)
    self.hud_buff_flags.append(BuffFlag.NORMAL)
    if type >= EffectType.SPEED:
        self.mod_stats[type] += value
        self.apply_all_stats()

macro Player.extendAttackerBuff(buffId, source, newExpire):
    for self.extend_attacker_iter in range(len(self.hud_buff_ids)):
        if self.hud_buff_ids[self.extend_attacker_iter] == buffId and self.hud_buff_sources[self.extend_attacker_iter] == source:
            self.hud_buff_expires[self.extend_attacker_iter] = newExpire
    for self.extend_attacker_iter in range(len(self.active_buff_ids)):
        if self.active_buff_ids[self.extend_attacker_iter] == buffId and self.active_buff_sources[self.extend_attacker_iter] == source:
            self.active_buff_expire_times[self.extend_attacker_iter] = newExpire

macro Player.addAttackerBuffValue(buffId, source, addValue):
    for self.add_attacker_buff_iter in range(len(self.active_buff_ids)):
        if self.active_buff_ids[self.add_attacker_buff_iter] == buffId and self.active_buff_sources[self.add_attacker_buff_iter] == source:
            self.active_buff_values[self.add_attacker_buff_iter] += addValue

# --- НОВЫЙ API МОДИФИКАТОРОВ (BUILDER PATTERN) ---
# Использовать СРАЗУ ПОСЛЕ макросов trackBuff/applyVisibleDebuff, чтобы
# изменить флаги (например, сделать бафф перманентным через BuffFlag.PERSIST_ON_DEATH).
macro Player.setLastBuffFlag(flag):
    self.active_buff_flags[len(self.active_buff_ids) - 1] = flag

macro Player.setLastHudFlag(flag):
    self.hud_buff_flags[len(self.hud_buff_ids) - 1] = flag

macro Player.setLastVisibleFlag(flag):
    self.active_buff_flags[len(self.active_buff_ids) - 1] = flag
    self.hud_buff_flags[len(self.hud_buff_ids) - 1] = flag

