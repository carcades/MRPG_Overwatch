#!mainFile "../main.opy"

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
    COUR_SOUND_EFFECT_ID

# ----- Member-макросы для Angelic Branch Data -----
macro Player.readerAbilities = self.branch_data[AngelicBranchData.ABILITIES_UNLOCKED]
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
macro Player.courageProgress = self.branch_data[AngelicBranchData.COUR_PROGRESS]
macro Player.courageHudIds = self.branch_t2_hud_ids
macro Player.courageActiveEffects = self.branch_t2_active_effects


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
    BLEED_LEVEL

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
# СХЕМЫ МАССИВОВ — EFFECTS TO BE DESTROYED
# ============================================================
# effects_to_be_destroyed_array[i] — массив из 3-5 элементов
enum EffectEntry:
    BUFF_ID = 0,
    TARGET,
    EXPIRE_TIME,
    TYPE,
    ACTION,
    VALUE


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

