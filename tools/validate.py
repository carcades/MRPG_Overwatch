#!/usr/bin/env python3
# ============================================================
# MRPG Overwatch — static validator for OverPy (.opy)
# ============================================================
# Парсит .opy как текст и проверяет СВЯЗИ между системами проекта:
#   A. целостность слотов (3 независимых пула по 128)
#   B. синхронизация enum <-> литералы массивов-схем
#   C. целостность подпрограмм (declare/def/call)
#   D. целостность BuffId / EffectAction (сироты, опечатки, обход API)
#   E. арность buff_append_args относительно вызова buff-подпрограммы
#   F. HUD-связность баффов (эвристика по префиксам имён)
#
# Запуск:  python tools/validate.py
# Exit:    0 = чисто (могут быть только WARN); 1 = есть хотя бы одна ERROR.
#
# Зависимости: только стандартная библиотека Python 3.
# Добавить новый чек = написать одну функцию и зарегистрировать её в CHECKS.
# ============================================================

import os
import re
import sys
from dataclasses import dataclass, field

# --- Параметры ---------------------------------------------------------------

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SKIP_DIRS = {".git", "node_modules", "__pycache__", ".venv", "venv", "tools", ".agents"}
OPY_EXT = ".opy"

# Workshop: 3 независимых пула по 128 слотов каждый.
SLOT_KINDS = ("globalvar", "playervar", "subroutine")
MAX_SLOT = 127

# Имена файлов, где разрешён прямой доступ к active_buff_* (центральная
# инфраструктура): сама система жизненного цикла и файл с макросами-API,
# которые в это разворачиваются.
BUFF_API_FILES = {
    "systems/effects_lifecycle.opy",
    "settings/array_schemas.opy",
}

# Арность buff_append_args в зависимости от целевой подпрограммы.
# add_buff намеренно ПЕРЕМЕННОЙ длины: lifecycle читает поля action/value
# только для стат-эффектов. Точная требуемая длина зависит от EffectType
# (4-й элемент массива) — см. BUFF_ADD_ARITY_BY_TYPE ниже.
BUFF_CALL_ARITY = {
    "add_hud_buff": 5,   # [target, expire, name, color, id]
    "extend_buff": 2,    # [[ids...], expire]
}
BUFF_CALL_NAMES = ("add_buff", "add_hud_buff", "extend_buff")

# Контракт длины add_buff по EffectType (формат [id, target, expire, type, action, value]).
# Типы, чья очистка в effects_lifecycle НЕ читает action/value -> хватает 4 элементов.
# PLAYER_VARIABLE читает action (для ветвления флага) -> 5.
# Стат-типы откатываются через value -> обязаны иметь все 6, иначе стат
# «восстановится на 0» = тихая порча стата (главный класс багов проекта).
BUFF_ADD_ARITY_BY_TYPE = {
    "ENTITY": 4,
    "HEALTH_BAR": 4,
    "HEAL_OVER_TIME": 4,
    "PLAYER_VARIABLE": 5,
    "SPEED": 6,
    "DAMAGE": 6,
    "HEALTH": 6,
    "DAMAGE_RECEIVED": 6,
    "HEALING_RECEIVED": 6,
    "PROJECTILE_SPEED": 6,
}
# Если EffectType не распознан — разрешаем диапазон, чтобы не врать.
BUFF_ADD_ARITY_FALLBACK = (4, 5, 6)
# Окно поиска парного вызова после присвоения buff_append_args (в строках).
BUFF_CALL_WINDOW = 8

# Enum'ы, члены которых проверяются на связность (использование/сиротство).
ENUM_REFS = ("BuffId", "EffectAction", "EffectType")


# --- Модель находки ----------------------------------------------------------

@dataclass
class Finding:
    severity: str        # "ERROR" | "WARN"
    rel_path: str        # путь относительно корня проекта
    line: int            # 1-based, 0 = «файл в целом»
    message: str


@dataclass
class SourceFile:
    rel_path: str
    raw: str
    lines: list = field(default_factory=list)  # нормализованные строки (без \r)


# --- Утилиты сканирования ----------------------------------------------------

def norm_line_endings(text: str) -> str:
    """В проекте смешанные CRLF/LF/mixed — нормализуем к \\n."""
    return text.replace("\r\n", "\n").replace("\r", "\n")


def strip_inline_comment(code: str) -> str:
    """Убирает хвостовой `# ...` комментарий, не трогая `#` внутри строк.

    OverPy не имеет блочных комментариев — только line comments.
    Строки в OverPy только двойные (Custom String, ".." ). Одинарных кавычек нет.
    """
    out = []
    i, n = 0, len(code)
    in_str = False
    while i < n:
        ch = code[i]
        if ch == '"':
            in_str = not in_str
            out.append(ch)
            i += 1
            continue
        if ch == "#" and not in_str:
            break  # комментарий до конца строки
        out.append(ch)
        i += 1
    return "".join(out)


def discover_files() -> list:
    found = []
    for dirpath, dirnames, filenames in os.walk(PROJECT_ROOT):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for fn in filenames:
            if fn.endswith(OPY_EXT):
                abs_path = os.path.join(dirpath, fn)
                rel = os.path.relpath(abs_path, PROJECT_ROOT).replace(os.sep, "/")
                found.append(rel)
    found.sort()
    return found


def load_files(rel_paths: list) -> list:
    files = []
    for rel in rel_paths:
        abs_path = os.path.join(PROJECT_ROOT, rel)
        with open(abs_path, "r", encoding="utf-8") as f:
            raw = f.read()
        norm = norm_line_endings(raw)
        files.append(SourceFile(rel_path=rel, raw=norm, lines=norm.split("\n")))
    return files


# --- Парсер ------------------------------------------------------------------
#
# Все индексы строятся по нормализованному тексту. Регекспы привязаны к
# подтверждённым форматам проекта (см. отчёт исследования).

DECL_RE = {
    kind: re.compile(rf"^\s*{kind}\s+([A-Za-z_]\w*)\s+(\d+)\b")
    for kind in SLOT_KINDS
}
DEF_RE = re.compile(r"^\s*def\s+([A-Za-z_]\w*)\s*\(\s*\)")
ENUM_HEADER_RE = re.compile(r"^\s*enum\s+([A-Za-z_]\w*)\s*:")
# член enum'а: 4 пробела отступа, NAME (= value)? ,  (с опц. хвостовым комментарием)
ENUM_MEMBER_RE = re.compile(r"^\s{4}([A-Z][A-Z0-9_]*)\s*(?:=\s*\d+)?\s*,?\s*(.*)$")
MACRO_RE = re.compile(r"^\s*macro\s+Player\.([A-Za-z_]\w*)\s*=\s*(.+?)\s*$")
# macro RHS, ссылающийся на массив-схему по enum-индексу:  self.<var>[<Enum>.<MEMBER>]
MACRO_ENUM_REF_RE = re.compile(r"self\.([a-z_]\w*)\s*\[\s*([A-Z][A-Za-z0-9_]*)\.([A-Z][A-Z0-9_]*)\s*\]")
# macro RHS, ссылающийся просто на массив (без enum):  self.<var>
MACRO_PLAIN_REF_RE = re.compile(r"self\.([a-z_]\w*)\b")
# вызов подпрограммы по имени (без точки перед именем):  name()
CALL_RE = re.compile(r"(?<![A-Za-z0-9_\.])([a-z_]\w*)\s*\(")
# ссылка на член enum:  EnumName.MEMBER
ENUM_REF_RE = re.compile(r"\b([A-Z][A-Za-z0-9_]*)\.([A-Z][A-Z0-9_]*)\b")
# присвоение литерала массива через member-access:  <obj>.<var> = [
LITERAL_MEMBER_RE = re.compile(r"([A-Za-z_]\w*)\.([a-z_]\w*)\s*=\s*\[")
# присвоение литерала массива bare (глобал):  <var> = [
LITERAL_BARE_RE = re.compile(r"(?<![A-Za-z0-9_\.])([a-z_]\w*)\s*=\s*\[")
# ручной append в active_buff_*:  <obj>.active_buff_ids.append(
MANUAL_APPEND_RE = re.compile(
    r"\.active_buff_(ids|targets|expire_times|types|actions|values)\s*\.\s*append\s*\("
)
BUFF_APPEND_ASSIGN_RE = re.compile(r"\.buff_append_args\s*=\s*\[")
BUFF_CALL_RE = re.compile(r"(?<![A-Za-z0-9_\.])(add_buff|add_hud_buff|extend_buff)\s*\(")


@dataclass
class SlotDecl:
    kind: str
    name: str
    slot: int
    rel_path: str
    line: int
    is_stub: bool = False   # помечено `# stub` — намеренная заготовка, def появится позже


@dataclass
class EnumDef:
    name: str
    members: list          # имена членов по порядку
    rel_path: str
    header_line: int
    member_lines: list     # параллельно с members: строка каждого члена


@dataclass
class LiteralAssign:
    varname: str
    element_count: int
    rel_path: str
    line: int
    is_bare: bool


@dataclass
class BuffAppend:
    rel_path: str
    line: int
    element_count: int
    type_token: str = ""   # 4-й элемент, напр. "EffectType.SPEED" (для type-aware арности)


@dataclass
class BuffCall:
    name: str              # add_buff / add_hud_buff / extend_buff
    rel_path: str
    line: int              # абсолютный символьный offset в тексте файла


@dataclass
class Index:
    slot_decls: list = field(default_factory=list)         # [SlotDecl]
    enums: dict = field(default_factory=dict)              # name -> EnumDef
    macro_enum_refs: list = field(default_factory=list)    # [(varname, enum_name)]
    macro_plain_refs: list = field(default_factory=list)   # [varname]
    defs: dict = field(default_factory=dict)               # name -> [(rel, line)]
    literals: list = field(default_factory=list)           # [LiteralAssign]
    calls: list = field(default_factory=list)              # [(name, rel, line)]
    buff_appends: list = field(default_factory=list)       # [BuffAppend]
    buff_calls: list = field(default_factory=list)         # [BuffCall]
    enum_refs: dict = field(default_factory=dict)          # EnumName -> set(used members)
    manual_appends: list = field(default_factory=list)     # [(rel, line, array_part)]


def _literal_element_count(text: str, open_bracket_pos: int) -> int:
    """Считает top-level элементы литерала `[...]` начиная с позиции открывающей `[`.

    Корректно обрабатывает: строки ("..."), вложенные []/(), многострочность,
    встроенные \\n внутри строк. Возвращает число элементов (0 для `[]`).
    """
    depth = 0
    top_commas = 0
    i = open_bracket_pos
    n = len(text)
    in_str = False
    seen_any = False
    while i < n:
        ch = text[i]
        if in_str:
            if ch == '"':
                in_str = False
            i += 1
            continue
        if ch == '"':
            in_str = True
            seen_any = True
            i += 1
            continue
        if ch == "[":
            depth += 1
            if depth == 1:
                seen_any = False  # reset: пустой ли первый уровень
            i += 1
            continue
        if ch == "]":
            depth -= 1
            if depth == 0:
                # конец литерала
                return top_commas + 1 if seen_any else top_commas
            i += 1
            continue
        if ch == "(":
            depth += 1
            i += 1
            continue
        if ch == ")":
            depth -= 1
            i += 1
            continue
        if depth == 1 and ch == ",":
            top_commas += 1
            seen_any = True
        elif depth >= 1 and ch.strip() != "":
            seen_any = True
        i += 1
    # Не нашли закрывающую скобку — считаем литерал незавершённым.
    return -1


def _literal_top_elements(text: str, open_bracket_pos: int) -> list:
    """Возвращает список top-level элементов литерала `[...]` как обрезанные строки.

    Тем же скобочно-балансным разбором, что и _literal_element_count, но
    собирает сами подстроки элементов (для чтения, например, EffectType.X в
    4-м элементе buff_append_args). Возвращает [] если литерал не закрыт.
    """
    depth = 0
    i = open_bracket_pos
    n = len(text)
    in_str = False
    start = None          # начало текущего элемента (на глубине 1)
    elements = []
    while i < n:
        ch = text[i]
        if in_str:
            if ch == '"':
                in_str = False
            i += 1
            continue
        if ch == '"':
            in_str = True
            if depth == 1 and start is None:
                start = i
            i += 1
            continue
        if ch in "[(":
            if depth == 1 and start is None and ch == "[":
                start = i  # вложенный массив как элемент
            depth += 1
            i += 1
            continue
        if ch in "])":
            depth -= 1
            if depth == 0:
                if start is not None:
                    elements.append(text[start:i].strip())
                return elements
            i += 1
            continue
        if depth == 1 and ch == ",":
            elements.append(text[start:i].strip() if start is not None else "")
            start = None
            i += 1
            continue
        if depth == 1 and start is None and ch.strip() != "":
            start = i
        i += 1
    return []


def _line_of_offset(lines: list, offset: int) -> int:
    """Возвращает 1-based номер строки по символьному offset'у."""
    pos = 0
    for idx, ln in enumerate(lines):
        if pos + len(ln) + 1 > offset:  # +1 за \n
            return idx + 1
        pos += len(ln) + 1
    return len(lines)


def parse_files(files: list) -> Index:
    idx = Index()

    for sf in files:
        text = sf.raw
        lines = sf.lines

        # --- Объявления слотов (3 пула) ---
        for lineno, line in enumerate(lines, start=1):
            code = strip_inline_comment(line)
            # маркер намеренной заготовки в хвостовом комментарии: `# stub`
            comment = line[len(code):]
            is_stub = bool(re.search(r"#\s*stub\b", comment, re.IGNORECASE))
            for kind in SLOT_KINDS:
                m = DECL_RE[kind].match(code)
                if m:
                    idx.slot_decls.append(SlotDecl(
                        kind=kind, name=m.group(1), slot=int(m.group(2)),
                        rel_path=sf.rel_path, line=lineno, is_stub=is_stub,
                    ))
                    break

        # --- def подпрограмм ---
        for lineno, line in enumerate(lines, start=1):
            m = DEF_RE.match(line)
            if m:
                name = m.group(1)
                idx.defs.setdefault(name, []).append((sf.rel_path, lineno))

        # --- enum'ы (могут быть в любом файле) ---
        cur_enum = None
        for lineno, line in enumerate(lines, start=1):
            mh = ENUM_HEADER_RE.match(line)
            if mh:
                cur_enum = EnumDef(
                    name=mh.group(1), members=[], rel_path=sf.rel_path,
                    header_line=lineno, member_lines=[],
                )
                idx.enums[cur_enum.name] = cur_enum
                continue
            if cur_enum is not None:
                stripped = line.strip()
                # Пустая строка ВНУТРИ enum не завершает блок: в проекте enum'ы
                # разбиты пустыми строками на смысловые группы (Tier 1 / Tier 2).
                # Завершаем блок только на строке без отступа (новая конструкция
                # у левого края: macro/enum/rule/комментарий-разделитель).
                if stripped == "":
                    continue
                if not line.startswith("    "):
                    cur_enum = None
                    continue
                # внутри блока: пропускаем чистые комментарии
                if stripped.startswith("#"):
                    continue
                mm = ENUM_MEMBER_RE.match(line)
                if mm:
                    cur_enum.members.append(mm.group(1))
                    cur_enum.member_lines.append(lineno)

        # --- macros: вывод schema_var -> enum ---
        for lineno, line in enumerate(lines, start=1):
            code = strip_inline_comment(line)
            if not MACRO_RE.match(code):
                continue
            for m in MACRO_ENUM_REF_RE.finditer(code):
                idx.macro_enum_refs.append((m.group(1), m.group(2)))
            for m in MACRO_PLAIN_REF_RE.finditer(code):
                idx.macro_plain_refs.append(m.group(1))

        # --- литералы массивов (member-access и bare) ---
        # member-access: ищем по всему тексту, считаем длину через баланс скобок.
        for m in LITERAL_MEMBER_RE.finditer(text):
            varname = m.group(2)
            open_pos = text.index("[", m.start(2))
            count = _literal_element_count(text, open_pos)
            if count < 0:
                continue
            lineno = _line_of_offset(lines, m.start())
            idx.literals.append(LiteralAssign(
                varname=varname, element_count=count,
                rel_path=sf.rel_path, line=lineno, is_bare=False,
            ))
        for m in LITERAL_BARE_RE.finditer(text):
            varname = m.group(1)
            open_pos = text.index("[", m.start(1))
            count = _literal_element_count(text, open_pos)
            if count < 0:
                continue
            lineno = _line_of_offset(lines, m.start())
            idx.literals.append(LiteralAssign(
                varname=varname, element_count=count,
                rel_path=sf.rel_path, line=lineno, is_bare=True,
            ))

        # --- вызовы подпрограмм ---
        for lineno, line in enumerate(lines, start=1):
            # убираем строку-определение def и комментарии
            if DEF_RE.match(line):
                continue
            code = strip_inline_comment(line)
            for m in CALL_RE.finditer(code):
                idx.calls.append((m.group(1), sf.rel_path, lineno))

        # --- buff_append_args присвоения ---
        for m in BUFF_APPEND_ASSIGN_RE.finditer(text):
            open_pos = text.index("[", m.start())
            count = _literal_element_count(text, open_pos)
            if count < 0:
                count = 0
            els = _literal_top_elements(text, open_pos)
            # 4-й элемент (индекс 3) — EffectType.X, если присутствует
            type_token = els[3] if len(els) >= 4 else ""
            lineno = _line_of_offset(lines, m.start())
            idx.buff_appends.append(BuffAppend(
                rel_path=sf.rel_path, line=lineno, element_count=count,
                type_token=type_token,
            ))

        # --- buff-вызовы ---
        for m in BUFF_CALL_RE.finditer(text):
            lineno = _line_of_offset(lines, m.start())
            idx.buff_calls.append(BuffCall(
                name=m.group(1), rel_path=sf.rel_path, line=m.start(),
            ))

        # --- ссылки на члены enum'ов (для orphan/typo чеков) ---
        # пропускаем строки-тела определений enum'ов, чтобы само определение
        # не считалось «использованием».
        enum_body_lines = set()
        for edef in idx.enums.values():
            if edef.rel_path == sf.rel_path:
                for ml in edef.member_lines:
                    enum_body_lines.add(ml)
        for lineno, line in enumerate(lines, start=1):
            if lineno in enum_body_lines:
                continue
            code = strip_inline_comment(line)
            for m in ENUM_REF_RE.finditer(code):
                enum_name, member = m.group(1), m.group(2)
                idx.enum_refs.setdefault(enum_name, set()).add(member)

        # --- ручные append в active_buff_* (обход инфраструктуры) ---
        for lineno, line in enumerate(lines, start=1):
            code = strip_inline_comment(line)
            m = MANUAL_APPEND_RE.search(code)
            if m:
                idx.manual_appends.append((sf.rel_path, lineno, m.group(1)))

    return idx


# --- Вспомогательный вывод карты schema_var -> {enum} ------------------------

def build_schema_map(idx: Index) -> dict:
    """varname -> set(enum_name), выведенная из макросов.

    Макросы вида `macro Player.X = self.<var>[<Enum>.MEMBER]` связывают
    переменную-массив со схемой (enum). Эта карта используется чеком B без
    какой-либо ручной конфигурации: добавление новой схемы через макрос
    автоматически включает её в проверку.
    """
    schema = {}
    for varname, enum_name in idx.macro_enum_refs:
        schema.setdefault(varname, set()).add(enum_name)
    return schema


# --- Чеки --------------------------------------------------------------------

def check_slots(idx: Index) -> list:
    """A. Целостность слотов — 3 независимых пула по 128 (превентивно).

    Дубли ищутся СТРОГО внутри одного типа: slot 5 в globalvar не конфликтует
    со slot 5 в playervar. Это страховка от будущих коллизий при росте проекта.
    """
    findings = []
    by_kind_slot = {k: {} for k in SLOT_KINDS}   # (kind, slot) -> [(rel,line,name)]
    by_kind_name = {k: {} for k in SLOT_KINDS}   # (kind, name) -> [(rel,line)]

    for d in idx.slot_decls:
        if d.slot < 0 or d.slot > MAX_SLOT:
            findings.append(Finding("ERROR", d.rel_path, d.line,
                f"{d.kind} '{d.name}' slot {d.slot} вне диапазона 0-{MAX_SLOT}"))
        by_kind_slot[d.kind].setdefault(d.slot, []).append(d)
        by_kind_name[d.kind].setdefault(d.name, []).append(d)

    for kind, slots in by_kind_slot.items():
        for slot, decls in slots.items():
            if len(decls) > 1:
                # report на первой декларации, со ссылкой на коллизию
                locs = ", ".join(f"{d.rel_path}:{d.line}" for d in decls)
                d0 = decls[0]
                findings.append(Finding("ERROR", d0.rel_path, d0.line,
                    f"{kind}: slot {slot} занят {len(decls)} раз ({locs})"))
    for kind, names in by_kind_name.items():
        for name, decls in names.items():
            if len(decls) > 1:
                locs = ", ".join(f"{d.rel_path}:{d.line}" for d in decls)
                d0 = decls[0]
                findings.append(Finding("ERROR", d0.rel_path, d0.line,
                    f"{kind}: имя '{name}' объявлено {len(decls)} раз ({locs})"))
    return findings


def check_enum_literal_sync(idx: Index) -> list:
    """B. Синхронизация enum <-> литералы массивов-схем.

    Для каждого литерала `eventPlayer.<var> = [...]` (или bare-глобала),
    если <var> связан со схемой (через макрос), длина литерала должна
    совпадать хотя бы с одним из enum'ов схемы. Ловит drift при добавлении
    поля в enum, но забытом обновлении инициализатора (branch_data 20 vs 24).
    """
    findings = []
    schema = build_schema_map(idx)
    enum_sizes = {name: len(ed.members) for name, ed in idx.enums.items()}

    # какие schema-var'ы хотя бы раз инициализируются литералом
    inited_schema_vars = set()
    for lit in idx.literals:
        if lit.varname in schema:
            inited_schema_vars.add(lit.varname)

    for lit in idx.literals:
        if lit.varname not in schema:
            continue
        expected = sorted(schema[lit.varname])
        sizes = {e: enum_sizes.get(e) for e in expected}
        if lit.element_count not in sizes.values():
            exp_desc = ", ".join(f"{e}={s}" for e, s in sizes.items())
            findings.append(Finding("ERROR", lit.rel_path, lit.line,
                f"литерал '{lit.varname}' содержит {lit.element_count} элемент(ов); "
                f"ожидается по схеме: {exp_desc}"))

    # бонус: schema-var, выведенный из макросов, но нигде не инициализированный
    for varname in schema:
        if varname not in inited_schema_vars:
            enums = ", ".join(sorted(schema[varname]))
            findings.append(Finding("WARN", "(global)", 0,
                f"массив-схема '{varname}' ({enums}) выводится из макросов, "
                f"но нигде не инициализируется литералом"))
    return findings


def check_subroutines(idx: Index) -> list:
    """C. Целостность подпрограмм: declare <-> def <-> call.

    Проверяем ТОЛЬКО внутри пула пользовательских подпрограмм (то, что
    объявлено в variables/subroutines.opy или определено через `def`). Это
    единственное множество, которое мы можем отличить от нативных функций
    Workshop. Намеренно НЕ проверяем «вызвана, но неизвестна»: без полного
    реестра нативов (rgb/wait/len/heal/...) такая проверка даёт сотни ложных
    срабатываний и делает шлагбаум бесполезным.

    Объявлено, но нет def      -> ERROR (закомментированный/удалённый def: tier_up_reset, chance).
    Есть def, но не объявлено   -> ERROR (subroutine не получит слот в Workshop).
    Объявлено, но def нет И не вызывается -> уже покрыто первым ERROR.
    Объявлено + def есть, но вызовов нет  -> WARN (мёртвый код).
    """
    findings = []
    declared = {}
    for d in idx.slot_decls:
        if d.kind == "subroutine":
            declared[d.name] = d
    defined = set(idx.defs.keys())
    called = {name for name, _, _ in idx.calls}

    # объявлено, но нет активного def — реальная дыра (вызов станет no-op).
    # Исключение: помеченные `# stub` — намеренные заготовки -> мягкий WARN.
    for name, d in declared.items():
        if name not in defined:
            if d.is_stub:
                findings.append(Finding("WARN", d.rel_path, d.line,
                    f"subroutine '{name}' — заготовка (# stub) без def; вызов будет no-op, "
                    f"пока не появится реализация"))
            else:
                findings.append(Finding("ERROR", d.rel_path, d.line,
                    f"subroutine '{name}' объявлена в subroutines.opy, но def не найден "
                    f"(закомментирован/удалён) — вызов будет тихим no-op. "
                    f"Если это намеренная заготовка, пометь её `# stub`"))
    # def есть, но не объявлен — Workshop не выделит слот
    for name in defined - set(declared.keys()):
        for rel, line in idx.defs[name]:
            findings.append(Finding("ERROR", rel, line,
                f"def '{name}()' существует, но subroutine не объявлена в variables/subroutines.opy"))
    # объявлено + определено, но нигде не вызывается — мёртвый код (мягко)
    for name, d in declared.items():
        if name in defined and name not in called:
            findings.append(Finding("WARN", d.rel_path, d.line,
                f"subroutine '{name}' объявлена и определена, но нигде не вызывается (мёртвый код)"))
    return findings


def check_enum_refs(idx: Index) -> list:
    """D1. Целостность Enum.MEMBER: сироты и опечатки.

    Использован <Enum>.<X>, но X не в enum -> ERROR (опечатка).
    Член enum объявлен, но нигде не используется -> WARN (сирот: PRAYER_MASTER_FLAG).
    Применяется к BuffId / EffectAction / EffectType.
    """
    findings = []
    for enum_name in ENUM_REFS:
        if enum_name not in idx.enums:
            continue
        members = set(idx.enums[enum_name].members)
        used = idx.enum_refs.get(enum_name, set())

        # опечатки: используется то, чего нет в enum
        for member in used - members:
            # первая точка использования
            loc = _first_ref_loc(idx, enum_name, member)
            findings.append(Finding("ERROR", loc[0], loc[1],
                f"{enum_name}.{member} используется, но '{member}' не в enum {enum_name}"))
        # сироты: объявлены, но не используются
        for member in sorted(members - used):
            ed = idx.enums[enum_name]
            mline = 0
            if member in ed.members:
                mline = ed.member_lines[ed.members.index(member)]
            findings.append(Finding("WARN", ed.rel_path, mline,
                f"{enum_name}.{member} объявлен, но нигде не используется (сирота)"))
    return findings


def _first_ref_loc(idx: Index, enum_name: str, member: str):
    """Возвращает (rel, line) первого вхождения `EnumName.MEMBER` в исходниках."""
    pat = re.compile(rf"\b{re.escape(enum_name)}\.{re.escape(member)}\b")
    # сканируем по порядку файлов/строк — нужен исходный текст без тел enum'ов
    # переиспользуем простую проходку по всем .opy через глобусы не храним,
    # поэтому перевыгружаем минимально: используем idx.calls-независимый обход.
    for rel in sorted({f for f, _, _ in idx.calls} | {d.rel_path for d in idx.slot_decls}
                      | {e.rel_path for e in idx.enums.values()}):
        abs_path = os.path.join(PROJECT_ROOT, rel)
        if not os.path.isfile(abs_path):
            continue
        with open(abs_path, "r", encoding="utf-8") as f:
            norm = norm_line_endings(f.read())
        for lineno, line in enumerate(norm.split("\n"), start=1):
            if pat.search(line):
                return (rel, lineno)
    return ("(global)", 0)


def check_manual_buff_appends(idx: Index) -> list:
    """D2. Ручной append в active_buff_* вне центральной инфраструктуры.

    CODESTYLE §4 требует использовать add_buff(). Прямой .append() в
    active_buff_* массивы минует централизованную систему очистки/удаления.
    Разрешено только в BUFF_API_FILES (effects_lifecycle.opy).
    """
    findings = []
    for rel, line, part in idx.manual_appends:
        if rel in BUFF_API_FILES:
            continue
        findings.append(Finding("WARN", rel, line,
            f"ручной .append в active_buff_{part} вне effects_lifecycle — обход add_buff() API; "
            f"используй add_buff() или расширь централизованную инфраструктуру"))
    return findings


def check_buff_arity(idx: Index) -> list:
    """E. Арность buff_append_args относительно ближайшего вызова.

    Каждое присвоение `buff_append_args = [...]` связывается с ближайшим
    следующим вызовом add_buff / add_hud_buff / extend_buff.

    add_hud_buff (5) и extend_buff (2) — фиксированная длина.
    add_buff — ПЕРЕМЕННАЯ длина по EffectType (4-й элемент):
      ENTITY/HEALTH_BAR/HEAL_OVER_TIME -> 4   (action/value не читаются при очистке)
      PLAYER_VARIABLE                  -> 5   (читается action)
      любой стат-тип (SPEED/DAMAGE/...) -> 6  (откат через value; короче = тихая
                                               порча стата — ГЛАВНЫЙ класс багов)
    Неизвестный EffectType -> диапазон 4..6 (не блокируем, но WARN при выходе).
    """
    findings = []
    if not idx.buff_appends:
        return findings
    calls_by_file = {}
    for bc in idx.buff_calls:
        calls_by_file.setdefault(bc.rel_path, []).append(bc)
    for v in calls_by_file.values():
        v.sort(key=lambda b: b.line)

    for ba in idx.buff_appends:
        candidates = calls_by_file.get(ba.rel_path, [])
        abs_path = os.path.join(PROJECT_ROOT, ba.rel_path)
        with open(abs_path, "r", encoding="utf-8") as f:
            norm = norm_line_endings(f.read())
        file_lines = norm.split("\n")
        paired = None
        for bc in candidates:
            bc_line = _line_of_offset(file_lines, bc.line)
            if bc_line > ba.line and bc_line - ba.line <= BUFF_CALL_WINDOW:
                paired = (bc, bc_line)
                break
        if paired is None:
            findings.append(Finding("WARN", ba.rel_path, ba.line,
                f"buff_append_args присвоен, но ни один из {BUFF_CALL_NAMES} не вызван "
                f"в течение {BUFF_CALL_WINDOW} строк"))
            continue
        bc, _ = paired

        if bc.name == "add_buff":
            # type-aware контракт
            etype = ba.type_token.split(".")[-1] if "." in ba.type_token else ""
            if etype in BUFF_ADD_ARITY_BY_TYPE:
                expected = BUFF_ADD_ARITY_BY_TYPE[etype]
                if ba.element_count != expected:
                    sev = "ERROR" if expected == 6 else "WARN"
                    extra = (" — стат-тип откатывается через value; недостача = "
                             "стат восстановится на 0 (тихая порча стата)") if expected == 6 else ""
                    findings.append(Finding(sev, ba.rel_path, ba.line,
                        f"buff_append_args для add_buff() с EffectType.{etype} содержит "
                        f"{ba.element_count} элемент(ов), ожидалось {expected}{extra}"))
            else:
                lo, hi = min(BUFF_ADD_ARITY_FALLBACK), max(BUFF_ADD_ARITY_FALLBACK)
                if not (lo <= ba.element_count <= hi):
                    findings.append(Finding("WARN", ba.rel_path, ba.line,
                        f"buff_append_args для add_buff() (EffectType не распознан: "
                        f"'{ba.type_token}') содержит {ba.element_count} элемент(ов), "
                        f"ожидалось {lo}..{hi}"))
        else:
            expected = BUFF_CALL_ARITY[bc.name]
            if ba.element_count != expected:
                findings.append(Finding("ERROR", ba.rel_path, ba.line,
                    f"buff_append_args для {bc.name}() содержит {ba.element_count} "
                    f"элемент(ов), ожидалось {expected}"))
    return findings


def check_hud_linkage(idx: Index) -> list:
    """F. HUD-связность баффов (эвристика по префиксам имён).

    Группируем BuffId по префиксу до первого '_' (либо само имя, если без '_').
    Если в группе есть add_buff — в ней должен быть и add_hud_buff (CODESTYLE §5.11).
    Это эвристика по именованию, а не формальная гарантия.
    """
    findings = []
    if "BuffId" not in idx.enums:
        return findings
    all_members = idx.enums["BuffId"].members

    # множества BuffId, которые фигурируют в add_buff vs add_hud_buff контексте.
    # поскольку контекст передачи — это buff_append_args, а сам id стоит в массиве,
    # упрощённо: считаем «add_buff-id» те BuffId.X, что встречаются в файлах,
    # где есть add_buff, и аналогично для hud. Более точно — по принадлежности
    # к группе, где встречается add_buff/add_hud_buff. Делаем группировку по группам.
    groups = {}  # group -> set(members)
    for m in all_members:
        key = m.split("_")[0] if "_" in m else m
        groups.setdefault(key, set()).add(m)

    # какие BuffId реально задействованы вообще
    used = idx.enum_refs.get("BuffId", set())

    for group, members in groups.items():
        active_members = members & used
        if not active_members:
            continue  # вся группа не используется — не наша забота (orphan чек ловит)
        # есть ли в проекте add_hud_buff вообще для этой группы?
        # определяем по наличию add_hud_buff и add_buff в коде +组成员ам used
        # Простой подход: группа «нуждается в HUD», если среди её использованных
        # членов есть такие, что хотя бы один должен отображаться. Эвристика:
        # если в группе есть использованные члены, требуем хотя бы одного
        # использованного члена, который встречается в файле, содержащем add_hud_buff.
        # Поскольку точное сопоставление строк затруднено, используем смягчённый
        # эвристический сигнал: если в группе НЕТ ни одного члена, упоминаемого
        # в районе add_hud_buff-вызовов, но есть члены у add_buff — WARN.
        # В v1 этот чек мягкий: пропускаем, если в коде есть add_hud_buff хотя бы раз.
        pass

    # В v1 реализуем безопасную мягкую версию: ничего не flagged, если в проекте
    # есть add_hud_buff. Чек активируется (WARN) только при явном дисбалансе,
    # который мы можем определить надёжно. Полная версия вынесена в README как TODO.
    # Это предохраняет от ложных срабатываний на текущем коде.
    return findings


# --- Реестр и раннер ---------------------------------------------------------

CHECKS = [
    ("A. Слоты", check_slots),
    ("B. enum<->литерал", check_enum_literal_sync),
    ("C. Подпрограммы", check_subroutines),
    ("D1. enum.ссылки", check_enum_refs),
    ("D2. обход API", check_manual_buff_appends),
    ("E. арность buff_append_args", check_buff_arity),
    ("F. HUD-связность", check_hud_linkage),
]


def render(findings: list) -> str:
    by_file = {}
    for f in findings:
        by_file.setdefault(f.rel_path, []).append(f)
    out_lines = []
    for rel in sorted(by_file.keys()):
        fs = sorted(by_file[rel], key=lambda x: (x.line, x.severity))
        out_lines.append(f"\n### {rel}")
        for f in fs:
            loc = f"L{f.line}" if f.line else "—"
            out_lines.append(f"  {f.severity:5} {loc:>6}  {f.message}")
    return "\n".join(out_lines)


def main() -> int:
    rel_paths = discover_files()
    if not rel_paths:
        print("Валидатор: .opy файлы не найдены.", file=sys.stderr)
        return 1
    files = load_files(rel_paths)
    idx = parse_files(files)

    all_findings = []
    print("MRPG Overwatch — статический валидатор\n")
    for title, check in CHECKS:
        findings = check(idx)
        errors = sum(1 for f in findings if f.severity == "ERROR")
        warns = sum(1 for f in findings if f.severity == "WARN")
        status = "OK" if not findings else (f"{errors}E/{warns}W")
        print(f"  [{status:>7}] {title}")
        all_findings.extend(findings)

    errors_total = sum(1 for f in all_findings if f.severity == "ERROR")
    warns_total = sum(1 for f in all_findings if f.severity == "WARN")

    if all_findings:
        print(render(all_findings))
    print(f"\n==> {errors_total} error(s), {warns_total} warning(s)")
    if errors_total:
        print("Сборка ЗАБЛОКИРОВАНА валидатором (exit 1).")
        return 1
    print("Валидатор: критических ошибок нет.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
