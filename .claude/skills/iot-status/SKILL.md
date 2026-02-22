---
name: iot-status
description: Phase 4 IoT 워크플로우 대시보드 — 마일스톤 + 팀별 진행 + 산출물 + 미결정 사항 자동 체크
---

# /iot-status 스킬

Phase 4 Fica IoT 개발의 전체 진행 상황을 **실제 파일/코드 기반**으로 자동 체크하여 대시보드를 생성합니다.

---

## 실행 순서

### 1단계: 워크플로우 문서 파싱

`docs/Phase4_IoT_워크플로우.md` Read:
- 마일스톤 체크박스 카운트 (`- [ ]` vs `- [x]`) — M1~M7 각각 + 전체
- 팀별 진행 테이블 파싱 (⬜/🔄/✅/⏸️/❌) — 5팀 × 7단계

### 2단계: 산출물 파일 존재 확인 (병렬 Glob)

아래 파일 존재 여부 + 줄 수 확인:
- `docs/ble-gatt-spec.md`
- `docs/firmware-spec.md`
- `docs/hardware-spec.md`
- `docs/db-schema-iot.md`
- `docs/kmong/firmware-brief.md`
- `docs/kmong/hardware-brief.md`

### 3단계: 앱 코드 체크 (병렬 Grep)

- `pubspec.yaml`에서 Grep: `flutter_blue_plus`, `nfc_manager`
- `lib/features/workout/data/fica_ble_service.dart` 존재 + 줄 수
- `lib/features/workout/data/nfc_service.dart` 존재 + 줄 수
- `lib/features/workout/domain/fica_provider.dart` 존재 + 줄 수

### 4단계: DB 스키마 체크

`docs/db-schema-iot.md` 또는 `docs/db-schema.md`에서 Grep:
- `gyms` 테이블 정의
- `equipment` 테이블 정의
- `equipment_usage` 테이블 정의
- `equipment_queue` 테이블 정의

### 5단계: MEMORY.md 미결정 사항 크로스체크

MEMORY.md에서 IoT 관련 📌 항목 확인:
- 센서 모델 (ICM-45686 vs LSM6DSV) 상태
- 총 세트 수 입력 위치 상태
- 횟수 동기화 방식 상태

### 6단계: 종합 개발 가이드 존재 확인

`docs/reference/02-21_피카_피트니스카운터_종합개발가이드.md` 존재 + 줄 수

---

## 출력 형식

반드시 아래 형식으로 출력할 것. 각 항목은 실제 파일 체크 결과 기반.

```
## Phase 4: Fica IoT 워크플로우 대시보드

---

### 마일스톤 진행률

| 마일스톤 | 시기 | 완료 | 미완료 | 진행률 |
|---------|------|------|--------|--------|
| M1: DK 데모 | 2주차 | X/6 | X/6 | XX% |
| M2: 센서 데모 | 3주차 | X/4 | X/4 | XX% |
| M3: 브레드보드 통합 | 4주차 | X/6 | X/6 | XX% |
| M4: 헬스장 1차 테스트 | 4주차 | X/5 | X/5 | XX% |
| M5: PCB 프로토타입 | 8주차 | X/6 | X/6 | XX% |
| M6: 필드 테스트 | 10주차 | X/5 | X/5 | XX% |
| M7: 양산 준비 | 12주차 | X/6 | X/6 | XX% |
| **전체** | — | **X/38** | **X/38** | **XX%** |

---

### 팀별 7단계 진행 매트릭스

| 단계 | Team 1 BLE | Team 2 펌웨어 | Team 3 H/W | Team 4 앱 | Team 5 백엔드 |
|------|-----------|-------------|-----------|---------|------------|
| 1. 조사 | ⬜/🔄/✅ | ... | ... | ... | ... |
| 2. 계획 | ... | ... | ... | ... | ... |
| 3. 구현 | ... | ... | ... | ... | ... |
| 4. 검증 | ... | ... | ... | ... | ... |
| 5. 비판 | ... | ... | ... | ... | ... |
| 6. 피드백 | ... | ... | ... | ... | ... |
| 7. 수정보완 | ... | ... | ... | ... | ... |

---

### 산출물 현황

| # | 파일 | 상태 | 줄 수 |
|---|------|------|-------|
| 1 | docs/ble-gatt-spec.md | ✅/❌ | XXX |
| 2 | docs/firmware-spec.md | ✅/❌ | XXX |
| 3 | docs/hardware-spec.md | ✅/❌ | XXX |
| 4 | docs/db-schema-iot.md | ✅/❌ | XXX |
| 5 | docs/kmong/firmware-brief.md | ✅/❌ | XXX |
| 6 | docs/kmong/hardware-brief.md | ✅/❌ | XXX |

---

### 앱 코드 현황

| # | 항목 | 상태 | 상세 |
|---|------|------|------|
| 1 | flutter_blue_plus 패키지 | ✅/❌ | 버전 |
| 2 | nfc_manager 패키지 | ✅/❌ | 버전 |
| 3 | fica_ble_service.dart | ✅/❌ | XXX줄 |
| 4 | nfc_service.dart | ✅/❌ | XXX줄 |
| 5 | fica_provider.dart | ✅/❌ | XXX줄 |

---

### DB 스키마 (IoT)

| # | 테이블 | 상태 |
|---|--------|------|
| 1 | gyms | ✅/❌ |
| 2 | equipment | ✅/❌ |
| 3 | equipment_usage | ✅/❌ |
| 4 | equipment_queue | ✅/❌ |

---

### 미결정 사항 (MEMORY.md)

| # | 항목 | 상태 | 비고 |
|---|------|------|------|
| 1 | 센서 모델 | 📌/✅ | ICM-45686 vs LSM6DSV |
| 2 | 총 세트 수 입력 | 📌/✅ | 앱 vs 컨트롤러 |
| 3 | 횟수 동기화 | 📌/✅ | 실시간 vs 배치 |

---

### 참조 문서

| 파일 | 줄 수 |
|------|-------|
| 종합 개발 가이드 | XXX줄 |
| 워크플로우 문서 | XXX줄 |

---

### 다음 작업 제안
1. ...
2. ...
3. ...
```

---

## 주의사항

1. **문서만 보지 말고 실제 파일을 Glob/Grep/Read로 직접 확인**할 것
2. 마일스톤 체크박스 파싱은 정규식 `- \[x\]` vs `- \[ \]`로 정확히 카운트
3. 팀별 진행 테이블은 워크플로우 문서 §4에서 상태 기호 직접 파싱
4. 모든 체크는 **병렬 실행** (Glob/Grep 동시 호출)으로 빠르게 처리
5. 실행 시간 목표: 20초 이내
