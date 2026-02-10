import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/animation_config.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/exercise_model.dart';
import '../../../domain/providers/user_provider.dart';
import '../../widgets/atoms/animated_wrappers.dart';
import '../../widgets/atoms/v2_card.dart';

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

  /// 선택된 운동 (1RM 추이용)
  String _selectedExercise = '벤치프레스';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  data: (stats) => _buildWeeklyStats(context, stats),
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
                  data: (stats) => _buildWeeklyCalendar(context, stats.workoutDates),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // 주간 볼륨 차트 (부위별 Stacked Bar)
                _buildSectionTitle('주간 볼륨 (최근 7일)', isDark),
                const SizedBox(height: AppSpacing.lg),
                muscleDailyVolumesAsync.when(
                  data: (volumes) => _buildWeeklyVolumeChart(context, volumes, isDark),
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
                  data: (volumes) => _buildMonthlyVolumeChart(context, volumes, isDark),
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
                  data: (stats) => _buildTotalStats(context, stats, isDark),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary500),
                  ),
                  error: (_, __) => _buildErrorCard(isDark),
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // 1RM 추이
                _buildSectionTitle('1RM 추이 (최근 6개월)', isDark),
                const SizedBox(height: AppSpacing.lg),
                _buildExercise1RMSection(context, isDark),

                const SizedBox(height: AppSpacing.xxxl),

                // 운동 빈도
                _buildSectionTitle('운동 빈도 (최근 6개월)', isDark),
                const SizedBox(height: AppSpacing.lg),
                _buildMuscleFrequencySection(context, isDark),
              ],
            ),
          ),
          // 부위별 상세 팝업 오버레이
          if (_selectedDailyVolume != null)
            _buildVolumeDetailPopup(
              context: context,
              isDark: isDark,
              date: _selectedDailyVolume!.date,
              volumeByMuscle: _selectedDailyVolume!.volumeByMuscle,
              onClose: () => setState(() => _selectedDailyVolume = null),
            ),
          if (_selectedMonthlyVolume != null)
            _buildVolumeDetailPopup(
              context: context,
              isDark: isDark,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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

  Widget _buildWeeklyVolumeChart(BuildContext context, List<MuscleDailyVolume> volumes, bool isDark) {
    if (volumes.isEmpty) {
      return V2Card(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Center(
          child: Text(
            '최근 7일 운동 기록이 없어요',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
      );
    }

    // 근육 그룹별 색상 맵 (가슴: 빨강, 등: 파랑, 어깨: 노랑, 하체: 초록, 팔: 보라, 코어: 주황)
    final muscleColors = {
      MuscleGroup.chest: AppColors.muscleChest,
      MuscleGroup.back: AppColors.muscleBack,
      MuscleGroup.shoulders: AppColors.warning,
      MuscleGroup.quadriceps: AppColors.success,
      MuscleGroup.biceps: AppColors.muscleArms,
      MuscleGroup.triceps: AppColors.muscleArms,
      MuscleGroup.core: AppColors.muscleCore,
    };

    // 근육 그룹 순서 (위에서부터 쌓이는 순서)
    final muscleOrder = [
      MuscleGroup.chest,
      MuscleGroup.back,
      MuscleGroup.shoulders,
      MuscleGroup.quadriceps,
      MuscleGroup.biceps,
      MuscleGroup.triceps,
      MuscleGroup.core,
    ];

    // 최대 총 볼륨 계산
    double maxTotalVolume = 0;
    for (final volume in volumes) {
      final total = volume.volumeByMuscle.values.fold<double>(0, (a, b) => a + b);
      if (total > maxTotalVolume) maxTotalVolume = total;
    }

    final now = DateTime.now();

    return Column(
      children: [
        V2Card(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SizedBox(
            height: 240,
            child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxTotalVolume > 0 ? maxTotalVolume * 1.2 : 100,
                    minY: 0,
                    barTouchData: BarTouchData(
                      enabled: true,
                      handleBuiltInTouches: false,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        tooltipMargin: 4,
                        fitInsideHorizontally: true,
                        fitInsideVertically: true,
                        getTooltipColor: (_) => Colors.transparent,
                        getTooltipItem: (group, x, rod, rodIndex) {
                          final index = group.x.toInt();
                          if (index < 0 || index >= volumes.length) return null;
                          final volumeByMuscle = volumes[index].volumeByMuscle;
                          final totalVolume = volumeByMuscle.values.fold<double>(0, (a, b) => a + b);
                          if (totalVolume == 0) return null;
                          return BarTooltipItem(
                            _formatVolumeCompact(totalVolume),
                            TextStyle(
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        },
                      ),
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        if (event is FlTapUpEvent &&
                            barTouchResponse != null &&
                            barTouchResponse.spot?.touchedBarGroupIndex != null) {
                          final index = barTouchResponse.spot!.touchedBarGroupIndex;
                          if (index >= 0 && index < volumes.length) {
                            setState(() {
                              _selectedDailyVolume = volumes[index];
                              _selectedMonthlyVolume = null;
                            });
                          }
                        }
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= volumes.length) {
                              return const SizedBox.shrink();
                            }
                            final date = volumes[index].date;
                            final dayLabel = '${date.day}일';
                            final isToday = date.day == now.day &&
                                date.month == now.month &&
                                date.year == now.year;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                dayLabel,
                                style: AppTypography.caption.copyWith(
                                  color: isToday
                                      ? AppColors.primary500
                                      : isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            );
                          },
                          reservedSize: 40,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 72,
                          getTitlesWidget: (value, meta) {
                            if (value == meta.max || value == meta.min) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              Formatters.number(value, decimals: 0),
                              style: AppTypography.caption.copyWith(
                                color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: volumes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      final date = data.date;
                      final isToday = date.day == now.day &&
                          date.month == now.month &&
                          date.year == now.year;

                      // Stacked Bar Chart 생성
                      final barStackItems = <BarChartRodStackItem>[];
                      double currentY = 0;

                      for (final muscle in muscleOrder) {
                        final volume = data.volumeByMuscle[muscle] ?? 0.0;
                        if (volume > 0) {
                          barStackItems.add(
                            BarChartRodStackItem(
                              currentY,
                              currentY + volume,
                              muscleColors[muscle] ?? (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            ),
                          );
                          currentY += volume;
                        }
                      }

                      final totalVolume = data.volumeByMuscle.values.fold<double>(0, (a, b) => a + b);

                      return BarChartGroupData(
                        x: index,
                        showingTooltipIndicators: totalVolume > 0 ? [0] : [],
                        barRods: [
                          BarChartRodData(
                            toY: currentY > 0 ? currentY : 0.1,
                            color: Colors.transparent,
                            width: 24,
                            borderRadius: BorderRadius.zero,
                            rodStackItems: barStackItems.isNotEmpty
                                ? barStackItems
                                : [
                                    BarChartRodStackItem(
                                      0,
                                      0,
                                      Colors.transparent,
                                    ),
                                  ],
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  swapAnimationDuration: AnimationConfig.slow,
                  swapAnimationCurve: AnimationConfig.defaultCurve,
                ),
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        // 범례
        _buildMuscleLegend(muscleColors, muscleOrder, isDark),
      ],
    );
  }

  Widget _buildMonthlyVolumeChart(BuildContext context, List<MuscleMonthlyVolume> volumes, bool isDark) {
    if (volumes.isEmpty) {
      return V2Card(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Center(
          child: Text(
            '최근 3개월 운동 기록이 없어요',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
      );
    }

    // 근육 그룹별 색상 맵 (가슴: 빨강, 등: 파랑, 어깨: 노랑, 하체: 초록, 팔: 보라, 코어: 주황)
    final muscleColors = {
      MuscleGroup.chest: AppColors.muscleChest,
      MuscleGroup.back: AppColors.muscleBack,
      MuscleGroup.shoulders: AppColors.warning,
      MuscleGroup.quadriceps: AppColors.success,
      MuscleGroup.biceps: AppColors.muscleArms,
      MuscleGroup.triceps: AppColors.muscleArms,
      MuscleGroup.core: AppColors.muscleCore,
    };

    // 근육 그룹 순서 (위에서부터 쌓이는 순서)
    final muscleOrder = [
      MuscleGroup.chest,
      MuscleGroup.back,
      MuscleGroup.shoulders,
      MuscleGroup.quadriceps,
      MuscleGroup.biceps,
      MuscleGroup.triceps,
      MuscleGroup.core,
    ];

    // 최대 총 볼륨 계산
    double maxTotalVolume = 0;
    for (final volume in volumes) {
      final total = volume.volumeByMuscle.values.fold<double>(0, (a, b) => a + b);
      if (total > maxTotalVolume) maxTotalVolume = total;
    }

    final now = DateTime.now();

    return Column(
      children: [
        V2Card(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SizedBox(
            height: 240,
            child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxTotalVolume > 0 ? maxTotalVolume * 1.2 : 100,
                    minY: 0,
                    barTouchData: BarTouchData(
                      enabled: true,
                      handleBuiltInTouches: false,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        tooltipMargin: 4,
                        fitInsideHorizontally: true,
                        fitInsideVertically: true,
                        getTooltipColor: (_) => Colors.transparent,
                        getTooltipItem: (group, x, rod, rodIndex) {
                          final index = group.x.toInt();
                          if (index < 0 || index >= volumes.length) return null;
                          final volumeByMuscle = volumes[index].volumeByMuscle;
                          final totalVolume = volumeByMuscle.values.fold<double>(0, (a, b) => a + b);
                          if (totalVolume == 0) return null;
                          return BarTooltipItem(
                            _formatVolumeCompact(totalVolume),
                            TextStyle(
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        },
                      ),
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        if (event is FlTapUpEvent &&
                            barTouchResponse != null &&
                            barTouchResponse.spot?.touchedBarGroupIndex != null) {
                          final index = barTouchResponse.spot!.touchedBarGroupIndex;
                          if (index >= 0 && index < volumes.length) {
                            setState(() {
                              _selectedMonthlyVolume = volumes[index];
                              _selectedDailyVolume = null;
                            });
                          }
                        }
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= volumes.length) {
                              return const SizedBox.shrink();
                            }
                            final monthLabel = volumes[index].monthLabel;
                            final isCurrentMonth = monthLabel == '${now.month}월';
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                monthLabel,
                                style: AppTypography.labelMedium.copyWith(
                                  color: isCurrentMonth
                                      ? AppColors.primary500
                                      : isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  fontWeight: isCurrentMonth ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            );
                          },
                          reservedSize: 40,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 72,
                          getTitlesWidget: (value, meta) {
                            if (value == meta.max || value == meta.min) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              Formatters.number(value, decimals: 0),
                              style: AppTypography.caption.copyWith(
                                color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: volumes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      final monthLabel = data.monthLabel;
                      final isCurrentMonth = monthLabel == '${now.month}월';

                      // Stacked Bar Chart 생성
                      final barStackItems = <BarChartRodStackItem>[];
                      double currentY = 0;

                      for (final muscle in muscleOrder) {
                        final volume = data.volumeByMuscle[muscle] ?? 0.0;
                        if (volume > 0) {
                          barStackItems.add(
                            BarChartRodStackItem(
                              currentY,
                              currentY + volume,
                              muscleColors[muscle] ?? (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            ),
                          );
                          currentY += volume;
                        }
                      }

                      final totalVolume = data.volumeByMuscle.values.fold<double>(0, (a, b) => a + b);

                      return BarChartGroupData(
                        x: index,
                        showingTooltipIndicators: totalVolume > 0 ? [0] : [],
                        barRods: [
                          BarChartRodData(
                            toY: currentY > 0 ? currentY : 0.1,
                            color: Colors.transparent,
                            width: 48,
                            borderRadius: BorderRadius.zero,
                            rodStackItems: barStackItems.isNotEmpty
                                ? barStackItems
                                : [
                                    BarChartRodStackItem(
                                      0,
                                      0,
                                      Colors.transparent,
                                    ),
                                  ],
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  swapAnimationDuration: AnimationConfig.slow,
                  swapAnimationCurve: AnimationConfig.defaultCurve,
                ),
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        // 범례
        _buildMuscleLegend(muscleColors, muscleOrder, isDark),
      ],
    );
  }

  /// 부위별 상세 팝업
  Widget _buildVolumeDetailPopup({
    required BuildContext context,
    required bool isDark,
    DateTime? date,
    String? monthLabel,
    required Map<MuscleGroup, double> volumeByMuscle,
    required VoidCallback onClose,
  }) {
    // 근육 그룹별 색상
    final muscleColors = {
      MuscleGroup.chest: AppColors.muscleChest,
      MuscleGroup.back: AppColors.muscleBack,
      MuscleGroup.shoulders: AppColors.warning,
      MuscleGroup.quadriceps: AppColors.success,
      MuscleGroup.biceps: AppColors.muscleArms,
      MuscleGroup.triceps: AppColors.muscleArms,
      MuscleGroup.core: AppColors.muscleCore,
    };

    // 부위별 이름 매핑
    final muscleLabels = {
      MuscleGroup.chest: '가슴',
      MuscleGroup.back: '등',
      MuscleGroup.shoulders: '어깨',
      MuscleGroup.quadriceps: '하체',
      MuscleGroup.biceps: '이두',
      MuscleGroup.triceps: '삼두',
      MuscleGroup.core: '코어',
    };

    // 볼륨이 있는 부위만 필터링하고 내림차순 정렬
    final entries = volumeByMuscle.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // 총 볼륨 계산
    final totalVolume = entries.fold<double>(0, (sum, e) => sum + e.value);

    // 제목 생성
    final title = date != null
        ? '${date.month}월 ${date.day}일 상세'
        : '$monthLabel 상세';

    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 제목
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTypography.h3.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    GestureDetector(
                      onTap: onClose,
                      child: Icon(
                        Icons.close,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                const SizedBox(height: 16),

                // 총 볼륨
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '총 볼륨',
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    Text(
                      '${Formatters.number(totalVolume, decimals: 0)}kg',
                      style: AppTypography.labelLarge.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 부위별 볼륨 리스트
                ...entries.map((entry) {
                  final muscle = entry.key;
                  final volume = entry.value;
                  final color = muscleColors[muscle] ?? (isDark ? AppColors.darkBorder : AppColors.lightBorder);
                  final label = muscleLabels[muscle] ?? muscle.label;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        // 색상 원형 아이콘
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 부위명
                        Expanded(
                          child: Text(
                            label,
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                            ),
                          ),
                        ),
                        // 볼륨
                        Text(
                          '${Formatters.number(volume, decimals: 0)}kg',
                          style: AppTypography.labelLarge.copyWith(
                            color: isDark ? AppColors.darkText : AppColors.lightText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 근육 부위별 범례
  Widget _buildMuscleLegend(
    Map<MuscleGroup, Color> muscleColors,
    List<MuscleGroup> muscleOrder,
    bool isDark,
  ) {
    // 중복 제거된 범례 항목 (이두/삼두를 "팔"로 표시, 대퇴사두를 "하체"로 표시)
    final legendItems = <_LegendItem>[];
    final seenLabels = <String>{};

    for (final muscle in muscleOrder) {
      String label;
      switch (muscle) {
        case MuscleGroup.biceps:
        case MuscleGroup.triceps:
          label = '팔';
          break;
        case MuscleGroup.quadriceps:
          label = '하체';
          break;
        default:
          label = muscle.label;
      }

      if (!seenLabels.contains(label) && label != '전신') {
        seenLabels.add(label);
        legendItems.add(_LegendItem(
          label: label,
          color: muscleColors[muscle] ?? (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          isDark: isDark,
        ));
      }
    }

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      alignment: WrapAlignment.center,
      children: legendItems,
    );
  }

  Widget _buildTotalStats(BuildContext context, UserStats stats, bool isDark) {
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

  /// 볼륨을 컴팩트하게 포맷 (예: 3.3K, 709K, 1.2M)
  String _formatVolumeCompact(double volume) {
    if (volume >= 1000000) {
      final v = volume / 1000000;
      return '${v.toStringAsFixed(v >= 10 ? 0 : 1)}M';
    } else if (volume >= 1000) {
      final v = volume / 1000;
      return '${v.toStringAsFixed(v >= 100 ? 0 : v >= 10 ? 0 : 1)}K';
    } else {
      return '${volume.toStringAsFixed(0)}kg';
    }
  }

  String _formatDurationShort(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours시간 $minutes분';
    }
    return '$minutes분';
  }

  /// 운동별 1RM 추이 섹션
  Widget _buildExercise1RMSection(BuildContext context, bool isDark) {
    // 운동 선택 드롭다운
    final exercises = ['벤치프레스', '스쿼트', '데드리프트', '오버헤드프레스', '바벨로우'];
    final exercise1RMHistoryAsync = ref.watch(exercise1RMHistoryProvider(_selectedExercise));

    return Column(
      children: [
        // 운동 선택 드롭다운
        V2Card(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedExercise,
              isExpanded: true,
              dropdownColor: isDark ? AppColors.darkCard : AppColors.lightCard,
              style: AppTypography.bodyLarge.copyWith(
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
              items: exercises.map((exercise) {
                return DropdownMenuItem<String>(
                  value: exercise,
                  child: Text(exercise),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedExercise = value;
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // 1RM 라인 차트
        exercise1RMHistoryAsync.when(
          data: (records) => _buildExercise1RMChart(context, records, isDark),
          loading: () => const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary500),
            ),
          ),
          error: (_, __) => _buildErrorCard(isDark),
        ),
      ],
    );
  }

  /// 운동별 1RM 라인 차트 (월간, 최근 6개월)
  Widget _buildExercise1RMChart(BuildContext context, List<Exercise1RMRecord> records, bool isDark) {
    // 0값 필터링 (기록이 없는 월 제외)
    final validRecords = records.where((r) => r.estimated1RM > 0).toList();

    if (validRecords.isEmpty) {
      return V2Card(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Center(
          child: Text(
            '$_selectedExercise 기록이 없어요',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
      );
    }

    // 최대 1RM 계산
    final max1RM = validRecords.map((r) => r.estimated1RM).fold<double>(
        0, (max, value) => value > max ? value : max);

    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= validRecords.length) {
                      return const SizedBox.shrink();
                    }
                    if (value != index.toDouble()) {
                      return const SizedBox.shrink();
                    }
                    final date = validRecords[index].date;
                    final label = '${date.month}월';
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        label,
                        style: AppTypography.caption.copyWith(
                          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  getTitlesWidget: (value, meta) {
                    if (value == meta.max || value == meta.min) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      Formatters.number(value, decimals: 0),
                      style: AppTypography.caption.copyWith(
                        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: (validRecords.length - 1).toDouble(),
            minY: 0,
            maxY: max1RM > 0 ? max1RM * 1.2 : 100,
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  validRecords.length,
                  (index) => FlSpot(
                    index.toDouble(),
                    validRecords[index].estimated1RM,
                  ),
                ),
                isCurved: true,
                color: AppColors.primary500,
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: AppColors.primary500,
                      strokeWidth: 2,
                      strokeColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.primary500.withValues(alpha: 0.1),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                tooltipMargin: 8,
                getTooltipColor: (_) => isDark ? AppColors.darkCard : AppColors.lightCard,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final index = spot.x.toInt();
                    if (index < 0 || index >= validRecords.length) {
                      return null;
                    }
                    final record = validRecords[index];
                    final value = Formatters.number(record.estimated1RM, decimals: 1);
                    // 호버 시 무게만 표시 (날짜 없음)
                    return LineTooltipItem(
                      '${value}kg',
                      TextStyle(
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 운동 빈도 섹션 (부위별 + 운동별 TOP 5)
  Widget _buildMuscleFrequencySection(BuildContext context, bool isDark) {
    final muscleFrequencyAsync = ref.watch(muscleFrequencyProvider);
    final exerciseFrequencyAsync = ref.watch(exerciseFrequencyProvider);

    return Column(
      children: [
        // 부위별 운동 빈도
        muscleFrequencyAsync.when(
          data: (frequencies) => _buildMuscleFrequencyCard(context, frequencies, isDark),
          loading: () => const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary500),
            ),
          ),
          error: (_, __) => _buildErrorCard(isDark),
        ),

        const SizedBox(height: AppSpacing.lg),

        // 운동별 빈도 TOP 5
        exerciseFrequencyAsync.when(
          data: (frequencies) => _buildExerciseFrequencyCard(context, frequencies, isDark),
          loading: () => const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary500),
            ),
          ),
          error: (_, __) => _buildErrorCard(isDark),
        ),
      ],
    );
  }

  /// 부위별 운동 빈도 카드
  Widget _buildMuscleFrequencyCard(BuildContext context, List<MuscleFrequency> frequencies, bool isDark) {
    if (frequencies.every((f) => f.count == 0)) {
      return V2Card(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Center(
          child: Text(
            '최근 6개월 운동 기록이 없어요',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
      );
    }

    // 최대 빈도 계산
    final maxCount = frequencies.map((f) => f.count).fold<int>(0, (max, count) => count > max ? count : max);

    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '부위별 운동 횟수',
            style: AppTypography.labelLarge.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...frequencies.map((frequency) {
            final percentage = maxCount > 0 ? (frequency.count / maxCount) : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: frequency.color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            frequency.label,
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${frequency.count}회',
                        style: AppTypography.labelMedium.copyWith(
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                      valueColor: AlwaysStoppedAnimation<Color>(frequency.color),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// 운동별 빈도 TOP 5 카드
  Widget _buildExerciseFrequencyCard(BuildContext context, List<ExerciseFrequency> frequencies, bool isDark) {
    if (frequencies.isEmpty) {
      return V2Card(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Center(
          child: Text(
            '최근 6개월 운동 기록이 없어요',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
      );
    }

    final maxCount = frequencies.isNotEmpty ? frequencies.first.count : 0;

    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '운동별 빈도 TOP 5',
            style: AppTypography.labelLarge.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...frequencies.asMap().entries.map((entry) {
            final index = entry.key;
            final frequency = entry.value;
            final percentage = maxCount > 0 ? (frequency.count / maxCount) : 0.0;

            // 부위별 색상 매핑
            final muscleColor = _getMuscleColor(frequency.primaryMuscle, isDark);

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            // 순위 뱃지 (부위별 색상 적용)
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: muscleColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${index + 1}',
                                style: AppTypography.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                frequency.exerciseName,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: isDark ? AppColors.darkText : AppColors.lightText,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: muscleColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${frequency.count}회',
                        style: AppTypography.labelMedium.copyWith(
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                      valueColor: AlwaysStoppedAnimation<Color>(muscleColor),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// 부위별 색상 가져오기 (주간/월간 차트와 동일)
  Color _getMuscleColor(String muscleLabel, bool isDark) {
    switch (muscleLabel) {
      case '가슴':
        return AppColors.muscleChest;
      case '등':
      case '광배근':
        return AppColors.muscleBack;
      case '어깨':
        return AppColors.warning;
      case '하체':
      case '대퇴사두':
      case '햄스트링':
      case '둔근':
        return AppColors.success;
      case '이두':
      case '삼두':
      case '팔':
        return AppColors.muscleArms;
      case '코어':
      case '복근':
        return AppColors.muscleCore;
      default:
        return isDark ? AppColors.darkBorder : AppColors.lightBorder;
    }
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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

/// 범례 아이템
class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;

  const _LegendItem({
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
