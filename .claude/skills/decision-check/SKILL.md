# /decision-check 스킬

MEMORY.md의 결정사항이 실제 코드에 100% 반영되었는지 자동 검증합니다.
**문서만 보지 말고, 실제 파일을 Grep/Read로 직접 확인**할 것.

---

## 실행 시점

- 수동: `/decision-check` 명령
- 반자동 (Claude가 자발적으로 실행):
  - 세션 시작 시 (📌 미반영 1개 이상이면)
  - 새 파일(.py/.md/.ipynb/.dart) 생성 직후
  - 커밋 직전
  - `/cv-status` 실행 시 마지막 섹션으로 포함

---

## 실행 순서

### 1단계: MEMORY.md 읽기
- `C:\Users\mal03\.claude\projects\C--Dev-V2log\memory\MEMORY.md` 읽기
- "현재 미반영 결정" 섹션에서 📌/✅/⚠️ 항목 추출
- 각 결정의 `영향 파일`, `검증 명령` 확인

### 2단계: Phase 1 일관성 검증 (병렬 Grep)

| # | 체크 항목 | 검증 방법 | 통과 조건 |
|---|----------|----------|----------|
| 1 | 지원 운동 수 | `exercise_angles.dart`에서 `ExerciseAngleRule(` 개수 vs CLAUDE.md "10개" | 일치 |
| 2 | Rep Counter 버전 | `rep_counter_service.dart` 상단 버전 주석 vs CLAUDE.md "v5.2" | 일치 |
| 3 | MLKit 버전 | `pubspec.yaml` 실제 버전 vs `CLAUDE-CV.md` 표기 | 일치 |
| 4 | camera 패키지 버전 | `pubspec.yaml` 실제 버전 vs `CLAUDE-CV.md` 표기 | 일치 |

### 3단계: Phase 2A 일관성 검증 (병렬 Grep)

| # | 체크 항목 | 검증 방법 | 통과 조건 |
|---|----------|----------|----------|
| 5 | YOLO11 잔존 | Grep `yolo11\|YOLO11\|yolo11n\|yolov11` in V2log-CV-Training (.gitignore, docs/reference 제외) | 0건 |
| 6 | YOLO26 존재 | Grep `yolo26n` in `scripts/train.py` | 1건+ |
| 7 | 클래스 수 | `data.yaml` nc 값 vs `V2log-CV-Training/CLAUDE.md` 클래스 표 개수 | 일치 |
| 8 | Phase 진행 상황 | `CLAUDE.md` Phase 2A 상태 표기 vs MEMORY.md 실제 진행 | 일치 |

### 4단계: 문서 간 크로스체크 (병렬)

| # | 체크 항목 | 검증 방법 | 통과 조건 |
|---|----------|----------|----------|
| 9 | CLAUDE.md ↔ CLAUDE-CV.md | 양쪽 Phase 2A 상태 비교 | 일치 |
| 10 | CLAUDE-CV.md ↔ V2log-CV-Training/CLAUDE.md | YOLO 버전, 클래스 수 비교 | 일치 |
| 11 | MEMORY.md ↔ 실제 코드 | 📌 미반영 항목에 대해 검증 명령 실행 | 정합성 확인 |

### 5단계: Single Source of Truth 검증

아래 Primary Source의 값이 다른 파일과 일치하는지 확인:
- **YOLO 버전** → Primary: `V2log-CV-Training/scripts/train.py`
- **클래스 목록** → Primary: `V2log-CV-Training/data.yaml`
- **패키지 버전** → Primary: `V2log/pubspec.yaml`
- **CV 로드맵** → Primary: `V2log/CLAUDE-CV.md`
- **앱 진행상황** → Primary: `V2log/CLAUDE.md`

---

## 출력 형식

```
## 결정 반영 검증 결과 (YYYY-MM-DD)

### ✅ 통과: N/N개  |  ❌ 실패: N개  |  ⚠️ 확인 필요: N개

**[Phase 1 일관성]**
| # | 체크 항목 | 상태 | 상세 |
|---|----------|------|------|
| 1 | 지원 운동 수 | ✅/❌ | 코드 N개 vs 문서 M개 |
| 2 | Rep Counter 버전 | ✅/❌ | 코드 vX vs 문서 vY |
| 3 | MLKit 버전 | ✅/❌ | pubspec ^X vs 문서 ^Y |
| 4 | camera 버전 | ✅/❌ | pubspec ^X vs 문서 ^Y |

**[Phase 2A 일관성]**
| # | 체크 항목 | 상태 | 상세 |
|---|----------|------|------|
| 5 | YOLO11 잔존 | ✅/❌ | N건 발견: [파일:라인] |
| 6 | YOLO26 존재 | ✅/❌ | train.py에 N건 |
| 7 | 클래스 수 | ✅/❌ | data.yaml N vs 문서 M |
| 8 | Phase 진행 상황 | ✅/❌ | 문서: "X" vs 실제: "Y" |

**[문서 간 크로스체크]**
| # | 체크 항목 | 상태 | 상세 |
|---|----------|------|------|
| 9 | CLAUDE.md ↔ CLAUDE-CV.md | ✅/❌ | |
| 10 | CLAUDE-CV.md ↔ CV-Training | ✅/❌ | |
| 11 | MEMORY.md ↔ 코드 | ✅/❌ | |

---

### ❌ 즉시 수정 필요
1. `파일:라인` — 현재: `X` → 올바른: `Y`
2. ...

### ⚠️ 미확정 결정 (확인 필요)
- [결정 내용]: [현재 상태]
```

---

## 주의사항

1. `docs/reference/` 하위 파일은 과거 보고서이므로 검증에서 **제외**
2. `.gitignore`의 폴더명은 외부 다운로드 데이터셋이므로 **제외**
3. `.ipynb` 파일의 비교 설명 ("YOLO11보다 빠름" 등)은 **허용**
4. 검증 실패 시 구체적 수정 제안 포함 (파일 + 라인 + before/after)
5. 모든 Grep은 **병렬 실행** (실행 시간 15초 이내)
6. 새로운 결정이 MEMORY.md에 추가되면 해당 검증도 자동 포함
