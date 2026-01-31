import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/providers/user_provider.dart';
import '../../widgets/atoms/v2_card.dart';

/// 통계 화면
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyStatsAsync = ref.watch(weeklyStatsProvider);
    final totalStatsAsync = ref.watch(userStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: Text(
          '통계',
          style: AppTypography.h3.copyWith(color: AppColors.darkText),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이번 주 요약
            _buildSectionTitle('이번 주'),
            const SizedBox(height: AppSpacing.lg),
            weeklyStatsAsync.when(
              data: (stats) => _buildWeeklyStats(context, stats),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary500),
              ),
              error: (_, __) => _buildErrorCard(),
            ),

            const SizedBox(height: AppSpacing.xxxl),

            // 이번 주 운동 일정
            _buildSectionTitle('이번 주 운동 일정'),
            const SizedBox(height: AppSpacing.lg),
            weeklyStatsAsync.when(
              data: (stats) => _buildWeeklyCalendar(context, stats.workoutDates),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            const SizedBox(height: AppSpacing.xxxl),

            // 전체 통계
            _buildSectionTitle('전체 통계'),
            const SizedBox(height: AppSpacing.lg),
            totalStatsAsync.when(
              data: (stats) => _buildTotalStats(context, stats),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary500),
              ),
              error: (_, __) => _buildErrorCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.h4.copyWith(
        color: AppColors.darkText,
      ),
    );
  }

  Widget _buildWeeklyStats(BuildContext context, WeeklyStats stats) {
    return Column(
      children: [
        // 주요 통계 카드들
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

  Widget _buildWeeklyCalendar(BuildContext context, List<DateTime> workoutDates) {
    // 이번 주 날짜 계산
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

          return Column(
            children: [
              Text(
                weekDays[index],
                style: AppTypography.caption.copyWith(
                  color: isToday
                      ? AppColors.primary500
                      : AppColors.darkTextTertiary,
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
                          ? AppColors.darkCardElevated
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
                            : AppColors.darkTextSecondary,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTotalStats(BuildContext context, UserStats stats) {
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          _TotalStatRow(
            icon: Icons.fitness_center,
            label: '총 운동 횟수',
            value: '${stats.totalWorkouts}회',
          ),
          const Divider(color: AppColors.darkBorder, height: AppSpacing.xl),
          _TotalStatRow(
            icon: Icons.local_fire_department,
            label: '총 볼륨',
            value: Formatters.volume(stats.totalVolume),
          ),
          const Divider(color: AppColors.darkBorder, height: AppSpacing.xl),
          _TotalStatRow(
            icon: Icons.timer,
            label: '총 운동 시간',
            value: Formatters.duration(stats.totalDuration),
          ),
          if (stats.currentStreak > 0) ...[
            const Divider(color: AppColors.darkBorder, height: AppSpacing.xl),
            _TotalStatRow(
              icon: Icons.local_fire_department,
              label: '현재 연속 운동',
              value: '${stats.currentStreak}일',
              valueColor: AppColors.secondary500,
            ),
          ],
          if (stats.longestStreak > 0) ...[
            const Divider(color: AppColors.darkBorder, height: AppSpacing.xl),
            _TotalStatRow(
              icon: Icons.emoji_events,
              label: '최장 연속 운동',
              value: '${stats.longestStreak}일',
              valueColor: AppColors.warning,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Center(
        child: Text(
          '통계를 불러오는데 실패했어요',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
      ),
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

/// 통계 카드
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
              color: AppColors.darkTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTypography.h3.copyWith(
                  color: AppColors.darkText,
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

/// 전체 통계 행
class _TotalStatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _TotalStatRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.darkTextSecondary,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: AppTypography.labelLarge.copyWith(
            color: valueColor ?? AppColors.darkText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
