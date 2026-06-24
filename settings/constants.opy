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
