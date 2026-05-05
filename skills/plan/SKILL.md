---
name: plan
description: Use when starting a new feature, fix, or refactor that needs explicit planning before code changes. Reads .handoff/config.md (and backlog if present) and writes a structured plan.md to .handoff/. Does NOT modify code or run build commands. Pair with /execute and /verify. Part of the agent-handoff bundle (4 skills) — install /setup-handoff, /plan, /execute, /verify together.
---

# Plan

Investigate the codebase, design the change, and write `.handoff/plan.md`. No code modification, no command execution.

## Gate (run first)

1. Read `.handoff/config.md`. If missing, abort:
   > ❌ No config found. Run `/setup-handoff` first.
2. **Re-entry check.** If `.handoff/plan.md` or `.handoff/review.md` already exists, this is a re-entry from a blocked cycle (verify ❌ retains them). Read both before planning anew: `review.md` lists the blockers, the previous `plan.md` shows what was being attempted. The new plan must address the blockers; if the previous plan had `> Addresses backlog: #N, #M`, carry the marker forward (the work is not done yet, the 🔄 items in `backlog.md` should stay 🔄).
3. If `.handoff/backlog.md` exists and has any open items: see [backlog-handling.md](backlog-handling.md).

## Output language

All output from this skill — conversational replies to the user, status/progress messages, AND the written `plan.md` — uses the language specified by `config.md`'s `response_language`. Default if config missing or field absent: `en`. Code, file paths, command syntax, and identifiers stay in their native language regardless.

## Workflow

1. Resolve the task description: from `/plan "<arg>"` if provided, otherwise the user just typed `/plan` and we may need to surface the backlog (see backlog-handling.md).
2. Investigate the codebase. Use the convention docs path and project doc index from config to guide what to read. Look at existing patterns the change must match.
3. Design the change. Match the structure described in [plan-template.md](plan-template.md): change list, sync commands (if any), test strategy, verification plan.
   - **Verification scope decision.** When filling the `## Verification plan` section, look at the change list and pick ONLY the commands that actually apply. `/verify` will run exactly what's listed there — nothing more. If the change is docs-only (or otherwise needs no command verification), write `(none — <one-line rationale>)`. For monorepos, list per-workspace commands matching the workspaces you touched, not every workspace's commands.
4. **Identify independent units.** Look at the change list: are there subsets of files/changes that can be applied independently (no shared types, no shared sync command, no sequential dependency)? If yes, list them as parallelizable groups in plan.md's optional `## Parallelization` section (see [plan-template.md](plan-template.md)). If everything is sequential or tightly coupled, omit the section.
5. Write `.handoff/plan.md`.
6. If backlog items are being addressed, also mark them 🔄 in `.handoff/backlog.md` (see backlog-handling.md §3).
7. Print:
   ```
   ✅ Plan written to .handoff/plan.md
   Next step: /execute (recommended in a fresh chat to keep context clean)
   ```

## Boundaries

- **Allowed:** read any file, web search, write `.handoff/plan.md`, mark items in `.handoff/backlog.md`.
- **Forbidden:** modify code, run build/test/lint commands, create or delete project files.
