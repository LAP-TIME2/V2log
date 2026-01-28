import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/workout_session_model.dart';
import '../../../domain/providers/user_provider.dart';
import '../../../domain/providers/workout_provider.dart';
import '../../widgets/atoms/v2_card.dart';

/// 홈 화면 (듀얼 모드 선택)
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isWorkoutInProgress = ref.watch(isWorkoutInProgressProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 인사
              _buildGreeting(context, user?.nickname),
              const SizedBox(height: AppSpacing.xxl),

              // 진행 중인 운동이 있으면 표시
              if (isWorkoutInProgress) ...[
                _buildActiveWorkoutBanner(context, ref),
                const SizedBox(height: AppSpacing.lg),
              ],

              // 모드 선택 카드
              _buildModeSelector(context, ref),
              const SizedBox(height: AppSpacing.lg),

              // 빠른 기록 버튼
              _buildQuickRecordButton(context, ref),
              const SizedBox(height: AppSpacing.xxl),

              // 이번 주 요약
              _buildWeeklySummary(context, ref),
              const SizedBox(height: AppSpacing.xxl),

              // 최근 운동
              _buildRecentWorkouts(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, String? nickname) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = '좋은 아침이에요';
    } else if (hour < 18) {
      greeting = '좋은 오후예요';
    } else {
      greeting = '좋은 저녁이에요';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  nickname ?? '운동하러 오셨군요!',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
            // 프로필 아이콘
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.darkCard,
              child: Icon(
                Icons.person,
                color: AppColors.darkTextSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveWorkoutBanner(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeWorkoutProvider);
    if (session == null) return const SizedBox.shrink();

    return V2Card(
      backgroundColor: AppColors.primary500.withValues(alpha: 0.1),
      borderColor: AppColors.primary500,
      borderWidth: 1,
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: () => context.push('/workout/session/${session.id}'),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary500,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '운동 진행 중',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary500,
                  ),
                ),
                Text(
                  '${session.sets.length}세트 완료 • ${Formatters.timer(session.currentDuration.inSeconds)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.primary500,
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // AI 모드 카드
        Expanded(
          child: _ModeCard(
            icon: Icons.smart_toy_outlined,
            title: 'AI 추천',
            description: 'AI가 오늘의\n루틴을 추천해요',
            gradient: [AppColors.primary600, AppColors.primary700],
            onTap: () => _startWorkout(context, ref, WorkoutMode.ai),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        // 자유 모드 카드
        Expanded(
          child: _ModeCard(
            icon: Icons.edit_note_outlined,
            title: '자유 기록',
            description: '내 루틴으로\n자유롭게 기록해요',
            gradient: [AppColors.secondary500, AppColors.secondary600],
            onTap: () => _startWorkout(context, ref, WorkoutMode.free),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickRecordButton(BuildContext context, WidgetRef ref) {
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: () => _startWorkout(context, ref, WorkoutMode.free),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(
              Icons.bolt,
              color: AppColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '빠른 기록',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.darkText,
                  ),
                ),
                Text(
                  '루틴 없이 바로 운동 기록하기',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.darkTextTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummary(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이번 주 요약',
          style: AppTypography.h4.copyWith(
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        statsAsync.when(
          data: (stats) => Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.fitness_center,
                  label: '운동 횟수',
                  value: '${stats.totalWorkouts}회',
                  color: AppColors.primary500,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatCard(
                  icon: Icons.local_fire_department,
                  label: '총 볼륨',
                  value: Formatters.number(stats.totalVolume, decimals: 0),
                  unit: 'kg',
                  color: AppColors.secondary500,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatCard(
                  icon: Icons.timer,
                  label: '운동 시간',
                  value: Formatters.duration(stats.totalDuration),
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildRecentWorkouts(BuildContext context, WidgetRef ref) {
    // TODO: 실제 데이터로 교체
    final recentWorkouts = <_RecentWorkoutData>[
      _RecentWorkoutData(
        date: DateTime.now().subtract(const Duration(days: 1)),
        name: '등 & 이두',
        duration: const Duration(minutes: 52),
        volume: 8500,
      ),
      _RecentWorkoutData(
        date: DateTime.now().subtract(const Duration(days: 2)),
        name: '가슴 & 삼두',
        duration: const Duration(minutes: 48),
        volume: 7200,
      ),
      _RecentWorkoutData(
        date: DateTime.now().subtract(const Duration(days: 4)),
        name: '하체',
        duration: const Duration(minutes: 65),
        volume: 12000,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '최근 운동',
              style: AppTypography.h4.copyWith(
                color: AppColors.darkText,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/history'),
              child: Text(
                '전체보기',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (recentWorkouts.isEmpty)
          V2Card(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 48,
                    color: AppColors.darkTextTertiary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '아직 운동 기록이 없어요',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '첫 운동을 시작해보세요!',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.darkTextTertiary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...recentWorkouts.map((workout) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _RecentWorkoutCard(workout: workout),
              )),
      ],
    );
  }

  Future<void> _startWorkout(
    BuildContext context,
    WidgetRef ref,
    WorkoutMode mode,
  ) async {
    try {
      await ref.read(activeWorkoutProvider.notifier).startWorkout(mode: mode);
      if (context.mounted) {
        context.push('/workout/session/active');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}

/// 모드 선택 카드
class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return V2GradientCard(
      gradientColors: gradient,
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 32,
            color: Colors.white,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: AppTypography.h4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

/// 통계 카드
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? unit;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.darkTextTertiary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTypography.h4.copyWith(
                  color: AppColors.darkText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 2),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    unit!,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentWorkoutData {
  final DateTime date;
  final String name;
  final Duration duration;
  final double volume;

  const _RecentWorkoutData({
    required this.date,
    required this.name,
    required this.duration,
    required this.volume,
  });
}

class _RecentWorkoutCard extends StatelessWidget {
  final _RecentWorkoutData workout;

  const _RecentWorkoutCard({required this.workout});

  @override
  Widget build(BuildContext context) {
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: () {},
      child: Row(
        children: [
          // 날짜
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.darkCardElevated,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Formatters.shortWeekday(workout.date),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.darkTextTertiary,
                  ),
                ),
                Text(
                  workout.date.day.toString(),
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),

          // 운동 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.name,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${Formatters.duration(workout.duration)} • ${Formatters.volume(workout.volume)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.chevron_right,
            color: AppColors.darkTextTertiary,
          ),
        ],
      ),
    );
  }
}
