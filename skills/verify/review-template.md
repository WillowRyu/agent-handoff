# Review Template

Standard structure for `.handoff/review.md`.

````markdown
# Verification Report

> Created: YYYY-MM-DD
> Plan: <plan title>
> Outcome: ✅ pass / ⚠️ pass with non-blocking / ❌ blocking

## Verification Commands

| Check | Command | Result |
|---|---|---|
| Tests | <cmd> | ✅ N tests passed |
| Typecheck | <cmd> | ✅ no errors |
| Lint | <cmd> | ✅ no errors |

## Plan vs change diff

- All change list items applied: ✅ / ❌ <list>
- Out-of-plan changes: <list or "(none)">

## ✅ Highlights

Brief, concrete things done well. Skip if nothing notable.

## ⚠️ Non-blocking suggestions

Will be appended to `.handoff/backlog.md` on cycle close. Each line:

`- [ ] <one-sentence improvement>, with rationale.`

## ❌ Blocking issues

(Only if outcome is ❌.) Each item: file:line, problem, recommended fix direction.

## Closed backlog items

(Only if plan had `> Addresses backlog: ...` and verify passed.)

- #2: <title>
- #5: <title>

## Cycle close

Per outcome:
- ✅ pass: handoff files deleted (plan, task, review). Backlog #N, #M closed.
- ⚠️ non-blocking only: handoff files deleted. Suggestions appended to backlog.
- ❌ blocking: handoff files retained. Run /plan to address blockers.
````
