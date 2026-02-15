/// 운동별 관절 각도 규칙 데이터
///
/// 횟수 카운팅에 사용: 관절 각도가 Peak ↔ Valley를 반복하면 1회
/// MediaPipe BlazePose 33개 관절 인덱스 기준

/// MediaPipe 포즈 랜드마크 인덱스
class PoseLandmarkIndex {
  static const int leftShoulder = 11;
  static const int rightShoulder = 12;
  static const int leftElbow = 13;
  static const int rightElbow = 14;
  static const int leftWrist = 15;
  static const int rightWrist = 16;
  static const int leftHip = 23;
  static const int rightHip = 24;
  static const int leftKnee = 25;
  static const int rightKnee = 26;
  static const int leftAnkle = 27;
  static const int rightAnkle = 28;
}

/// 각도 계산에 사용할 3개 관절 (중간이 꼭짓점)
class AngleJoints {
  final int first;
  final int middle; // 각도를 측정하는 꼭짓점
  final int last;

  const AngleJoints({
    required this.first,
    required this.middle,
    required this.last,
  });
}

/// 추천 촬영 방향
enum RecommendedView {
  /// 정면 촬영 (양쪽 팔/다리가 다 보이는 운동)
  front,

  /// 측면 촬영 (관절 접힘이 잘 보이는 운동)
  side,
}

/// 운동별 횟수 카운팅 규칙
class ExerciseAngleRule {
  /// 운동 이름 (한국어)
  final String name;

  /// 운동 이름 (영어, DB 매칭용)
  final String nameEn;

  /// 추적할 관절 조합 (왼쪽)
  final AngleJoints leftJoints;

  /// 추적할 관절 조합 (오른쪽)
  final AngleJoints rightJoints;

  /// Peak 각도 (펴진 상태) — 도(°) 단위
  final double peakAngle;

  /// Valley 각도 (접힌 상태) — 도(°) 단위
  final double valleyAngle;

  /// Peak/Valley 판정 허용 범위 (±)
  final double tolerance;

  /// 추천 촬영 방향 (정면/측면)
  final RecommendedView recommendedView;

  /// 꼭짓점 관절(middle)이 기준 관절(first) 위에 있어야 유효한지
  ///
  /// true = 오버헤드 운동 (숄더프레스 등):
  ///   팔꿈치가 어깨 아래로 내려가면 → 운동 자세가 아님 → 카운팅 무시
  ///   운동 끝나고 팔 내리는 동작, 이동 중 동작 등을 필터링
  final bool vertexMustBeAboveFirst;

  const ExerciseAngleRule({
    required this.name,
    required this.nameEn,
    required this.leftJoints,
    required this.rightJoints,
    required this.peakAngle,
    required this.valleyAngle,
    this.tolerance = 20.0,
    this.recommendedView = RecommendedView.side,
    this.vertexMustBeAboveFirst = false,
  });
}

/// 지원하는 운동별 각도 규칙 목록
///
/// Peak = 관절이 펴진 상태 (시작/끝 자세)
/// Valley = 관절이 접힌 상태 (수축 자세)
class ExerciseAngles {
  static const List<ExerciseAngleRule> rules = [
    // 팔 운동
    ExerciseAngleRule(
      name: '바이셉 컬',
      nameEn: 'Bicep Curl',
      leftJoints: AngleJoints(
        first: PoseLandmarkIndex.leftShoulder,
        middle: PoseLandmarkIndex.leftElbow,
        last: PoseLandmarkIndex.leftWrist,
      ),
      rightJoints: AngleJoints(
        first: PoseLandmarkIndex.rightShoulder,
        middle: PoseLandmarkIndex.rightElbow,
        last: PoseLandmarkIndex.rightWrist,
      ),
      peakAngle: 160.0,
      valleyAngle: 40.0,
      recommendedView: RecommendedView.side, // 측면에서 팔꿈치 접힘이 잘 보임
    ),
    ExerciseAngleRule(
      name: '트라이셉 푸시다운',
      nameEn: 'Tricep Pushdown',
      leftJoints: AngleJoints(
        first: PoseLandmarkIndex.leftShoulder,
        middle: PoseLandmarkIndex.leftElbow,
        last: PoseLandmarkIndex.leftWrist,
      ),
      rightJoints: AngleJoints(
        first: PoseLandmarkIndex.rightShoulder,
        middle: PoseLandmarkIndex.rightElbow,
        last: PoseLandmarkIndex.rightWrist,
      ),
      peakAngle: 160.0,
      valleyAngle: 50.0,
      recommendedView: RecommendedView.side,
    ),

    // 가슴/어깨 운동
    ExerciseAngleRule(
      name: '벤치 프레스',
      nameEn: 'Bench Press',
      leftJoints: AngleJoints(
        first: PoseLandmarkIndex.leftShoulder,
        middle: PoseLandmarkIndex.leftElbow,
        last: PoseLandmarkIndex.leftWrist,
      ),
      rightJoints: AngleJoints(
        first: PoseLandmarkIndex.rightShoulder,
        middle: PoseLandmarkIndex.rightElbow,
        last: PoseLandmarkIndex.rightWrist,
      ),
      peakAngle: 160.0,
      valleyAngle: 80.0,
      recommendedView: RecommendedView.side,
    ),
    ExerciseAngleRule(
      name: '숄더 프레스',
      nameEn: 'Shoulder Press',
      leftJoints: AngleJoints(
        first: PoseLandmarkIndex.leftShoulder,
        middle: PoseLandmarkIndex.leftElbow,
        last: PoseLandmarkIndex.leftWrist,
      ),
      rightJoints: AngleJoints(
        first: PoseLandmarkIndex.rightShoulder,
        middle: PoseLandmarkIndex.rightElbow,
        last: PoseLandmarkIndex.rightWrist,
      ),
      peakAngle: 170.0,
      valleyAngle: 80.0,
      recommendedView: RecommendedView.front, // 정면에서 양쪽 팔 다 보임
      vertexMustBeAboveFirst: true, // 팔꿈치가 어깨 아래로 내려가면 운동 자세 아님
    ),

    // 하체 운동
    ExerciseAngleRule(
      name: '스쿼트',
      nameEn: 'Squat',
      leftJoints: AngleJoints(
        first: PoseLandmarkIndex.leftHip,
        middle: PoseLandmarkIndex.leftKnee,
        last: PoseLandmarkIndex.leftAnkle,
      ),
      rightJoints: AngleJoints(
        first: PoseLandmarkIndex.rightHip,
        middle: PoseLandmarkIndex.rightKnee,
        last: PoseLandmarkIndex.rightAnkle,
      ),
      peakAngle: 170.0,
      valleyAngle: 90.0,
      recommendedView: RecommendedView.side, // 측면에서 무릎 각도가 잘 보임
    ),
    ExerciseAngleRule(
      name: '레그 익스텐션',
      nameEn: 'Leg Extension',
      leftJoints: AngleJoints(
        first: PoseLandmarkIndex.leftHip,
        middle: PoseLandmarkIndex.leftKnee,
        last: PoseLandmarkIndex.leftAnkle,
      ),
      rightJoints: AngleJoints(
        first: PoseLandmarkIndex.rightHip,
        middle: PoseLandmarkIndex.rightKnee,
        last: PoseLandmarkIndex.rightAnkle,
      ),
      peakAngle: 170.0,
      valleyAngle: 80.0,
      recommendedView: RecommendedView.side,
    ),
    ExerciseAngleRule(
      name: '레그 컬',
      nameEn: 'Leg Curl',
      leftJoints: AngleJoints(
        first: PoseLandmarkIndex.leftHip,
        middle: PoseLandmarkIndex.leftKnee,
        last: PoseLandmarkIndex.leftAnkle,
      ),
      rightJoints: AngleJoints(
        first: PoseLandmarkIndex.rightHip,
        middle: PoseLandmarkIndex.rightKnee,
        last: PoseLandmarkIndex.rightAnkle,
      ),
      peakAngle: 170.0,
      valleyAngle: 40.0,
      recommendedView: RecommendedView.side,
    ),

    // 등 운동
    ExerciseAngleRule(
      name: '바벨 로우',
      nameEn: 'Barbell Row',
      leftJoints: AngleJoints(
        first: PoseLandmarkIndex.leftShoulder,
        middle: PoseLandmarkIndex.leftElbow,
        last: PoseLandmarkIndex.leftWrist,
      ),
      rightJoints: AngleJoints(
        first: PoseLandmarkIndex.rightShoulder,
        middle: PoseLandmarkIndex.rightElbow,
        last: PoseLandmarkIndex.rightWrist,
      ),
      peakAngle: 160.0,
      valleyAngle: 70.0,
      recommendedView: RecommendedView.side, // 측면에서 당기는 동작이 잘 보임
    ),
    ExerciseAngleRule(
      name: '랫 풀다운',
      nameEn: 'Lat Pulldown',
      leftJoints: AngleJoints(
        first: PoseLandmarkIndex.leftShoulder,
        middle: PoseLandmarkIndex.leftElbow,
        last: PoseLandmarkIndex.leftWrist,
      ),
      rightJoints: AngleJoints(
        first: PoseLandmarkIndex.rightShoulder,
        middle: PoseLandmarkIndex.rightElbow,
        last: PoseLandmarkIndex.rightWrist,
      ),
      peakAngle: 170.0,
      valleyAngle: 60.0,
      recommendedView: RecommendedView.front, // 정면에서 양쪽 팔 다 보임
    ),

    // 전신 운동
    ExerciseAngleRule(
      name: '데드리프트',
      nameEn: 'Deadlift',
      leftJoints: AngleJoints(
        first: PoseLandmarkIndex.leftShoulder,
        middle: PoseLandmarkIndex.leftHip,
        last: PoseLandmarkIndex.leftKnee,
      ),
      rightJoints: AngleJoints(
        first: PoseLandmarkIndex.rightShoulder,
        middle: PoseLandmarkIndex.rightHip,
        last: PoseLandmarkIndex.rightKnee,
      ),
      peakAngle: 170.0,
      valleyAngle: 90.0,
      recommendedView: RecommendedView.side, // 측면에서 엉덩이 힌지가 잘 보임
    ),

    // ========== 어깨 피벗 운동 (신규 4개) ==========
    // 기존 10개 규칙은 팔꿈치/무릎/엉덩이 피벗만 지원
    // 레이즈/플라이 계열은 어깨가 피벗 → H→S←E 축 사용

    // 어깨 외전 (abduction) — 팔을 옆으로 올리는 운동
    ExerciseAngleRule(
      name: '레터럴 레이즈',
      nameEn: 'Lateral Raise',
      leftJoints: AngleJoints(
        first: PoseLandmarkIndex.leftHip,
        middle: PoseLandmarkIndex.leftShoulder,
        last: PoseLandmarkIndex.leftElbow,
      ),
      rightJoints: AngleJoints(
        first: PoseLandmarkIndex.rightHip,
        middle: PoseLandmarkIndex.rightShoulder,
        last: PoseLandmarkIndex.rightElbow,
      ),
      peakAngle: 95.0, // 어깨 높이까지 올린 상태
      valleyAngle: 15.0, // 팔이 몸통 옆에 붙은 상태
      recommendedView: RecommendedView.front, // 정면에서 양팔 외전이 잘 보임
    ),

    // 어깨 굴곡 (flexion) — 팔을 앞으로 올리는 운동
    ExerciseAngleRule(
      name: '프론트 레이즈',
      nameEn: 'Front Raise',
      leftJoints: AngleJoints(
        first: PoseLandmarkIndex.leftHip,
        middle: PoseLandmarkIndex.leftShoulder,
        last: PoseLandmarkIndex.leftElbow,
      ),
      rightJoints: AngleJoints(
        first: PoseLandmarkIndex.rightHip,
        middle: PoseLandmarkIndex.rightShoulder,
        last: PoseLandmarkIndex.rightElbow,
      ),
      peakAngle: 95.0,
      valleyAngle: 15.0,
      recommendedView: RecommendedView.side, // 측면에서 시상면 굴곡이 잘 보임
    ),

    // 어깨 수평 내전 (horizontal adduction) — 팔을 벌렸다 모으는 운동
    ExerciseAngleRule(
      name: '플라이',
      nameEn: 'Fly',
      leftJoints: AngleJoints(
        first: PoseLandmarkIndex.leftHip,
        middle: PoseLandmarkIndex.leftShoulder,
        last: PoseLandmarkIndex.leftElbow,
      ),
      rightJoints: AngleJoints(
        first: PoseLandmarkIndex.rightHip,
        middle: PoseLandmarkIndex.rightShoulder,
        last: PoseLandmarkIndex.rightElbow,
      ),
      peakAngle: 150.0, // 팔 벌린 상태
      valleyAngle: 40.0, // 팔 모은 상태
      tolerance: 25.0, // 2D 투영 한계로 기본값(20)보다 넓게
      recommendedView: RecommendedView.front,
    ),

    // 어깨 신전 (extension) — 팔을 위에서 아래로 당기는 운동
    ExerciseAngleRule(
      name: '스트레이트 암 풀',
      nameEn: 'Straight Arm Pull',
      leftJoints: AngleJoints(
        first: PoseLandmarkIndex.leftHip,
        middle: PoseLandmarkIndex.leftShoulder,
        last: PoseLandmarkIndex.leftElbow,
      ),
      rightJoints: AngleJoints(
        first: PoseLandmarkIndex.rightHip,
        middle: PoseLandmarkIndex.rightShoulder,
        last: PoseLandmarkIndex.rightElbow,
      ),
      peakAngle: 160.0, // 팔이 위로 올라간 상태
      valleyAngle: 30.0, // 팔이 아래로 내려온 상태
      recommendedView: RecommendedView.side,
    ),
  ];

  /// 운동 이름(영어)으로 각도 규칙 찾기
  ///
  /// 1차: 정확한 이름 매칭
  /// 2차: 이름에 포함 매칭 (Dumbbell Bicep Curl → Bicep Curl)
  /// 3차: 키워드 매칭 (Seated Cable Row → "row" 키워드 → 바벨 로우 규칙)
  static ExerciseAngleRule? findByNameEn(String nameEn) {
    // 하이픈을 공백으로 정규화 (Push-up → push up, Pull-up → pull up)
    final lower = nameEn.toLowerCase().replaceAll('-', ' ');

    // 1차: 정확한 매칭
    for (final rule in rules) {
      if (rule.nameEn.toLowerCase() == lower) return rule;
    }

    // 2차: 부분 매칭
    for (final rule in rules) {
      if (lower.contains(rule.nameEn.toLowerCase())) return rule;
    }

    // 3차: 키워드 매칭
    return _findByKeywordsEn(lower);
  }

  /// 운동 이름(한국어)으로 각도 규칙 찾기
  static ExerciseAngleRule? findByName(String name) {
    // 1차: 정확한 매칭
    for (final rule in rules) {
      if (rule.name == name) return rule;
    }

    // 2차: 부분 매칭
    for (final rule in rules) {
      if (name.contains(rule.name)) return rule;
    }

    // 3차: 키워드 매칭
    return _findByKeywordsKo(name);
  }

  /// 영어 키워드 → 대표 운동 규칙 매칭
  ///
  /// 2단계 검색: 긴 키워드 먼저 → 짧은 키워드 폴백
  /// 긴 키워드 우선으로 모호한 매칭 방지
  /// (예: 'lateral raise' → Lateral Raise, 'raise' 단독은 모호하므로 제거)
  static ExerciseAngleRule? _findByKeywordsEn(String lower) {
    // 1단계: 긴 키워드 (2단어 이상) — 우선 매칭
    const longKeywordMap = {
      'lateral raise': 'Lateral Raise',
      'front raise': 'Front Raise',
      'upright row': 'Lateral Raise', // 주 운동은 어깨 외전
      'overhead triceps': 'Tricep Pushdown',
      'overhead press': 'Shoulder Press',
      'shoulder press': 'Shoulder Press',
      'leg extension': 'Leg Extension',
      'leg curl': 'Leg Curl',
      'leg press': 'Squat',
      'hip thrust': 'Deadlift', // 엉덩이 힌지 패턴
      'split squat': 'Squat',
      'front squat': 'Squat',
      'hack squat': 'Squat',
      'goblet squat': 'Squat',
      'stiff leg': 'Deadlift',
      'skull crusher': 'Tricep Pushdown',
      'pull down': 'Lat Pulldown',
      'push down': 'Tricep Pushdown',
      'push up': 'Bench Press',
      'pull up': 'Lat Pulldown',
      'chin up': 'Lat Pulldown',
      'pec deck': 'Fly', // 어깨 수평 내전
      'cable crossover': 'Fly',
      'straight arm': 'Straight Arm Pull',
      'ab slide': 'Deadlift', // S→H←K 패턴
      'ab roller': 'Deadlift',
      'cable crunch': 'Deadlift',
    };

    for (final entry in longKeywordMap.entries) {
      if (lower.contains(entry.key)) {
        return rules.firstWhere((r) => r.nameEn == entry.value);
      }
    }

    // 2단계: 짧은 키워드 (1단어) — 폴백
    const shortKeywordMap = {
      'curl': 'Bicep Curl',
      'row': 'Barbell Row',
      'squat': 'Squat',
      'deadlift': 'Deadlift',
      'romanian': 'Deadlift',
      'rdl': 'Deadlift',
      'pulldown': 'Lat Pulldown',
      'pushdown': 'Tricep Pushdown',
      'pushup': 'Bench Press',
      'pullup': 'Lat Pulldown',
      'chinup': 'Lat Pulldown',
      'dip': 'Tricep Pushdown',
      'dips': 'Tricep Pushdown',
      'lunge': 'Squat',
      'press': 'Bench Press', // 최후 폴백
      'crunch': 'Deadlift', // S→H←K 패턴
      'kickback': 'Tricep Pushdown',
      'preacher': 'Bicep Curl',
      'concentration': 'Bicep Curl',
      'arnold': 'Shoulder Press',
      'fly': 'Fly', // 어깨 피벗 (기존 Bench Press → Fly로 수정!)
      'flye': 'Fly',
      'pullover': 'Straight Arm Pull',
      'hyperextension': 'Deadlift',
    };

    for (final entry in shortKeywordMap.entries) {
      if (lower.contains(entry.key)) {
        return rules.firstWhere((r) => r.nameEn == entry.value);
      }
    }

    return null;
  }

  /// 한국어 키워드 → 대표 운동 규칙 매칭
  ///
  /// 영어와 동일한 2단계 구조 (긴 키워드 우선)
  static ExerciseAngleRule? _findByKeywordsKo(String name) {
    // 1단계: 긴 키워드 (2단어 이상) — 우선 매칭
    const longKeywordMap = {
      '레터럴 레이즈': 'Lateral Raise',
      '사이드 레이즈': 'Lateral Raise',
      '프론트 레이즈': 'Front Raise',
      '업라이트 로우': 'Lateral Raise', // 주 운동은 어깨 외전
      '오버헤드 프레스': 'Shoulder Press',
      '숄더 프레스': 'Shoulder Press',
      '레그 익스텐션': 'Leg Extension',
      '레그 컬': 'Leg Curl',
      '레그 프레스': 'Squat',
      '레그프레스': 'Squat',
      '힙 스러스트': 'Deadlift',
      '스컬 크러셔': 'Tricep Pushdown',
      '케이블 크런치': 'Deadlift',
      '스트레이트 암': 'Straight Arm Pull',
      '펙 덱': 'Fly',
      '펙덱': 'Fly',
    };

    for (final entry in longKeywordMap.entries) {
      if (name.contains(entry.key)) {
        return rules.firstWhere((r) => r.nameEn == entry.value);
      }
    }

    // 2단계: 짧은 키워드 — 폴백
    const shortKeywordMap = {
      '컬': 'Bicep Curl',
      '로우': 'Barbell Row',
      '스쿼트': 'Squat',
      '데드리프트': 'Deadlift',
      '풀다운': 'Lat Pulldown',
      '푸시다운': 'Tricep Pushdown',
      '딥스': 'Tricep Pushdown',
      '런지': 'Squat',
      '프레스': 'Bench Press', // 최후 폴백
      '크런치': 'Deadlift',
      '킥백': 'Tricep Pushdown',
      '프리쳐': 'Bicep Curl',
      '플라이': 'Fly', // 어깨 피벗 (기존 Bench Press → Fly로 수정!)
      '풀오버': 'Straight Arm Pull',
    };

    for (final entry in shortKeywordMap.entries) {
      if (name.contains(entry.key)) {
        return rules.firstWhere((r) => r.nameEn == entry.value);
      }
    }

    return null;
  }
}
