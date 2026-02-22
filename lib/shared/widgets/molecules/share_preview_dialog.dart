import 'package:flutter/material.dart';
import 'package:v2log/core/extensions/context_extension.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/utils/workout_share_utils.dart';
import 'package:v2log/shared/models/workout_session_model.dart';
import 'package:v2log/shared/widgets/molecules/workout_share_card.dart';
import 'package:v2log/shared/widgets/atoms/v2_button.dart';

/// 공유 미리보기 다이얼로그 (history_screen, workout_summary_screen 공용)
class SharePreviewDialog extends StatefulWidget {
  final WorkoutSessionModel session;
  final Map<String, String> exerciseNames;
  final Future<void> Function() onShare;
  final Future<void> Function() onSave;

  const SharePreviewDialog({
    required this.session,
    required this.exerciseNames,
    required this.onShare,
    required this.onSave,
    super.key,
  });

  @override
  State<SharePreviewDialog> createState() => _SharePreviewDialogState();
}

class _SharePreviewDialogState extends State<SharePreviewDialog> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;

    return Dialog(
      backgroundColor: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
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
                        style: AppTypography.h3.copyWith(
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      IconButton(
                        onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),

            // 공유 카드 미리보기 (캡처 대상) - 스크롤 가능
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: RepaintBoundary(
                  key: WorkoutShareUtils.getCaptureKey(widget.session.id),
                  child: WorkoutShareCard(
                    session: widget.session,
                    exerciseNames: widget.exerciseNames,
                  ),
                ),
              ),
            ),

            // 저장 + 공유 버튼 (항상 하단 고정)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: _isProcessing
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : Row(
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
            ),
          ],
        ),
      ),
    );
  }
}
