---
name: verify
description: Use after /execute to verify the changes are correct. Reads .handoff/{config,plan,task}.md, runs the verification commands from config, writes review.md, and on success cleans up handoff state and resolves processed backlog items. STRONGLY recommended to run in a fresh chat — fresh context is the entire point of this stage.
---

# Verify

Independent validation of `execute`'s output. Strict separation of context is the value: a fresh chat reading only the plan and code can spot what an in-context verify would miss.

## Gate (run first)

Required files in `.handoff/`: `config.md`, `plan.md`, `task.md`. If any missing, abort with the matching message:

- `config.md` missing:
  > ❌ No config found. Run `/setup-handoff` first.
- `plan.md` missing:
  > ❌ No plan found. Run `/plan` first.
- `task.md` missing:
  > ❌ No task found. Run `/execute` first.

## Workflow

1. Read config, plan, task.
2. Run the three verification commands from config (`test`, `typecheck`, `lint`). See [checks.md](checks.md) for command execution rules.
3. Compare actual code changes against plan's change list — note anything missing or extra.
4. Build review.md per [review-template.md](review-template.md).
5. Run cycle close per [cycle-close.md](cycle-close.md): file cleanup + backlog auto-resolve + non-blocking append.
6. Print summary based on outcome (see cycle-close.md).

## Boundaries

- **Allowed:** run verification commands, read any file, write `.handoff/review.md`, edit `.handoff/backlog.md` (resolve 🔄 items, append non-blocking), delete `.handoff/{plan,task,review}.md` per cycle-close rules.
- **Forbidden:** modify any code, modify `plan.md` or `task.md` mid-cycle, delete `.handoff/config.md`, delete the user's source files.

## Output language

`review.md` and progress messages use config's `response_language`.
