# Cycle Close

How verify cleans up after writing review.md. Decisions branch on outcome.

## Outcome categories

- **✅ pass** = all verification commands ✅, no blocking issues, no non-blocking suggestions.
- **⚠️ pass with non-blocking** = all verification commands ✅, no blocking issues, but at least one non-blocking suggestion.
- **❌ blocking** = at least one verification command ❌ OR at least one blocking issue noted in plan-vs-diff or convention check.

## Per-outcome actions

### ✅ pass

1. If plan.md has `> Addresses backlog: #N, #M`:
   - Parse the IDs.
   - In `.handoff/backlog.md`, find each `- [🔄] #N ...` line and DELETE the entire line.
   - The "Closed backlog items" section in review.md is the only audit trail (review.md is about to be deleted; rely on git history of `.handoff/` if it's tracked).
2. Delete `.handoff/plan.md`, `.handoff/task.md`, `.handoff/review.md`.
3. Print:
   ```
   ✅ Verification passed. Cycle closed.
   <if backlog closed:> Closed backlog items: #N, #M
   ```

### ⚠️ pass with non-blocking

1. Treat plan-addressed backlog items same as ✅ (delete them — verification passed, the work is done).
2. Append the "⚠️ Non-blocking suggestions" from review.md as new entries in `.handoff/backlog.md`. Number them continuing the existing sequence (next free integer after the highest current ID).
3. Delete `.handoff/plan.md`, `.handoff/task.md`, `.handoff/review.md`.
4. Print:
   ```
   ⚠️  Cycle closed with N suggestions added to backlog.
   <if backlog closed:> Closed backlog items: #N, #M
   ```

### ❌ blocking

1. Do NOT modify backlog. Items marked 🔄 stay 🔄 — the next plan cycle will pick them up after the blockers are fixed.
2. Do NOT delete plan.md, task.md, review.md. The next /plan will read them.
3. Print:
   ```
   ❌ Verification found blocking issues. See .handoff/review.md.
   Run /plan to address them; the next cycle will inherit context.
   ```

## Backlog ID assignment

Open question (spec §11): is backlog ID monotonically increasing, or do we reuse closed IDs? **MVP decision: monotonic.** Find max integer ID currently in backlog.md, increment for each new non-blocking item.

## No `.bak` file

Spec §6.4: rely on git for backups. Never create `.handoff/backlog.md.bak`.
