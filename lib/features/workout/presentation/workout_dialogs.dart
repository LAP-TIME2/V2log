import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/extensions/context_extension.dart';
import 'package:v2log/core/utils/formatters.dart';
import 'package:v2log/core/utils/haptic_feedback.dart';
import 'package:v2log/shared/models/exercise_model.dart';
import 'package:v2log/shared/models/workout_session_model.dart';
import 'package:v2log/shared/models/workout_set_model.dart';
import 'package:v2log/features/workout/domain/timer_provider.dart';
import 'package:v2log/features/profile/domain/user_provider.dart';
import 'package:v2log/features/workout/domain/workout_provider.dart';
import 'package:v2log/shared/widgets/molecules/set_row.dart';
import 'workout_components.dart';

/// 운동 취소 다이얼로그
void showCancelDialog({
  required BuildContext context,
  required WidgetRef ref,
}) {
  final router = GoRouter.of(context);
  final isDark = context.isDarkMode;

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      title: Text(
        '운동 취소',
        style: AppTypography.h4
            .copyWith(color: isDark ? AppColors.darkText : AppColors.lightText),
      ),
      content: Text(
        '진행 중인 운동을 취소하시겠습니까?\n기록된 세트는 저장되지 않습니다.',
        style: AppTypography.bodyMedium.copyWith(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('계속하기'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            await ref.read(activeWorkoutProvider.notifier).cancelWorkout();
            ref.read(workoutTimerProvider.notifier).stop();

            // 루틴 운동 및 인덱스 초기화
            ref.read(routineExercisesProvider.notifier).clear();
            ref.read(currentExerciseIndexProvider.notifier).reset();

            router.go('/home');
          },
          child: Text(
            '취소하기',
            style: TextStyle(color: AppColors.error),
          ),
        ),
      ],
    ),
  );
}

/// 세트 삭제 확인 다이얼로그
void showDeleteConfirmDialog({
  required BuildContext context,
  required WidgetRef ref,
  required WorkoutSetModel set,
}) {
  final isDark = context.isDarkMode;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      title: Text(
        '세트 삭제',
        style: AppTypography.h4
            .copyWith(color: isDark ? AppColors.darkText : AppColors.lightText),
      ),
      content: Text(
        '${set.setNumber}세트를 삭제하시겠습니까?',
        style: AppTypography.bodyMedium.copyWith(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            '취소',
            style: AppTypography.labelLarge.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            AppHaptics.mediumImpact();
            await ref.read(activeWorkoutProvider.notifier).deleteSet(set.id);
          },
          child: Text(
            '삭제',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.error,
            ),
          ),
        ),
      ],
    ),
  );
}

/// 세트 타입 선택 바텀시트
void showSetTypeSelector({
  required BuildContext context,
  required WidgetRef ref,
  required SetType currentSetType,
  required ValueChanged<SetType> onSetTypeChanged,
  required ExerciseModel? supersetPartnerExercise,
  required VoidCallback onSupersetPartnerReset,
  required VoidCallback showSupersetPartnerSelector,
}) {
  final isDark = context.isDarkMode;
  showModalBottomSheet(
    context: context,
    backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusXl),
      ),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '세트 타입',
                style: AppTypography.h4.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...SetType.values.map((type) {
                final isSelected = type == currentSetType;
                return ListTile(
                  leading: SetTypeBadge(type: type),
                  title: Text(
                    type.label,
                    style: AppTypography.bodyLarge.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  subtitle: type == SetType.superset
                      ? Text(
                          '두 운동을 번갈아 수행',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary,
                          ),
                        )
                      : null,
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary500)
                      : null,
                  onTap: () {
                    onSetTypeChanged(type);
                    Navigator.pop(context);

                    // 슈퍼세트 선택 시 파트너 운동 선택 (자유 모드 + 파트너 미선택)
                    if (type == SetType.superset &&
                        supersetPartnerExercise == null) {
                      final session = ref.read(activeWorkoutProvider);
                      if (session?.mode == WorkoutMode.free) {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          showSupersetPartnerSelector();
                        });
                      }
                    }

                    // 슈퍼세트가 아닌 타입 선택 시 파트너 초기화
                    if (type != SetType.superset) {
                      onSupersetPartnerReset();
                    }
                  },
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}

/// 슈퍼세트 파트너 운동 선택 바텀시트
void showSupersetPartnerSelector({
  required BuildContext context,
  required SetType currentSetType,
  required ValueChanged<ExerciseModel> onSelect,
  required VoidCallback onDismissedWithoutSelection,
}) {
  final isDark = context.isDarkMode;
  showModalBottomSheet(
    context: context,
    backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusXl),
      ),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return ExerciseSelectorSheet(
            scrollController: scrollController,
            onSelect: (exercise) {
              onSelect(exercise);
              Navigator.pop(context);
            },
          );
        },
      );
    },
  ).then((_) {
    onDismissedWithoutSelection();
  });
}

/// 운동 선택 바텀시트 (자유 모드용)
void showExerciseSelector({
  required BuildContext context,
  required ValueChanged<ExerciseModel> onSelect,
}) {
  final isDark = context.isDarkMode;
  showModalBottomSheet(
    context: context,
    backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusXl),
      ),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return ExerciseSelectorSheet(
            scrollController: scrollController,
            onSelect: (exercise) {
              onSelect(exercise);
              Navigator.pop(context);
            },
          );
        },
      );
    },
  );
}

/// 메모 입력 다이얼로그
Future<void> showMemoDialog({
  required BuildContext context,
  required String currentNotes,
  required ValueChanged<String> onSave,
}) async {
  final isDark = context.isDarkMode;
  final controller = TextEditingController(text: currentNotes);
  final hasMemo = currentNotes.isNotEmpty;

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      title: Row(
        children: [
          Icon(
            Icons.edit_note,
            color: hasMemo
                ? AppColors.warning
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
            size: 24,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '운동 메모',
            style: AppTypography.h4.copyWith(
                color: isDark ? AppColors.darkText : AppColors.lightText),
          ),
        ],
      ),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLength: 200,
        maxLines: 4,
        style: AppTypography.bodyMedium.copyWith(
          color: isDark ? AppColors.darkText : AppColors.lightText,
        ),
        decoration: InputDecoration(
          hintText: '예: 어깨 통증 발생',
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: isDark
                ? AppColors.darkTextTertiary
                : AppColors.lightTextTertiary,
          ),
          filled: true,
          fillColor:
              isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide.none,
          ),
          counterStyle: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColors.darkTextTertiary
                : AppColors.lightTextTertiary,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            '취소',
            style: AppTypography.labelLarge.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            final newNotes = controller.text.trim();
            onSave(newNotes);
            Navigator.pop(context);
          },
          child: Text(
            '저장',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.primary500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

/// 운동 완료 다이얼로그
void showFinishDialog({
  required BuildContext context,
  required WidgetRef ref,
  required Map<String, String> exerciseNotes,
  required bool isMounted,
}) {
  final session = ref.read(activeWorkoutProvider);
  if (session == null || session.sets.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('최소 1개의 세트를 완료해주세요')),
    );
    return;
  }

  // Provider SSOT 상태 확인 (추가 방어)
  final isFinishing = ref.read(activeWorkoutProvider.notifier).isFinishing;
  if (isFinishing) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('운동 완료 처리 중입니다...')),
    );
    return;
  }

  // WorkoutScreen의 GoRouter를 미리 캡처 (다이얼로그 pop 후 stale context 방지)
  final router = GoRouter.of(context);
  final isDark = context.isDarkMode;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return Consumer(
        builder: (dialogContext, ref, child) {
          // Provider의 finishing 상태 구독
          final finishing =
              ref.read(activeWorkoutProvider.notifier).isFinishing;

          return AlertDialog(
            backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
            title: Text(
              '운동 완료',
              style: AppTypography.h4.copyWith(
                  color:
                      isDark ? AppColors.darkText : AppColors.lightText),
            ),
            content: Text(
              '운동을 완료하시겠습니까?\n총 ${session.sets.length}세트, ${Formatters.volume(session.calculatedVolume)} 볼륨',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed:
                    finishing ? null : () => Navigator.pop(dialogContext),
                child: const Text('계속하기'),
              ),
              TextButton(
                onPressed: finishing
                    ? null
                    : () async {
                        // 다이얼로그 pop 전에 필요한 notifier 참조 캡처
                        final workoutNotifier =
                            ref.read(activeWorkoutProvider.notifier);
                        final timerNotifier =
                            ref.read(workoutTimerProvider.notifier);
                        final routineNotifier =
                            ref.read(routineExercisesProvider.notifier);
                        final indexNotifier =
                            ref.read(currentExerciseIndexProvider.notifier);

                        Navigator.pop(dialogContext);

                        try {
                          // 운동별 메모를 "exerciseId: 메모 / exerciseId: 메모" 형식으로 변환
                          final notesList =
                              exerciseNotes.entries.map((e) {
                            return '${e.key}: ${e.value}';
                          }).toList();
                          final formattedNotes = notesList.isEmpty
                              ? null
                              : notesList.join(' / ');

                          // finishWorkout 내부에서 lock 획득/해제 처리됨
                          final finishedSession =
                              await workoutNotifier.finishWorkout(
                                  notes: formattedNotes);

                          // null 반환 = 중복 호출 차단됨
                          if (finishedSession == null) {
                            if (isMounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('이미 처리 중입니다')),
                              );
                            }
                            return;
                          }

                          timerNotifier.stop();

                          // 루틴 운동 및 인덱스 초기화
                          routineNotifier.clear();
                          indexNotifier.reset();

                          // 기록/통계 Provider 새로고침
                          if (isMounted) {
                            ref.invalidate(workoutHistoryProvider);
                            ref.invalidate(recentWorkoutsProvider);
                            ref.invalidate(weeklyStatsProvider);
                            ref.invalidate(userStatsProvider);
                          }

                          // 요약 화면으로 이동 (GoRouter로 관리되는 라우트)
                          if (isMounted) {
                            router.go('/workout/summary',
                                extra: finishedSession);
                          }

                          // 이동 후 활성 운동 정리 (WorkoutScreen은 이미 대체됨)
                          await workoutNotifier.clearActiveWorkout();
                        } catch (e) {
                          if (isMounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('운동 완료 실패: $e')),
                            );
                          }
                        }
                      },
                child: finishing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.success,
                        ),
                      )
                    : Text(
                        '완료하기',
                        style: TextStyle(color: AppColors.success),
                      ),
              ),
            ],
          );
        },
      );
    },
  );
}
