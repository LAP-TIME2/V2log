---
name: cv-status
description: CV 전체 워크플로우 대시보드 — 모든 Phase의 모든 항목을 실제 코드에서 자동 체크
---

# /cv-status 스킬

CV 개발 전체 워크플로우의 모든 항목을 **실제 코드 기반**으로 자동 체크하여 대시보드를 생성합니다.
문서(CLAUDE-CV.md)만 보지 말고, **실제 파일/코드를 직접 확인**해서 보고할 것.

---

## 실행 순서

### 1단계: Phase 0 (기획 & 조사) 체크
아래 문서 파일 존재 여부 확인 (Glob):
- `docs/02-12_CV분석_1_아키텍처_전체구조.md`
- `docs/02-12_CV분석_2_운동화면_심층분석.md`
- `docs/02-12_CV분석_3_성능_빌드_호환성.md`
- `docs/02-12-10-46_CV_무게횟수_자동감지_진행상황.md`
- `docs/reference/CV_피벗_사업계획서_Fica_2026.md`
- `docs/reference/CV_무게측정_횟수카운팅_최신기술_보고서_2026.md`
- `CLAUDE-CV.md`

### 2단계: Phase 1 (횟수 카운팅) 체크 — 환경 설정
- `pubspec.yaml`에서 Grep: `camera`, `google_mlkit_pose_detection`, `permission_handler` → 버전 추출
- `android/app/src/main/AndroidManifest.xml`에서 Grep: `android.permission.CAMERA`
- `ios/Runner/Info.plist`에서 Grep: `NSCameraUsageDescription`

### 3단계: Phase 1 — 핵심 서비스 파일 체크
아래 파일의 존재 여부 + 줄 수 확인 (Bash: `wc -l`):
- `lib/data/services/pose_detection_service.dart`
- `lib/data/services/rep_counter_service.dart`
- `lib/core/utils/exercise_angles.dart`
- `lib/domain/providers/cv_provider.dart`

### 4단계: Phase 1 — UI 파일 체크
- `lib/presentation/widgets/molecules/camera_overlay.dart` — 존재 + 줄 수
- `lib/presentation/widgets/molecules/pose_overlay.dart` — 존재 + 줄 수

### 5단계: Phase 1 — 앱 통합 상태 체크
`lib/presentation/screens/workout/workout_screen.dart`에서 Grep:
- `_cvModeEnabled` → CV 토글 존재?
- `CameraOverlay` → 위젯 사용?
- `onRepsDetected` → 콜백 연결?

### 6단계: Phase 1 — 알고리즘 상세 체크
`lib/data/services/rep_counter_service.dart` 상단 50줄 Read:
- 버전 정보 (v5.x)
- 사용 중인 필터 (One Euro, Velocity Gate 등)

### 7단계: Phase 1 — 운동 목록 체크
`lib/core/utils/exercise_angles.dart`에서 Grep:
- `ExerciseAngleRule(` 패턴으로 정의된 운동 개수
- 각 운동의 `nameKr`, `nameEn`, `recommendedView` 추출

### 8단계: Phase 1 — 성능 최적화 체크
코드에서 직접 확인:
- `camera_overlay.dart`에서 `ResolutionPreset` → 해상도 제한?
- `camera_overlay.dart`에서 프레임 스킵 로직 (`_frameCount` 등)?
- `camera_overlay.dart`에서 `dispose()` + `didChangeAppLifecycleState`?
- `rep_counter_service.dart`에서 디바운싱 간격 (`_debounceMs` 등)?
- `workout_screen.dart`에서 `confidence >= 0.7` 신뢰도 체크?

### 9단계: Phase 1 — UX 체크
코드에서 직접 확인:
- CV 모드 토글 기본값 (`_cvModeEnabled = false`)?
- 세트 완료 시 카운터 리셋 (`didUpdateWidget`에서 `completedSets` 체크)?
- 촬영 방향 안내 UI (camera_overlay.dart에서 `isSideView` 표시)?
- 쉬는 시간 AI 자동 중지 구현 여부?
- 자동 감지 토스트 표시 구현 여부?

### 10단계: Phase 1.5 (스마트 무게 입력) 체크
- `lib/data/services/weight_suggestion_service.dart` 존재?
- `pubspec.yaml`에 `paddle_ocr` 또는 OCR 관련 패키지?
- 바벨 사진 촬영 UI 존재?

### 11단계: Phase 2A (모델 학습) 체크
- 프로젝트 내 `*.tflite` 파일 존재? (Glob: `**/*.tflite`)
- `data.yaml` (YOLO 학습 설정) 존재?
- Roboflow 프로젝트 관련 설정 파일?

### 12단계: Phase 2B (앱 통합) 체크
- `pubspec.yaml`에 `tflite_flutter` 패키지?
- `lib/data/services/weight_detection_service.dart` 존재?
- 플레이트 등록 UI 파일 존재?
- B2B Fine-tuning 관련 코드?

### 13단계: Phase 3 (미래) 체크
- LLM 기반 카운팅 관련 코드?
- SAM 2 관련 코드?
- 폼 교정 관련 코드?

### 14단계: 문서 현황
- `docs/` 폴더에서 CV 관련 파일 목록 (Glob: `docs/*CV*`, `docs/*cv*`)
- `docs/CV_수정노트.md` 최신 항목 (마지막 50줄 Read)

---

## 출력 형식

반드시 아래 형식으로 출력할 것. 각 항목은 실제 코드 체크 결과 기반.

```
## CV 개발 전체 워크플로우 대시보드

---

### Phase 0: 기획 & 조사 ✅/⏳
| # | 항목 | 상태 | 근거 |
|---|------|------|------|
| 1 | CV 기술 조사 보고서 | ✅/❌ | 파일 존재 여부 |
| 2 | 앱 아키텍처 호환성 분석 | ✅/❌ | |
| 3 | 운동 화면 심층 분석 | ✅/❌ | |
| 4 | 성능/빌드 호환성 분석 | ✅/❌ | |
| 5 | 사업계획서 CV 피벗 | ✅/❌ | |
| 6 | CLAUDE-CV.md 가이드 | ✅/❌ | |
| 7 | 기술 논의 정리 | ✅/❌ | |

---

### Phase 1: 횟수 자동 카운팅 ✅/🔧/⏳

**[환경 설정]**
| # | 항목 | 상태 | 상세 |
|---|------|------|------|
| 1 | camera 패키지 | ✅/❌ | ^X.X.X |
| 2 | mlkit_pose_detection 패키지 | ✅/❌ | ^X.X.X |
| 3 | permission_handler 패키지 | ✅/❌ | ^X.X.X |
| 4 | Android CAMERA 권한 | ✅/❌ | AndroidManifest.xml |
| 5 | iOS NSCameraUsageDescription | ✅/❌ | Info.plist |

**[핵심 서비스]**
| # | 파일 | 상태 | 줄 수 | 역할 |
|---|------|------|-------|------|
| 6 | pose_detection_service.dart | ✅/❌ | XXX | MediaPipe 래퍼 |
| 7 | rep_counter_service.dart | ✅/❌ | XXX | 카운팅 엔진 vX.X |
| 8 | exercise_angles.dart | ✅/❌ | XXX | 운동 N개 각도 규칙 |
| 9 | cv_provider.dart | ✅/❌ | XXX | 상태 관리 |

**[UI]**
| # | 파일 | 상태 | 줄 수 | 역할 |
|---|------|------|-------|------|
| 10 | camera_overlay.dart | ✅/❌ | XXX | 카메라+횟수+방향 |
| 11 | pose_overlay.dart | ✅/❌ | XXX | 33개 관절 오버레이 |
| 12 | workout_screen.dart 통합 | ✅/❌ | — | 토글+콜백 |

**[알고리즘]** (vX.X)
| # | 항목 | 상태 | 상세 |
|---|------|------|------|
| 13 | One Euro Filter | ✅/❌ | 적응형 노이즈 제거 |
| 14 | Velocity Gate | ✅/❌ | 속도 기반 운동 판별 |
| 15 | Amplitude Check | ✅/❌ | 진폭 검증 |
| 16 | 방향 전환 보존 (v5.1) | ✅/❌ | peak/valley 유지 |
| 17 | 운동 시작 확인 (v5.2) | ✅/❌ | 2회 연속 감지 |

**[성능 최적화]**
| # | 항목 | 상태 | 상세 |
|---|------|------|------|
| 18 | 해상도 640×480 제한 | ✅/❌ | ResolutionPreset |
| 19 | 프레임 스킵 | ✅/❌ | N번째만 처리 |
| 20 | CameraOverlay 별도 위젯 | ✅/❌ | 리빌드 격리 |
| 21 | dispose() + Lifecycle | ✅/❌ | 메모리 누수 방지 |
| 22 | 디바운싱 | ✅/❌ | XXXms |
| 23 | GPU 위임(delegate) | ✅/❌ | |

**[UX]**
| # | 항목 | 상태 | 상세 |
|---|------|------|------|
| 24 | CV 토글 (기본 OFF) | ✅/❌ | |
| 25 | 세트 완료 시 리셋 | ✅/❌ | |
| 26 | 신뢰도 < 0.7 필터 | ✅/❌ | |
| 27 | 촬영 방향 안내 | ✅/❌ | 정면/측면 표시 |
| 28 | 쉬는 시간 AI 중지 | ✅/❌ | |
| 29 | 자동 감지 토스트 | ✅/❌ | |

**[지원 운동]** (N개)
| # | 운동명 | 영문 | 추천 방향 |
|---|--------|------|----------|
| 1 | ... | ... | 정면/측면 |

---

### Phase 1.5: 스마트 무게 입력 ✅/🔧/⏳
| # | 항목 | 상태 | 상세 |
|---|------|------|------|
| 1 | 바벨 사진 촬영 UI | ✅/❌ | |
| 2 | 원탭 확인 UX | ✅/❌ | |
| 3 | IWF 컬러 인식 (HSV) | ✅/❌ | |
| 4 | OCR (PaddleOCR) | ✅/❌ | |
| 5 | YOLO 플레이트 개수 감지 | ✅/❌ | |
| 6 | _currentWeight 자동 입력 | ✅/❌ | |
| 7 | 정확도 검증 (70~85%) | ✅/❌ | |

---

### Phase 2A: 모델 학습 (Python/Colab) ✅/🔧/⏳
| # | 항목 | 상태 | 상세 |
|---|------|------|------|
| 1 | 사진 수집 (3,000~5,000장) | ✅/❌ | |
| 2 | 클래스 분류 (9종) | ✅/❌ | |
| 3 | Roboflow 프로젝트 | ✅/❌ | |
| 4 | 수동 라벨링 (500장) | ✅/❌ | |
| 5 | 자동 라벨링 + 수정 | ✅/❌ | |
| 6 | 데이터 증강 (×5~10배) | ✅/❌ | |
| 7 | Colab 환경 셋업 | ✅/❌ | |
| 8 | YOLO11 nano 학습 | ✅/❌ | |
| 9 | .pt → .tflite 변환 | ✅/❌ | |

---

### Phase 2B: 앱 통합 ✅/🔧/⏳
| # | 항목 | 상태 | 상세 |
|---|------|------|------|
| 1 | tflite_flutter 패키지 | ✅/❌ | |
| 2 | image 패키지 | ✅/❌ | |
| 3 | weight_detection_service.dart | ✅/❌ | |
| 4 | model.tflite 앱 내장 | ✅/❌ | |
| 5 | 무게 계산 로직 | ✅/❌ | |
| 6 | 플레이트 등록 UI (B2B) | ✅/❌ | |
| 7 | 무게 감지 결과 UI | ✅/❌ | |
| 8 | 실시간 YOLO 오버레이 | ✅/❌ | |
| 9 | workout_screen 무게 콜백 | ✅/❌ | |
| 10 | B2B Fine-tuning 파이프라인 | ✅/❌ | |

---

### Phase 3: 미래 기술 ✅/🔧/⏳
| # | 항목 | 상태 | 상세 |
|---|------|------|------|
| 1 | LLM 범용 카운팅 | ✅/❌ | |
| 2 | SAM 2 바벨 추적 | ✅/❌ | |
| 3 | 1,900+ 운동 지원 | ✅/❌ | |
| 4 | 실시간 폼 교정 | ✅/❌ | |
| 5 | 속도 기반 훈련 (VBT) | ✅/❌ | |

---

### 요약 대시보드

| Phase | 상태 | 완료 | 미완료 | 진행률 |
|-------|------|------|--------|--------|
| Phase 0 (기획) | ✅/🔧/⏳ | X | X | XX% |
| Phase 1 (횟수) | ✅/🔧/⏳ | X | X | XX% |
| Phase 1.5 (스마트 무게) | ✅/🔧/⏳ | X | X | XX% |
| Phase 2A (모델 학습) | ✅/🔧/⏳ | X | X | XX% |
| Phase 2B (앱 통합) | ✅/🔧/⏳ | X | X | XX% |
| Phase 3 (미래) | ✅/🔧/⏳ | X | X | XX% |
| **전체** | | **X** | **X** | **XX%** |

### 관련 문서 (N개)
| 파일 | 설명 |
|------|------|
| `경로` | 설명 |

### 다음 작업 제안
1. ...
2. ...
3. ...
```

---

## 주의사항

1. **문서만 보지 말고 실제 코드를 Grep/Read로 직접 확인**할 것
2. Phase 2A (모델 학습)은 앱 바깥 작업이므로 파일 존재 여부로만 판단
3. 새로운 CV 파일이 추가되었으면 해당 Phase 체크리스트에 자동 반영
4. 모든 체크는 **병렬 실행** (Glob/Grep 동시 호출)으로 빠르게 처리
5. 실행 시간 목표: 30초 이내
