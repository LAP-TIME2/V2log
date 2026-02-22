import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/extensions/context_extension.dart';
import 'package:v2log/features/profile/domain/user_provider.dart';
import 'package:v2log/shared/widgets/atoms/animated_wrappers.dart';
import 'package:v2log/shared/widgets/atoms/v2_card.dart';

import 'widgets/weekly_summary_card.dart';
import 'widgets/volume_chart.dart';
import 'widgets/one_rm_trend_chart.dart';
import 'widgets/muscle_distribution_chart.dart';

/// 통계 화면
class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  /// 선택된 주간 볼륨 데이터 (팝업 표시용)
  MuscleDailyVolume? _selectedDailyVolume;

  /// 선택된 월간 볼륨 데이터 (팝업 표시용)
  MuscleMonthlyVolume? _selectedMonthlyVolume;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final weeklyStatsAsync = ref.watch(weeklyStatsProvider);
    final totalStatsAsync = ref.watch(userStatsProvider);
    final muscleDailyVolumesAsync = ref.watch(muscleDailyVolumesProvider);
    final muscleMonthlyVolumesAsync = ref.watch(muscleMonthlyVolumesProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        title: Text(
          '통계',
          style: AppTypography.h3.copyWith(color: isDark ? AppColors.darkText : AppColors.lightText),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이번 주 요약
                _buildSectionTitle('이번 주', isDark),
                const SizedBox(height: AppSpacing.lg),
                weeklyStatsAsync.when(
                  data: (stats) => WeeklySummaryCard(stats: stats),
                  loading: () => Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: ShimmerLoading(height: 100, borderRadius: 12)),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(child: ShimmerLoading(height: 100, borderRadius: 12)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(child: ShimmerLoading(height: 100, borderRadius: 12)),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(child: ShimmerLoading(height: 100, borderRadius: 12)),
                        ],
                      ),
                    ],
                  ),
                  error: (_, __) => _buildErrorCard(isDark),
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // 이번 주 운동 일정
                _buildSectionTitle('이번 주 운동 일정', isDark),
                const SizedBox(height: AppSpacing.lg),
                weeklyStatsAsync.when(
                  data: (stats) => WeeklyCalendar(workoutDates: stats.workoutDates),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // 주간 볼륨 차트 (부위별 Stacked Bar)
                _buildSectionTitle('주간 볼륨 (최근 7일)', isDark),
                const SizedBox(height: AppSpacing.lg),
                muscleDailyVolumesAsync.when(
                  data: (volumes) => WeeklyVolumeChart(
                    volumes: volumes,
                    onBarTapped: (volume) {
                      setState(() {
                        _selectedDailyVolume = volume;
                        _selectedMonthlyVolume = null;
                      });
                    },
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary500),
                  ),
                  error: (_, __) => _buildErrorCard(isDark),
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // 월간 볼륨 차트 (부위별 Stacked Bar)
                _buildSectionTitle('월간 볼륨 (최근 3개월)', isDark),
                const SizedBox(height: AppSpacing.lg),
                muscleMonthlyVolumesAsync.when(
                  data: (volumes) => MonthlyVolumeChart(
                    volumes: volumes,
                    onBarTapped: (volume) {
                      setState(() {
                        _selectedMonthlyVolume = volume;
                        _selectedDailyVolume = null;
                      });
                    },
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary500),
                  ),
                  error: (_, __) => _buildErrorCard(isDark),
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // 전체 통계
                _buildSectionTitle('전체 통계', isDark),
                const SizedBox(height: AppSpacing.lg),
                totalStatsAsync.when(
                  data: (stats) => TotalStatsCard(stats: stats),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary500),
                  ),
                  error: (_, __) => _buildErrorCard(isDark),
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // 강도 분석
                _buildSectionTitle('강도 분석 (최근 30일)', isDark),
                const SizedBox(height: AppSpacing.lg),
                const IntensityZoneSection(),

                const SizedBox(height: AppSpacing.xxxl),

                // 1RM 추이
                _buildSectionTitle('1RM 추이 (최근 6개월)', isDark),
                const SizedBox(height: AppSpacing.lg),
                const OneRmTrendSection(),

                const SizedBox(height: AppSpacing.xxxl),

                // 운동 빈도
                _buildSectionTitle('운동 빈도 (최근 6개월)', isDark),
                const SizedBox(height: AppSpacing.lg),
                const MuscleFrequencySection(),
              ],
            ),
          ),
          // 부위별 상세 팝업 오버레이
          if (_selectedDailyVolume != null)
            VolumeDetailPopup(
              date: _selectedDailyVolume!.date,
              volumeByMuscle: _selectedDailyVolume!.volumeByMuscle,
              onClose: () => setState(() => _selectedDailyVolume = null),
            ),
          if (_selectedMonthlyVolume != null)
            VolumeDetailPopup(
              monthLabel: _selectedMonthlyVolume!.monthLabel,
              volumeByMuscle: _selectedMonthlyVolume!.volumeByMuscle,
              onClose: () => setState(() => _selectedMonthlyVolume = null),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: AppTypography.h4.copyWith(
        color: isDark ? AppColors.darkText : AppColors.lightText,
      ),
    );
  }

  Widget _buildErrorCard(bool isDark) {
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Center(
        child: Text(
          '통계를 불러오는데 실패했어요',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ),
    );
  }
}
