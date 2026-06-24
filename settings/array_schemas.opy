#!mainFile "../main.opy"

# ============================================================
# СХЕМЫ МАССИВОВ — READER DATA
# ============================================================
# reader_data — общий массив для класса Reader (простые переменные)
enum ReaderData:
    ABILITIES = 0,
    PRAYER_ITER,
    HOLY_CIRCLE_ITER,
    HOLY_CIRCLE_ITER_PLUS,
    
    # Prayer of Salvation simple fields
    SALV_PROGRESS,
    SALV_CAST_DURATION,
    SALV_CAN_CAST_MOVING,
    SALV_IS_ACTIVE,
    SALV_SPEED_BONUS,
    SALV_DURATION,
    SALV_ORIGINAL_CAST_DUR,
    SALV_SOUND_EFFECT_ID,
    
    # Prayer for Courage simple fields
    COUR_PROGRESS,
    COUR_CAST_DURATION,
    COUR_CAN_CAST_MOVING,
    COUR_ADDED_DMG_RECEIVED,
    COUR_ADDED_DAMAGE,
    COUR_DURATION,
    COUR_ORIGINAL_CAST_DUR,
    COUR_SOUND_EFFECT_ID

# ----- Member-макросы для Reader Data -----
macro Player.readerAbilities = self.reader_data[ReaderData.ABILITIES]
macro Player.readerPrayerIter = self.reader_data[ReaderData.PRAYER_ITER]
macro Player.readerHolyCircleIter = self.reader_data[ReaderData.HOLY_CIRCLE_ITER]
macro Player.readerHolyCircleIterPlus = self.reader_data[ReaderData.HOLY_CIRCLE_ITER_PLUS]

macro Player.prayerProgress = self.reader_data[ReaderData.SALV_PROGRESS]
macro Player.prayerCastDuration = self.reader_data[ReaderData.SALV_CAST_DURATION]
macro Player.prayerCanCastMoving = self.reader_data[ReaderData.SALV_CAN_CAST_MOVING]
macro Player.prayerIsActive = self.reader_data[ReaderData.SALV_IS_ACTIVE]
macro Player.prayerSpeedBonus = self.reader_data[ReaderData.SALV_SPEED_BONUS]
macro Player.prayerDuration = self.reader_data[ReaderData.SALV_DURATION]
macro Player.prayerOriginalCastDur = self.reader_data[ReaderData.SALV_ORIGINAL_CAST_DUR]
macro Player.prayerSoundEffectId = self.reader_data[ReaderData.SALV_SOUND_EFFECT_ID]

# Вложенные переменные (массивы) были вынесены в отдельные переменные, доступ напрямую:
macro Player.prayerHudIds = self.reader_prayer_hud_ids
macro Player.prayerActiveEffects = self.reader_prayer_active_effects
macro Player.prayerHudBarId = self.reader_prayer_hud_ids[0]
macro Player.prayerWorldBarId = self.reader_prayer_hud_ids[1]

# Макросы для Courage (если понадобятся)
macro Player.courageProgress = self.reader_data[ReaderData.COUR_PROGRESS]
macro Player.courageHudIds = self.reader_courage_hud_ids
macro Player.courageActiveEffects = self.reader_courage_active_effects


# ============================================================
# СХЕМЫ МАССИВОВ — EFFECTS TO BE DESTROYED
# ============================================================
# effects_to_be_destroyed_array[i] — массив из 3-5 элементов
enum EffectEntry:
    TARGET = 0,
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

