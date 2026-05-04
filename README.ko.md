# Agent Handoff Skills

[English](README.md) | **한국어**

코딩 에이전트를 위한 엄격한 3단계 핸드오프 워크플로우 — `plan` → `execute` → `verify` — 컨텍스트 사이를 디스크 기반 상태로 이어줍니다.

## 왜 필요한가

같은 컨텍스트에서 일하는 에이전트는 자신이 만든 결과물을 제대로 검증하지 못합니다. 이 플러그인은 작업을 세 개의 스킬로 나누고 boundary를 강제하며, 상태를 `.handoff/*.md`에 남겨 verify를 새 채팅에서 돌릴 수 있게 합니다. 자세한 배경은 [docs/why-handoff.md](docs/why-handoff.md) 참고.

## 네 개의 스킬

| 스킬 | 사용 시점 | 읽음 | 씀 | 금지 |
|---|---|---|---|---|
| `/setup-handoff` | 프로젝트당 한 번 | manifest, 에이전트 가이드, 문서 트리 | `.handoff/config.md` | 코드, 빌드 명령 |
| `/plan` | 기능/수정 시작 시 | config, backlog | `.handoff/plan.md` | 코드, 빌드 명령 |
| `/execute` | `/plan` 이후 | config, plan | `.handoff/task.md` + 코드 | test/typecheck/lint |
| `/verify` | `/execute` 이후, 새 채팅 | config, plan, task | `.handoff/review.md`, 정리 | 코드 |

## 설치

### Claude Code

```bash
/plugin marketplace add WillowRyu/agent-handoff
/plugin install agent-handoff
```

### 도구별 설치 안내

<details>
<summary>Cursor</summary>

SKILL.md frontmatter는 Cursor 룰 형식과 호환됩니다. 각 `skills/<name>/SKILL.md`를 프로젝트의 `.cursor/rules/`에 복사하세요. (검증된 조합은 커뮤니티 기여로 추가 예정.)
</details>

<details>
<summary>Codex / Gemini / Aider</summary>

frontmatter (name + description + body)는 의도적으로 최소화해서 일반적인 "system instruction" 파일로도 동작합니다. 특정 도구에서 테스트해 보셨다면 issues로 알려주세요 — 설치 안내가 여기에 추가됩니다.
</details>

## 워크플로우

```
/setup-handoff              # 한 번만
/plan "<작업 설명>"          # 무엇을 할지 기술
/execute                    # 새 채팅에서 권장
/verify                     # 또 다른 새 채팅에서 권장
```

각 단계의 실제 산출물 예시는 [docs/examples/](docs/examples/) 참고.

## 설정

`/setup-handoff`이 `.handoff/config.md`를 작성합니다. 검증 명령, 응답 언어, 문서 경로를 바꾸려면 직접 편집하세요. `/setup-handoff`를 다시 돌리면 덮어쓰고, `/setup-handoff --auto`는 인터뷰를 완전히 건너뜁니다 (자동 감지에 실패한 항목만 묻는 fallback 포함).

## v1 범위

- 위 4개 스킬
- setup-handoff의 `--auto` 모드
- verify 통과 시 backlog 자동 정리
- Stack-agnostic (어떤 언어/프레임워크에서도 작동 — sync 명령은 plan에서 옴)

## v1 제외 (Out of scope)

- `/setup-handoff --refresh` (지금은 config.md 수동 편집)
- backlog 수동 조작 (`/verify --close-backlog ...`)
- 추가 스킬 (`git-push`, `pr-analyzer`, `verify-all` — v2 가능성)
- Claude Code 외 도구 형식으로의 자동 변환

## 라이선스

MIT.
