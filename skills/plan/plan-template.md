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

Which `Verification Commands` from config will run, and what we expect:

```markdown
- `<test cmd>` — all tests pass
- `<typecheck cmd>` — no errors
- `<lint cmd>` — no errors
```

If config's Verification Commands section uses the monorepo blockquote (per-workspace candidates), pick the commands matching the workspace this plan touches and list them here as concrete commands. If multiple workspaces are touched, list each.
