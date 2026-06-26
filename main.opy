# =============================================
# MRPG Overwatch - Main Entry Point
# =============================================
# Кастомный RPG-режим для Overwatch Workshop.
# Код организован в модульную структуру через #!include.
# Для компиляции используйте OverPy (VS Code extension).                

# --- Settings & Extensions ---
#!include "settings/extensions.opy"
#!include "settings/constants.opy"

# --- Variable Declarations ---
#!include "variables/global_vars.opy"
#!include "variables/player_vars.opy"
#!include "variables/subroutines.opy"

# --- Schemas ---
#!include "settings/array_schemas.opy"

# --- Core Systems ---  
#!include "core/init.opy"
#!include "core/leveling.opy"
#!include "core/respawn.opy"
#!include "core/hud.opy"

# --- Spawn Area ---
#!include "spawn/coordinates.opy"
#!include "spawn/effects.opy"
#!include "spawn/bubble.opy"
#!include "spawn/hero_select.opy"
#!include "spawn/stat_shop.opy"

# --- Blood Shop & Seppuku ---
#!include "blood/coordinates.opy"
#!include "blood/effects.opy"
#!include "blood/seppuku.opy"
#!include "blood/shop.opy"
#!include "blood/abilities.opy"

# --- Underground ---
#!include "underground/coordinates.opy"
#!include "underground/effects.opy"
#!include "underground/navigation.opy"
#!include "underground/emerald_economy.opy"
#!include "underground/emerald_mining.opy"

# --- World Objects ---
#!include "world/coordinates.opy"
#!include "world/effects.opy"
#!include "world/xp_mine.opy"
#!include "world/blood_money_mine.opy"

# --- Relic Treasury ---
#!include "relic_treasury/coordinates.opy"
#!include "relic_treasury/effects.opy"
#!include "relic_treasury/navigation.opy"
#!include "relic_treasury/shop.opy"

# --- Altar of Rebirth ---
#!include "altar/coordinates.opy"
#!include "altar/effects.opy"
#!include "altar/navigation.opy"
#!include "altar/subroutines.opy"
#!include "altar/tier_selection.opy"

# --- Classes ---
#!include "classes/reader/init.opy"
#!include "classes/reader/holy_circle.opy"
#!include "classes/reader/prayer_of_salvation.opy"
#!include "classes/reader/prayer_of_courage.opy"

#!include "classes/demon_worshiper/cursed_mark.opy"

# --- Systems ---
#!include "systems/effects_lifecycle.opy"

# --- Debug & Testing ---
#!include "debug/test_rules.opy"
