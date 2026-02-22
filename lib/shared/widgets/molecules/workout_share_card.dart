import 'package:flutter/material.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/utils/formatters.dart';
import 'package:v2log/shared/models/workout_session_model.dart';
import 'package:v2log/shared/models/workout_set_model.dart';

/// 운동 기록 공유용 카드 위젯
/// 이미지로 캡처하여 공유하기 위한 용도
/// 항상 다크 배경이므로 context 색상 대신 고정 색상 사용
class WorkoutShareCard extends StatelessWidget {
  final WorkoutSessionModel session;
  final Map<String, String> exerciseNames;

  // 공유 카드 전용 고정 색상 (항상 다크 배경)
  static const _cardTextSecondary = Color(0xFFA1A1AA);
  static const _cardBgElevated = Color(0xFF242424);

  const WorkoutShareCard({
    required this.session,
    required this.exerciseNames,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final duration = session.duration ?? Duration.zero;
    final totalVolume = session.calculatedVolume;
    final totalSets = session.sets.length;
    final prSets = session.sets.where((s) => s.isPr).toList();

    return Container(
      width: 400,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary500.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          _buildHeader(),
          const SizedBox(height: AppSpacing.lg),

          // 완료 메시지
          _buildCompletionMessage(prSets.length),
          const SizedBox(height: AppSpacing.xl),

          // 주요 통계
          _buildMainStats(duration, totalVolume, totalSets),
          const SizedBox(height: AppSpacing.lg),

          // PR 섹션 (있는 경우)
          if (prSets.isNotEmpty) ...[
            _buildPrSection(prSets),
            const SizedBox(height: AppSpacing.lg),
          ],

          // 운동별 요약
          _buildExerciseSummary(),
          const SizedBox(height: AppSpacing.xl),

          // 푸터 (워터마크)
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // 로고 아이콘
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.fitness_center,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        // 제목
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'V2log',
              style: AppTypography.h3.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '오늘의 운동 기록',
              style: AppTypography.bodySmall.copyWith(
                color: _cardTextSecondary,
              ),
            ),
          ],
        ),
        const Spacer(),
        // 날짜 + 요일
        Text(
          '${Formatters.monthDay(session.startedAt)} ${Formatters.weekday(session.startedAt)}',
          style: AppTypography.labelMedium.copyWith(
            color: _cardTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionMessage(int prCount) {
    String message;
    Color accentColor;

    if (prCount > 0) {
      message = '개인 기록 $prCount개 달성!';
      accentColor = AppColors.warning;
    } else if (totalSets >= 20) {
      message = '정말 열심히 했어요!';
      accentColor = AppColors.success;
    } else if (totalSets >= 10) {
      message = '좋은 운동이었어요!';
      accentColor = AppColors.primary500;
    } else {
      message = '운동 완료!';
      accentColor = AppColors.success;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        message,
        style: AppTypography.h4.copyWith(
          color: accentColor,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMainStats(Duration duration, double volume, int sets) {
    return Row(
      children: [
        Expanded(
          child: _ShareStatBox(
            icon: Icons.timer_outlined,
            label: '운동 시간',
            value: Formatters.duration(duration),
            color: AppColors.primary500,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _ShareStatBox(
            icon: Icons.fitness_center,
            label: '총 볼륨',
            value: Formatters.volume(volume),
            color: AppColors.secondary500,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _ShareStatBox(
            icon: Icons.repeat,
            label: '총 세트',
            value: '$sets세트',
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildPrSection(List<WorkoutSetModel> prSets) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '개인 기록',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...prSets.map((set) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '${_getExerciseName(set.exerciseId)}: ${set.weight}kg x ${set.reps}회',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildExerciseSummary() {
    final exerciseGroups = session.setsByExercise;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '운동별 요약',
          style: AppTypography.labelLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...exerciseGroups.entries.map((entry) {
          final exerciseId = entry.key;
          final sets = entry.value;
          final maxWeight = sets
              .map((s) => s.weight ?? 0)
              .fold<double>(0, (a, b) => a > b ? a : b);
          final exerciseName = _getExerciseName(exerciseId);

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    exerciseName,
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${sets.length}세트',
                    style: AppTypography.bodySmall.copyWith(
                      color: _cardTextSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '최고 ${maxWeight}kg',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primary500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: _cardBgElevated,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'V2log',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.primary500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '- 전문가 루틴으로 시작하고, 기록은 10초 만에',
            style: AppTypography.bodySmall.copyWith(
              color: _cardTextSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  String _getExerciseName(String exerciseId) {
    if (exerciseNames.containsKey(exerciseId)) {
      return exerciseNames[exerciseId]!;
    }

    // UUID의 앞 8자리만 반환
    if (exerciseId.length > 8 && exerciseId.contains('-')) {
      return '운동 ${exerciseId.substring(0, 8)}';
    }

    return exerciseId;
  }

  int get totalSets => session.sets.length;
}

/// 공유용 통계 박스
class _ShareStatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ShareStatBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: AppSpacing.xs),
          // 텍스트가 길어지면 자동으로 축소
          SizedBox(
            height: 24,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                value,
                style: AppTypography.h4.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
                maxLines: 1,
              ),
            ),
          ),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: WorkoutShareCard._cardTextSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
