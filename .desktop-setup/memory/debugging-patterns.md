# Flutter 디버깅 패턴 & 교훈

## 핵심 원칙: 구조 먼저, 수정은 나중에

> "오류를 해결할때 보이는 부분만 일시적으로 해결하지 말고 구조와 형태를 전체적으로 보고 진단 후에 오류를 해결해줘" — 사용자 피드백 (2026-02-11)

### 버그 수정 프로세스 (반드시 순서대로)

1. **재현 확인** — 정확히 어떤 조건에서 발생하는지
2. **전체 흐름 추적** — 관련 코드의 시작점 → 중간 → 끝점
3. **레이어 식별** — 문제가 어느 레이어(Layout/Paint/Logic/Navigation)에서 발생하는지
4. **근본 원인 확정** — "왜" 발생하는지 (증상이 아닌 원인)
5. **수정 적용** — 원인이 있는 레이어에서 수정
6. **검증** — 수정이 원인 레이어에서 작동하는지 확인

### 1차 시도 실패 시 대응
- ❌ 다른 표면적 수정 시도
- ✅ 즉시 중단 → 구조 분석 모드 → 전체 흐름 다시 추적

---

## 실패 사례 & 교훈

### 사례 1: ShimmerLoadingList overflow (노란색 사선)

**증상**: 화면 전환 시 하단에 노란색 사선(overflow 경고) 잠깐 표시

**실패한 접근 (1차)**:
- `ClipRect`로 감싸고 `mainAxisSize: MainAxisSize.min` 추가
- 실패 이유: `ClipRect`는 Paint 단계에서만 클리핑. Overflow 경고는 Layout 단계

**성공한 접근 (2차)**:
- `LayoutBuilder`로 가용 높이 계산 → 들어갈 수 있는 아이템 수만 생성
- Layout 단계에서 크기를 제한하므로 overflow 자체가 발생하지 않음

**교훈**:
```
Flutter 렌더링 파이프라인:
Layout (크기/위치) → Paint (그리기) → Composite (합성)

- Layout 문제 → Layout 도구로 해결 (LayoutBuilder, Expanded, ConstrainedBox)
- Paint 문제 → Paint 도구로 해결 (ClipRect, ClipRRect, CustomPaint)
- 두 레이어를 혼동하면 수정이 작동하지 않음
```

### 사례 2: _dependents.isEmpty 네비게이션 에러

**증상**: 운동 완료 → "기록 상세 보기" 클릭 시 빨간 에러 화면

**실패한 접근 (1차)**: GoRouter.of(context) 캡처 + popUntil → 여전히 에러
**실패한 접근 (2차)**: popUntil 제거, go()만 사용 → 화면 전환 안됨

**성공한 접근 (3차)**:
- 근본 원인 발견: WorkoutSummaryScreen이 `Navigator.pushReplacement(MaterialPageRoute(...))`로 푸시됨 → GoRouter 관리 밖
- GoRouter 밖 화면에서 `GoRouter.go()` 호출하면 작동하지 않음
- 해결: `/workout/summary`를 GoRouter route로 등록, `extra` 파라미터로 session 데이터 전달

**교훈**:
```
GoRouter 앱에서 네비게이션 문제 발생 시:
1. 현재 화면이 GoRouter route인지 확인
2. Navigator.push/pushReplacement로 GoRouter 밖에서 화면을 띄웠는지 확인
3. GoRouter 밖 화면 → GoRouter.go() 작동 안함
4. 모든 화면은 GoRouter route로 등록해야 함
```

### 사례 3: Dialog context race condition (이전 세션)

**증상**: 다이얼로그 닫은 후 네비게이션 간헐적 실패

**근본 원인**: `showDialog` builder의 `(context)`가 부모 context를 shadow → pop 후 stale context

**해결 패턴**:
```dart
// 다이얼로그 열기 전에 캡처
final router = GoRouter.of(context);
final notifier = ref.read(provider.notifier);

showDialog(...);

// 캡처한 참조 사용
router.go('/home');
notifier.clear();
```

---

## Flutter 레이어별 도구 매핑

| 문제 레이어 | 증상 | 해결 도구 |
|------------|------|-----------|
| Layout | RenderFlex overflow, 크기 초과 | LayoutBuilder, Expanded, Flexible, ConstrainedBox, SizedBox |
| Paint | 시각적 잘림 필요 | ClipRect, ClipRRect, ClipOval, CustomClipper |
| Navigation | 화면 전환 실패, context 에러 | GoRouter route 등록, context 캡처 |
| State | 비동기 후 disposed widget | mounted 체크, ref 사전 캡처 |
