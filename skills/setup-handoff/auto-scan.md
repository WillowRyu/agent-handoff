# Auto-Scan Rules

Run all five scans before any user interaction. Each scan produces a default value (or marks the item as "needs interview" if scanning failed).

## 1. Agent guidance files

Look for these files at repo root (always):
- `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `.cursorrules`, `.cursor/rules/`, `.github/copilot-instructions.md`, `.aider.conf.yml`

Then, if `toolchain.workspaces` is non-empty (monorepo detected), also look in each workspace root for:
- `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `.claude/`, `.agent/`

(`.cursorrules`, `.cursor/rules/`, `.github/copilot-instructions.md`, `.aider.conf.yml` are repo-root only; do not scan per-workspace.)

## 2. Verification command candidates (manifests)

Probe these in order; the first that yields candidates wins, but record all that exist:

| Manifest | How to extract |
|---|---|
| `package.json` | Read `scripts` keys; match `test`, `typecheck`/`tsc`, `lint`/`eslint` |
| `pyproject.toml` | Look for `[tool.poetry.scripts]`, `[project.scripts]`; otherwise default to `pytest`, `mypy`, `ruff check` |
| `Cargo.toml` | Defaults: `cargo test`, `cargo check`, `cargo clippy` |
| `go.mod` | Defaults: `go test ./...`, `go vet ./...`, `golangci-lint run` |
| `Gemfile` | Defaults: `bundle exec rspec`, `bundle exec rubocop` |
| `composer.json` | Read `scripts` keys |
| `Makefile` | Look for targets named `test`, `typecheck`, `lint` |

If none match, mark all three (test/typecheck/lint) as "needs interview".

For monorepos: also probe each workspace's own manifest (e.g. `apps/server/package.json`) for the same scripts. Record per-workspace candidates separately so the interview can emit them in the Verification Commands blockquote (see interview.md "Final write").

## 3. Documentation directory tree

Scan repo root for: `docs/`, `documentation/`, `wiki/`, `.agent/rules/`, `guides/`. Up to 2 levels deep, root-cap 50 files.

If `toolchain.workspaces` is non-empty: also scan each workspace root for the same directory list AND for top-level `*.md` files in the workspace (README.md, CHANGELOG.md, LOCAL_SETUP.md, FE_DEVELOPMENT_GUIDE.md, etc.). Per-workspace cap: 15 files.

## 4. README summary

If `README.md` (or `README.rst`, `README`) exists at root, read first ~200 lines. Extract:
- Project description (first paragraph after the heading)
- Stack indicators (framework names, language mentions)

## 5. Toolchain detection

| Signal | Conclusion |
|---|---|
| `pnpm-lock.yaml` | package manager: pnpm |
| `yarn.lock` | package manager: yarn |
| `package-lock.json` | package manager: npm |
| `bun.lockb` | package manager: bun |
| `turbo.json` | monorepo: turborepo |
| `lerna.json` | monorepo: lerna |
| `nx.json` | monorepo: nx |
| `pnpm-workspace.yaml` | monorepo: pnpm workspaces |
| `Cargo.lock` + `[workspace]` in Cargo.toml | monorepo: cargo workspaces |
| `go.work` | monorepo: go workspaces |
| package.json `dependencies` keys (or pyproject) | frameworks: detect React, Vue, Next, NestJS, Django, FastAPI, etc. |

### Workspace path extraction (when monorepo detected)

Extract and resolve the workspace path list:

| Source | How to extract workspace dirs |
|---|---|
| `pnpm-workspace.yaml` | `packages:` field; expand each glob (e.g. `apps/*` → all matching dirs) |
| `package.json` `workspaces` | array of globs; expand same way |
| `turbo.json` exists | infer from `package.json` `workspaces` |
| `lerna.json` `packages` | array of globs |
| `nx.json` exists | infer from `package.json` `workspaces` |
| `Cargo.toml` `[workspace]` `members` | array of relative paths or globs |
| `go.work` | `use` directives, each pointing at a workspace dir |

After workspace extraction, expose `toolchain.workspaces` (list of resolved relative paths, e.g. `["apps/server", "apps/web", "apps/mobile"]`).

**Cap:** if more than 8 workspaces, scan only the first 8 (alphabetical, with `apps/*` and `packages/*` ordered together by parent then name). Remaining N–8 workspaces are listed in the output as `toolchain.workspaces_truncated: N` with a note: "Re-run /setup-handoff in a workspace subdirectory to capture that workspace's docs."

## Description heuristic for doc index entries

For each agent-guidance file and each doc-tree file, generate a short `description` (3–7 words) from the filename plus its workspace context. The description goes into the final config.md doc index alongside the markdown link.

Filename → description mapping (examples):
- `LOCAL_SETUP.md` → "local dev setup"
- `FE_DEVELOPMENT_GUIDE.md` → "frontend dev guide"
- `MFE_DEPLOYMENT_STRATEGY.md` → "module federation deploy"
- `CHANGELOG.md` → "changelog"
- `README.md` → "project overview" (or workspace-scoped: "server overview" when under `apps/server/`)
- `AGENTS.md` → "agent-agnostic rules" (or workspace-scoped: "server workspace" when under `apps/server/`)
- `CLAUDE.md` → "root agent rules" (root) or "<workspace> agent rules" (per-workspace)
- `GEMINI.md` → "Gemini-specific"

Workspace context (e.g. "server", "web", "mobile" parsed from the parent workspace path) is injected into the description for sub-package files so each entry is self-explanatory at a glance.

## Output of auto-scan

A structured object the interview module reads:
- `verification.test`, `verification.typecheck`, `verification.lint` (each: detected command or `null`)
- `verification.workspace_candidates` (when monorepo: map of workspace path → `{test, typecheck, lint}` candidate commands)
- `agent_guidance` (list of `{path, description}` entries)
- `doc_tree` (nested list of `{path, description}` entries)
- `toolchain.pkg_manager`, `toolchain.monorepo`, `toolchain.frameworks` (string or list)
- `toolchain.workspaces` (list of resolved relative paths; empty when not a monorepo)
- `toolchain.workspaces_truncated` (integer; total workspace count when > 8, else absent)
- `convention_doc_candidates` (subset of doc_tree directories whose names match `conventions|rules|guidelines|patterns|standards`; mark the strongest match with ★)
