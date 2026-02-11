import 'package:flutter/material.dart';
import 'package:muscle_selector/muscle_selector.dart';

import '../../../data/models/exercise_model.dart';

/// 미니 인체 근육 맵 — muscle_selector SVG 패키지 기반
/// SVG 자연 종횡비(1.22:1)에 맞춰 렌더링하여 공간을 최대 활용
class MiniMuscleMap extends StatelessWidget {
  final MuscleGroup primaryMuscle;
  final List<MuscleGroup> secondaryMuscles;
  final double width;

  /// SVG 자연 종횡비 (human_body.svg: 271x223 → 1.215:1)
  static const double _svgAspectRatio = 1.215;

  const MiniMuscleMap({
    super.key,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    this.width = 60,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final height = width / _svgAspectRatio;

    // 하이라이트할 그룹 수집
    final groups = <String>{};
    groups.addAll(_groupsFor(primaryMuscle));
    for (final m in secondaryMuscles) {
      groups.addAll(_groupsFor(m));
    }

    // ValueKey로 근육 그룹이 바뀔 때마다 위젯을 새로 생성
    // (패키지가 initialSelectedGroups를 initState에서만 읽기 때문)
    final groupKey = '${primaryMuscle.name}_${groups.join(',')}';

    return SizedBox(
      width: width,
      height: height,
      child: IgnorePointer(
        child: MusclePickerMap(
          key: ValueKey(groupKey),
          map: Maps.BODY,
          width: width,
          height: height,
          initialSelectedGroups: groups.toList(),
          selectedColor: primaryMuscle.color.withValues(alpha: 0.85),
          strokeColor: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.10),
          onChanged: (_) {},
        ),
      ),
    );
  }

  /// MuscleGroup → muscle_selector 패키지 그룹명 변환
  static List<String> _groupsFor(MuscleGroup m) => switch (m) {
    MuscleGroup.chest => ['chest'],
    MuscleGroup.shoulders || MuscleGroup.rearDelts => ['shoulders'],
    MuscleGroup.biceps => ['biceps'],
    MuscleGroup.triceps => ['triceps'],
    MuscleGroup.forearms => ['forearm'],
    MuscleGroup.abs || MuscleGroup.core => ['abs'],
    MuscleGroup.obliques => ['obliques'],
    MuscleGroup.back || MuscleGroup.lats => ['lats', 'upper_back'],
    MuscleGroup.lowerBack => ['lower_back'],
    MuscleGroup.traps => ['trapezius'],
    MuscleGroup.quadriceps || MuscleGroup.quads || MuscleGroup.legs || MuscleGroup.hipFlexors => ['quads'],
    MuscleGroup.hamstrings => ['harmstrings'], // 패키지 내부 오타 (harmstrings)
    MuscleGroup.glutes => ['glutes'],
    MuscleGroup.calves => ['calves'],
    MuscleGroup.fullBody => [
      'chest', 'shoulders', 'biceps', 'triceps', 'forearm',
      'abs', 'obliques', 'lats', 'upper_back', 'lower_back',
      'trapezius', 'quads', 'harmstrings', 'glutes', 'calves',
    ],
    _ => [],
  };
}
