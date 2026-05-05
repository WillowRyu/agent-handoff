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

## Output language

All output from this skill — conversational replies to the user, status messages, blocker reports, AND `task.md` notes — uses the language specified by `config.md`'s `response_language`. Default if config missing or field absent: `en`. Code edits, file paths, command syntax, and shell command output stay in their native language.

## Workflow

1. Read `plan.md` end-to-end.
2. Create `.handoff/task.md` with one checkbox per change list entry plus one per sync command.
3. **Check for parallelization.** If `plan.md` has a `## Parallelization` section AND your host agent supports parallel subagent dispatch (e.g., Claude Code's Task tool), dispatch one subagent per independent group instead of applying sequentially in step 4. The dispatcher (this skill instance) owns `task.md` updates; subagents apply file edits only and report completion per file. Wait for all subagents before running sync commands (step 5). If a subagent hits a blocker, follow the blocker protocol in [boundaries.md](boundaries.md). If host doesn't support parallel dispatch or no `## Parallelization` section exists, fall back to sequential application below.
4. For each change:
   - Apply the file edit / creation as plan describes.
   - Update task.md: mark the item complete.
5. After code edits done, run sync commands one by one. Update task.md per command.
6. Print:
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
