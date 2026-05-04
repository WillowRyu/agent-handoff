# Auto-Scan Rules

Run all five scans before any user interaction. Each scan produces a default value (or marks the item as "needs interview" if scanning failed).

## 1. Agent guidance files

Look for these files at repo root (or near root). Collect any that exist:

- `CLAUDE.md`
- `AGENTS.md`
- `GEMINI.md`
- `.cursorrules`
- `.cursor/rules/` (directory; list contents)
- `.github/copilot-instructions.md`
- `.aider.conf.yml`

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

## 3. Documentation directory tree

Scan top-level for any of: `docs/`, `documentation/`, `wiki/`, `.agent/rules/`, `guides/`.

For each found, list contents up to 2 levels deep. Cap at 50 files; if more, list 50 and note "(N more)".

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
| package.json `dependencies` keys (or pyproject) | frameworks: detect React, Vue, Next, NestJS, Django, FastAPI, etc. |

## Output of auto-scan

A structured object the interview module reads:
- `verification.test`, `verification.typecheck`, `verification.lint` (each: detected command or `null`)
- `agent_guidance` (list of file paths)
- `doc_tree` (nested list)
- `toolchain.pkg_manager`, `toolchain.monorepo`, `toolchain.frameworks` (string or list)
- `convention_doc_candidates` (subset of doc_tree directories whose names match `conventions|rules|guidelines|patterns|standards`; mark the strongest match with ★)
