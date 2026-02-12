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
  ];

  /// 운동 이름(영어)으로 각도 규칙 찾기
  ///
  /// 1차: 정확한 이름 매칭
  /// 2차: 이름에 포함 매칭 (Dumbbell Bicep Curl → Bicep Curl)
  /// 3차: 키워드 매칭 (Seated Cable Row → "row" 키워드 → 바벨 로우 규칙)
  static ExerciseAngleRule? findByNameEn(String nameEn) {
    final lower = nameEn.toLowerCase();

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
  static ExerciseAngleRule? _findByKeywordsEn(String lower) {
    // 키워드 → 대표 운동 이름 (영어)
    const keywordMap = {
      'curl': 'Bicep Curl',
      'row': 'Barbell Row',
      'press': 'Bench Press',
      'squat': 'Squat',
      'deadlift': 'Deadlift',
      'pulldown': 'Lat Pulldown',
      'pull down': 'Lat Pulldown',
      'extension': 'Leg Extension',
      'pushdown': 'Tricep Pushdown',
      'push down': 'Tricep Pushdown',
      'fly': 'Bench Press',
      'flye': 'Bench Press',
      'raise': 'Shoulder Press',
      'lunge': 'Squat',
      'leg press': 'Squat',
    };

    for (final entry in keywordMap.entries) {
      if (lower.contains(entry.key)) {
        return rules.firstWhere(
          (r) => r.nameEn == entry.value,
        );
      }
    }
    return null;
  }

  /// 한국어 키워드 → 대표 운동 규칙 매칭
  static ExerciseAngleRule? _findByKeywordsKo(String name) {
    const keywordMap = {
      '컬': 'Bicep Curl',
      '로우': 'Barbell Row',
      '프레스': 'Bench Press',
      '스쿼트': 'Squat',
      '데드리프트': 'Deadlift',
      '풀다운': 'Lat Pulldown',
      '익스텐션': 'Leg Extension',
      '푸시다운': 'Tricep Pushdown',
      '플라이': 'Bench Press',
      '레이즈': 'Shoulder Press',
      '런지': 'Squat',
      '레그프레스': 'Squat',
    };

    for (final entry in keywordMap.entries) {
      if (name.contains(entry.key)) {
        return rules.firstWhere(
          (r) => r.nameEn == entry.value,
        );
      }
    }
    return null;
  }
}
