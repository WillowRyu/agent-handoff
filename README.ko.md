# Agent Handoff Skills

[English](README.md) | **한국어**

코딩 에이전트를 위한 엄격한 3단계 핸드오프 워크플로우 — `plan` → `execute` → `verify` — 컨텍스트 사이를 디스크 기반 상태로 이어줍니다.

## 왜 필요한가

같은 컨텍스트에서 일하는 에이전트는 자신이 만든 결과물을 제대로 검증하지 못합니다. 이 플러그인은 작업을 세 개의 스킬로 나누고 boundary를 강제하며, 상태를 `.handoff/*.md`에 남겨 verify를 새 채팅에서 돌릴 수 있게 합니다. 자세한 배경은 [docs/why-handoff.ko.md](docs/why-handoff.ko.md) 참고.

## 네 개의 스킬

| 스킬 | 사용 시점 | 읽음 | 씀 | 금지 |
|---|---|---|---|---|
| `/setup-handoff` | 프로젝트당 한 번 | manifest, 에이전트 가이드, 문서 트리 | `.handoff/config.md` | 코드, 빌드 명령 |
| `/plan` | 기능/수정 시작 시 | config, backlog | `.handoff/plan.md` | 코드, 빌드 명령 |
| `/execute` | `/plan` 이후 | config, plan | `.handoff/task.md` + 코드 | test/typecheck/lint |
| `/verify` | `/execute` 이후, 새 채팅 | config, plan, task | `.handoff/review.md`, 정리 | 코드 |

## 설치

### 범용 (모든 지원 에이전트 — 권장)

[`vercel-labs/skills`](https://github.com/vercel-labs/skills) 기반. Claude Code, Cursor, Codex, Gemini CLI, Aider 등 50개 이상의 에이전트에서 동작.

> **⚠️ 4개 스킬을 함께 설치하세요.** 스킬은 한 세트로 설계됐습니다: 각 스킬의 gate는 이전 단계가 쓴 상태를 기대합니다 (`/plan`은 `/setup-handoff`가 만든 `config.md`, `/execute`는 `plan.md`, `/verify`는 `task.md`). 부분 설치는 설치되지 않은 슬래시 명령을 가리키는 gate failure를 일으킵니다. `--skill '*'` (또는 `--all`)로 4개 모두 한 번에 설치하세요.

```bash
# 인터랙티브: 어느 에이전트에 설치할지 선택 (4개 스킬 기본 선택)
npx skills@latest add WillowRyu/agent-handoff

# 비인터랙티브: 4개 스킬 모두 Claude Code에 글로벌 설치
npx skills@latest add WillowRyu/agent-handoff --skill '*' -g -a claude-code -y
```

유용한 플래그: `-g` (글로벌, `~/`에 설치), `--list` (dry-run), `--skill '*'` (모든 스킬, 권장), `-a <agent>` (대상 에이전트). `npx skills@latest --help` 참고.

### Claude Code (플러그인 마켓플레이스 대안)

```bash
/plugin marketplace add WillowRyu/agent-handoff
/plugin install agent-handoff
```

## 워크플로우

```
/setup-handoff              # 한 번만
/plan "<작업 설명>"          # 무엇을 할지 기술
/execute                    # 새 채팅에서 권장
/verify                     # 또 다른 새 채팅에서 권장
```

각 단계의 실제 산출물 예시는 [docs/examples/](docs/examples/) 참고.

## 권한 (Permissions)

각 스킬은 특정 파일을 씁니다. 핸드오프 상태 파일에 대한 쓰기 권한을 에이전트 권한 설정에서 미리 허용해두면 매번 prompt에 막히는 마찰이 줄어듭니다. 나머지 (`/execute` 중 소스 파일 수정, `/verify` 중 `Bash` 실행)는 프로젝트의 기존 관행을 따르세요.

| 스킬 | 필요 권한 |
|---|---|
| `setup-handoff` | repo에 대한 Read; `.handoff/config.md`에 대한 Write/Edit |
| `plan` | repo에 대한 Read; `.handoff/plan.md`와 `.handoff/backlog.md`에 대한 Write/Edit |
| `execute` | plan에 명시된 소스 파일에 대한 Edit; `.handoff/task.md`에 대한 Write; plan의 sync commands를 위한 `Bash` |
| `verify` | test/typecheck/lint를 위한 `Bash`; `.handoff/{plan,task,review,backlog}.md`에 대한 Edit/Delete |

### Claude Code

`~/.claude/settings.json` (글로벌) 또는 `.claude/settings.json` (프로젝트)에 추가해서 핸드오프 상태 쓰기를 미리 허용:

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

### 다른 에이전트

Cursor, Codex, Gemini CLI, Aider 등은 각자의 권한 모델이 있습니다. 스킬은 `.handoff/`와 plan에 명시된 소스 파일 외에는 손대지 않으니, 기존 scoping 관행을 그대로 적용하면 됩니다.

## 설정

`/setup-handoff`이 `.handoff/config.md`를 작성합니다. 검증 명령, 응답 언어, 문서 경로를 바꾸려면 직접 편집하세요. `/setup-handoff`를 다시 돌리면 덮어쓰고, `/setup-handoff --auto`는 인터뷰를 완전히 건너뜁니다 (자동 감지에 실패한 항목만 묻는 fallback 포함).

## v1 범위

- 4개 스킬, 엄격한 boundary와 `.handoff/*.md` 디스크 기반 핸드오프
- Stack-agnostic + **모노레포 인식** 스캔 (pnpm/npm/yarn/turbo/lerna/nx/cargo/go workspaces; workspace 별 docs + verification 후보)
- Setup 인터뷰가 **응답 언어를 가장 먼저** 물음 — 그 후의 모든 출력 (status 메시지, 작성되는 `.md` 파일)이 해당 언어로
- Doc index는 클릭 가능한 markdown 링크 + 짧은 설명
- **Plan이 verification 범위 결정** — `/verify`는 `plan.md`의 `## Verification plan`에 적힌 명령만 실행 (docs-only 변경 같으면 rationale과 함께 전체 skip); 섹션이 없으면 `config.md`로 fallback
- 선택적 **병렬화** — `/plan`이 `## Parallelization`에 독립 단위 식별; `/execute`가 host(Claude Code Task tool 등) 지원 시 group별 subagent로 분할 dispatch
- setup-handoff의 `--auto` 모드 (인터뷰 스킵, 자동 감지 실패 항목만 fallback)
- verify 통과 시 backlog 자동 정리

## v1 제외 (Out of scope)

- `/setup-handoff --refresh` (지금은 config.md 수동 편집)
- backlog 수동 조작 (`/verify --close-backlog ...`)
- 추가 스킬 (`git-push`, `pr-analyzer`, `verify-all` — v2 가능성)
- Claude Code 외 도구 형식으로의 자동 변환

## 라이선스

MIT.
