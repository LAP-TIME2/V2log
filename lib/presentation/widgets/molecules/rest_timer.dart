import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/utils/haptic_feedback.dart';
import '../../../domain/providers/timer_provider.dart';
import '../../../core/utils/animation_config.dart';

/// 휴식 타이머 위젯
class RestTimerWidget extends ConsumerWidget {
  final bool expanded;

  const RestTimerWidget({
    this.expanded = true,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(restTimerProvider);
    final isRunning = timerState.isRunning;

    if (!expanded) {
      return _buildCompact(context, ref, timerState);
    }

    final isComplete = isRunning && timerState.remainingSeconds <= 0;

    return AnimatedContainer(
      duration: AnimationConfig.fast,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: isComplete
            ? Border.all(color: AppColors.success, width: 2)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 타이머 표시
          Stack(
            alignment: Alignment.center,
            children: [
              // 진행률 원형 표시
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: isRunning ? timerState.progress : 0,
                  strokeWidth: 8,
                  backgroundColor: context.borderColor,
                  valueColor: AlwaysStoppedAnimation(
                    isRunning ? AppColors.primary500 : context.textTertiaryColor,
                  ),
                ),
              ),
              // 시간 텍스트
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timerState.formattedTime,
                    style: AppTypography.timer.copyWith(
                      color: isRunning
                          ? AppColors.primary500
                          : context.textSecondaryColor,
                    ),
                  ),
                  if (isRunning) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '휴식 중',
                      style: AppTypography.labelMedium.copyWith(
                        color: context.textSecondaryColor,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // 컨트롤 버튼들
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TimerButton(
                icon: Icons.remove,
                label: '-15초',
                onTap: () {
                  AppHaptics.lightImpact();
                  ref.read(restTimerProvider.notifier).addTime(-15);
                },
              ),
              const SizedBox(width: AppSpacing.md),
              // 시작/일시정지
              _TimerButton(
                icon: timerState.isPaused
                    ? Icons.play_arrow
                    : (isRunning ? Icons.pause : Icons.play_arrow),
                label: timerState.isPaused
                    ? '재개'
                    : (isRunning ? '일시정지' : '시작'),
                isPrimary: true,
                onTap: () {
                  AppHaptics.mediumImpact();
                  if (timerState.isPaused) {
                    ref.read(restTimerProvider.notifier).resume();
                  } else if (isRunning) {
                    ref.read(restTimerProvider.notifier).pause();
                  } else {
                    ref.read(restTimerProvider.notifier).start();
                  }
                },
              ),
              const SizedBox(width: AppSpacing.md),
              _TimerButton(
                icon: Icons.add,
                label: '+15초',
                onTap: () {
                  AppHaptics.lightImpact();
                  ref.read(restTimerProvider.notifier).addTime(15);
                },
              ),
              const SizedBox(width: AppSpacing.md),
              _TimerButton(
                icon: Icons.skip_next,
                label: '건너뛰기',
                onTap: () {
                  ref.read(restTimerProvider.notifier).skip();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompact(
    BuildContext context,
    WidgetRef ref,
    RestTimerState timerState,
  ) {
    final isRunning = timerState.isRunning;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isRunning
            ? AppColors.primary500.withValues(alpha: 0.1)
            : context.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: isRunning
            ? Border.all(color: AppColors.primary500, width: 1)
            : null,
      ),
      child: Row(
        children: [
          // 타이머 아이콘
          Icon(
            Icons.timer,
            color: isRunning ? AppColors.primary500 : context.textSecondaryColor,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),

          // 시간
          Text(
            timerState.formattedTime,
            style: AppTypography.timerSmall.copyWith(
              color: isRunning ? AppColors.primary500 : context.textSecondaryColor,
              fontSize: 24,
            ),
          ),

          const Spacer(),

          // 버튼들
          if (isRunning) ...[
            IconButton(
              icon: const Icon(Icons.remove, size: 20),
              onPressed: () {
                ref.read(restTimerProvider.notifier).addTime(-15);
              },
              color: context.textSecondaryColor,
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: Icon(
                timerState.isPaused ? Icons.play_arrow : Icons.pause,
                size: 20,
              ),
              onPressed: () {
                if (timerState.isPaused) {
                  ref.read(restTimerProvider.notifier).resume();
                } else {
                  ref.read(restTimerProvider.notifier).pause();
                }
              },
              color: AppColors.primary500,
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 20),
              onPressed: () {
                ref.read(restTimerProvider.notifier).addTime(15);
              },
              color: context.textSecondaryColor,
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () {
                ref.read(restTimerProvider.notifier).skip();
              },
              color: context.textTertiaryColor,
              visualDensity: VisualDensity.compact,
            ),
          ] else ...[
            TextButton.icon(
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('휴식 시작'),
              onPressed: () {
                ref.read(restTimerProvider.notifier).start();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 타이머 버튼
class _TimerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _TimerButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: isPrimary ? AppColors.primary500 : context.cardElevatedColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: Container(
              width: isPrimary ? 56 : 44,
              height: isPrimary ? 56 : 44,
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: isPrimary ? Colors.white : context.textColor,
                size: isPrimary ? 28 : 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: context.textTertiaryColor,
          ),
        ),
      ],
    );
  }
}
