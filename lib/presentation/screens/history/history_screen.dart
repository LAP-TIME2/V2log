import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/workout_session_model.dart';
import '../../../domain/providers/workout_provider.dart';
import '../../widgets/atoms/v2_card.dart';

/// 운동 기록 히스토리 화면
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(workoutHistoryProvider());

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: Text(
          '운동 기록',
          style: AppTypography.h3.copyWith(color: AppColors.darkText),
        ),
        elevation: 0,
      ),
      body: historyAsync.when(
        data: (sessions) => _buildHistoryList(context, sessions),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary500),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '기록을 불러오는데 실패했어요',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context, List<WorkoutSessionModel> sessions) {
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.fitness_center,
              size: 64,
              color: AppColors.darkTextTertiary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '아직 운동 기록이 없어요',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '첫 운동을 시작해보세요!',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextTertiary,
              ),
            ),
          ],
        ),
      );
    }

    // 날짜별로 그룹화
    final groupedSessions = <String, List<WorkoutSessionModel>>{};
    for (final session in sessions) {
      final dateKey = _getDateKey(session.startedAt);
      groupedSessions.putIfAbsent(dateKey, () => []).add(session);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: groupedSessions.length,
      itemBuilder: (context, index) {
        final dateKey = groupedSessions.keys.elementAt(index);
        final daySessions = groupedSessions[dateKey]!;
        final date = daySessions.first.startedAt;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 헤더
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.lg,
                bottom: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Text(
                    Formatters.relativeDate(date),
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    Formatters.monthDay(date),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.darkTextTertiary,
                    ),
                  ),
                ],
              ),
            ),

            // 해당 날짜의 운동 세션들
            ...daySessions.map((session) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _WorkoutSessionCard(session: session),
                )),
          ],
        );
      },
    );
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

/// 운동 세션 카드
class _WorkoutSessionCard extends StatelessWidget {
  final WorkoutSessionModel session;

  const _WorkoutSessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final duration = session.totalDurationSeconds != null
        ? Duration(seconds: session.totalDurationSeconds!)
        : session.duration ?? Duration.zero;

    final volume = session.totalVolume ?? session.calculatedVolume;
    final setCount = session.totalSets ?? session.sets.length;

    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: () {
        // TODO: 세션 상세 화면으로 이동
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              // 모드 아이콘
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: session.mode == WorkoutMode.preset
                      ? AppColors.primary500.withValues(alpha: 0.15)
                      : AppColors.secondary500.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(
                  session.mode == WorkoutMode.preset
                      ? Icons.menu_book_outlined
                      : Icons.edit_note_outlined,
                  color: session.mode == WorkoutMode.preset
                      ? AppColors.primary500
                      : AppColors.secondary500,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // 운동 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getWorkoutTitle(),
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      Formatters.time(session.startedAt),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.darkTextTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // 화살표
              Icon(
                Icons.chevron_right,
                color: AppColors.darkTextTertiary,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // 통계
          Row(
            children: [
              _StatItem(
                icon: Icons.timer_outlined,
                label: '운동 시간',
                value: Formatters.duration(duration),
              ),
              const SizedBox(width: AppSpacing.xl),
              _StatItem(
                icon: Icons.fitness_center,
                label: '세트',
                value: '$setCount세트',
              ),
              const SizedBox(width: AppSpacing.xl),
              _StatItem(
                icon: Icons.local_fire_department_outlined,
                label: '볼륨',
                value: Formatters.volume(volume),
              ),
            ],
          ),

          // 메모가 있으면 표시
          if (session.notes != null && session.notes!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.darkCardElevated,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 16,
                    color: AppColors.darkTextTertiary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      session.notes!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.darkTextSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 기분 평점
          if (session.moodRating != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < session.moodRating! ? Icons.star : Icons.star_border,
                  size: 16,
                  color: index < session.moodRating!
                      ? AppColors.warning
                      : AppColors.darkTextTertiary,
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  String _getWorkoutTitle() {
    if (session.notes != null && session.notes!.isNotEmpty) {
      // 메모가 짧으면 제목으로 사용
      if (session.notes!.length <= 20) {
        return session.notes!;
      }
    }
    return session.mode == WorkoutMode.preset ? '전문가 루틴' : '자유 운동';
  }
}

/// 통계 아이템
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: AppColors.darkTextTertiary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: AppColors.darkTextTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.darkText,
          ),
        ),
      ],
    );
  }
}
