# Verification Checks

Run in this order. Stop on first command failure only if it makes subsequent checks meaningless (e.g. typecheck failure prevents tests from compiling).

## 1. Tests

Run `config.verification.test`. Capture stdout + stderr + exit code.

- Exit 0 → ✅
- Non-zero → ❌, capture failing test names

## 2. Typecheck

Run `config.verification.typecheck`. Capture stdout + stderr + exit code.

- Exit 0 → ✅
- Non-zero → ❌, capture error count + first 5 errors

## 3. Lint

Run `config.verification.lint`. Capture stdout + stderr + exit code.

- Exit 0 → ✅
- Non-zero → ⚠️ if "warnings only", ❌ if errors

## 4. Plan vs change diff

For each item in plan's change list, confirm the file exists and the relevant edit is in `git diff` (or new-file content). Note:
- Files plan said to modify but show no change → ❌ blocking
- Files changed that aren't in plan → ⚠️ non-blocking ("scope drift")

## 5. Convention check (light)

Pick the convention docs path from config. Skim 1-2 docs that look relevant to the change list. If a clear violation jumps out (e.g. plan ignored a documented pattern), note as ⚠️ non-blocking with a doc reference.

Don't go deep — verify is not a substitute for code review.

## Skipped commands

If any command in config is empty (`""` or `(not detected)`), skip it and note in review.md "Skipped: <step> (no command in config)".
