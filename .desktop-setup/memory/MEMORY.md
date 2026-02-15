# V2log Project Memory

## 클로드 작업 규칙

### 설명 스타일
- **기술 용어 후 반드시 "그러니까" + 쉬운 설명 붙이기**
- 코딩 초보자가 이해할 수 있는 수준으로

### 작업 방식
- **코드 수정은 제한 없이** 최대 성능으로 진행
- **설명은 한 번에 3개씩** 나눠서 전달
- 작업 끝나면 `flutter run -d R3CT90G9P0B` 실행해서 테스트
- **이 프로젝트는 데스크탑 테스트용 복사본** (원본: `C:\Dev\V2log` 노트북)

### 결정 기록 규칙 ⭐ (2026-02-13 신설)
- **결정 즉시 기록**: "이렇게 하자"가 나오면 즉시 아래 `현재 미반영 결정`에 추가
- **미반영 표시**: 📌 = 결정했지만 파일 아직 안 고침, ✅ = 반영 완료
- **구현 시 반영**: 코딩/커밋할 때 관련 파일 수정 → 📌를 ✅로 변경
- **아카이브**: ✅ 완료된 결정은 `memory/decisions-archive.md`로 이동 (MEMORY.md 용량 관리)
- **조사/보고서 자동 저장**: 서브에이전트 조사 완료 → `docs/reference/`에 즉시 저장 (사용자 요청 없어도)
- **세션 시작 시**: 📌 미반영 목록 먼저 확인 → 사용자에게 알리기

### 버그 수정
- **1차 실패 → 즉시 중단, 구조 분석 모드 전환**
- 수정 전: 정확한 레이어 확인 → 전체 호출 흐름 추적 → 해당 레이어에서 작동하는지 검증

### 상태 머신 설계 필수 규칙 (Rep Counter v5)
- **Dry-run Trace 필수**: 코드 작성 전에 프레임 단위 시뮬레이션 표 추적
- **구성요소 간 상호작용 검증**: 동시 작동 시 시퀀스 확인
- **물리적 제약 조건 체크**: 방향 전환 시 속도=0 등 반영

### 새 기능 개발 워크플로우
- **플랜 단계에서 실제 데이터 먼저 탐색** (Explore 에이전트)
- **파일 1개씩 + 배경 빌드** (6개 한꺼번에 금지)
- **"안 되는 경우"도 플랜에 포함**

### 문서/Git 규칙
- **커밋마다 CLAUDE.md "개발 진행 상황" 업데이트**
- **git push 전 CLAUDE.md, CLAUDE-CV.md 최신화**
- **session-log.md는 절대 Write 금지! 항상 Edit(append)**
- **브리핑 전 실제 코드 먼저 확인** (문서만 보고 판단 금지)

### Windows 환경
- Node.js UTF-8: `Buffer.from(JSON.stringify(body), 'utf-8')` 사용
- PreCompact Hook: `cmd /c` 래핑 금지 (stdin 차단됨)

---

## 📌 현재 미반영 결정

### 2026-02-12 — Phase 2A 데이터/모델 (어제)
- 9개 클래스 + 헬스장 관리자 1회 촬영 → Fine-tuning (B2B)
- 200장으로 MVP 시작 가능 (검증보고서 확인)
- 📌 미반영: 이후 02-13에 일부 방향 변경됨 (아래 참조)

### 2026-02-13 — CV 전략 수정
- ✅ **YOLO11 → YOLO26-N 변경** — 반영 완료 (CLAUDE-CV.md, train.py, V2log-CV-Training/CLAUDE.md, 행동가이드, data.yaml)
- ✅ **부분 촬영 원칙** — 반영 완료 (CLAUDE-CV.md, cv-status SKILL.md)
- ✅ **Two-Stage 파이프라인** — 반영 완료 (CLAUDE-CV.md, cv-status SKILL.md)
- ✅ **버튼 0개 UX** — 반영 완료 (CLAUDE-CV.md, cv-status SKILL.md)
- ✅ **IWF 컬러 인식 → 보너스** — 반영 완료 (CLAUDE-CV.md, cv-status SKILL.md)
- ✅ **Phase 1.5 불필요** — 반영 완료 (CLAUDE-CV.md, cv-status SKILL.md)
- ⚠️ **클래스 구조**: 미확정 — 더 고민하면서 방향 결정하기로 함 (3개+OCR vs 9개)
- **라벨링은 9개 클래스로 시작** — 나중에 3개로 합치기는 가능, 반대는 불가
- **기존 Roboflow 데이터셋 (21,688장)**: 무게 라벨 없음, 사전학습용으로 활용
- **사진 촬영 완료**: 20kg/15kg/10kg/5kg/2.5kg 폴더별 정리 → `data\images\train\`에 복사함
- ✅ **Roboflow 프로젝트 완료**: `laptimev2log/v2log-weight-plates`
- ✅ **라벨링 완료**: 926장 업로드, 537장 라벨링 (단일+멀티 플레이트)
- ✅ **Dataset v2 생성 완료** (2026-02-15)
- ⚠️ 클래스에 숫자 찌꺼기(0, 2, 3) 남아있음 — 코랩 자동라벨링 잔여물, 나중에 정리
- 📌 **다음 작업 (02-15 이어서)**: Versions → v2 → **"Download Dataset"** → YOLOv8 포맷 → Colab에서 YOLO26-N 학습
  - ⚠️ "Train Model" 버튼 누르지 말 것 (Roboflow 크레딧 소모됨)
  - 무료 Google Colab T4 GPU로 학습
  - 학습 노트북: `C:\Dev\V2log-CV-Training\` (train.py 등)

---

## 보고서 인덱스

| 날짜 | 파일 | 내용 |
|------|------|------|
| 02-13 | `docs/reference/02-13_CV_무게자동감지_실현가능성_종합분석_2026.md` | 3명 전문가 에이전트 조사 (경쟁사, 광학, 파이프라인, UX, B2B) |
| 02-12 | `docs/reference/CV_무게측정_횟수카운팅_최신기술_보고서_2026.md` | YOLO 모델 비교, 데이터셋, 오픈소스 |
| — | `docs/reference/CV_피벗_사업계획서_Fica_2026.md` | Fica 사업계획서 |
| 02-12 | `C:\Dev\V2log-CV-Training\Phase2A_데이터수집_검증보고서.md` | 4개 에이전트 데이터 수집 전략 검증 |
| 02-12 | `C:\Dev\V2log-CV-Training\Phase2A_행동가이드.md` | 촬영→라벨링→학습 스텝바이스텝 |

---

## Fica(피카) 사업 맥락

- **피벗**: IoT 센서 → Computer Vision (스마트폰 카메라 + AI)
- **킬러 기능**: 실시간 폼체크 (관절 각도 임계값 비교)
- **비즈니스**: SaaS 월 9,900원, B2C → B2B 확장, BEP 1,515명
- **경쟁사**: EGYM, Technogym, Tempo/Tonal(홈짐 한계), VAY Sports(폐업)
- **포지셔닝**: "저비용 + 높은 범용성 + 폼체크" = 블루오션
- **관련 파일**: `docs/reference/CV_피벗_사업계획서_Fica_2026.md`
- **팀**: 대표(이관주, 16년 피트니스), CTO(OO전자 AI), Jeremy Buendia(367만)
