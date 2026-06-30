# ARCHITECTURE.md — карта систем MRPG Overwatch

> **Роль этого файла.** Это живая **карта** проекта: что уже реализовано, через что
> с этим работать, какие швы опасны. Она существует, потому что владелец кода не
> читает `.opy` напрямую, а каждая новая нейросеть в новом диалоге не знает, что
> уже есть. Сюда стоит писать: описание существующих систем и список известных швов.
> **Не сюда:** процедуры «как добавлять фичу» (→ `BUILD.md`), синтаксис языка и
> движка (→ `CODESTYLE.md`).
>
> **Правило ведения:** добавил/изменил систему — обнови соответствующую строку
> здесь. Это часть Definition of Done (см. `BUILD.md`). Документ должен описывать
> код таким, какой он есть, а не каким задумывался.
>
> Сопутствующие документы: `BUILD.md` (как добавлять фичи), `CODESTYLE.md`
> (язык и оптимизация), `tools/validate.py` (статический шлагбаум).

---

## Карта файлов

```
main.opy                       точка входа: только #!include в нужном порядке
settings/
  extensions.opy               настройки Workshop
  constants.opy                #!define + enum (Zone, EffectType, EffectAction, BuffId, ...)
  array_schemas.opy            enum-схемы массивов + member-макросы + ЕДИНЫЙ API эффектов
                               (в т.ч. схема passives_data: вампиризм/кровотечение/cursed mark)
variables/
  global_vars.opy              globalvar объявления
  player_vars.opy              playervar объявления (слот = ручной номер из пула 128)
  subroutines.opy              subroutine объявления (слот = ручной номер)
core/
  init.opy                     инициализация матча и игроков (Player Init, Init Dummy Bot)
  leveling.opy                 рост статов с уровнем, цвет XP-бара
  respawn.opy                  телепорт на спавн, очистка при смерти (СЛАБАЯ — см. швы)
  hud.opy                      левый HUD (XP/валюта) + правый список баффов (5 слотов)
  player_leave.opy             Мусорная корзина (Garbage Collection): очистка эффектов при выходе
systems/
  effects_lifecycle.opy        ХРЕБЕТ: add_buff/extend_buff/add_hud_buff + авто-удаление
spawn/ blood/ underground/
  world/ altar/ relic_treasury/ зоны и их механики
classes/
  reader/                      класс «Читатель» (ангельская ветка): prayer_of_salvation,
                               prayer_of_courage, holy_circle, init
  demon_worshiper/             класс «Демонопоклонник» (демоническая ветка): cursed_mark
debug/test_rules.opy           отладочные правила
tools/validate.py              статический валидатор связей (запускать перед сборкой)
```

Порядок `#!include` в `main.opy` важен: extensions → constants → переменные →
схемы → core → зоны/классы → systems → debug.

---

## Хребет: система жизненного цикла эффектов

Файл: `systems/effects_lifecycle.opy`. Это центральная система, через которую
проходят ВСЕ временные эффекты.

**Хранилище** — 6 параллельных массивов на игроке (индекс i = один эффект):
`active_buff_ids`, `active_buff_targets`, `active_buff_expire_times`,
`active_buff_types`, `active_buff_actions`, `active_buff_values`.
Схема индекса — enum `EffectEntry` в `array_schemas.opy`.

**Регистрация:**
- Низкоуровнево: `eventPlayer.buff_append_args = [...]` затем `add_buff()` —
  **работает только над `eventPlayer`**.
- Рекомендуемо (любая цель): макросы `trackBuff(...)` / `applyVisibleDebuff(...)`
  из `array_schemas.opy` — работают на `self`, т.е. `victim.applyVisibleDebuff(...)`.

**Продление:** `extend_buff()` (формат `[[ids...], newExpire]`) или атомарно по
индексу `.active_buff_expire_times[...index(id)] = newExpire`.

**Удаление и откат — автоматические.** Правило `Process player buffs` каждые ~0.2с
сканирует массивы; при истечении времени по `EffectType` делает нужное:
| EffectType | что делает при истечении |
|---|---|
| `ENTITY` | `destroyEffect(target)` |
| `HEAL_OVER_TIME` | `stopHealingOverTime(target)` |
| `HEALTH_BAR` | `removeHealthPool(target)` |
| `PLAYER_VARIABLE` | по `EffectAction` снимает флаг (напр. `prayerIsActive=false`) |
| `SPEED`/`DAMAGE`/`HEALTH`/`DAMAGE_RECEIVED`/`HEALING_RECEIVED`/`PROJECTILE_SPEED` | вычитает `value` из стата и переприменяет (`setMoveSpeed`/...) |

> **Контракт длины (важно):** стат-типы при истечении читают `value` → их
> `buff_append_args` обязан содержать все 6 элементов. Не-стат-типы (`ENTITY` и т.п.)
> `action`/`value` не читают → достаточно 4. Это проверяет `validate.py` (E).
> Если добавляешь НОВЫЙ стат-`EffectType` — обязан добавить ему `elif`-ветку
> отката здесь, иначе стат не восстановится никогда.

---

## HUD-баффы (правый список)

Файлы: данные — `hud_buff_*` массивы; рендер — `core/hud.opy`; авто-удаление —
правило `Process HUD buffs` в `effects_lifecycle.opy`.

4 параллельных массива: `hud_buff_ids`, `hud_buff_expires`, `hud_buff_names`,
`hud_buff_colors`. Регистрация: `add_hud_buff()` (только eventPlayer) или
`trackHud(...)`/`applyVisibleDebuff(...)` (любая цель).

**Лимит 5 одновременных HUD-надписей — осознанный** (экономия лимита в 128
текстов / 256 эффектов Workshop). Это не баг. 6-й бафф не отобразится.

---

## Статы игрока (Архитектура Base + Modifiers)

Все статы-проценты (`speed`, `damage`, `health`, `damage_received`, `healing_received`, `projectiles_speed`) рассчитываются через компонентную систему на основе индексов `EffectType` (от 4 до 9).

- **`base_stats`** (массив): Базовые значения (по умолчанию 100 для статов). Изменяются перманентно при получении уровня или в магазинах. Инициализируются в `core/init.opy` (для Player и Bot) массивом из 10 элементов.
- **`mod_stats`** (массив): Временные баффы (по умолчанию 0). Автоматически обновляются макросами `trackBuff`/`applyVisibleDebuff` и системой `effects_lifecycle.opy` при добавлении или истечении баффов.
- **`apply_all_stats()`** (макрос): Складывает базу и модификатор `max(0, base + mod)` для всех характеристик и вызывает нативные экшены `setMoveSpeed`, `setDamageDealt` и т.д.

Прямых переменных вроде `stat_speed` больше не существует. Доступ к значениям предоставляется только через макросы (`base_stat_speed`, `mod_stat_damage` и т.д. в `array_schemas.opy`). Лимиты хранятся в массиве `stats_limit` (enum `StatLimit`).

---

## Пассивки (`passives_data`)

Файл схемы: `settings/array_schemas.opy` (enum `PassivesData`, 15 полей). Один playervar
`passives_data` (слот 20) хранит данные трёх подсистем через member-макросы:

- **Вампиризм** — `passiveVampire`, `vampireSize`, `vampireLevel` (покупается в
  `blood/shop.opy`, читается в `blood/abilities.opy`).
- **Кровотечение** — `bleeding*` поля (шанс/кд/длительность/сила/уровень + флаг
  `isReceivingBleedDamage`).
- **Cursed Mark** (Demon Worshiper) — `cursedMarkStacks`, `cursedMarkExpire`,
  `cursedMarkDamagePool`, `cursedMarkEffectId`.

**Инициализация плотным литералом из 15 элементов — в ОБОИХ init-блоках** `core/init.opy`
(`Player Init` и `Init Dummy Bot`), по умолчанию всё `false`/`0` = «выкл». Литерал
обязателен: без него массив — «голый ноль», и первая запись по индексу (напр.
`cursedMarkStacks` = индекс 10) создаёт разреженный массив (запрет `CODESTYLE §6.1`).
Длину покрывает валидатор (check B: 15 элементов = 15 полей enum).

---

## Классы и ветки развития

Класс определяется `altar_status` (enum `AltarStatus`: NONE / TIER_2_SELECTION /
READER / DEMON_WORSHIPER). Выбор — в `altar/tier_selection.opy` (зона Алтаря).

**`branch_data` — переменная-«юнион»:** один и тот же playervar хранит данные
текущей ветки. Если игрок Reader — поля по enum `AngelicBranchData` (24 поля).
Если Demon — по enum `DemonicBranchData` (4 поля). Member-макросы (`prayerProgress`,
`dwCurseDuration` и т.п.) дают именованный доступ. **Не читай ангельские макросы у
демона и наоборот** — это разные раскладки одного массива.

- **Reader (ангельская):** способности `prayer_of_salvation` (баф: health pool +
  heal-over-time + speed, стаки), `prayer_of_courage` (Tier 2). Файлы в
  `classes/reader/`. Хороший образец работы с хребтом.
- **Demon Worshiper (демоническая):** пассив Ash Layer (−20% урона), способность
  Cursed Mark (`cursed_mark.opy`) — стак-дебафф на `victim` с накоплением урона.

---

## Зоны

enum `Zone`: NONE, BUBBLE, BLOOD_SHOP, EMERALD_MINE, ALTAR, UNDERGROUND,
RELIC_TREASURY. Текущая зона игрока — `current_zone`. Зоны влияют на доступность
способностей (напр. молитва кастуется только в `Zone.NONE`) и на отображение.

Спавн даёт иммунитет/лечение (heal-bubble) — это **состояние зоны**, не бафф, в
хребте не регистрируется.

---

## Экономика и валюты

`gold`, `emeralds`, `blood_points`, `level_up_points`, `xp`/`level`. Майнинг:
`world/xp_mine.opy` (опыт), `world/blood_money_mine.opy`, `underground/emerald_*`
(изумруды с динамической ценой). Магазины: `spawn/stat_shop.opy`,
`blood/shop.opy`, `relic_treasury/shop.opy`.

---

## Известные швы (риски, ещё не закрытые архитектурно)

Отсортировано по тяжести. Это карта того, где «выстрелит через полгода».

| # | Шов | Статус |
|---|-----|--------|
| 1 | **Смерть не чистит `active_buff_*`.** `core/respawn.opy` при `playerDied` зовёт только `stopAllDamageOverTime()`. Если игрок умер с активным стат-баффом, после респауна бафф истечёт и система вычтет его из стата → возможна порча стата. | ЗАКРЫТ (при смерти `*_expire_times` обнуляются, вызывая безопасный авто-откат) |
| 2 | **Нет правила `playerLeft`.** При выходе игрока его HUD/эффекты не убираются принудительно → ghost-сущности в памяти сервера (нарушает `CODESTYLE §6.5`). | ЗАКРЫТ (добавлен `core/player_leave.opy` с GC-системой, чистящей баффы и `gc_ids`) |
| 3 | **`add_buff()` привязан к `eventPlayer`.** Дебаффы на чужую цель раньше требовали ручных `.append` (см. историю `cursed_mark`). | ЗАКРЫТ (внедрены макросы `trackBuff`/`applyVisibleDebuff`/`extendBuff`, `cursed_mark` полностью переведён на них) |
| 4 | **`branch_data` — юнион двух раскладок.** Чтение «не той» ветки даёт тихий мусор. | ПРИНЯТО как дизайн; защита — дисциплина макросов |
| 5 | **`tier_up_reset` — заготовка** (`# stub`, без `def`). Сброс бонусов при переходе на тир выше пока не реализован. | ЗАПЛАНИРОВАН |
| 6 | **Инициализация продублирована** в `Player Init` и `Init Dummy Bot` (статы + `passives_data`). Новый стат/поле легко забыть в одном из блоков. Вдобавок бот-init **неполный**: нет `stats_limit`, `level_up_points`, `current_race` и др. — боты живут на zero-default. | ЗАКРЫТ (бот-init теперь полностью синхронизирован с Player Init: добавлены `stats_limit`, `level_up_points`, `current_race` и прочие поля) |

Когда закрываешь шов — обнови его статус здесь.

---

## Что проверяет валидатор (`tools/validate.py`)

Запуск: `python tools/validate.py` (exit 0 = можно собирать; exit 1 = есть ERROR).

| Чек | Ловит |
|---|---|
| A. Слоты | коллизии/дубли номеров и имён в пулах playervar/globalvar/subroutine |
| B. enum↔литерал | длина инициализатора массива ≠ числу полей его enum-схемы |
| C. Подпрограммы | объявлен subroutine без `def` (кроме `# stub`); `def` без объявления; мёртвый код |
| D1. enum-ссылки | `Enum.MEMBER`, которого нет в enum (опечатка); сироты-члены |
| D2. обход API | ручной `.append` в `active_buff_*` вне `effects_lifecycle` (WARN) |
| E. арность | `buff_append_args` неверной длины для своего `EffectType` (стат < 6 = ERROR) |
| F. HUD-связность | (заглушка, зарезервировано) |
| G. Утечки (GC) | сырые вызовы `createEffect` и др. без отслеживания через GC-макросы |

Добавить новый чек = одна функция `check_*` + строка в списке `CHECKS`. Это и есть
механизм наращивания защиты под новые системы (см. `BUILD.md` → «Новая
инфраструктура»).
