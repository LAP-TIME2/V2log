import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/sync_queue_model.dart';
import '../../../data/models/workout_session_model.dart';
import '../../../domain/providers/sync_provider.dart';
import '../../../domain/providers/user_provider.dart';
import '../../../domain/providers/workout_provider.dart';
import '../../widgets/atoms/v2_card.dart';

// 운동 이름 추출 헬퍼 함수
String _getWorkoutName(WorkoutSessionModel session) {
  if (session.notes != null && session.notes!.isNotEmpty) {
    return session.notes!;
  }
  if (session.mode == WorkoutMode.preset) {
    return '전문가 루틴';
  }
  final setCount = session.totalSets ?? session.sets.length;
  return '자유 운동 ($setCount세트)';
}

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
            Expanded(
              child: Column(
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
            ),
            const SizedBox(width: AppSpacing.md),
            // 동기화 상태 아이콘
            _SyncStatusIndicator(),
            const SizedBox(width: AppSpacing.sm),
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
        // 전문가 루틴 모드 카드
        Expanded(
          child: _ModeCard(
            icon: Icons.menu_book_outlined,
            title: '전문가 루틴',
            description: '검증된 프로그램으로\n체계적으로 시작해요',
            gradient: [AppColors.primary600, AppColors.primary700],
            onTap: () => context.push('/routine/library'),
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
    final statsAsync = ref.watch(weeklyStatsProvider);

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
                  value: '${stats.workoutCount}회',
                  color: AppColors.primary500,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatCard(
                  icon: Icons.local_fire_department,
                  label: '총 볼륨',
                  value: Formatters.number(stats.totalVolume, decimals: 0, round: true),
                  unit: 'kg',
                  color: AppColors.secondary500,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatCard(
                  icon: Icons.timer,
                  label: '운동 시간',
                  value: Formatters.durationCompact(stats.totalDuration),
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
    final recentWorkoutsAsync = ref.watch(recentWorkoutsProvider);

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
        recentWorkoutsAsync.when(
          data: (recentWorkouts) {
            if (recentWorkouts.isEmpty) {
              return V2Card(
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
              );
            }
            return Column(
              children: recentWorkouts.map((session) {
                final workout = _RecentWorkoutData(
                  date: session.startedAt,
                  name: _getWorkoutName(session),
                  duration: Duration(seconds: session.totalDurationSeconds ?? 0),
                  volume: session.totalVolume ?? session.calculatedVolume,
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _RecentWorkoutCard(workout: workout),
                );
              }).toList(),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xxl),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, __) => V2Card(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Center(
              child: Text(
                '기록을 불러오는데 실패했어요',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
            ),
          ),
        ),
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
              Flexible(
                child: Text(
                  value,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.darkText,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

/// 동기화 상태 표시기
class _SyncStatusIndicator extends ConsumerWidget {
  const _SyncStatusIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connection = ref.watch(connectionStateProvider);
    final syncStatus = ref.watch(syncStateProvider);
    final pendingCount = ref.watch(pendingSyncCountProvider);

    return GestureDetector(
      onTap: () => _showSyncStatusDialog(context, ref),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 메인 아이콘
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _buildIcon(connection, syncStatus),
            ),
            // 대기 중인 작업 수 뱃지
            if ((pendingCount.value ?? 0) > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      '${pendingCount.value ?? 0}',
                      style: AppTypography.caption.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(ConnectionStatus connection, SyncStatus syncStatus) {
    final status = syncStatus;

    // 오프라인
    if (connection == ConnectionStatus.offline) {
      return const Icon(
        Icons.cloud_off,
        key: ValueKey('offline'),
        color: AppColors.darkTextTertiary,
        size: 20,
      );
    }

    // 동기화 중
    if (status == SyncStatus.syncing) {
      return const SizedBox(
        key: ValueKey('syncing'),
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary500),
        ),
      );
    }

    // 동기화 완료
    if (status == SyncStatus.completed) {
      return const Icon(
        Icons.cloud_done,
        key: ValueKey('completed'),
        color: AppColors.success,
        size: 20,
      );
    }

    // 동기화 에러
    if (status == SyncStatus.error) {
      return const Icon(
        Icons.cloud_sync,
        key: ValueKey('error'),
        color: AppColors.error,
        size: 20,
      );
    }

    // 온라인 (기본)
    return const Icon(
      Icons.cloud,
      key: ValueKey('online'),
      color: AppColors.success,
      size: 20,
    );
  }

  void _showSyncStatusDialog(BuildContext context, WidgetRef ref) {
    final connection = ref.read(connectionStateProvider);
    final syncStatus = ref.read(syncStateProvider);
    final pendingCount = ref.read(pendingSyncCountProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: const Text('동기화 상태'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusRow('연결 상태', _getConnectionLabel(connection)),
            const SizedBox(height: AppSpacing.sm),
            _buildStatusRow('동기화 상태', _getSyncStatusLabel(syncStatus)),
            const SizedBox(height: AppSpacing.sm),
            _buildStatusRow('대기 중인 작업', '${pendingCount.value ?? 0}건'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
          if (connection == ConnectionStatus.offline)
            TextButton(
              onPressed: () {
                ref.read(syncControllerProvider.notifier).refreshConnection();
                Navigator.of(context).pop();
              },
              child: const Text('재연결'),
            )
          else if ((pendingCount.value ?? 0) > 0)
            TextButton(
              onPressed: () {
                ref.read(syncControllerProvider.notifier).syncNow();
                Navigator.of(context).pop();
              },
              child: const Text('지금 동기화'),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _getConnectionLabel(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.online:
        return '온라인';
      case ConnectionStatus.offline:
        return '오프라인';
      case ConnectionStatus.unknown:
        return '알 수 없음';
    }
  }

  String _getSyncStatusLabel(SyncStatus status) {
    switch (status) {
      case SyncStatus.idle:
        return '대기 중';
      case SyncStatus.syncing:
        return '동기화 중...';
      case SyncStatus.completed:
        return '완료';
      case SyncStatus.error:
        return '오류 발생';
    }
  }
}
