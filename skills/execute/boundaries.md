# Execute Boundaries

`execute` is the only skill that modifies code. To prevent scope drift, it MUST follow these rules.

## Allowed

| Action | Source of truth |
|---|---|
| Modify a file | Listed in plan.md "Change list" with the exact path |
| Create a file | Listed in plan.md "Change list" with `[Create]` marker |
| Delete a file | Listed in plan.md "Change list" with `[Delete]` marker |
| Run a shell command | Listed verbatim in plan.md "Sync commands" |
| Update `.handoff/task.md` | Always allowed |

## Forbidden

| Action | Reason |
|---|---|
| Edit any file not in plan.md change list | Improvising scope |
| Run any command not in plan.md sync commands | Including test/typecheck/lint — those belong to verify |
| Modify plan.md | The plan is the contract |
| Modify config.md or backlog.md | Setup/verify own those |
| Delete `.handoff/` | The cycle owns its state |

## Blocker protocol

If during execution you find:
- a file the plan said to modify doesn't exist
- a function the plan referenced has a different signature
- a sync command fails in a way the plan didn't anticipate
- the change as described conflicts with code you're seeing

Then:
1. STOP. Don't push through.
2. Update `.handoff/task.md` to mark the in-progress item as ⚠️ blocked.
3. Print to user:
   ```
   ⚠️  Blocker at <task item>: <description>
   Plan needs revision. Run /plan again with this context.
   ```
4. End the session. The user re-runs `/plan` to incorporate the new info.
