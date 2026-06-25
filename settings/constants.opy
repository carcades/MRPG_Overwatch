#!mainFile "../main.opy"

# ===== Compile-time Constants =====

#!define SPAWN_BUBBLE_RADIUS 45.3


# ===== Enumerations =====

enum Zone:
    NONE = 0,
    BUBBLE,
    BLOOD_SHOP,
    EMERALD_MINE,
    ALTAR,
    UNDERGROUND

enum AltarStatus:
    NONE = 0,
    TIER_2_SELECTION,
    READER,
    DEMON_WORSHIPER

enum EmeraldCostVector:
    UP_PRICE = 0,
    DOWN_PRICE

enum EffectType:
    ENTITY = 0,
    HEALTH_BAR,
    HEAL_OVER_TIME,
    PLAYER_VARIABLE,
    SPEED,
    DAMAGE,
    HEALTH

enum EffectAction:
    SUBTRACT = 0,
    EXISTENCE_PRAYER_OF_SALVATION

enum BuffId:
    PRAYER_VISUAL = 0,
    PRAYER_HEALTH_POOL,
    PRAYER_HEAL_OVER_TIME,
    PRAYER_SPEED,
    PRAYER_ACTIVE_FLAG
