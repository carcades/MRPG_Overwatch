#!mainFile "../main.opy"

# ============================================================
# СХЕМЫ МАССИВОВ — PRAYER OF SALVATION
# ============================================================
# reader_prayer_of_salvation — массив из 11 элементов
# Хранит состояние молитвы спасения у игрока
enum PrayerSalvation:
    PROGRESS = 0,
    HUD_IDS,
    CAST_DURATION,
    _UNUSED_3,
    CAN_CAST_MOVING,
    IS_ACTIVE,
    SPEED_BONUS,
    DURATION,
    ORIGINAL_CAST_DURATION,
    SOUND_EFFECT_ID,
    ACTIVE_EFFECTS

# ----- Member-макросы для Prayer of Salvation -----
macro Player.prayerProgress = self.reader_prayer_of_salvation[PrayerSalvation.PROGRESS]
macro Player.prayerHudIds = self.reader_prayer_of_salvation[PrayerSalvation.HUD_IDS]
macro Player.prayerCastDuration = self.reader_prayer_of_salvation[PrayerSalvation.CAST_DURATION]
macro Player.prayerCanCastMoving = self.reader_prayer_of_salvation[PrayerSalvation.CAN_CAST_MOVING]
macro Player.prayerIsActive = self.reader_prayer_of_salvation[PrayerSalvation.IS_ACTIVE]
macro Player.prayerSpeedBonus = self.reader_prayer_of_salvation[PrayerSalvation.SPEED_BONUS]
macro Player.prayerDuration = self.reader_prayer_of_salvation[PrayerSalvation.DURATION]
macro Player.prayerOriginalCastDur = self.reader_prayer_of_salvation[PrayerSalvation.ORIGINAL_CAST_DURATION]
macro Player.prayerSoundEffectId = self.reader_prayer_of_salvation[PrayerSalvation.SOUND_EFFECT_ID]
macro Player.prayerActiveEffects = self.reader_prayer_of_salvation[PrayerSalvation.ACTIVE_EFFECTS]

macro Player.prayerHudBarId = self.reader_prayer_of_salvation[PrayerSalvation.HUD_IDS][0]
macro Player.prayerWorldBarId = self.reader_prayer_of_salvation[PrayerSalvation.HUD_IDS][1]


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

