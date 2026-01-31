import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/workout_session_model.dart';
import '../../../data/models/workout_set_model.dart';
import '../../widgets/atoms/v2_button.dart';
import '../../widgets/atoms/v2_card.dart';

/// 운동 완료 요약 화면
class WorkoutSummaryScreen extends ConsumerWidget {
  final WorkoutSessionModel session;

  const WorkoutSummaryScreen({
    required this.session,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = session.duration ?? Duration.zero;
    final totalVolume = session.calculatedVolume;
    final totalSets = session.sets.length;
    final prSets = session.sets.where((s) => s.isPr).toList();

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xxl),

              // 완료 아이콘
              _buildCompletionBadge(),
              const SizedBox(height: AppSpacing.xl),

              // 축하 메시지
              Text(
                '운동 완료!',
                style: AppTypography.h1.copyWith(
                  color: AppColors.darkText,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _getMotivationalMessage(totalSets, prSets.length),
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // 주요 통계
              _buildMainStats(duration, totalVolume, totalSets),
              const SizedBox(height: AppSpacing.xl),

              // PR 달성 (있는 경우)
              if (prSets.isNotEmpty) ...[
                _buildPrSection(prSets),
                const SizedBox(height: AppSpacing.xl),
              ],

              // 운동별 요약
              _buildExerciseSummary(),
              const SizedBox(height: AppSpacing.xxl),

              // 버튼들
              _buildActionButtons(context),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionBadge() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.success, AppColors.success.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.check,
        size: 64,
        color: Colors.white,
      ),
    );
  }

  String _getMotivationalMessage(int sets, int prs) {
    if (prs > 0) {
      return '오늘 $prs개의 개인 기록을 달성했어요! 대단해요!';
    }
    if (sets >= 20) {
      return '정말 열심히 했어요! 최고의 운동이었습니다!';
    }
    if (sets >= 10) {
      return '좋은 운동이었어요! 꾸준함이 실력입니다.';
    }
    return '오늘도 운동 완료! 내일도 파이팅!';
  }

  Widget _buildMainStats(Duration duration, double volume, int sets) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            icon: Icons.timer_outlined,
            label: '운동 시간',
            value: Formatters.duration(duration),
            color: AppColors.primary500,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatBox(
            icon: Icons.fitness_center,
            label: '총 볼륨',
            value: Formatters.volume(volume),
            color: AppColors.secondary500,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatBox(
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
    return V2Card(
      backgroundColor: AppColors.warning.withValues(alpha: 0.1),
      borderColor: AppColors.warning,
      borderWidth: 1,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                '개인 기록 달성!',
                style: AppTypography.h4.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...prSets.map((set) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.warning,
                      size: 16,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        '${set.exerciseId}: ${set.weight}kg x ${set.reps}회',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.darkText,
                        ),
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

    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '운동별 요약',
            style: AppTypography.h4.copyWith(
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...exerciseGroups.entries.map((entry) {
            final exerciseId = entry.key;
            final sets = entry.value;
            final totalVolume = sets.fold<double>(
                0, (sum, s) => sum + (s.weight ?? 0) * (s.reps ?? 0));
            final maxWeight = sets
                .map((s) => s.weight ?? 0)
                .fold<double>(0, (a, b) => a > b ? a : b);

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary500.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      color: AppColors.primary500,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getExerciseName(exerciseId),
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.darkText,
                          ),
                        ),
                        Text(
                          '${sets.length}세트 • 최고 ${maxWeight}kg',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.darkTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Formatters.volume(totalVolume),
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.primary500,
                        ),
                      ),
                      Text(
                        '볼륨',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.darkTextTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _getExerciseName(String exerciseId) {
    // 간단한 매핑 (실제로는 Provider에서 가져옴)
    final names = {
      'ex-001': '벤치프레스',
      'ex-002': '인클라인 덤벨 프레스',
      'ex-010': '데드리프트',
      'ex-011': '랫풀다운',
      'ex-040': '스쿼트',
      'bench_press': '벤치 프레스',
      'squat': '스쿼트',
      'deadlift': '데드리프트',
    };
    return names[exerciseId] ?? exerciseId;
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        V2Button.primary(
          text: '홈으로 돌아가기',
          icon: Icons.home,
          onPressed: () {
            // Navigator 스택을 모두 제거하고 GoRouter로 홈 이동
            Navigator.of(context).popUntil((route) => route.isFirst);
            context.go('/home');
          },
          fullWidth: true,
        ),
        const SizedBox(height: AppSpacing.md),
        V2Button.secondary(
          text: '기록 상세 보기',
          icon: Icons.history,
          onPressed: () {
            // Navigator 스택을 모두 제거하고 GoRouter로 히스토리 이동
            Navigator.of(context).popUntil((route) => route.isFirst);
            context.go('/history');
          },
          fullWidth: true,
        ),
      ],
    );
  }
}

/// 통계 박스 위젯
class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.h4.copyWith(
              color: AppColors.darkText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
