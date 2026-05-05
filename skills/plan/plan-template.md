# Plan Template

Every `plan.md` follows this structure. Sections marked (optional) are omitted when not applicable.

## Header

```markdown
# <Task title>

> Created: YYYY-MM-DD
> Author: plan skill
```

## (Optional) Backlog marker

If this plan addresses backlog items:

```markdown
> Addresses backlog: #2, #5
```

## Background

Two or three sentences. Why are we doing this? What's the user-visible outcome?

## Change list

For every file that will be created or modified, one entry:

```markdown
### `path/to/file.ext` — [Create | Modify]

What changes and why. If modifying, name the function/section. Cite the convention doc that governs the pattern (from config's doc index).
```

## Parallelization (optional)

When the change list contains subsets that can be applied independently — no shared types, no shared sync command, no sequential dependency — group them here. `/execute` may dispatch each group to a separate subagent when the host agent supports parallel dispatch (e.g., Claude Code's Task tool). Otherwise execute applies them sequentially. If nothing in the change list is safely parallelizable, omit this section.

```markdown
- **Group A (independent):** `frontend/main/src/components/error-boundary.tsx`
- **Group B (independent):** `packages/logic/src/hooks/use-user-search.ts`
- **Group C (depends on B):** `frontend/main/src/container/{home-start,dm,notifications}/*.container.tsx`
```

Each group is a bullet. Mark dependencies inline ("depends on X") so the executor knows what must finish first.

## Sync commands (optional)

Only when the change requires running shell commands beyond pure code edits — e.g. installing dependencies, running codegen, generating migrations. Each command on its own line:

```
pnpm install
pnpm gen:types
```

If no sync commands, omit this section entirely.

## Test strategy

Per change, what test confirms it. Reference exact test file paths.

```markdown
- `tests/<area>/<file>.test.ts` — verifies <behavior>
```

## Verification plan

The exact commands `/verify` will run for this change. Pick the subset that actually applies — verify runs ONLY what's listed here, in order. Two acceptable formats:

**(a) Concrete commands (the common case):**

```markdown
- `<test cmd>` — all tests pass
- `<typecheck cmd>` — no errors
- `<lint cmd>` — no errors
```

For monorepos, list per-workspace commands matching the touched workspaces:

```markdown
- `pnpm -C apps/server test` — server unit tests pass
- `pnpm -C apps/server tsc:check` — server types resolve
```

**(b) Explicit skip (when no command verification applies):**

```markdown
(none — docs-only change; plan-vs-diff check is sufficient)
```

Rationale after the em-dash is required so verify can record WHY commands were skipped. The plan-vs-diff and convention checks still run.
