import 'package:flutter/material.dart';
import 'package:v2log/core/extensions/context_extension.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/utils/formatters.dart';
import 'package:v2log/features/profile/domain/user_provider.dart';
import 'package:v2log/shared/widgets/atoms/animated_wrappers.dart';
import 'package:v2log/shared/widgets/atoms/v2_card.dart';

/// 이번 주 요약 통계 카드 (운동 횟수, 총 볼륨, 운동 시간, 운동 일수)
class WeeklySummaryCard extends StatelessWidget {
  final WeeklyStats stats;

  const WeeklySummaryCard({required this.stats, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.fitness_center,
                label: '운동 횟수',
                value: '${stats.workoutCount}',
                unit: '회',
                color: AppColors.primary500,
                gradient: [
                  AppColors.primary500.withValues(alpha: 0.2),
                  AppColors.primary600.withValues(alpha: 0.1),
                ],
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
                gradient: [
                  AppColors.secondary500.withValues(alpha: 0.2),
                  AppColors.secondary600.withValues(alpha: 0.1),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.timer,
                label: '운동 시간',
                value: _formatDurationShort(stats.totalDuration),
                unit: '',
                color: AppColors.success,
                gradient: [
                  AppColors.success.withValues(alpha: 0.2),
                  AppColors.success.withValues(alpha: 0.1),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _StatCard(
                icon: Icons.calendar_today,
                label: '운동 일수',
                value: '${stats.workoutDates.length}',
                unit: '일',
                color: AppColors.info,
                gradient: [
                  AppColors.info.withValues(alpha: 0.2),
                  AppColors.info.withValues(alpha: 0.1),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDurationShort(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours시간 $minutes분';
    }
    return '$minutes분';
  }
}

/// 이번 주 운동 일정 캘린더
class WeeklyCalendar extends StatelessWidget {
  final List<DateTime> workoutDates;

  const WeeklyCalendar({required this.workoutDates, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final now = DateTime.now();
    final weekday = now.weekday;
    final startOfWeek = DateTime(now.year, now.month, now.day - (weekday - 1));

    final weekDays = ['월', '화', '수', '목', '금', '토', '일'];
    final workoutDateSet = workoutDates
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();

    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          final date = startOfWeek.add(Duration(days: index));
          final isToday = date.day == now.day &&
              date.month == now.month &&
              date.year == now.year;
          final hasWorkout = workoutDateSet.contains(date);

          return FadeSlideIn(
            index: index,
            child: Column(
              children: [
                Text(
                  weekDays[index],
                  style: AppTypography.caption.copyWith(
                    color: isToday
                        ? AppColors.primary500
                        : isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: hasWorkout
                        ? AppColors.primary500
                        : isToday
                            ? (isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    border: isToday && !hasWorkout
                        ? Border.all(color: AppColors.primary500, width: 2)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${date.day}',
                    style: AppTypography.labelMedium.copyWith(
                      color: hasWorkout
                          ? Colors.white
                          : isToday
                              ? AppColors.primary500
                              : isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// 전체 통계 카드
class TotalStatsCard extends StatelessWidget {
  final UserStats stats;

  const TotalStatsCard({required this.stats, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final dividerColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          _TotalStatRow(
            icon: Icons.fitness_center,
            label: '총 운동 횟수',
            value: '${stats.totalWorkouts}회',
            isDark: isDark,
          ),
          Divider(color: dividerColor, height: AppSpacing.xl),
          _TotalStatRow(
            icon: Icons.local_fire_department,
            label: '총 볼륨',
            value: Formatters.volume(stats.totalVolume),
            isDark: isDark,
          ),
          Divider(color: dividerColor, height: AppSpacing.xl),
          _TotalStatRow(
            icon: Icons.timer,
            label: '총 운동 시간',
            value: Formatters.duration(stats.totalDuration),
            isDark: isDark,
          ),
          if (stats.currentStreak > 0) ...[
            Divider(color: dividerColor, height: AppSpacing.xl),
            _TotalStatRow(
              icon: Icons.local_fire_department,
              label: '현재 연속 운동',
              value: '${stats.currentStreak}일',
              valueColor: AppColors.secondary500,
              isDark: isDark,
            ),
          ],
          if (stats.longestStreak > 0) ...[
            Divider(color: dividerColor, height: AppSpacing.xl),
            _TotalStatRow(
              icon: Icons.emoji_events,
              label: '최장 연속 운동',
              value: '${stats.longestStreak}일',
              valueColor: AppColors.warning,
              isDark: isDark,
            ),
          ],
        ],
      ),
    );
  }
}

/// 통계 카드 (개별 항목)
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;
  final List<Color> gradient;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTypography.h3.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    unit,
                    style: AppTypography.labelMedium.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
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

/// 전체 통계 행
class _TotalStatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isDark;

  const _TotalStatRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: AppTypography.labelLarge.copyWith(
            color: valueColor ?? (isDark ? AppColors.darkText : AppColors.lightText),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
