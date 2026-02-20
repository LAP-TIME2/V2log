# Claude Code 업데이트 종합 정리 (2026년 1~2월)

> 작성일: 2026-02-19
> 대상 버전: v2.1.34 ~ v2.1.47
> 현재 버전: v2.1.47 (2026-02-18)

---

## 목차

1. [주요 신규 기능](#1-주요-신규-기능)
   - [1.1 Claude Code on the Web (원격 실행)](#11-claude-code-on-the-web-원격-실행)
   - [1.2 Agent Teams (에이전트 팀)](#12-agent-teams-에이전트-팀)
   - [1.3 Plugins + Marketplace (플러그인 마켓)](#13-plugins--marketplace-플러그인-마켓)
   - [1.4 Custom Agents (커스텀 에이전트)](#14-custom-agents-커스텀-에이전트)
   - [1.5 Agent Memory (에이전트 메모리)](#15-agent-memory-에이전트-메모리)
   - [1.6 Claude Sonnet 4.6 + Fast Mode](#16-claude-sonnet-46--fast-mode)
   - [1.7 ToolSearch (도구 지연 로딩)](#17-toolsearch-도구-지연-로딩)
2. [새 명령어/설정](#2-새-명령어설정)
3. [버전별 Changelog](#3-버전별-changelog)
4. [Windows 관련 수정](#4-windows-관련-수정)
5. [성능/메모리 개선](#5-성능메모리-개선)
6. [보안 강화](#6-보안-강화)
7. [V2log 프로젝트 적용 가이드](#7-v2log-프로젝트-적용-가이드)

---

## 1. 주요 신규 기능

### 1.1 Claude Code on the Web (원격 실행)

**개요**: 로컬 터미널과 claude.ai 클라우드 사이에서 작업을 주고받는 기능.

**구조**:
```
[내 PC 터미널]  ──&──→  [claude.ai 클라우드 VM]  ──/teleport──→  [내 PC 터미널]
  Claude Code              웹에서 자동 실행                      결과 가져오기
```

**사용법**:

| 방법 | 명령 | 설명 |
|------|------|------|
| 대화 중 보내기 | `& 작업 내용` | 메시지 앞에 `&` 붙이면 클라우드로 전송 |
| CLI에서 직접 | `claude --remote "작업 내용"` | 터미널에서 바로 원격 세션 시작 |
| 가져오기 | `/teleport` 또는 `/tp` | 웹 세션을 로컬로 가져오기 |
| 진행 확인 | `/tasks` | 백그라운드 작업 목록 확인 (`t`로 teleport) |
| 환경 선택 | `/remote-env` | 원격 환경 설정 (네트워크, 환경변수) |

**활용 패턴**:

```bash
# 패턴 1: 계획은 로컬, 실행은 클라우드
claude --permission-mode plan    # 플랜 모드로 협의
& 위에서 논의한 플랜 실행해줘        # 실행은 클라우드에 맡기기

# 패턴 2: 여러 작업 동시 실행
& 테스트 수정해줘
& API 문서 업데이트해줘
& 로거 리팩토링해줘
# → 3개가 각각 독립 세션으로 병렬 실행

# 패턴 3: 결과 가져오기
/teleport                       # 세션 선택 → 브랜치 체크아웃 + 대화 기록 복원
claude --teleport <session-id>  # 특정 세션 직접 가져오기
```

**요구사항**:
- Pro / Max / Team / Enterprise 플랜
- GitHub 연결 필수 (Claude GitHub 앱 설치)
- GitLab 미지원
- teleport 시: git clean 상태 + 같은 repo + 같은 계정

**클라우드 환경**:
- Anthropic 관리 VM (격리됨)
- Python, Node.js, Ruby, Java, Go, Rust, C++ 등 사전 설치
- PostgreSQL 16, Redis 7.0 포함
- 네트워크: 기본 제한적 (npm, PyPI, GitHub 등 허용), 설정으로 변경 가능
- iOS 앱에서도 모니터링/조작 가능

**주의사항**:
- 터미널 → 웹: 기존 세션을 통째로 push하는 게 아니라 **새 세션 생성** (현재 대화 컨텍스트 포함)
- 웹 → 터미널: teleport로 가져오기 가능
- 비용: 일반 Claude Code 사용량과 합산

---

### 1.2 Agent Teams (에이전트 팀)

**개요**: 여러 Claude 세션을 팀으로 묶어 동시 작업시키는 기능 (실험적).

**구조**:
```
[팀 리더 Claude]
    ├── 팀원 A: 프론트엔드 담당
    ├── 팀원 B: 백엔드 담당
    └── 팀원 C: 테스트 담당

팀원 간 직접 메시지 교환 가능
공유 Task List로 작업 조율
```

**활성화**:
```json
// settings.json 또는 환경변수
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

**사용법**: 자연어로 팀 구성을 설명하면 Claude가 알아서 팀 생성.
```
이 프로젝트를 3명이 나눠서 작업해줘:
- 1명은 프론트엔드 UI 수정
- 1명은 백엔드 API 수정
- 1명은 테스트 코드 작성
```

**커뮤니케이션 방식**:
- 자동 메시지 전달
- Idle 알림 (팀원이 놀고 있을 때)
- 공유 Task List
- 직접 메시지 (특정 팀원에게)
- 브로드캐스트 (전체, 비용 주의)

**Agent Teams vs Subagents 차이**:

| 항목 | Subagents (Task 도구) | Agent Teams |
|------|----------------------|-------------|
| 독립성 | 결과만 반환 | 완전 독립, 서로 대화 |
| 소통 | 메인에게만 보고 | 팀원끼리 직접 소통 |
| 적합한 작업 | 단일 조사/검색 | 복합 수정 (프론트+백+테스트) |

**비용**: 3명 팀 ≈ 혼자 할 때의 3~4배 토큰 (시간 절약으로 상쇄)

**훅 이벤트**: `TeammateIdle`, `TaskCompleted`

---

### 1.3 Plugins + Marketplace (플러그인 마켓)

**개요**: 남이 만든 도구 패키지를 한 번에 설치/사용하는 시스템 (Public Beta).

**플러그인 구성요소**:
- Slash Commands (커스텀 명령어)
- Agents (전문 에이전트)
- MCP Servers (외부 도구 연결)
- Hooks (이벤트 반응 스크립트)

**사용법**:
```bash
/plugin                    # 플러그인 관리 메뉴
/plugin install <이름>      # 설치
/plugin list               # 설치된 목록
```

**마켓플레이스**: 270+ 플러그인, 739개 스킬이 공개되어 있음.
- 공식: https://github.com/anthropics/skills
- 커뮤니티: https://claudemarketplaces.com/

**플러그인 만들기**: `.claude/plugins/` 폴더에 구성 파일 작성.

---

### 1.4 Custom Agents (커스텀 에이전트)

**개요**: `.claude/agents/` 폴더에 마크다운 파일을 넣어 나만의 전문 에이전트를 정의.

**파일 구조**:
```
.claude/agents/
├── reviewer.md        ← 코드 리뷰 전문
├── tester.md          ← 테스트 작성 전문
└── cv-specialist.md   ← CV 코드 전문
```

**에이전트 파일 형식** (예시):
```markdown
---
name: CV Specialist
description: CV/ML 코드 전문 에이전트
model: opus
memory: project
---

# 역할
CV Phase 관련 코드만 담당합니다.

# 규칙
- CLAUDE-CV.md 항상 참조
- 헬스장 환경 체크리스트 6항목 확인
```

**호출**: Task 도구에서 `agent_type`으로 지정하거나, Agent Teams에서 팀원으로 배정.

---

### 1.5 Agent Memory (에이전트 메모리)

**개요**: 에이전트가 세션 간 정보를 자동으로 기억/활용하는 공식 시스템.

**범위 설정**:

| 범위 | 설명 |
|------|------|
| `user` | 사용자 전체 (모든 프로젝트) |
| `project` | 특정 프로젝트만 |
| `local` | 로컬 머신에서만 |

**기존 MEMORY.md와의 관계**: 우리가 수동으로 관리하던 MEMORY.md 패턴이 공식 기능으로 편입된 것. 자동 기록/갱신이 추가됨.

---

### 1.6 Claude Sonnet 4.6 + Fast Mode

**Sonnet 4.6** (v2.1.45):
- 새로운 모델 옵션 추가
- `/model` 명령으로 전환 가능
- Opus보다 빠르고 저렴, 충분히 높은 성능

**Fast Mode** (v2.1.36):
- `/fast` 명령으로 토글
- 같은 Opus 4.6 모델의 **빠른 출력 모드** (모델 자체가 바뀌지 않음)
- 문서: https://code.claude.com/docs/en/fast-mode

---

### 1.7 ToolSearch (도구 지연 로딩)

**개요**: MCP 도구의 전체 스키마를 매번 로드하지 않고, 필요할 때만 불러오는 내장 기능.

**작동 방식**:
```
항상 로드됨:    ToolSearch 도구 설명 + 도구 이름 목록 (가벼움)
필요할 때만:    도구의 전체 스키마 (ToolSearch 호출 시 로드)
```

**효과**: MCP 도구가 많아도 평소 토큰 소비가 적음. 예를 들어 Notion MCP 12개 도구(~22,000 토큰)가 있어도, 실제로 호출 전까지는 이름 목록만 컨텍스트에 포함.

**참고**: `claude doctor`에서 보여주는 토큰 수치는 "전부 로드할 경우"의 최대치이며, 실제 사용량은 더 적음.

---

## 2. 새 명령어/설정

### 슬래시 명령어

| 명령 | 버전 | 설명 |
|------|------|------|
| `/debug` | 최신 | 세션 트러블슈팅 도움 |
| `/teleport` (`/tp`) | 기존 | 웹 세션을 로컬로 가져오기 |
| `/tasks` | 기존 | 백그라운드/원격 작업 목록 |
| `/remote-env` | 기존 | 원격 환경 설정 선택 |
| `/plugin` | 최신 | 플러그인 관리 |
| `/rename` | 개선 | 인자 없으면 대화 기반 자동 이름 생성 (v2.1.41) |
| `/fast` | v2.1.36 | Opus 4.6 빠른 출력 모드 토글 |

### CLI 명령어

| 명령 | 버전 | 설명 |
|------|------|------|
| `claude --remote "작업"` | 기존 | 원격 웹 세션 시작 |
| `claude --teleport` | 기존 | 웹 세션 가져오기 (인터랙티브 선택) |
| `claude --teleport <id>` | 기존 | 특정 웹 세션 가져오기 |
| `claude auth login` | v2.1.41 | CLI에서 로그인 |
| `claude auth status` | v2.1.41 | 인증 상태 확인 |
| `claude auth logout` | v2.1.41 | CLI에서 로그아웃 |

### 설정

| 설정 | 설명 |
|------|------|
| `spinnerTipsOverride` | 스피너 팁 커스터마이즈. `tips` 배열 + `excludeDefault: true` 옵션 |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | Agent Teams 활성화 (환경변수 또는 settings.json) |
| `chat:newline` 키바인딩 | 멀티라인 입력 키 설정 가능 (v2.1.47) |

---

## 3. 버전별 Changelog

### v2.1.47 (2026-02-18) — 현재 버전

**핵심 수정**:
- Plan 모드가 context compact 후에도 유지 (기존에는 compact 시 풀림)
- PDF 많은 대화에서 compact 실패하던 문제 수정
- 병렬 파일 수정 시 하나 실패해도 나머지 계속 진행
- Bash 권한 분류기 할루시네이션 검증 추가

**Windows 수정 (5건)**:
- 터미널 줄 수가 항상 "1"로 표시되던 문제 (원인: `\r\n`)
- 굵은 글씨/색상이 엉뚱한 위치에 나오던 문제
- MSYS2/Cygwin 쉘에서 bash 출력이 무시되던 문제
- 같은 CLAUDE.md 드라이브 대소문자 다르면 2번 로드
- 훅(PreToolUse, PostToolUse)이 조용히 실패 → Git Bash로 실행

**성능/메모리 (6건)**:
- API 스트림 버퍼 사용 후 해제
- 에이전트 완료 후 메시지 기록 정리
- O(n²) 메시지 누적 제거
- SessionStart 훅 지연 실행 (시작 ~500ms 빨라짐)
- `@` 파일 멘션 인덱스 프리워밍 + 캐싱
- Resume 목록 10개 → 50개

**세션 관리 (5건)**:
- `/rename` 후 resume 시 이름 유지
- `/clear` 후 이름 잔류 수정
- compact 후 이름 유지
- 16KB 초과 첫 메시지 세션 resume 가능
- 대형 세션 목록 누락 수정

**에이전트 (3건)**:
- 동시 에이전트 API 400 에러 수정
- 백그라운드 에이전트 결과 원시 데이터 대신 정답 반환
- `Ctrl+F`로 백그라운드 에이전트 전체 종료

**기타 주목할 만한 수정**:
- Edit 도구가 유니코드 따옴표(""'') 을 직선 따옴표로 변환하던 버그 수정
- CJK 와이드 문자 타임스탬프 정렬 수정
- MCP 서버가 deferred loading 후 관리 다이얼로그에 안 나오던 문제 수정
- WSL2에서 이미지 BMP 붙여넣기 지원
- LSP findReferences가 gitignore 파일 결과에 포함하던 문제 수정

---

### v2.1.45 (2026-02-17)

**신규**:
- Claude Sonnet 4.6 모델 지원
- `spinnerTipsOverride` 설정 (커스텀 스피너 팁)
- SDK 속도 제한 정보 타입 (`SDKRateLimitInfo`, `SDKRateLimitEvent`)
- `--add-dir` 디렉토리에서 `enabledPlugins`, `extraKnownMarketplaces` 읽기

**수정**:
- Agent Teams가 Bedrock/Vertex/Foundry에서 실패 → 환경변수 전파 수정
- macOS 샌드박스 임시 파일 권한 오류 수정
- Task 도구(백그라운드 에이전트) 완료 시 `ReferenceError` 크래시 수정
- 이미지 붙여넣기 후 Enter 자동완성 충돌 수정
- 과도한 `.claude.json.backup` 파일 축적 수정
- 플러그인 설치 후 재시작 없이 바로 사용 가능

**성능**:
- 시작 시 세션 히스토리 즉시 로딩 제거
- Shell 대량 출력 시 메모리 무한 증가 수정
- 축소된 read/search 그룹에 현재 처리 중인 파일명 표시

---

### v2.1.44 (2026-02-16)

- 인증 갱신 오류 수정

---

### v2.1.42 (2026-02-13)

- `/resume`에서 인터럽트 메시지가 세션 제목으로 표시되던 문제 수정
- Opus 4.6 출시 안내가 Bedrock/Vertex/Foundry 사용자에게도 표시되던 문제 수정
- 이미지 많은 세션에서 dimension 제한 에러 메시지 개선 + `/compact` 제안

---

### v2.1.41 (2026-02-13)

**신규**:
- `claude auth login` / `status` / `logout` CLI 명령어
- Windows ARM64 네이티브 바이너리 지원
- `/rename` 인자 없이 호출 시 대화 기반 자동 이름 생성

**수정**:
- `@`멘션에 앵커 프래그먼트(`@README.md#installation`) 있을 때 파일 해석 실패
- FileReadTool이 FIFO, `/dev/stdin`, 대용량 파일에서 블로킹
- 백그라운드 작업 알림이 SDK 스트리밍 모드에서 미전달
- 분류기 규칙 입력 시 커서 점프
- 마크다운 링크 표시 텍스트 누락
- auto-compact 실패 에러 알림 표시 수정
- 서브에이전트 경과 시간에 권한 대기 시간 포함되던 문제
- Plan 모드 중 proactive tick 발동 수정
- 설정 파일 디스크 변경 시 stale 권한 규칙 정리
- 훅 차단 에러에 stderr 내용 표시

**UI**:
- 좁은 터미널에서 프롬프트 푸터 레이아웃 개선

---

### v2.1.39 (2026-02-10)

- 터미널 렌더링 성능 개선
- Fatal 에러가 삼켜지는 대신 표시
- 세션 닫힌 후 프로세스 행 수정
- 터미널 화면 경계에서 글자 소실
- verbose 트랜스크립트 뷰 빈 줄 수정

---

### v2.1.38 (2026-02-10)

- VS Code 터미널 scroll-to-top 회귀 수정
- Tab 키가 자동완성 대신 슬래시 명령 큐잉하던 문제
- 환경변수 래퍼 사용 bash 명령 권한 매칭 수정
- 스트리밍 미사용 시 tool 간 텍스트 사라짐
- VS Code에서 resume 시 세션 중복 수정
- 샌드박스 모드에서 `.claude/skills` 쓰기 차단
- **보안**: heredoc 파싱에서 명령 삽입(command smuggling) 방지

---

### v2.1.37 (2026-02-07)

- `/extra-usage` 활성화 후 `/fast` 즉시 사용 가능하도록 수정

---

### v2.1.36 (2026-02-07)

- **Opus 4.6 Fast Mode** 사용 가능
- 문서: https://code.claude.com/docs/en/fast-mode

---

### v2.1.34 (2026-02-06)

- Agent Teams 설정 변경 시 렌더 크래시 수정
- 샌드박스 제외 명령(`sandbox.excludedCommands`, `dangerouslyDisableSandbox`)이 `autoAllowBashIfSandboxed` 활성 시 Bash ask 권한 규칙 우회하던 보안 버그 수정

---

## 4. Windows 관련 수정 (전체 요약)

| 버전 | 문제 | 원인 | 수정 |
|------|------|------|------|
| v2.1.47 | 줄 수 항상 "1" 표시 | `os.EOL`이 `\r\n`이라 계산 틀림 | `\n` 기준으로 통일 |
| v2.1.47 | 굵은 글씨/색상 위치 이탈 | `\r\n` 줄바꿈이 마크다운 파싱 오류 유발 | 렌더링 전 정규화 |
| v2.1.47 | MSYS2/Cygwin bash 출력 무시 | 쉘 출력 처리 호환성 | 쉘 종류별 처리 분기 |
| v2.1.47 | CLAUDE.md 2번 로드 | `C:\` vs `c:\` 대소문자 차이 | 경로 정규화 |
| v2.1.47 | CWD 추적 임시파일 누적 | 정리 안 됨 | 자동 정리 추가 |
| v2.1.47 | 훅 실행 실패 | cmd.exe 호환성 | Git Bash로 실행 |
| v2.1.47 | Right Alt 잔상 `[25~` | Git Bash 이스케이프 시퀀스 | 필터링 추가 |
| v2.1.47 | WSL2 이미지 붙여넣기 | BMP 형식 미지원 | BMP 지원 추가 |
| v2.1.47 | worktree 세션 매칭 실패 | 드라이브 대소문자 | 경로 정규화 |
| v2.1.41 | ARM64 미지원 | 바이너리 없음 | win32-arm64 추가 |

---

## 5. 성능/메모리 개선 (전체 요약)

| 버전 | 개선 항목 | 효과 |
|------|----------|------|
| v2.1.47 | API 스트림 버퍼 해제 | 긴 세션 메모리 안정 |
| v2.1.47 | 에이전트 메시지 기록 정리 | 에이전트 작업 후 메모리 회수 |
| v2.1.47 | O(n²) 진행 업데이트 제거 | 대량 에이전트 작업 시 성능 |
| v2.1.47 | SessionStart 훅 지연 실행 | 시작 ~500ms 빨라짐 |
| v2.1.47 | `@` 멘션 인덱스 프리워밍 | 파일 추천 즉시 표시 |
| v2.1.47 | Resume 목록 50개 | 세션 찾기 빨라짐 |
| v2.1.47 | PDF compact 실패 수정 | PDF 많은 대화 안정 |
| v2.1.45 | 시작 시 세션 히스토리 로딩 제거 | 시작 속도 향상 |
| v2.1.45 | Shell 대량 출력 메모리 제한 | RSS 무한 증가 방지 |
| v2.1.39 | 터미널 렌더링 성능 | 전반적 UI 반응성 |

---

## 6. 보안 강화

| 버전 | 항목 | 설명 |
|------|------|------|
| v2.1.47 | Bash 권한 검증 | 할루시네이션 기반 허용 방지 — Claude가 "이건 허용됨"이라고 거짓 판단하는 걸 막음 |
| v2.1.47 | 멀티라인 bash "Always allow" | 잘못된 권한 패턴이 설정 파일 손상시키던 문제 수정 |
| v2.1.38 | heredoc 명령 삽입 방지 | heredoc 블록 안에 숨겨진 명령 실행 차단 |
| v2.1.38 | `.claude/skills` 쓰기 차단 | 샌드박스 모드에서 스킬 디렉토리 변조 방지 |
| v2.1.34 | 샌드박스 제외 명령 우회 | 제외된 명령이 ask 권한까지 우회하던 문제 수정 |

---

## 7. V2log 프로젝트 적용 가이드

### 바로 쓸 수 있는 기능

| 기능 | 활용 방안 | 필요 조건 |
|------|----------|----------|
| `& 작업` / `--remote` | CV 리팩토링, 테스트 작성을 클라우드에 맡기기 | GitHub 연결 |
| `/fast` | 단순 수정/검색 시 빠른 응답 | 없음 (바로 사용) |
| `/rename` 자동 | 세션 이름 자동 생성 | 없음 |
| Sonnet 4.6 | 비용 절약이 필요한 단순 작업 | `/model`로 전환 |

### 설정하면 쓸 수 있는 기능

| 기능 | 설정 방법 | 적합한 경우 |
|------|----------|------------|
| Agent Teams | `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` | 대규모 리팩토링, 프론트+백엔드 동시 수정 |
| Custom Agents | `.claude/agents/cv-specialist.md` 생성 | CV 전용 에이전트, 리뷰 에이전트 등 |
| Plugins | `/plugin install` | 커뮤니티 도구 활용 |

### 이미 적용 중인 기능

| 기능 | 현재 상태 |
|------|----------|
| ToolSearch | 자동 적용됨 (MCP 도구 지연 로딩) |
| Agent Memory | MEMORY.md로 수동 관리 중 (공식 기능과 병행 가능) |

---

## 참고 링크

- [공식 Changelog](https://code.claude.com/docs/en/changelog)
- [GitHub Releases](https://github.com/anthropics/claude-code/releases)
- [Claude Code on the Web 문서](https://code.claude.com/docs/en/claude-code-on-the-web)
- [Agent Teams 문서](https://code.claude.com/docs/en/agent-teams)
- [Plugins 문서](https://code.claude.com/docs/en/plugins)
- [Fast Mode 문서](https://code.claude.com/docs/en/fast-mode)
- [Anthropic Skills GitHub](https://github.com/anthropics/skills)
