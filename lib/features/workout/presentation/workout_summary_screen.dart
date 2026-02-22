import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/extensions/context_extension.dart';
import 'package:v2log/core/utils/fitness_calculator.dart';
import 'package:v2log/core/utils/formatters.dart';
import 'package:v2log/core/utils/workout_share_utils.dart';
import 'package:v2log/shared/dummy/dummy_exercises.dart';
import 'package:v2log/shared/dummy/dummy_preset_routines.dart';
import 'package:v2log/shared/models/workout_session_model.dart';
import 'package:v2log/shared/models/workout_set_model.dart';
import 'package:v2log/features/workout/domain/workout_provider.dart';
import 'package:v2log/shared/widgets/atoms/animated_wrappers.dart';
import 'package:v2log/shared/widgets/atoms/v2_button.dart';
import 'package:v2log/shared/widgets/atoms/v2_card.dart';
import 'package:v2log/shared/widgets/molecules/workout_share_card.dart';

/// 운동 완료 요약 화면
class WorkoutSummaryScreen extends ConsumerStatefulWidget {
  final WorkoutSessionModel session;

  const WorkoutSummaryScreen({
    required this.session,
    super.key,
  });

  @override
  ConsumerState<WorkoutSummaryScreen> createState() => _WorkoutSummaryScreenState();
}

class _WorkoutSummaryScreenState extends ConsumerState<WorkoutSummaryScreen>
    with TickerProviderStateMixin {
  /// 공유 중 여부
  bool _isSharing = false;

  late final AnimationController _badgeController;
  late final Animation<double> _badgeScale;
  late final AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _badgeScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.elasticOut),
    );
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 순차 실행
    _badgeController.forward().then((_) {
      if (widget.session.sets.any((s) => s.isPr)) {
        _confettiController.forward();
      }
    });
  }

  @override
  void dispose() {
    _badgeController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exerciseNamesAsync = ref.watch(exerciseNamesMapProvider);
    final exerciseNames = exerciseNamesAsync.valueOrNull ?? {};

    final duration = widget.session.duration ?? Duration.zero;
    final totalVolume = widget.session.calculatedVolume;
    final totalSets = widget.session.sets.length;
    final prSets = widget.session.sets.where((s) => s.isPr).toList();

    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xxl),

              // 완료 아이콘
              _buildCompletionBadge(),
              const SizedBox(height: AppSpacing.xl),

              // 축하 메시지
              Text(
                '운동 완료!',
                style: AppTypography.h1.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _getMotivationalMessage(totalSets, prSets.length),
                style: AppTypography.bodyLarge.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // 주요 통계
              _buildMainStats(duration, totalVolume, totalSets, isDark),
              const SizedBox(height: AppSpacing.xl),

              // PR 달성 (있는 경우)
              if (prSets.isNotEmpty) ...[
                _buildPrSection(prSets, exerciseNames, isDark),
                const SizedBox(height: AppSpacing.xl),
              ],

              // 운동별 요약
              _buildExerciseSummary(exerciseNames, isDark),
              const SizedBox(height: AppSpacing.xxl),

              // 버튼들
              _buildActionButtons(context, isDark),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionBadge() {
    return AnimatedBuilder(
      animation: _badgeScale,
      builder: (context, child) {
        return Transform.scale(
          scale: _badgeScale.value,
          child: child,
        );
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.success, AppColors.success.withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.check,
          size: 64,
          color: Colors.white,
        ),
      ),
    );
  }

  String _getMotivationalMessage(int sets, int prs) {
    if (prs > 0) {
      return '오늘 $prs개의 개인 기록을 달성했어요! 대단해요!';
    }
    if (sets >= 20) {
      return '정말 열심히 했어요! 최고의 운동이었습니다!';
    }
    if (sets >= 10) {
      return '좋은 운동이었어요! 꾸준함이 실력입니다.';
    }
    return '오늘도 운동 완료! 내일도 파이팅!';
  }

  Widget _buildMainStats(Duration duration, double volume, int sets, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            icon: Icons.timer_outlined,
            label: '운동 시간',
            value: Formatters.duration(duration),
            numericValue: duration.inMinutes.toDouble(),
            suffix: '분',
            color: AppColors.primary500,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatBox(
            icon: Icons.fitness_center,
            label: '총 볼륨',
            value: Formatters.volume(volume),
            numericValue: volume,
            suffix: 'kg',
            color: AppColors.secondary500,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatBox(
            icon: Icons.repeat,
            label: '총 세트',
            value: '$sets세트',
            numericValue: sets.toDouble(),
            suffix: '세트',
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildPrSection(List<WorkoutSetModel> prSets, Map<String, String> exerciseNames, bool isDark) {
    return V2Card(
      backgroundColor: AppColors.warning.withValues(alpha: 0.1),
      borderColor: AppColors.warning,
      borderWidth: 1,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                '개인 기록 달성!',
                style: AppTypography.h4.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...prSets.map((set) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.warning,
                      size: 16,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        '${_getExerciseName(set.exerciseId, exerciseNames)}: ${set.weight}kg x ${set.reps}회',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  /// widget.session.notes에서 운동별 메모를 추출하고 exercise_id를 key로 사용
  Map<String, String> _parseExerciseNotes(Map<String, String> exerciseNames) {
    final Map<String, String> exerciseNotes = {};
    if (widget.session.notes == null || widget.session.notes!.isEmpty) {
      return exerciseNotes;
    }

    // "exerciseId: 메모 / exerciseId: 메모" 형식 파싱
    final parts = widget.session.notes!.split(' / ');
    for (final part in parts) {
      final colonIndex = part.indexOf(':');
      if (colonIndex > 0) {
        final exerciseId = part.substring(0, colonIndex).trim();
        final note = part.substring(colonIndex + 1).trim();
        exerciseNotes[exerciseId] = note;
      }
    }
    return exerciseNotes;
  }

  Widget _buildExerciseSummary(Map<String, String> exerciseNames, bool isDark) {
    final exerciseGroups = widget.session.setsByExercise;
    final parsedNotes = _parseExerciseNotes(exerciseNames);

    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '운동별 요약',
            style: AppTypography.h4.copyWith(
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...exerciseGroups.entries.map((entry) {
            final exerciseId = entry.key;
            final sets = entry.value;
            // 웜업 제외 볼륨 계산
            final totalVolume = sets.fold<double>(
                0, (sum, s) => s.setType == SetType.warmup ? sum : sum + (s.weight ?? 0) * (s.reps ?? 0));
            final maxWeight = sets
                .map((s) => s.weight ?? 0)
                .fold<double>(0, (a, b) => a > b ? a : b);
            final exerciseName = _getExerciseName(exerciseId, exerciseNames);
            // exercise_id로 메모 매칭
            final exerciseNote = parsedNotes[exerciseId];

            // 강도 존 계산: working set 평균 무게 기준
            final workingSets = sets.where((s) => s.setType != SetType.warmup && (s.weight ?? 0) > 0).toList();
            IntensityZone? intensityZone;
            if (workingSets.isNotEmpty && maxWeight > 0) {
              final avgWeight = workingSets.fold<double>(0, (sum, s) => sum + (s.weight ?? 0)) / workingSets.length;
              // 세션 내 best set 기반 1RM 추정
              double best1rm = 0;
              for (final s in workingSets) {
                if ((s.weight ?? 0) > 0 && (s.reps ?? 0) > 0) {
                  final est = FitnessCalculator.calculate1RM(s.weight!, s.reps!);
                  if (est > best1rm) best1rm = est;
                }
              }
              if (best1rm > 0) {
                intensityZone = FitnessCalculator.analyzeIntensity(avgWeight, best1rm);
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary500.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          color: AppColors.primary500,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    exerciseName,
                                    style: AppTypography.labelLarge.copyWith(
                                      color: isDark ? AppColors.darkText : AppColors.lightText,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (intensityZone != null) ...[
                                  const SizedBox(width: AppSpacing.sm),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: intensityZone.color.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      intensityZone.label,
                                      style: AppTypography.labelSmall.copyWith(
                                        color: intensityZone.color,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              '${sets.length}세트 • 최고 ${maxWeight}kg • 볼륨 ${Formatters.volume(totalVolume)}',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // 세트 타입별 요약
                  Wrap(
                    spacing: AppSpacing.xs,
                    children: _buildSetTypeBadges(sets, isDark),
                  ),
                  // 해당 운동의 메모 표시
                  if (exerciseNote != null && exerciseNote.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm, left: 52),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_note,
                            size: 14,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              '📝 $exerciseNote',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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

  /// 세트 타입별 뱃지 목록 생성
  /// "웜업 1 / 본세트 2" 형식으로 표시
  List<Widget> _buildSetTypeBadges(List<WorkoutSetModel> sets, bool isDark) {
    final typeCounts = <SetType, int>{};
    for (final set in sets) {
      typeCounts[set.setType] = (typeCounts[set.setType] ?? 0) + 1;
    }

    // 세트 타입별 문자열 생성: "웜업 1 / 본세트 2"
    final typeLabels = <String>[];
    for (final entry in typeCounts.entries) {
      typeLabels.add('${entry.key.label} ${entry.value}');
    }

    if (typeLabels.isEmpty) {
      return [];
    }

    return [
      Text(
        typeLabels.join(' / '),
        style: AppTypography.bodySmall.copyWith(
          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          fontSize: 11,
        ),
      ),
    ];
  }

  String _getExerciseName(String exerciseId, Map<String, String> exerciseNames) {
    // 전달받은 exerciseNames 맵에서 먼저 찾기 (Supabase 데이터)
    if (exerciseNames.containsKey(exerciseId)) {
      return exerciseNames[exerciseId]!;
    }

    // DummyExercises에서 찾기
    final exercise = DummyExercises.getById(exerciseId);
    if (exercise != null) {
      return exercise.name;
    }

    // DummyPresetRoutines에서 찾기
    final presetExercise = DummyPresetRoutines.getExerciseById(exerciseId);
    if (presetExercise != null) {
      return presetExercise.name;
    }

    // 못 찾으면 ID의 앞 8자리만 표시 (UUID인 경우)
    if (exerciseId.length > 8 && exerciseId.contains('-')) {
      return '운동 ${exerciseId.substring(0, 8)}';
    }

    return exerciseId;
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Column(
      children: [
        V2Button.primary(
          text: '홈으로 돌아가기',
          icon: Icons.home,
          onPressed: () {
            // GoRouter.go()가 선언적으로 전체 라우트 스택 교체
            // popUntil 사용 금지: MaterialPageRoute + ProviderScope 충돌로 _dependents.isEmpty 에러 발생
            GoRouter.of(context).go('/home');
          },
          fullWidth: true,
        ),
        const SizedBox(height: AppSpacing.md),
        V2Button.secondary(
          text: '기록 상세 보기',
          icon: Icons.history,
          onPressed: () {
            GoRouter.of(context).go('/history');
          },
          fullWidth: true,
        ),
        const SizedBox(height: AppSpacing.sm),
        // 공유 버튼
        TextButton.icon(
          onPressed: _isSharing ? null : () => _showShareDialog(context),
          icon: _isSharing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary500,
                  ),
                )
              : Icon(Icons.share, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          label: Text(
            '공유하기',
            style: AppTypography.bodyMedium.copyWith(
              color: _isSharing
                  ? (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)
                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
          ),
        ),
      ],
    );
  }

  /// 공유 텍스트 생성 헬퍼
  String _buildShareText() {
    final duration = widget.session.duration ?? Duration.zero;
    final totalVolume = widget.session.calculatedVolume;
    final totalSets = widget.session.sets.length;
    final prSets = widget.session.sets.where((s) => s.isPr).toList();

    return WorkoutShareUtils.generateShareSummary(
      date: widget.session.startedAt,
      duration: duration,
      volume: totalVolume,
      sets: totalSets,
      prCount: prSets.isNotEmpty ? prSets.length : null,
    );
  }

  /// 공유 다이얼로그 표시
  void _showShareDialog(BuildContext context) async {
    final exerciseNames = await ref.read(exerciseNamesMapProvider.future);

    if (!mounted) return;

    // dialog 바깥에서 scaffoldMessenger 캡처 (Known Pitfall 방지)
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => _SharePreviewDialog(
        session: widget.session,
        exerciseNames: exerciseNames,
        onShare: () async {
          // 1. dialog 살아있을 때 캡처
          final captureKey = WorkoutShareUtils.getCaptureKey(widget.session.id);
          final imageBytes = await WorkoutShareUtils.captureFromRenderBox(captureKey);
          // 2. dialog 닫기
          Navigator.of(dialogContext).pop();
          // 3. 공유 실행
          await _shareWorkout(imageBytes, scaffoldMessenger);
        },
        onSave: () async {
          // 1. dialog 살아있을 때 캡처
          final captureKey = WorkoutShareUtils.getCaptureKey(widget.session.id);
          final imageBytes = await WorkoutShareUtils.captureFromRenderBox(captureKey);
          // 2. dialog 닫기
          Navigator.of(dialogContext).pop();
          // 3. 갤러리 저장 실행
          await _saveToGallery(imageBytes, scaffoldMessenger);
        },
      ),
    );
  }

  /// 운동 기록 공유 (이미지 바이트를 외부에서 받음)
  Future<void> _shareWorkout(Uint8List? imageBytes, ScaffoldMessengerState messenger) async {
    setState(() => _isSharing = true);

    try {
      final shareText = _buildShareText();

      if (imageBytes != null) {
        await WorkoutShareUtils.shareImageFile(
          imageBytes,
          shareText,
          subject: 'V2log 운동 기록',
        );
      } else {
        // 이미지 캡처 실패 시 텍스트만 공유
        await Share.share(shareText, subject: 'V2log 운동 기록');
      }

      messenger.showSnackBar(
        const SnackBar(
          content: Text('공유 완료!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('공유에 실패했어요: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
      WorkoutShareUtils.clearCaptureKey(widget.session.id);
    }
  }

  /// 갤러리에 이미지 저장
  Future<void> _saveToGallery(Uint8List? imageBytes, ScaffoldMessengerState messenger) async {
    setState(() => _isSharing = true);

    try {
      if (imageBytes == null) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('이미지 생성에 실패했어요'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final success = await WorkoutShareUtils.saveToGallery(imageBytes);

      if (success) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('갤러리에 저장 완료!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('저장에 실패했어요. 갤러리 권한을 확인해주세요.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('저장에 실패했어요: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
      WorkoutShareUtils.clearCaptureKey(widget.session.id);
    }
  }
}

/// 공유 미리보기 다이얼로그
class _SharePreviewDialog extends StatefulWidget {
  final WorkoutSessionModel session;
  final Map<String, String> exerciseNames;
  final Future<void> Function() onShare;
  final Future<void> Function() onSave;

  const _SharePreviewDialog({
    required this.session,
    required this.exerciseNames,
    required this.onShare,
    required this.onSave,
  });

  @override
  State<_SharePreviewDialog> createState() => _SharePreviewDialogState();
}

class _SharePreviewDialogState extends State<_SharePreviewDialog> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Dialog(
      backgroundColor: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더: 제목 + 닫기 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '운동 기록 공유',
                  style: AppTypography.h3.copyWith(color: textColor),
                ),
                IconButton(
                  onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  style: IconButton.styleFrom(
                    backgroundColor: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // 공유 카드 미리보기 (캡처 대상) - 스크롤 가능
            Flexible(
              child: SingleChildScrollView(
                child: RepaintBoundary(
                  key: WorkoutShareUtils.getCaptureKey(widget.session.id),
                  child: WorkoutShareCard(
                    session: widget.session,
                    exerciseNames: widget.exerciseNames,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 저장 + 공유 버튼 (항상 하단 고정)
            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              Row(
                children: [
                  // 저장하기 버튼
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        setState(() => _isProcessing = true);
                        await widget.onSave();
                      },
                      icon: Icon(
                        Icons.download,
                        size: 18,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                      label: Text(
                        '저장',
                        style: TextStyle(
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // 공유하기 버튼
                  Expanded(
                    flex: 2,
                    child: V2Button.primary(
                      text: '공유하기',
                      icon: Icons.share,
                      onPressed: () async {
                        setState(() => _isProcessing = true);
                        await widget.onShare();
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// 통계 박스 위젯
class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final double? numericValue;
  final String? suffix;
  final int decimals;

  const _StatBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.numericValue,
    this.suffix,
    this.decimals = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final textStyle = AppTypography.h4.copyWith(
      color: isDark ? AppColors.darkText : AppColors.lightText,
      fontWeight: FontWeight.w700,
    );
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 28,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: numericValue != null
                  ? CountUpText(
                      endValue: numericValue!,
                      suffix: suffix,
                      decimals: decimals,
                      style: textStyle,
                    )
                  : Text(
                      value,
                      style: textStyle,
                      maxLines: 1,
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
