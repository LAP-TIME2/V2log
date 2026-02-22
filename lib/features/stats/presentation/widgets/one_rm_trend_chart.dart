import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:v2log/core/extensions/context_extension.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/utils/formatters.dart';
import 'package:v2log/features/profile/domain/user_provider.dart';
import 'package:v2log/shared/widgets/atoms/v2_card.dart';

/// 운동별 1RM 추이 섹션 (드롭다운 + 라인 차트)
class OneRmTrendSection extends ConsumerStatefulWidget {
  const OneRmTrendSection({super.key});

  @override
  ConsumerState<OneRmTrendSection> createState() => _OneRmTrendSectionState();
}

class _OneRmTrendSectionState extends ConsumerState<OneRmTrendSection> {
  String _selectedExercise = '벤치프레스';

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
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
          data: (records) => _OneRmLineChart(
            records: records,
            selectedExercise: _selectedExercise,
          ),
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

/// 1RM 라인 차트 위젯
class _OneRmLineChart extends StatelessWidget {
  final List<Exercise1RMRecord> records;
  final String selectedExercise;

  const _OneRmLineChart({
    required this.records,
    required this.selectedExercise,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final validRecords = records.where((r) => r.estimated1RM > 0).toList();

    if (validRecords.isEmpty) {
      return V2Card(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Center(
          child: Text(
            '$selectedExercise 기록이 없어요',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
      );
    }

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
}
