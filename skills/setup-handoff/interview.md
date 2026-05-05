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
convention_docs:   ...

## Project Documentation Index

### Agent guidance
- [path/to/file.md](path/to/file.md) — short description
- ...

### Project docs
- [path/to/file.md](path/to/file.md) — short description
- ...

### Detected toolchain
- package manager: ...
- monorepo: ...
- frameworks: ...
```

Doc-index entries use the markdown-link form `- [path](path) — desc` (em-dash, not hyphen). The short description (3–7 words) is sourced from the auto-scan description heuristic (see [auto-scan.md](auto-scan.md) "Description heuristic for doc index entries"), which folds workspace context into the phrase for sub-package files (e.g. `apps/server/README.md` → "server overview").

Write to `<handoff_dir>/config.md`.

### Monorepo branch — Verification Commands

If the auto-scan detected a monorepo (`toolchain.monorepo` is non-null) AND the root `package.json` has no `test`/`typecheck`/`lint` scripts, write the top-level fields empty and append a blockquote listing per-workspace candidates:

```
## Verification Commands

test:
typecheck:
lint:
build:

> Monorepo — root package.json has no test/typecheck/lint scripts.
> Plan picks the right command per workspace from this candidate list:
> - <workspace-1>: `<test cmd>`, `<typecheck cmd>`, `<lint cmd>`
> - <workspace-2>: `<test cmd>`, `<typecheck cmd>`, `<lint cmd>`
> ...
```

Use up to 8 workspaces (matching the `toolchain.workspaces` cap). Wrap each per-workspace command in backticks so it renders as inline code inside the blockquote.

If the monorepo DOES have root-level test/typecheck/lint scripts (rare but possible — e.g. turbo orchestrating from root), use those root scripts as the top-level fields and skip the blockquote.

If non-monorepo: keep the existing single-set behavior (write the detected commands directly into `test:`/`typecheck:`/`lint:`).
