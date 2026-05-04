# Interview Script

Run one question at a time. After each answer, store the result and move on.

## Default mode (5 questions)

### [1] Verification commands

Show auto-detected defaults (or "(not detected)" for any null):

```
[1] Verification commands
    Detected:
      test:      <auto.test or "(not detected)">
      typecheck: <auto.typecheck or "(not detected)">
      lint:      <auto.lint or "(not detected)">
    Use these? [Y/edit/skip]
```

- `Y` (or Enter): use detected values; missing ones become empty
- `edit`: ask each command one by one (fall back to a free-text prompt)
- `skip`: leave all three empty (verify will warn later)

### [2] Response language

```
[2] Response language (default: en) — change? [y/N]
```

- `N` (or Enter): keep `en`
- `y`: free-text input (ISO code preferred, e.g. `ko`, `ja`)

If the auto-scan found agent guidance files (CLAUDE.md, AGENTS.md) that contain language directives like "respond in Korean", use that as the default instead of `en`.

### [3] Handoff directory

```
[3] Handoff directory (default: .handoff/) — change? [y/N]
```

- `N` (or Enter): use `.handoff/`
- `y`: free-text input

### [4] Convention docs path

If `convention_doc_candidates` is non-empty:

```
[4] Convention docs path
    Detected:
      ★ <strongest match>
        <other candidates>
    Which? [1/2/.../none]
```

If no candidates: `[4] Convention docs path? Free-text or 'none'.`

### [5] Project documentation index

```
[5] Project documentation index
    Auto-collected:
      Agent guidance: <list>
      Docs:           <doc_tree summary>
      Toolchain:      <pkg_manager> + <monorepo> + <frameworks>
    Confirm or edit? [Y/edit]
```

- `Y` (or Enter): commit as-is
- `edit`: open the structured index for free-text editing (line-by-line removal allowed)

## --auto mode

For each of the 5 items, if auto-scan produced a non-null value: use it silently. If null:

```
⚠️  Couldn't auto-detect [<item name>]. Falling back to interview for this item.
```

Then ask only that item using the default-mode prompt.

After all items resolved, write `.handoff/config.md` (no further confirmation).

## Final write

Construct the markdown body per spec §5.5 layout. Sections:

```
# Handoff Config

## Verification Commands
test:      ...
typecheck: ...
lint:      ...
build:     (optional)

## Conventions
response_language: ...
handoff_dir:       ...
commit_style:      conventional

## Project Documentation Index

### Agent guidance
- ...

### Project docs
- ...

### Detected toolchain
- package manager: ...
- monorepo: ...
- frameworks: ...
```

Write to `<handoff_dir>/config.md`.
