# Agent Handoff Skills

**English** | [한국어](README.ko.md)

Strict 3-stage handoff workflow for coding agents — `plan` → `execute` → `verify` — with disk-backed state for cross-context handoff.

## Why

Agents working in a single context tend to skip verification of their own output. This plugin splits the work into three skills with strict boundaries, persisting state to `.handoff/*.md` so verify can run in a fresh chat. See [docs/why-handoff.md](docs/why-handoff.md) for the long version.

## The four skills

| Skill | When | Reads | Writes | Forbidden |
|---|---|---|---|---|
| `/setup-handoff` | once per project | manifests, agent docs, doc tree | `.handoff/config.md` | code, build commands |
| `/plan` | starting a feature/fix | config, backlog | `.handoff/plan.md` | code, build commands |
| `/execute` | after `/plan` | config, plan | `.handoff/task.md` + code | test/typecheck/lint |
| `/verify` | after `/execute`, fresh chat | config, plan, task | `.handoff/review.md`, cleans up | code |

## Install

### Universal (any supported agent — recommended)

Powered by [`vercel-labs/skills`](https://github.com/vercel-labs/skills), which works with Claude Code, Cursor, Codex, Gemini CLI, Aider, and 50+ other agents.

```bash
# Interactive: pick which agents to install into
npx skills@latest add WillowRyu/agent-handoff

# Non-interactive: install all 4 skills globally for Claude Code
npx skills@latest add WillowRyu/agent-handoff --skill '*' -g -a claude-code -y
```

Useful flags: `-g` (global, into `~/`), `--list` (dry-run), `--skill <name>` (pick specific), `-a <agent>` (target agent). See `npx skills@latest --help`.

### Claude Code (plugin marketplace alternative)

```bash
/plugin marketplace add WillowRyu/agent-handoff
/plugin install agent-handoff
```

## Workflow

```
/setup-handoff              # once
/plan "<task description>"  # describe what you want
/execute                    # ideally in a fresh chat
/verify                     # ideally in another fresh chat
```

See [docs/examples/](docs/examples/) for concrete artifacts at each stage.

## Permissions

Each skill writes specific files. Pre-allowing the handoff-state writes in your agent's permission settings avoids per-prompt friction; everything else (source-file edits during `/execute`, `Bash` during `/verify`) follows your existing project conventions.

| Skill | Needs |
|---|---|
| `setup-handoff` | Read on the repo; Write/Edit on `.handoff/config.md` |
| `plan` | Read on the repo; Write/Edit on `.handoff/plan.md` and `.handoff/backlog.md` |
| `execute` | Edit on source files listed in the plan; Write on `.handoff/task.md`; `Bash` for the plan's sync commands |
| `verify` | `Bash` for test/typecheck/lint; Edit/Delete on `.handoff/{plan,task,review,backlog}.md` |

### Claude Code

Add to `~/.claude/settings.json` (global) or `.claude/settings.json` (project) to pre-allow handoff state writes:

```json
{
  "permissions": {
    "allow": [
      "Write(.handoff/**)",
      "Edit(.handoff/**)"
    ]
  }
}
```

### Other agents

Cursor, Codex, Gemini CLI, Aider, etc. each have their own permission models. The skills don't reach outside `.handoff/` and the source files explicitly listed in the plan, so apply your existing scoping conventions.

## Configuration

`/setup-handoff` writes `.handoff/config.md`. Edit it directly to change verification commands, response language, or doc paths. Re-running `/setup-handoff` overwrites; `/setup-handoff --auto` skips the interview entirely (falls back to asking only for items it couldn't auto-detect).

## What's in scope (v1)

- 4 skills above
- `--auto` mode for setup-handoff
- Backlog auto-resolve on verify pass
- Stack-agnostic (works for any language/framework — sync commands come from your plan)

## What's out of scope (v1)

- `/setup-handoff --refresh` (manually edit config for now)
- Manual backlog operations (`/verify --close-backlog ...`)
- More skills (`git-push`, `pr-analyzer`, `verify-all` — possibly v2)
- Auto-conversion to non-Claude-Code tool formats

## License

MIT.
