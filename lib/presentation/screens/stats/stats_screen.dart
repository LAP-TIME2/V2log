import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/exercise_model.dart';
import '../../../domain/providers/user_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final weeklyStatsAsync = ref.watch(weeklyStatsProvider);
    final totalStatsAsync = ref.watch(userStatsProvider);
    final muscleDailyVolumesAsync = ref.watch(muscleDailyVolumesProvider);
    final muscleMonthlyVolumesAsync = ref.watch(muscleMonthlyVolumesProvider);

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
      body: Stack(
        children: [
          SingleChildScrollView(
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

                // 주간 볼륨 차트 (부위별 Stacked Bar)
                _buildSectionTitle('주간 볼륨 (최근 7일)'),
                const SizedBox(height: AppSpacing.lg),
                muscleDailyVolumesAsync.when(
                  data: (volumes) => _buildWeeklyVolumeChart(context, volumes),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary500),
                  ),
                  error: (_, __) => _buildErrorCard(),
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // 월간 볼륨 차트 (부위별 Stacked Bar)
                _buildSectionTitle('월간 볼륨 (최근 3개월)'),
                const SizedBox(height: AppSpacing.lg),
                muscleMonthlyVolumesAsync.when(
                  data: (volumes) => _buildMonthlyVolumeChart(context, volumes),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary500),
                  ),
                  error: (_, __) => _buildErrorCard(),
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
          // 부위별 상세 팝업 오버레이
          if (_selectedDailyVolume != null)
            _buildVolumeDetailPopup(
              context: context,
              date: _selectedDailyVolume!.date,
              volumeByMuscle: _selectedDailyVolume!.volumeByMuscle,
              onClose: () => setState(() => _selectedDailyVolume = null),
            ),
          if (_selectedMonthlyVolume != null)
            _buildVolumeDetailPopup(
              context: context,
              monthLabel: _selectedMonthlyVolume!.monthLabel,
              volumeByMuscle: _selectedMonthlyVolume!.volumeByMuscle,
              onClose: () => setState(() => _selectedMonthlyVolume = null),
            ),
        ],
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

  Widget _buildWeeklyVolumeChart(BuildContext context, List<MuscleDailyVolume> volumes) {
    if (volumes.isEmpty) {
      return V2Card(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Center(
          child: Text(
            '최근 7일 운동 기록이 없어요',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
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
      MuscleGroup.biceps: AppColors.muscleShoulders,
      MuscleGroup.triceps: AppColors.muscleTriceps,
      MuscleGroup.core: AppColors.secondary500,
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
                        tooltipPadding: EdgeInsets.zero,
                        tooltipMargin: 8,
                        getTooltipColor: (_) => Colors.transparent,
                        getTooltipItem: (group, x, rod, rodIndex) {
                          final index = group.x.toInt();
                          if (index < 0 || index >= volumes.length) return null;
                          final volumeByMuscle = volumes[index].volumeByMuscle;
                          final totalVolume = volumeByMuscle.values.fold<double>(0, (a, b) => a + b);
                          if (totalVolume == 0) return null;
                          return BarTooltipItem(
                            '${Formatters.number(totalVolume, decimals: 0)}kg',
                            const TextStyle(
                              color: AppColors.darkText,
                              fontSize: 14,
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
                                      : AppColors.darkTextTertiary,
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
                                color: AppColors.darkTextTertiary,
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
                          color: AppColors.darkBorder,
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
                              muscleColors[muscle] ?? AppColors.darkBorder,
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
                ),
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        // 범례
        _buildMuscleLegend(muscleColors, muscleOrder),
      ],
    );
  }

  Widget _buildMonthlyVolumeChart(BuildContext context, List<MuscleMonthlyVolume> volumes) {
    if (volumes.isEmpty) {
      return V2Card(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Center(
          child: Text(
            '최근 3개월 운동 기록이 없어요',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
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
      MuscleGroup.biceps: AppColors.muscleShoulders,
      MuscleGroup.triceps: AppColors.muscleTriceps,
      MuscleGroup.core: AppColors.secondary500,
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
                        tooltipPadding: EdgeInsets.zero,
                        tooltipMargin: 8,
                        getTooltipColor: (_) => Colors.transparent,
                        getTooltipItem: (group, x, rod, rodIndex) {
                          final index = group.x.toInt();
                          if (index < 0 || index >= volumes.length) return null;
                          final volumeByMuscle = volumes[index].volumeByMuscle;
                          final totalVolume = volumeByMuscle.values.fold<double>(0, (a, b) => a + b);
                          if (totalVolume == 0) return null;
                          return BarTooltipItem(
                            '${Formatters.number(totalVolume, decimals: 0)}kg',
                            const TextStyle(
                              color: AppColors.darkText,
                              fontSize: 14,
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
                                      : AppColors.darkTextSecondary,
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
                                color: AppColors.darkTextTertiary,
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
                          color: AppColors.darkBorder,
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
                              muscleColors[muscle] ?? AppColors.darkBorder,
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
                ),
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        // 범례
        _buildMuscleLegend(muscleColors, muscleOrder),
      ],
    );
  }

  /// 부위별 상세 팝업
  Widget _buildVolumeDetailPopup({
    required BuildContext context,
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
      MuscleGroup.biceps: AppColors.muscleShoulders,
      MuscleGroup.triceps: AppColors.muscleTriceps,
      MuscleGroup.core: AppColors.secondary500,
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
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.darkBorder),
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
                        color: AppColors.darkText,
                      ),
                    ),
                    GestureDetector(
                      onTap: onClose,
                      child: Icon(
                        Icons.close,
                        color: AppColors.darkTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.darkBorder),
                const SizedBox(height: 16),

                // 총 볼륨
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '총 볼륨',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.darkTextSecondary,
                      ),
                    ),
                    Text(
                      '${Formatters.number(totalVolume, decimals: 0)}kg',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.darkText,
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
                  final color = muscleColors[muscle] ?? AppColors.darkBorder;
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
                              color: AppColors.darkText,
                            ),
                          ),
                        ),
                        // 볼륨
                        Text(
                          '${Formatters.number(volume, decimals: 0)}kg',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.darkText,
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
          color: muscleColors[muscle] ?? AppColors.darkBorder,
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

/// 범례 아이템
class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendItem({
    required this.label,
    required this.color,
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
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }
}
