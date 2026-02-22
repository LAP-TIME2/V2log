import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/extensions/context_extension.dart';
import 'package:v2log/core/utils/formatters.dart';
import 'package:v2log/core/utils/haptic_feedback.dart';
import 'package:v2log/shared/dummy/dummy_exercises.dart';
import 'package:v2log/shared/models/exercise_model.dart';
import 'package:v2log/shared/models/preset_routine_model.dart';
import 'package:v2log/shared/models/workout_session_model.dart';
import 'package:v2log/shared/models/workout_set_model.dart';
import 'package:v2log/features/workout/domain/timer_provider.dart';
import 'package:v2log/features/workout/domain/workout_provider.dart';
import 'package:v2log/shared/widgets/atoms/v2_button.dart';
import 'package:v2log/shared/widgets/molecules/quick_input_control.dart';
import 'package:v2log/features/workout/presentation/camera_overlay.dart';
import 'package:v2log/shared/widgets/molecules/rest_timer.dart';
import 'package:v2log/shared/widgets/molecules/set_row.dart';

import 'workout_dialogs.dart';
import 'workout_components.dart';
import 'package:v2log/features/workout/domain/workout_input_provider.dart';

/// 운동 진행 화면 (빠른 기록 UI)
class WorkoutScreen extends ConsumerStatefulWidget {
  final String? sessionId;

  const WorkoutScreen({
    this.sessionId,
    super.key,
  });

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  // CV 모드 (카메라 횟수 자동 카운팅)
  bool _cvModeEnabled = false;

  // Phase 2B: AI 무게 감지 상태
  bool _weightAutoDetected = false;
  double _detectedWeightConfidence = 0.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(activeWorkoutProvider);
      if (session != null) {
        // 세션 타이머 시작
        ref.read(workoutTimerProvider.notifier).startFrom(session.startedAt);

        // 프리셋 모드면 루틴 운동 로드
        if (session.mode == WorkoutMode.preset && session.routineId != null) {
          ref.read(routineExercisesProvider.notifier).loadFromRoutine(
            session.routineId!,
            dayNumber: 1,
          );
        } else {
          // 자유 모드면 기본 운동 설정
          ref.read(workoutInputProvider.notifier).setFreeExercise(
            DummyExercises.exercises.first,
          );
        }
      }
    });
  }

  /// 현재 운동 가져오기
  ExerciseModel? _getCurrentExercise(WorkoutSessionModel session) {
    if (session.mode == WorkoutMode.preset) {
      final routineExercise = ref.watch(currentRoutineExerciseProvider);
      return routineExercise?.exercise;
    }
    return ref.watch(workoutInputProvider).freeExercise;
  }

  /// 현재 운동 ID 가져오기
  String? _getCurrentExerciseId(WorkoutSessionModel session) {
    if (session.mode == WorkoutMode.preset) {
      final routineExercise = ref.watch(currentRoutineExerciseProvider);
      return routineExercise?.exercise?.id ?? routineExercise?.exerciseId;
    }
    return ref.watch(workoutInputProvider).freeExercise?.id;
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeWorkoutProvider);
    final workoutTimer = ref.watch(workoutTimerProvider);
    final routineExercises = ref.watch(routineExercisesProvider);
    final currentExerciseIndex = ref.watch(currentExerciseIndexProvider);
    final input = ref.watch(workoutInputProvider);

    final isDark = context.isDarkMode;

    if (session == null) {
      // 진행 중인 운동이 없으면 빈 로딩 UI 표시 (요약 화면으로 이동 후 정리됨)
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary500),
        ),
      );
    }

    final currentExercise = _getCurrentExercise(session);
    final currentExerciseId = _getCurrentExerciseId(session);
    final currentSets = currentExerciseId != null
        ? ref.watch(exerciseSetsProvider(currentExerciseId))
        : <WorkoutSetModel>[];

    // 프리셋 모드에서 루틴 운동 로딩 중
    if (session.mode == WorkoutMode.preset && routineExercises.isEmpty) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        appBar: _buildAppBar(context, session, workoutTimer, isDark),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary500),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: _buildAppBar(context, session, workoutTimer, isDark),
      body: Column(
        children: [
          // 상단 고정 영역 (스크롤 안 됨)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 운동 진행 상태 표시 (프리셋 모드)
              if (session.mode == WorkoutMode.preset && routineExercises.isNotEmpty)
                _buildExerciseProgress(routineExercises, currentExerciseIndex, isDark),

              // 운동 가이드 영역
              _buildExerciseHeader(session, currentExercise, isDark),
            ],
          ),

          // CV 카메라 오버레이 (AI 횟수 카운팅)
          if (_cvModeEnabled)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
              child: CameraOverlay(
                exerciseNameEn: currentExercise?.nameEn,
                exerciseName: currentExercise?.name,
                completedSets: currentSets.length,
                enableWeightDetection: true,
                onRepsDetected: (reps, confidence) {
                  if (confidence >= 0.7) {
                    ref.read(workoutInputProvider.notifier).setReps(reps);
                  }
                },
                onWeightDetected: (weight, confidence) {
                  ref.read(workoutInputProvider.notifier).setWeight(weight);
                  setState(() {
                    _weightAutoDetected = true;
                    _detectedWeightConfidence = confidence;
                  });
                },
              ),
            ),

          // 세트 기록 리스트 (스크롤 가능)
          Expanded(
            child: _buildSetList(currentSets, input, isDark),
          ),

          // 하단 고정 영역 (스크롤 안 됨)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 휴식 타이머 (컴팩트)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: RestTimerWidget(expanded: false),
              ),

              // 강도 존 표시바
              if (currentExerciseId != null && input.currentWeight > 0)
                IntensityZoneIndicator(
                  currentWeight: input.currentWeight,
                  exerciseId: currentExerciseId,
                  currentSets: currentSets,
                ),

              // AI 무게 감지 뱃지 (Phase 2B)
              if (_weightAutoDetected)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary500.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: AppColors.primary500.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, size: 14, color: AppColors.primary500),
                      const SizedBox(width: 4),
                      Text(
                        'AI 감지 ${(_detectedWeightConfidence * 100).toInt()}%',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => setState(() => _weightAutoDetected = false),
                        child: Icon(Icons.close, size: 14, color: AppColors.primary500.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                ),

              // 빠른 입력 컨트롤
              QuickInputControl(
                weight: input.currentWeight,
                reps: input.currentReps,
                previousWeight: currentSets.isNotEmpty ? currentSets.last.weight : null,
                previousReps: currentSets.isNotEmpty ? currentSets.last.reps : null,
                onWeightChanged: (value) {
                  ref.read(workoutInputProvider.notifier).setWeight(value);
                  setState(() => _weightAutoDetected = false); // 수동 조작 시 AI 뱃지 해제
                },
                onRepsChanged: (value) => ref.read(workoutInputProvider.notifier).setReps(value),
              ),

              // 세트 완료 버튼 + 다음 운동 버튼
              _buildBottomButtons(session, routineExercises, currentExerciseIndex, currentSets, isDark),
            ],
          ),
        ],
      ),
    );
  }

  /// 운동 진행 상태 표시 (1/6 운동)
  Widget _buildExerciseProgress(
    List<PresetRoutineExerciseModel> exercises,
    int currentIndex,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      color: isDark ? AppColors.darkCard : AppColors.lightCard,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '운동 ${currentIndex + 1}/${exercises.length}',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary500,
                ),
              ),
              Text(
                '${((currentIndex + 1) / exercises.length * 100).toInt()}%',
                style: AppTypography.labelMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // 진행바
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: (currentIndex + 1) / exercises.length,
              backgroundColor: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary500),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    dynamic session,
    int workoutTimer,
    bool isDark,
  ) {
    return AppBar(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => showCancelDialog(context: context, ref: ref),
      ),
      title: Column(
        children: [
          Text(
            session.mode.label,
            style: AppTypography.labelMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          Text(
            Formatters.timerLong(workoutTimer),
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.primary500,
            ),
          ),
        ],
      ),
      actions: [
        // CV 모드 토글
        IconButton(
          icon: Icon(
            _cvModeEnabled ? Icons.videocam : Icons.videocam_off_outlined,
            color: _cvModeEnabled ? AppColors.primary500 : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          onPressed: () => setState(() {
            _cvModeEnabled = !_cvModeEnabled;
            if (!_cvModeEnabled) {
              _weightAutoDetected = false; // CV 끄면 AI 뱃지도 해제
            }
          }),
          tooltip: 'AI 횟수 카운팅 + 무게 감지',
        ),
        TextButton(
          onPressed: () => showFinishDialog(
            context: context,
            ref: ref,
            exerciseNotes: ref.read(workoutInputProvider).exerciseNotes,
            isMounted: mounted,
          ),
          child: Text(
            '완료',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.success,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseHeader(WorkoutSessionModel session, ExerciseModel? exercise, bool isDark) {
    if (exercise == null) {
      // 프리셋 모드에서 운동 정보 로딩 중
      final routineExercise = ref.watch(currentRoutineExerciseProvider);
      if (routineExercise != null) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            border: Border(
              bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary500.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: AppColors.primary500,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routineExercise.exercise?.name ?? '운동 ${routineExercise.orderIndex + 1}',
                      style: AppTypography.h4.copyWith(color: isDark ? AppColors.darkText : AppColors.lightText),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      routineExercise.setsRepsText,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    }

    final input = ref.watch(workoutInputProvider);

    return ExerciseGuideCard(
      exercise: exercise,
      session: session,
      notes: _getCurrentExerciseNotes(),
      onEditNotes: () => showMemoDialog(
        context: context,
        currentNotes: _getCurrentExerciseNotes(),
        onSave: (notes) => _setCurrentExerciseNotes(notes),
      ),
      onChangeExercise: session.mode == WorkoutMode.free
          ? () => showExerciseSelector(
                context: context,
                onSelect: (exercise) {
                  ref.read(workoutInputProvider.notifier).setFreeExercise(exercise);
                  ref.read(workoutInputProvider.notifier).resetSupersetState();
                },
              )
          : null,
      routineExercise: session.mode == WorkoutMode.preset
          ? ref.watch(currentRoutineExerciseProvider)
          : null,
      supersetPartner: input.supersetPartnerExercise,
      isDark: isDark,
    );
  }

  Widget _buildSetList(List<WorkoutSetModel> sets, WorkoutInputState input, bool isDark) {
    return Column(
      children: [
        // 헤더
        const SetRowHeader(),

        // 세트 리스트
        Expanded(
          child: sets.isEmpty
              ? _buildEmptySetMessage(input, isDark)
              : ListView.builder(
                  itemCount: sets.length + 1, // +1 for current set
                  itemBuilder: (context, index) {
                    if (index < sets.length) {
                      final set = sets[index];
                      // 세션 내 최고 무게 세트에만 PR 표시
                      final isSessionPr = _isSessionMaxWeightSet(set, sets);
                      return SetRow(
                        setNumber: set.setNumber,
                        setType: set.setType,
                        weight: set.weight,
                        reps: set.reps,
                        isCompleted: true,
                        isPr: isSessionPr,
                        onLongPress: () => showDeleteConfirmDialog(
                          context: context,
                          ref: ref,
                          set: set,
                        ),
                      );
                    }
                    // 현재 입력 중인 세트
                    return SetRow(
                      setNumber: sets.length + 1,
                      setType: input.currentSetType,
                      weight: input.currentWeight,
                      reps: input.currentReps,
                      isCurrent: true,
                      onTap: () => _handleSetTypeTap(),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// 세션 내 최고 무게 세트인지 확인 (같은 무게면 첫 번째만 PR)
  bool _isSessionMaxWeightSet(WorkoutSetModel set, List<WorkoutSetModel> allSets) {
    // 같은 운동의 세트만 필터링
    final exerciseSets = allSets.where((s) => s.exerciseId == set.exerciseId).toList();
    if (exerciseSets.isEmpty) return false;

    // setNumber 순으로 정렬
    exerciseSets.sort((a, b) => a.setNumber.compareTo(b.setNumber));

    // 최고 무게 찾기
    double maxWeight = exerciseSets
        .map((s) => s.weight)
        .where((w) => w != null)
        .fold<double>(0, (max, w) => w! > max ? w : max);

    if (maxWeight == 0) return false;

    // 최고 무게를 가진 첫 번째 세트인지 확인
    for (final s in exerciseSets) {
      if (s.weight == maxWeight) {
        return s.id == set.id; // 첫 번째 최고 무게 세트만 true
      }
    }

    return false;
  }

  Widget _buildEmptySetMessage(WorkoutInputState input, bool isDark) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 현재 세트 (입력 대기)
          SetRow(
            setNumber: 1,
            setType: input.currentSetType,
            weight: input.currentWeight,
            reps: input.currentReps,
            isCurrent: true,
            onTap: () => _handleSetTypeTap(),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '첫 세트를 완료해보세요!',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(
    WorkoutSessionModel session,
    List<PresetRoutineExerciseModel> routineExercises,
    int currentExerciseIndex,
    List<WorkoutSetModel> currentSets,
    bool isDark,
  ) {
    final isPresetMode = session.mode == WorkoutMode.preset;
    final isLastExercise = currentExerciseIndex >= routineExercises.length - 1;
    final routineExercise = isPresetMode ? ref.watch(currentRoutineExerciseProvider) : null;
    final targetSets = routineExercise?.targetSets ?? 3;
    final completedSets = currentSets.length;
    final isTargetReached = completedSets >= targetSets;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        border: Border(
          top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 세트 완료 버튼
            V2Button.primary(
              text: isPresetMode ? '완료 $completedSets/$targetSets' : '세트 완료',
              icon: Icons.check_circle,
              onPressed: _completeSet,
              fullWidth: true,
            ),

            // 프리셋 모드에서 다음 운동 버튼
            if (isPresetMode && routineExercises.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  // 이전 운동 버튼
                  if (currentExerciseIndex > 0)
                    Expanded(
                      child: V2Button.outline(
                        text: '이전',
                        icon: Icons.arrow_back,
                        onPressed: () {
                          ref.read(currentExerciseIndexProvider.notifier).previous();
                        },
                      ),
                    ),
                  if (currentExerciseIndex > 0) const SizedBox(width: AppSpacing.sm),

                  // 다음 운동 버튼
                  Expanded(
                    child: isLastExercise
                        ? V2Button.secondary(
                            text: '완료',
                            icon: Icons.flag,
                            onPressed: () => showFinishDialog(
                              context: context,
                              ref: ref,
                              exerciseNotes: ref.read(workoutInputProvider).exerciseNotes,
                              isMounted: mounted,
                            ),
                          )
                        : V2Button.secondary(
                            text: isTargetReached ? '다음' : '다음으로',
                            icon: Icons.arrow_forward,
                            onPressed: () {
                              ref.read(currentExerciseIndexProvider.notifier).next();
                            },
                          ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _completeSet() async {
    final session = ref.read(activeWorkoutProvider);
    if (session == null) return;

    final exerciseId = _getCurrentExerciseId(session);
    if (exerciseId == null) return;

    final input = ref.read(workoutInputProvider);

    AppHaptics.heavyImpact();

    try {
      await ref.read(activeWorkoutProvider.notifier).addSet(
            exerciseId: exerciseId,
            weight: input.currentWeight,
            reps: input.currentReps,
            setType: input.currentSetType,
          );

      // 슈퍼세트 모드: 운동 A <-> B 자동 전환
      if (input.currentSetType == SetType.superset &&
          input.supersetPartnerExercise != null &&
          session.mode == WorkoutMode.free) {
        ref.read(workoutInputProvider.notifier).swapSupersetExercises();

        // 파트너 운동 완료 후(=메인으로 돌아올 때)만 휴식 타이머 시작
        final updatedInput = ref.read(workoutInputProvider);
        if (!updatedInput.supersetIsOnPartner) {
          ref.read(restTimerProvider.notifier).start();
        }
      } else {
        // 일반 모드: 항상 휴식 타이머 시작
        ref.read(restTimerProvider.notifier).start();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  /// 세트 타입 선택 핸들러
  void _handleSetTypeTap() {
    final input = ref.read(workoutInputProvider);
    showSetTypeSelector(
      context: context,
      ref: ref,
      currentSetType: input.currentSetType,
      onSetTypeChanged: (type) {
        ref.read(workoutInputProvider.notifier).setSetType(type);
      },
      supersetPartnerExercise: input.supersetPartnerExercise,
      onSupersetPartnerReset: () {
        ref.read(workoutInputProvider.notifier).setSupersetPartnerExercise(null);
        ref.read(workoutInputProvider.notifier).setSupersetIsOnPartner(false);
      },
      showSupersetPartnerSelector: () {
        if (mounted) {
          showSupersetPartnerSelector(
            context: context,
            currentSetType: ref.read(workoutInputProvider).currentSetType,
            onSelect: (exercise) {
              ref.read(workoutInputProvider.notifier).setSupersetPartnerExercise(exercise);
              ref.read(workoutInputProvider.notifier).setSupersetIsOnPartner(false);
            },
            onDismissedWithoutSelection: () {
              final currentInput = ref.read(workoutInputProvider);
              if (currentInput.supersetPartnerExercise == null &&
                  currentInput.currentSetType == SetType.superset) {
                ref.read(workoutInputProvider.notifier).setSetType(SetType.working);
              }
            },
          );
        }
      },
    );
  }

  /// 현재 운동의 메모 가져오기
  String _getCurrentExerciseNotes() {
    final session = ref.read(activeWorkoutProvider);
    if (session == null) return '';
    final exerciseId = _getCurrentExerciseId(session);
    if (exerciseId == null) return '';
    return ref.read(workoutInputProvider.notifier).getExerciseNote(exerciseId);
  }

  /// 현재 운동의 메모 저장
  void _setCurrentExerciseNotes(String notes) {
    final session = ref.read(activeWorkoutProvider);
    if (session == null) return;
    final exerciseId = _getCurrentExerciseId(session);
    if (exerciseId == null) return;
    ref.read(workoutInputProvider.notifier).setExerciseNote(exerciseId, notes);
  }
}
