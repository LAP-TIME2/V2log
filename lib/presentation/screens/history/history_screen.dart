import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/session_notes_formatter.dart';
import '../../../core/utils/workout_share_utils.dart';
import '../../../data/models/workout_session_model.dart';
import '../../../data/models/workout_set_model.dart';
import '../../../domain/providers/workout_provider.dart';
import '../../widgets/atoms/animated_wrappers.dart';
import '../../widgets/atoms/v2_button.dart';
import '../../widgets/atoms/v2_card.dart';
import '../../widgets/molecules/set_row.dart';
import '../../widgets/molecules/workout_share_card.dart';

/// 운동 기록 히스토리 화면
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final historyAsync = ref.watch(workoutHistoryProvider());

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        title: Text(
          '운동 기록',
          style: AppTypography.h3.copyWith(color: isDark ? AppColors.darkText : AppColors.lightText),
        ),
        elevation: 0,
      ),
      body: historyAsync.when(
        data: (sessions) => _buildHistoryList(context, sessions),
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: ShimmerLoadingList(
            itemCount: 3,
            itemHeight: 100,
            spacing: AppSpacing.md,
            borderRadius: 12,
          ),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '기록을 불러오는데 실패했어요',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context, List<WorkoutSessionModel> sessions) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.fitness_center,
              size: 64,
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '아직 운동 기록이 없어요',
              style: AppTypography.bodyLarge.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '첫 운동을 시작해보세요!',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
              ),
            ),
          ],
        ),
      );
    }

    // 날짜별로 그룹화
    final groupedSessions = <String, List<WorkoutSessionModel>>{};
    for (final session in sessions) {
      final dateKey = _getDateKey(session.startedAt);
      groupedSessions.putIfAbsent(dateKey, () => []).add(session);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: groupedSessions.length,
      itemBuilder: (context, index) {
        final dateKey = groupedSessions.keys.elementAt(index);
        final daySessions = groupedSessions[dateKey]!;
        final date = daySessions.first.startedAt;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 헤더
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.lg,
                bottom: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Text(
                    Formatters.relativeDate(date),
                    style: AppTypography.labelLarge.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    Formatters.monthDay(date),
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                    ),
                  ),
                ],
              ),
            ),

            // 해당 날짜의 운동 세션들
            ...daySessions.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: FadeSlideIn(
                    index: entry.key,
                    child: _WorkoutSessionCard(session: entry.value),
                  ),
                )),
          ],
        );
      },
    );
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

/// 운동 세션 카드
class _WorkoutSessionCard extends ConsumerWidget {
  final WorkoutSessionModel session;

  const _WorkoutSessionCard({required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final duration = session.totalDurationSeconds != null
        ? Duration(seconds: session.totalDurationSeconds!)
        : session.duration ?? Duration.zero;

    final volume = session.totalVolume ?? session.calculatedVolume;
    final setCount = session.totalSets ?? session.sets.length;

    // exercise 이름 맵 가져오기
    final exerciseNamesAsync = ref.watch(exerciseNamesMapProvider);
    final exerciseNames = exerciseNamesAsync.valueOrNull ?? {};

    // 메모 포맷팅 (exercise_id를 운동명으로 변환)
    final formattedNotes = formatSessionNotes(session.notes, exerciseNames);

    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: () => context.push('/history/${session.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              // 모드 아이콘
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: session.mode == WorkoutMode.preset
                      ? AppColors.primary500.withValues(alpha: 0.15)
                      : AppColors.secondary500.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(
                  session.mode == WorkoutMode.preset
                      ? Icons.menu_book_outlined
                      : Icons.edit_note_outlined,
                  color: session.mode == WorkoutMode.preset
                      ? AppColors.primary500
                      : AppColors.secondary500,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // 운동 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getWorkoutTitle(formattedNotes),
                      style: AppTypography.labelLarge.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      Formatters.time(session.startedAt),
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // 화살표
              Icon(
                Icons.chevron_right,
                color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // 통계
          Row(
            children: [
              _StatItem(
                icon: Icons.timer_outlined,
                label: '운동 시간',
                value: Formatters.duration(duration),
              ),
              const SizedBox(width: AppSpacing.xl),
              _StatItem(
                icon: Icons.fitness_center,
                label: '세트',
                value: '$setCount세트',
              ),
              const SizedBox(width: AppSpacing.xl),
              _StatItem(
                icon: Icons.local_fire_department_outlined,
                label: '볼륨',
                value: Formatters.volume(volume),
              ),
            ],
          ),

          // 메모가 있으면 표시
          if (formattedNotes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 16,
                    color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      formattedNotes,
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

          // 기분 평점
          if (session.moodRating != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < session.moodRating! ? Icons.star : Icons.star_border,
                  size: 16,
                  color: index < session.moodRating!
                      ? AppColors.warning
                      : isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  String _getWorkoutTitle(String formattedNotes) {
    if (formattedNotes.isNotEmpty) {
      // 메모가 짧으면 제목으로 사용
      if (formattedNotes.length <= 20) {
        return formattedNotes;
      }
    }
    return session.mode == WorkoutMode.preset ? '전문가 루틴' : '자유 운동';
  }
}

/// 통계 아이템
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: AppTypography.labelMedium.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
      ],
    );
  }
}

/// 운동 상세 화면
class HistoryDetailScreen extends ConsumerStatefulWidget {
  final String sessionId;

  const HistoryDetailScreen({required this.sessionId, super.key});

  @override
  ConsumerState<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends ConsumerState<HistoryDetailScreen> {
  /// 공유 중 여부
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sessionAsync = ref.watch(workoutSessionDetailProvider(widget.sessionId));
    final exerciseNamesAsync = ref.watch(exerciseNamesMapProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        title: Text(
          '운동 상세',
          style: AppTypography.h3.copyWith(color: isDark ? AppColors.darkText : AppColors.lightText),
        ),
        elevation: 0,
        actions: [
          // 공유 버튼 (앱바)
          sessionAsync.whenOrNull(
            data: (session) => session != null
                ? _isSharing
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary500,
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () => _shareWorkout(context, session, exerciseNamesAsync),
                        icon: const Icon(Icons.share_outlined),
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      )
                : null,
          ) ?? const SizedBox.shrink(),
        ],
      ),
      body: sessionAsync.when(
        data: (session) {
          if (session == null) {
            return Center(
              child: Text(
                '운동 기록을 찾을 수 없습니다',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            );
          }

          final exerciseNames = exerciseNamesAsync.valueOrNull ?? {};

          // 메모 포맷팅 (exercise_id를 운동명으로 변환)
          final formattedNotes = formatSessionNotes(session.notes, exerciseNames);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 요약 카드
                _buildSummaryCard(session, formattedNotes),
                const SizedBox(height: AppSpacing.xl),

                // 운동별 세트 목록
                Text(
                  '운동 기록',
                  style: AppTypography.h4.copyWith(color: isDark ? AppColors.darkText : AppColors.lightText),
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildExercisesList(session, exerciseNames),
                const SizedBox(height: AppSpacing.xl),

                // 공유 버튼 (하단)
                V2Button.secondary(
                  text: '공유하기',
                  icon: Icons.share,
                  onPressed: _isSharing ? null : () => _shareWorkout(context, session, exerciseNamesAsync),
                  fullWidth: true,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary500),
        ),
        error: (_, __) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '기록을 불러오는데 실패했어요',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              V2Button.primary(
                text: '다시 시도',
                onPressed: () => ref.invalidate(workoutSessionDetailProvider(widget.sessionId)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 공유 텍스트 생성 헬퍼
  String _buildShareText(WorkoutSessionModel session) {
    final duration = session.duration ?? Duration.zero;
    final totalVolume = session.calculatedVolume;
    final totalSets = session.sets.length;
    final prSets = session.sets.where((s) => s.isPr).toList();

    return WorkoutShareUtils.generateShareSummary(
      date: session.startedAt,
      duration: duration,
      volume: totalVolume,
      sets: totalSets,
      prCount: prSets.isNotEmpty ? prSets.length : null,
    );
  }

  /// 운동 기록 공유 다이얼로그 표시
  Future<void> _shareWorkout(
    BuildContext context,
    WorkoutSessionModel session,
    AsyncValue<Map<String, String>> exerciseNamesAsync,
  ) async {
    final exerciseNames = exerciseNamesAsync.valueOrNull ?? {};

    if (!mounted) return;

    // dialog 바깥에서 scaffoldMessenger 캡처 (Known Pitfall 방지)
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => _SharePreviewDialog(
        session: session,
        exerciseNames: exerciseNames,
        onShare: () async {
          // 1. dialog 살아있을 때 캡처
          final captureKey = WorkoutShareUtils.getCaptureKey(session.id);
          final imageBytes = await WorkoutShareUtils.captureFromRenderBox(captureKey);
          // 2. dialog 닫기
          Navigator.of(dialogContext).pop();
          // 3. 공유 실행
          await _doShare(session, imageBytes, scaffoldMessenger);
        },
        onSave: () async {
          // 1. dialog 살아있을 때 캡처
          final captureKey = WorkoutShareUtils.getCaptureKey(session.id);
          final imageBytes = await WorkoutShareUtils.captureFromRenderBox(captureKey);
          // 2. dialog 닫기
          Navigator.of(dialogContext).pop();
          // 3. 갤러리 저장 실행
          await _doSaveToGallery(session, imageBytes, scaffoldMessenger);
        },
      ),
    );
  }

  /// 이미지 공유 실행
  Future<void> _doShare(
    WorkoutSessionModel session,
    Uint8List? imageBytes,
    ScaffoldMessengerState messenger,
  ) async {
    setState(() => _isSharing = true);

    try {
      final shareText = _buildShareText(session);

      if (imageBytes != null) {
        await WorkoutShareUtils.shareImageFile(
          imageBytes,
          shareText,
          subject: 'V2log 운동 기록',
        );
      } else {
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
      print('=== 공유 실패: $e ===');
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
      WorkoutShareUtils.clearCaptureKey(session.id);
    }
  }

  /// 갤러리에 이미지 저장
  Future<void> _doSaveToGallery(
    WorkoutSessionModel session,
    Uint8List? imageBytes,
    ScaffoldMessengerState messenger,
  ) async {
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
      print('=== 갤러리 저장 실패: $e ===');
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
      WorkoutShareUtils.clearCaptureKey(session.id);
    }
  }

  Widget _buildSummaryCard(WorkoutSessionModel session, String formattedNotes) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final duration = session.totalDurationSeconds != null
        ? Duration(seconds: session.totalDurationSeconds!)
        : session.duration ?? Duration.zero;
    final volume = session.totalVolume ?? session.calculatedVolume;
    final setCount = session.totalSets ?? session.sets.length;

    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: session.mode == WorkoutMode.preset
                      ? AppColors.primary500.withValues(alpha: 0.15)
                      : AppColors.secondary500.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  session.mode.label,
                  style: AppTypography.labelSmall.copyWith(
                    color: session.mode == WorkoutMode.preset
                        ? AppColors.primary500
                        : AppColors.secondary500,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                Formatters.dateTime(session.startedAt),
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  icon: Icons.timer_outlined,
                  label: '운동 시간',
                  value: Formatters.duration(duration),
                ),
              ),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.fitness_center,
                  label: '세트',
                  value: '$setCount세트',
                ),
              ),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.local_fire_department_outlined,
                  label: '볼륨',
                  value: Formatters.volume(volume),
                ),
              ),
            ],
          ),
          if (formattedNotes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                formattedNotes,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExercisesList(
    WorkoutSessionModel session,
    Map<String, String> exerciseNames,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // 운동별로 세트 그룹화
    final setsByExercise = <String, List<WorkoutSetModel>>{};
    for (final set in session.sets) {
      setsByExercise.putIfAbsent(set.exerciseId, () => []).add(set);
    }

    if (setsByExercise.isEmpty) {
      return V2Card(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Text(
            '기록된 세트가 없습니다',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
      );
    }

    return Column(
      children: setsByExercise.entries.map((entry) {
        final exerciseId = entry.key;
        final sets = entry.value;
        final exerciseName = _getExerciseName(exerciseId, exerciseNames);

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: V2Card(
            padding: const EdgeInsets.all(AppSpacing.lg),
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
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
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
                          Text(
                            exerciseName,
                            style: AppTypography.labelLarge.copyWith(
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                            ),
                          ),
                          Text(
                            '${sets.length}세트',
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                // 세트 목록 헤더
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(
                        '세트',
                        style: AppTypography.caption.copyWith(
                          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      child: Text(
                        '타입',
                        style: AppTypography.caption.copyWith(
                          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '무게',
                        style: AppTypography.caption.copyWith(
                          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '횟수',
                        style: AppTypography.caption.copyWith(
                          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '볼륨',
                        style: AppTypography.caption.copyWith(
                          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, height: AppSpacing.lg),
                // 세트 목록
                ...sets.asMap().entries.map((entry) {
                  final index = entry.key;
                  final set = entry.value;
                  // 웜업 세트는 볼륨 회색으로 표시
                  final isWarmup = set.setType == SetType.warmup;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Row(
                            children: [
                              Text(
                                '${index + 1}',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: isDark ? AppColors.darkText : AppColors.lightText,
                                ),
                              ),
                              if (set.isPr)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.emoji_events,
                                    size: 14,
                                    color: AppColors.warning,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // 세트 타입 뱃지
                        SizedBox(
                          width: 32,
                          child: SetTypeBadge(type: set.setType, compact: true),
                        ),
                        Expanded(
                          child: Text(
                            '${set.weight ?? 0}kg',
                            style: AppTypography.bodyMedium.copyWith(
                              color: isWarmup ? (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary) : (isDark ? AppColors.darkText : AppColors.lightText),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${set.reps ?? 0}회',
                            style: AppTypography.bodyMedium.copyWith(
                              color: isWarmup ? (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary) : (isDark ? AppColors.darkText : AppColors.lightText),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            Formatters.volume(set.volume),
                            style: AppTypography.bodyMedium.copyWith(
                              color: isWarmup ? (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary) : AppColors.primary500,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getExerciseName(String exerciseId, Map<String, String> exerciseNames) {
    final exerciseName = getExerciseNameFromId(exerciseId, exerciseNames);
    if (exerciseName != exerciseId) {
      return exerciseName;
    }

    // 못 찾으면 '운동' 반환
    return '운동';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: isDark ? AppColors.darkBg : Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 헤더: 제목 + 닫기
              Row(
                children: [
                  Text(
                    '운동 기록 공유',
                    style: AppTypography.h3.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // 공유 카드 미리보기 (캡처 대상 - 항상 다크 테마)
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: RepaintBoundary(
                  key: WorkoutShareUtils.getCaptureKey(widget.session.id),
                  child: WorkoutShareCard(
                    session: widget.session,
                    exerciseNames: widget.exerciseNames,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 저장 + 공유 버튼
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
                          side: BorderSide(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
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
      ),
    );
  }
}

/// 요약 항목
class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Icon(icon, size: 24, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.labelLarge.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          ),
        ),
      ],
    );
  }
}
