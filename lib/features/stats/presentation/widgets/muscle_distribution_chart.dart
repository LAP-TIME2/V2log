import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:v2log/core/extensions/context_extension.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/utils/fitness_calculator.dart';
import 'package:v2log/features/profile/domain/user_provider.dart';
import 'package:v2log/shared/widgets/atoms/v2_card.dart';

/// 강도 분석 섹션
class IntensityZoneSection extends ConsumerWidget {
  const IntensityZoneSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDarkMode;
    final intensityAsync = ref.watch(intensityZoneDistributionProvider);

    return intensityAsync.when(
      data: (distribution) => _IntensityZoneCard(distribution: distribution),
      loading: () => const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary500),
        ),
      ),
      error: (_, __) => _buildErrorCard(isDark),
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

/// 강도 분석 카드
class _IntensityZoneCard extends StatelessWidget {
  final IntensityZoneDistribution distribution;

  const _IntensityZoneCard({required this.distribution});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    if (distribution.totalSets == 0) {
      return V2Card(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Center(
          child: Text(
            '최근 30일 운동 기록이 없어요',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
      );
    }

    final zoneOrder = [
      IntensityZone.hypertrophy,
      IntensityZone.strength,
      IntensityZone.maxStrength,
      IntensityZone.endurance,
      IntensityZone.warmup,
    ];

    final sortedZones = [...zoneOrder]..sort((a, b) {
      final countA = distribution.setCountByZone[a] ?? 0;
      final countB = distribution.setCountByZone[b] ?? 0;
      return countB.compareTo(countA);
    });

    final total = distribution.totalSets;
    final maxCount = sortedZones
        .map((z) => distribution.setCountByZone[z] ?? 0)
        .fold<int>(0, (max, count) => count > max ? count : max);

    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 가로 누적 막대
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 28,
              child: Row(
                children: zoneOrder.map((zone) {
                  final count = distribution.setCountByZone[zone] ?? 0;
                  if (count == 0) return const SizedBox.shrink();
                  final ratio = count / total;
                  return Expanded(
                    flex: (ratio * 1000).round().clamp(1, 1000),
                    child: Container(
                      color: zone.color,
                      alignment: Alignment.center,
                      child: ratio >= 0.1
                          ? Text(
                              '${(ratio * 100).round()}%',
                              style: AppTypography.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // 존 범례 (가로)
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xs,
            children: zoneOrder.map((zone) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: zone.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    zone.label,
                    style: AppTypography.caption.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.xl),
          Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          const SizedBox(height: AppSpacing.lg),

          // 존별 상세 리스트 (세트 수 내림차순)
          ...sortedZones.map((zone) {
            final count = distribution.setCountByZone[zone] ?? 0;
            final percentage = total > 0 ? (count / total) : 0.0;
            final barRatio = maxCount > 0 ? (count / maxCount) : 0.0;

            return _IntensityZoneRow(
              zone: zone,
              count: count,
              percentage: percentage,
              barRatio: barRatio,
              isDark: isDark,
            );
          }),
        ],
      ),
    );
  }
}

/// 운동 빈도 섹션 (부위별 + 운동별 TOP 5)
class MuscleFrequencySection extends ConsumerWidget {
  const MuscleFrequencySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDarkMode;
    final muscleFrequencyAsync = ref.watch(muscleFrequencyProvider);
    final exerciseFrequencyAsync = ref.watch(exerciseFrequencyProvider);

    return Column(
      children: [
        muscleFrequencyAsync.when(
          data: (frequencies) => _MuscleFrequencyCard(frequencies: frequencies),
          loading: () => const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary500),
            ),
          ),
          error: (_, __) => _buildErrorCard(isDark),
        ),

        const SizedBox(height: AppSpacing.lg),

        exerciseFrequencyAsync.when(
          data: (frequencies) => _ExerciseFrequencyCard(frequencies: frequencies),
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

/// 부위별 운동 빈도 카드
class _MuscleFrequencyCard extends StatelessWidget {
  final List<MuscleFrequency> frequencies;

  const _MuscleFrequencyCard({required this.frequencies});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

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
          }),
        ],
      ),
    );
  }
}

/// 운동별 빈도 TOP 5 카드
class _ExerciseFrequencyCard extends StatelessWidget {
  final List<ExerciseFrequency> frequencies;

  const _ExerciseFrequencyCard({required this.frequencies});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

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
          }),
        ],
      ),
    );
  }

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

/// 강도 존 행 위젯
class _IntensityZoneRow extends StatelessWidget {
  final IntensityZone zone;
  final int count;
  final double percentage;
  final double barRatio;
  final bool isDark;

  const _IntensityZoneRow({
    required this.zone,
    required this.count,
    required this.percentage,
    required this.barRatio,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: zone.color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  zone.label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ),
              Text(
                zone.suggestedReps,
                style: AppTypography.caption.copyWith(
                  color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${count}세트',
                style: AppTypography.labelMedium.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '(${(percentage * 100).round()}%)',
                style: AppTypography.caption.copyWith(
                  color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: barRatio,
              backgroundColor: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
              valueColor: AlwaysStoppedAnimation<Color>(zone.color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
