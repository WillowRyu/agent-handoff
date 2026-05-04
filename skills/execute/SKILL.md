---
name: execute
description: Use after /plan to apply the planned changes. Reads .handoff/plan.md and writes/updates code exactly as specified, plus runs only the sync commands listed in the plan. Does NOT run test, typecheck, or lint commands — those belong to /verify. Pair with /plan and /verify. Part of the agent-handoff bundle (4 skills) — install /setup-handoff, /plan, /execute, /verify together.
---

# Execute

Apply the changes that `plan.md` describes. Stay strictly inside the plan; never improvise.

## Gate (run first)

1. Read `.handoff/config.md`. If missing, abort:
   > ❌ No config found. Run `/setup-handoff` first.
2. Read `.handoff/plan.md`. If missing, abort:
   > ❌ No plan found. Run `/plan` first.
3. Both present → proceed.

## Workflow

1. Read `plan.md` end-to-end.
2. Create `.handoff/task.md` with one checkbox per change list entry plus one per sync command.
3. For each change:
   - Apply the file edit / creation as plan describes.
   - Update task.md: mark the item complete.
4. After code edits done, run sync commands one by one. Update task.md per command.
5. Print:
   ```
   ✅ task.md updated. All planned changes applied.
   Next step: /verify (strongly recommended in a fresh chat)
   ```

## Boundaries

See [boundaries.md](boundaries.md). Critical points:
- Only run commands listed under "Sync commands" in the plan.
- Never run test/typecheck/lint commands (those are verify's job).
- Never modify plan.md.
- If a critical blocker is discovered (the plan can't be executed as written), STOP, print:
  ```
  ⚠️  Blocker: <description>. Plan needs revision — run `/plan` again.
  ```
  Do NOT improvise around it.

## Output language

Progress messages use `config.md`'s `response_language`. Code itself remains in the language native to the project (typically English).
