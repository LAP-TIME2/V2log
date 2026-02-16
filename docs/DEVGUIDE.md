# V2log 개발 프로세스 가이드

> 이 프로젝트에 설정된 자동화/문서/명령어 시스템 전체 정리.
> "어떤 상황에 뭘 쓰면 되는지" 한눈에 보기.

---

## 1. 자동으로 돌아가는 것 (신경 안 써도 됨)

### PreCompact 훅 — Notion 자동 기록 + DEVLOG 자동 업데이트
- **언제**: Claude 대화가 길어져서 `auto-compact` 되거나, `/compact` 입력 시
- **뭘 하는지**:
  1. `.claude/session-log.md` 내용을 **Notion 노트 DB**에 자동 전송
  2. 오늘 git 커밋 목록을 Notion에 추가
  3. `docs/DEVLOG.md`에 커밋 자동 기록
  4. session-log.md 초기화
- **파일**: `.claude/hooks/pre-compact-notion.js`

### 세션 로그 — Claude가 자동으로 작성
- **언제**: 에러 해결, 커밋, 핵심 패턴 등장, 빌드 결과 등 작업 중 수시로
- **뭘 하는지**: `.claude/session-log.md`에 상세 기록 → compact 시 Notion으로 전송
- **Notion 수신**: 노트 DB > "중간 작업물" 분류 > "개발 역량 강화" 영역

### DEVLOG 자동 업데이트 (3중 안전망)
| Layer | 언제 | 누가 | 뭘 넣는지 |
|-------|------|------|----------|
| 1 | Claude가 커밋할 때 | Claude | 커밋 + 배운 점 + 결정 (리치) |
| 2 | compact 시 | PreCompact 훅 | 커밋 해시 + 메시지 (기본) |
| 3 | `/devlog` 입력 시 | Claude (수동) | 빠진 커밋 + (auto) 보강 |

- **중복 방지**: 해시 기반 필터링 — Layer 1이 먼저 쓰면 Layer 2는 스킵

### Claude가 자동으로 지키는 규칙
| 규칙 | 트리거 | 하는 일 |
|------|--------|---------|
| 결정 즉시 기록 | "이렇게 하자" 발언 | MEMORY.md 📌 미반영에 추가 |
| 새 파일 교차 확인 | .py/.md/.dart 생성 | MEMORY.md 결정과 충돌 없는지 확인 |
| 커밋 전 결정 검증 | git commit 직전 | 변경 파일이 결정 영향 파일이면 값 확인 |
| 파라미터 연쇄 점검 | 값 A를 바꿀 때 | A에 의존하는 B, C도 같이 조정 |
| CLAUDE.md 업데이트 | 커밋할 때 | 진행 상황 체크리스트 동기화 |
| DEVLOG.md 업데이트 | 커밋할 때 | 타임라인 + 배운 점 추가 |
| 세션 로그 즉시 기록 | 에러/커밋/패턴 | session-log.md에 즉시 append |
| 수정노트 즉시 기록 | 버그 해결/설계 완료 | CV_수정노트.md에 추가 |
| 헬스장 환경 체크 | CV 코드 수정 전 | CLAUDE-CV.md §10 체크리스트 확인 |
| 설명 스타일 | 항상 | 기술 용어 → "그러니까" + 쉬운 설명 |

---

## 2. 슬래시 명령어 (직접 입력해서 사용)

### `/cv-status` — CV 진행 상황 대시보드
- **쓸 때**: "CV 어디까지 했지?", "다음에 뭘 해야 하지?"
- **보여주는 것**: 모든 Phase의 모든 항목을 **실제 코드에서** 자동 체크 (✅/❌)
- **예시**: Phase 1 완료 여부, Phase 2A 학습 결과, Phase 2B 통합 상태

### `/cv-test` — CV 실기기 테스트
- **쓸 때**: CV 코드 수정 후 실제 폰에서 확인하고 싶을 때
- **하는 일**: Flutter 빌드 → 테스트 기기(R3CN90HVMKL)에 설치 → 실행

### `/decision-check` — 결정 반영 검증
- **쓸 때**: "지난번에 결정한 거 코드에 적용됐어?", "빠진 거 없어?"
- **하는 일**: MEMORY.md의 📌 미반영 결정 vs 실제 코드 비교 → 위반 건수 출력
- **자동 실행 시점**: 세션 시작 시 / 새 파일 생성 후 / 커밋 직전

### `/devlog` — 개발 일지 업데이트
- **쓸 때**: "DEVLOG에 빠진 거 없어?", "자동 기록 보강해줘"
- **하는 일**: git log에서 빠진 커밋 catch-up + `(auto)` 항목에 맥락 보강

### `/compact` — 대화 정리
- **쓸 때**: 대화가 길어져서 정리하고 싶을 때
- **하는 일**: 컨텍스트 압축 + Notion 자동 전송 + DEVLOG 자동 업데이트

### `/commit` — 커밋
- **쓸 때**: "커밋해줘"
- **하는 일**: 변경 분석 → 커밋 메시지 자동 작성 → 커밋

---

## 3. 문서 체계 (어디에 뭐가 있는지)

### 프로젝트 루트
| 파일 | 역할 | 보는 시점 |
|------|------|----------|
| `CLAUDE.md` | 앱 전체 설계 + DB 스키마 + 진행 체크리스트 | "지금 뭘 해야 하지?" |
| `CLAUDE-CV.md` | CV 기술 스택 + 코딩 규칙 + 통합 포인트 | CV 코드 수정할 때 |
| `CLAUDE.local.md` | 개인 작업 규칙 (설명 스타일, 기록 규칙) | Git에 안 올라감 (로컬 전용) |

### docs/ 폴더
| 파일 | 역할 | 보는 시점 |
|------|------|----------|
| `DEVGUIDE.md` | **이 문서** — 프로세스 총정리 | "뭐가 있고 어떻게 쓰지?" |
| `DEVLOG.md` | 개발 일지 (시간순 스토리) | "어떤 과정으로 만들었지?" |
| `CV_수정노트.md` | CV 버그 해결 상세 교과서 (v2B-001~010) | "왜 이렇게 고쳤지?" |
| `reference/` | 조사 보고서 모음 (6편) | 기술 결정의 근거 찾을 때 |

### .claude/ 폴더 (Claude 전용)
| 파일 | 역할 |
|------|------|
| `session-log.md` | 오늘 작업 로그 (compact 시 Notion 전송 후 초기화) |
| `hooks/pre-compact-notion.js` | PreCompact 훅 (Notion + DEVLOG 자동 업데이트) |
| `hooks/.env` | Notion API 토큰 (NOTION_TOKEN) |
| `skills/cv-status/` | /cv-status 스킬 정의 |
| `skills/cv-test/` | /cv-test 스킬 정의 |
| `skills/decision-check/` | /decision-check 스킬 정의 |
| `skills/devlog/` | /devlog 스킬 정의 |

### MEMORY.md (Claude 자동 메모리)
| 위치 | 역할 |
|------|------|
| `~/.claude/projects/.../memory/MEMORY.md` | Claude가 세션 간 기억하는 메모 (결정 추적, 작업 규칙) |

---

## 4. 실제 사용 시나리오

| 상황 | 행동 |
|------|------|
| "오늘 뭐 했는지 보고 싶어" | `docs/DEVLOG.md` 열기 (Part 2 타임라인) |
| "경영진에게 프로젝트 설명" | `docs/DEVLOG.md` Part 1 (경영진 요약) |
| "다른 개발자에게 인수인계" | `docs/DEVLOG.md` 전체 + `CLAUDE.md` |
| "CV 진행 상황" | Claude에 `/cv-status` 입력 |
| "이 버그 왜 이렇게 고쳤어?" | `docs/CV_수정노트.md` (v2B-001~010) |
| "결정한 거 반영됐어?" | Claude에 `/decision-check` 입력 |
| "DEVLOG에 빠진 거?" | Claude에 `/devlog` 입력 |
| "CV 코드 고쳤는데 테스트" | Claude에 `/cv-test` 입력 |
| "이 기술 결정의 근거?" | `docs/reference/` 날짜별 보고서 |
| "뭐가 있고 어떻게 쓰지?" | **이 문서** (`docs/DEVGUIDE.md`) |

---

## 5. 데이터 흐름도

```
[Claude 작업 중]
  ├→ session-log.md (즉시 기록)
  ├→ CV_수정노트.md (버그 해결 시)
  └→ MEMORY.md (결정 사항)

[Claude 커밋 시]
  ├→ DEVLOG.md (리치 콘텐츠)      ← Layer 1
  ├→ CLAUDE.md (진행 체크리스트)
  └→ git commit

[auto-compact 또는 /compact 시]
  ├→ DEVLOG.md (기본 커밋)         ← Layer 2 (백업)
  ├→ Notion DB (session-log 전송)
  └→ session-log.md 초기화

[/devlog 수동 실행 시]
  └→ DEVLOG.md (catch-up + 보강)   ← Layer 3 (보험)
```
