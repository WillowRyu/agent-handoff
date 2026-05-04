# Agent Handoff Skills

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

### Claude Code

```bash
/plugin marketplace add WillowRyu/agent-handoff
/plugin install agent-handoff
```

### Tool-specific install notes

<details>
<summary>Cursor</summary>

The SKILL.md frontmatter is compatible with Cursor's rules format. Copy each `skills/<name>/SKILL.md` into `.cursor/rules/` in your project. (Tested combinations to be added by community.)
</details>

<details>
<summary>Codex / Gemini / Aider</summary>

The frontmatter (name + description + body) is intentionally minimal so it works as a generic "system instruction" file. Reach out via issues if you tested a specific tool — install steps land here.
</details>

## Workflow

```
/setup-handoff              # once
/plan "<task description>"  # describe what you want
/execute                    # ideally in a fresh chat
/verify                     # ideally in another fresh chat
```

See [docs/examples/](docs/examples/) for concrete artifacts at each stage.

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
