<!-- Example .handoff/config.md from a pnpm + turborepo + NestJS + React project. -->

# Handoff Config

## Verification Commands
test:      pnpm turbo test
typecheck: pnpm turbo typecheck
lint:      pnpm lint
build:

## Conventions
response_language: en
handoff_dir:       .handoff
commit_style:      conventional

## Project Documentation Index

### Agent guidance
- CLAUDE.md
- AGENTS.md

### Project docs
- README.md
- docs/conventions/ — coding patterns
  - apollo-client.md
  - component-design-pattern.md
- docs/features/ — module-by-module reference

### Detected toolchain
- package manager: pnpm (from pnpm-lock.yaml)
- monorepo: turborepo (from turbo.json)
- frameworks: NestJS, React, Apollo Client (from package.json deps)
