import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:v2log/core/extensions/context_extension.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/utils/animation_config.dart';
import 'package:v2log/core/utils/formatters.dart';
import 'package:v2log/shared/models/exercise_model.dart';
import 'package:v2log/features/profile/domain/user_provider.dart';
import 'package:v2log/shared/widgets/atoms/v2_card.dart';

/// 주간 볼륨 차트 (부위별 Stacked Bar)
class WeeklyVolumeChart extends StatelessWidget {
  final List<MuscleDailyVolume> volumes;
  final ValueChanged<MuscleDailyVolume> onBarTapped;

  const WeeklyVolumeChart({
    required this.volumes,
    required this.onBarTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

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

    final muscleColors = _muscleColors;
    final muscleOrder = _muscleOrder;

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
                        formatVolumeCompact(totalVolume),
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
                        onBarTapped(volumes[index]);
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
                barGroups: _buildBarGroups(volumes, muscleOrder, muscleColors, isDark),
              ),
              swapAnimationDuration: AnimationConfig.slow,
              swapAnimationCurve: AnimationConfig.defaultCurve,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        MuscleLegend(muscleColors: muscleColors, muscleOrder: muscleOrder),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups(
    List<MuscleDailyVolume> volumes,
    List<MuscleGroup> muscleOrder,
    Map<MuscleGroup, Color> muscleColors,
    bool isDark,
  ) {
    return volumes.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

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
                : [BarChartRodStackItem(0, 0, Colors.transparent)],
          ),
        ],
      );
    }).toList();
  }
}

/// 월간 볼륨 차트 (부위별 Stacked Bar)
class MonthlyVolumeChart extends StatelessWidget {
  final List<MuscleMonthlyVolume> volumes;
  final ValueChanged<MuscleMonthlyVolume> onBarTapped;

  const MonthlyVolumeChart({
    required this.volumes,
    required this.onBarTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

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

    final muscleColors = _muscleColors;
    final muscleOrder = _muscleOrder;

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
                        formatVolumeCompact(totalVolume),
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
                        onBarTapped(volumes[index]);
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
                barGroups: _buildBarGroups(volumes, muscleOrder, muscleColors, isDark),
              ),
              swapAnimationDuration: AnimationConfig.slow,
              swapAnimationCurve: AnimationConfig.defaultCurve,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        MuscleLegend(muscleColors: muscleColors, muscleOrder: muscleOrder),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups(
    List<MuscleMonthlyVolume> volumes,
    List<MuscleGroup> muscleOrder,
    Map<MuscleGroup, Color> muscleColors,
    bool isDark,
  ) {
    return volumes.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

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
                : [BarChartRodStackItem(0, 0, Colors.transparent)],
          ),
        ],
      );
    }).toList();
  }
}

/// 부위별 상세 팝업 오버레이
class VolumeDetailPopup extends StatelessWidget {
  final DateTime? date;
  final String? monthLabel;
  final Map<MuscleGroup, double> volumeByMuscle;
  final VoidCallback onClose;

  const VolumeDetailPopup({
    this.date,
    this.monthLabel,
    required this.volumeByMuscle,
    required this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    final muscleColors = _muscleColors;
    final muscleLabels = {
      MuscleGroup.chest: '가슴',
      MuscleGroup.back: '등',
      MuscleGroup.shoulders: '어깨',
      MuscleGroup.quadriceps: '하체',
      MuscleGroup.biceps: '이두',
      MuscleGroup.triceps: '삼두',
      MuscleGroup.core: '코어',
    };

    final entries = volumeByMuscle.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final totalVolume = entries.fold<double>(0, (sum, e) => sum + e.value);

    final title = date != null
        ? '${date!.month}월 ${date!.day}일 상세'
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
                ...entries.map((entry) {
                  final muscle = entry.key;
                  final volume = entry.value;
                  final color = muscleColors[muscle] ?? (isDark ? AppColors.darkBorder : AppColors.lightBorder);
                  final label = muscleLabels[muscle] ?? muscle.label;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            label,
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                            ),
                          ),
                        ),
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
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 근육 부위별 범례
class MuscleLegend extends StatelessWidget {
  final Map<MuscleGroup, Color> muscleColors;
  final List<MuscleGroup> muscleOrder;

  const MuscleLegend({
    required this.muscleColors,
    required this.muscleOrder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final legendItems = <Widget>[];
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

/// 볼륨을 컴팩트하게 포맷 (예: 3.3K, 709K, 1.2M)
String formatVolumeCompact(double volume) {
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

/// 근육 그룹별 색상 맵 (공유 상수)
final Map<MuscleGroup, Color> _muscleColors = {
  MuscleGroup.chest: AppColors.muscleChest,
  MuscleGroup.back: AppColors.muscleBack,
  MuscleGroup.shoulders: AppColors.warning,
  MuscleGroup.quadriceps: AppColors.success,
  MuscleGroup.biceps: AppColors.muscleArms,
  MuscleGroup.triceps: AppColors.muscleArms,
  MuscleGroup.core: AppColors.muscleCore,
};

/// 근육 그룹 순서 (공유 상수)
final List<MuscleGroup> _muscleOrder = [
  MuscleGroup.chest,
  MuscleGroup.back,
  MuscleGroup.shoulders,
  MuscleGroup.quadriceps,
  MuscleGroup.biceps,
  MuscleGroup.triceps,
  MuscleGroup.core,
];
