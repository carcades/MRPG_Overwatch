# Предписание по написанию OverPy кода

Данный документ определяет правила написания кода для проекта MRPG Overwatch.
Предназначен для разработчиков и нейросетей.

---

## 1. Базовые конструкции OverPy

### 1.1 Структура правил (rules)

```python
rule "Название правила на английском":
    @Event eachPlayer          # или global
    @Condition условие1
    @Condition условие2        # условия объединяются через AND
    
    # тело правила
    действие1
    действие2
```

- `@Event eachPlayer` — правило выполняется для каждого игрока, доступен `eventPlayer`
- `@Event global` — глобальное правило, выполняется один раз
- `@Condition` — правило срабатывает только когда ВСЕ условия истинны
- Все `@Condition` должны идти до тела правила
- `@Disabled` — отключает правило (для отладки)

### 1.2 Переменные

```python
# Объявление (в файлах variables/*.opy)
playervar имя_переменной слот_номер    # переменная игрока (макс 128)
globalvar имя_переменной слот_номер    # глобальная переменная (макс 128)

# Использование
eventPlayer.имя_переменной = значение  # для playervar
имя_переменной = значение              # для globalvar
```

- Слот — число от 0 до 127, каждый слот уникален
- Имя переменной — snake_case
- Максимальный размер массива — 1000 элементов

### 1.3 Подпрограммы (subroutines)

```python
# Объявление (в variables/subroutines.opy)
subroutine имя_подпрограммы

# Определение
def имя_подпрограммы():
    @Name "Читаемое название"
    # тело

# Вызов
имя_подпрограммы()
```

- Подпрограммы НЕ поддерживают аргументы напрямую
- Для передачи данных — записывай во временные переменные перед вызовом
- `def` в OverPy компилируется в subroutine Workshop, а НЕ в обычную функцию

### 1.4 Циклы и условия

```python
# for
for переменная in range(число):
    действие
    wait(0.016)    # ОБЯЗАТЕЛЬНО wait в циклах!

# while  
while условие:
    действие
    wait(0.016)

# if/elif/else
if условие:
    действие
elif другое_условие:
    действие
else:
    действие

# loop (повтор правила при сохранении условий)
if ruleCondition:
    loop()
```

> **ВАЖНО**: Каждый цикл ДОЛЖЕН содержать `wait()`, иначе сервер зависнет.
> Минимальный wait = 0.016 секунд.

### 1.5 Константы компиляции

```python
#!define ИМЯ_КОНСТАНТЫ значение

# Пример
#!define SPAWN_BUBBLE_RADIUS 45.3
```

- Простая текстовая подстановка при компиляции
- Не создаёт переменную Workshop — не занимает слот
- Используй для фиксированных числовых значений

### 1.6 Включение файлов

```python
#!include "путь/к/файлу.opy"
```

- Каждый включаемый файл должен начинаться с `#!mainFile "путь/к/main.opy"`
- Порядок включения важен — зависимости должны быть подключены раньше

### 1.7 Полезные функции Workshop

```python
# Таймер / ожидание
wait(секунды)

# Эффекты
createEffect(visibility, тип, цвет, позиция, радиус, reeval)
destroyEffect(id)
playEffect(visibility, тип, цвет, позиция, радиус)  # мгновенный

# HUD
hudSubheaderText(видимость, текст, позиция, сортировка, цвет, reeval)
progressBarHud(видимость, процент, текст, позиция, сортировка, цвет1, цвет2, reeval)

# Игрок
eventPlayer.getPosition()
eventPlayer.getEyePosition()
eventPlayer.isAlive()
eventPlayer.isMoving()
eventPlayer.isHoldingButton(Button.XXX)
eventPlayer.setMoveSpeed(процент)
eventPlayer.setDamageDealt(процент)
eventPlayer.setMaxHealth(процент)

# Массивы
array.append(элемент)
del array[индекс]
len(array)
array.filter(lambda x: условие)
array.map(lambda x: выражение)
array.index(значение)  # возвращает -1 если не найден

# Утилиты
getTotalTimeElapsed()     # время с начала матча
getLastCreatedEntity()    # ID последнего созданного эффекта
getLastCreatedText()      # ID последнего созданного текста
evalOnce(выражение)       # вычислить один раз и запомнить
```

---

## 2. Продвинутые конструкции: управление переменными

### 2.1 Проблема

Workshop ограничен 128 переменными игрока. Нет объектов, словарей, структур.
Сложные данные приходится хранить в массивах. Код вида `array[5][2]` нечитаем.

### 2.2 Решение: Enum-индексы

Определяй `enum` для каждого массива-структуры:

```python
enum PrayerSalvation:
    PROGRESS = 0,
    HUD_IDS,
    CAST_DURATION,
    CAN_CAST_MOVING,
    IS_ACTIVE

# Использование:
eventPlayer.reader_prayer_of_salvation[PrayerSalvation.PROGRESS]++
eventPlayer.reader_prayer_of_salvation[PrayerSalvation.IS_ACTIVE] = true
```

- Enum компилируется в число — нулевой оверхед в Workshop
- Каждый массив-структура должен иметь свой enum
- Описание полей — в комментарии над enum

### 2.3 Решение: Member-макросы (сокращённый доступ)

```python
macro Player.prayerProgress = self.reader_prayer_of_salvation[PrayerSalvation.PROGRESS]
macro Player.prayerIsActive = self.reader_prayer_of_salvation[PrayerSalvation.IS_ACTIVE]

# Использование (компилируется в тот же код что и enum-индексы):
eventPlayer.prayerProgress++
eventPlayer.prayerIsActive = true
```

- `macro Player.xxx` создаёт свойство, доступное через `player.xxx`
- `self` заменяется на конкретного игрока при компиляции
- Нулевой оверхед — это текстовая подстановка
- Определяй в `settings/array_schemas.opy`

### 2.4 Решение: Функциональные макросы

```python
macro add(a, b): a + b
macro Player.setPowerLevel(level):
    self.setMaxHealth(level * 300)
    self.setDamageDealt(100 + level * 20)
```

- Для повторяющихся вычислений
- Макросы НЕ создают subroutine — код вставляется inline

### 2.5 Файл array_schemas.opy

Все enum-схемы и member-макросы для массивов хранятся в `settings/array_schemas.opy`.

Структура файла:
```python
# ============================================================
# СХЕМЫ МАССИВОВ — [ИМЯ МАССИВА]
# ============================================================
# описание массива

enum ИмяСхемы:
    ПОЛЕ_1 = 0,
    ПОЛЕ_2,
    ПОЛЕ_3

# Member-макросы
macro Player.кратокеИмя = self.имя_переменной[ИмяСхемы.ПОЛЕ_1]
```

**Правила:**
- При добавлении нового поля — добавь в enum и напиши комментарий
- Неиспользуемые слоты помечай как `_UNUSED_N`
- Member-макросы именуй в camelCase: `prayerProgress`, `statLimitHealth`

---

## 3. Стиль кода

### 3.1 Именование

| Что | Стиль | Пример |
|-----|-------|--------|
| Переменные (playervar/globalvar) | snake_case | `stat_damage`, `in_blood_shop` |
| Enum типы | PascalCase | `PrayerSalvation`, `EffectEntry` |
| Enum значения | UPPER_SNAKE_CASE | `CAST_DURATION`, `IS_ACTIVE` |
| Member-макросы | camelCase | `prayerProgress`, `statLimitHealth` |
| Константы (#!define) | UPPER_SNAKE_CASE | `SPAWN_BUBBLE_RADIUS` |
| Правила | Английский, описательно | `"Reader Ability: prayer for salvation"` |
| Файлы | snake_case.opy | `holy_circle.opy`, `stat_shop.opy` |

### 3.2 Структура проекта

```
main.opy                    # точка входа, только #!include
settings/
  extensions.opy            # настройки Workshop
  constants.opy             # #!define и enum (не массивы)
  array_schemas.opy         # enum-схемы массивов и member-макросы
variables/
  global_vars.opy           # globalvar объявления
  player_vars.opy           # playervar объявления
  subroutines.opy           # subroutine объявления
core/                       # базовые системы (init, leveling, hud)
classes/                    # классы персонажей
  reader/                   # класс "Читатель"
systems/                    # глобальные системы (effects_lifecycle)
spawn/, blood/, altar/...   # зоны / локации
debug/                      # отладка
```

### 3.3 Комментарии

```python
# --- Секция ---               # разделитель блока
#секция кода                    # пояснение к следующему блоку
#пояснение к конкретной строке  # inline-комментарий
```

- Комментируй ЗАЧЕМ, а не ЧТО
- Каждый нетривиальный блок кода должен иметь комментарий
- Не удаляй существующие комментарии при рефакторинге

### 3.4 Порядок подключения в main.opy

1. `settings/extensions.opy` — настройки Workshop
2. `settings/constants.opy` — константы и enum 
3. `variables/*.opy` — объявления переменных
4. `settings/array_schemas.opy` — схемы массивов (после переменных!)
5. `core/*.opy` — ядро
6. Локации и классы
7. `systems/*.opy` — глобальные системы
8. `debug/*.opy` — отладка

---

## 4. Правила для нейросети

1. **Не менять код без прямого указания** пользователя
2. **Перед изменением массива** — проверь `settings/array_schemas.opy`
3. **Никогда не используй магические числа** для индексов массивов — используй enum
4. **При добавлении нового массива-структуры** — создай enum и member-макросы в `array_schemas.opy`
5. **Всегда добавляй `wait()`** в циклы
6. **Помни лимиты**: 128 playervar, 128 globalvar, 256 эффектов, 128 текстов, 8-12 игроков
7. **Не создавай лишние эффекты** — переиспользуй существующие через reeval
8. **Файл = один логический модуль** — не смешивай разные системы в одном файле
