import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/extensions/context_extension.dart';
import 'package:v2log/shared/models/notification_settings_model.dart';
import 'package:v2log/features/profile/domain/notification_provider.dart';
import 'package:v2log/shared/widgets/atoms/v2_card.dart';
import 'package:v2log/shared/widgets/atoms/v2_switch.dart';

/// 알림 설정 화면 (요일별 개별 시간 설정)
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        title: Text(
          '알림 설정',
          style: AppTypography.h3.copyWith(color: isDark ? AppColors.darkText : AppColors.lightText),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          // 전체 알림 ON/OFF
          _buildToggleCard(
            icon: Icons.notifications_active,
            title: '운동 리마인더 알림',
            description: settings.enabled
                ? '${settings.activeWeekdays.length}개 요일 설정됨'
                : '요일별로 알림을 설정하세요',
            value: settings.enabled,
            onChanged: (value) {
              notifier.toggleAll(value);
            },
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.lg),

          // 요일별 설정 (한 줄)
          _buildWeekdaysRow(settings, notifier, isDark),

          const SizedBox(height: AppSpacing.xl),

          // 테스트 알림 버튼
          if (settings.enabled) ...[
            V2Card(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notifications,
                        color: AppColors.primary500,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '테스트 알림',
                              style: AppTypography.labelMedium.copyWith(
                                color: isDark ? AppColors.darkText : AppColors.lightText,
                              ),
                            ),
                            Text(
                              '알림이 정상 작동하는지 확인해보세요',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton.icon(
                    onPressed: () => notifier.showTestNotification(),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('테스트 알림 받기'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary500,
                      side: const BorderSide(color: AppColors.primary500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // 안내 문구
          Center(
            child: Text(
              '요일을 눌러서 알림 시간을 설정하세요! 💪',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 전체 토글 카드
  Widget _buildToggleCard({
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary500.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              icon,
              color: AppColors.primary500,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelMedium.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          V2Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  /// 요일 버튼 한 줄 (고정 순서: 월 화 수 목 금 토 일)
  Widget _buildWeekdaysRow(NotificationSettingsModel settings, dynamic notifier, bool isDark) {
    const weekdayNames = ['월', '화', '수', '목', '금', '토', '일'];
    const weekdayColors = [
      AppColors.primary500,  // 월
      AppColors.primary500,  // 화
      AppColors.primary500,  // 수
      AppColors.primary500,  // 목
      AppColors.primary500,  // 금
      AppColors.primary500,  // 토
      AppColors.primary500,  // 일
    ];

    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: AppColors.success,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '요일별 알림 시간',
                style: AppTypography.labelMedium.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // 요일 버튼들 (항상 월 화 수 목 금 토 일 순서)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final weekday = index + 1; // 1(월) ~ 7(일)
              final weekdaySetting = settings.getWeekdaySetting(weekday);
              final isEnabled = weekdaySetting.enabled;
              final weekdayColor = weekdayColors[index];

              return Expanded(
                child: Transform.translate(
                  offset: Offset(0, isEnabled ? -8 : 0),
                  child: GestureDetector(
                    onTap: () => _showWeekdayDialog(context, weekday, weekdaySetting, notifier),
                    child: Column(
                      children: [
                        // 요일 버튼
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: isEnabled ? 52 : 48,
                          decoration: BoxDecoration(
                            color: isEnabled
                                ? weekdayColor.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            border: Border.all(
                              color: isEnabled
                                  ? weekdayColor.withValues(alpha: 0.8)
                                  : isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              width: isEnabled ? 2 : 1,
                            ),
                            boxShadow: isEnabled
                                ? [
                                    BoxShadow(
                                      color: weekdayColor.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  weekdayNames[index],
                                  style: AppTypography.labelSmall.copyWith(
                                    color: isEnabled
                                        ? weekdayColor
                                        : isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                                    fontWeight: isEnabled ? FontWeight.w700 : FontWeight.normal,
                                  ),
                                ),
                                if (isEnabled) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    weekdaySetting.timeString,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: weekdayColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ] else ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'OFF',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// 요일별 설정 다이얼로그
  Future<void> _showWeekdayDialog(
    BuildContext context,
    int weekday,
    WeekdaySetting currentSetting,
    dynamic notifier,
  ) async {
    const weekdayNames = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    final weekdayName = weekdayNames[weekday - 1];
    const weekdayColor = AppColors.primary500; // 모든 요일 동일 색상

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _WeekdaySettingDialog(
        weekday: weekday,
        weekdayName: weekdayName,
        weekdayColor: weekdayColor,
        currentSetting: currentSetting,
      ),
    );

    if (result == true && mounted) {
      // 다이얼로그에서 확인을 누르면 설정이 이미 저장됨
    }
  }
}

/// 요일별 설정 다이얼로그
class _WeekdaySettingDialog extends ConsumerStatefulWidget {
  final int weekday; // 1(월) ~ 7(일)
  final String weekdayName;
  final Color weekdayColor;
  final WeekdaySetting currentSetting;

  const _WeekdaySettingDialog({
    required this.weekday,
    required this.weekdayName,
    required this.weekdayColor,
    required this.currentSetting,
  });

  @override
  ConsumerState<_WeekdaySettingDialog> createState() =>
      _WeekdaySettingDialogState();
}

class _WeekdaySettingDialogState extends ConsumerState<_WeekdaySettingDialog> {
  late bool _enabled;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _enabled = widget.currentSetting.enabled;
    _selectedTime = TimeOfDay(
      hour: widget.currentSetting.hour,
      minute: widget.currentSetting.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: widget.weekdayColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                widget.weekdayName[0], // 첫 글자 (월, 화, ...)
                style: AppTypography.labelMedium.copyWith(
                  color: widget.weekdayColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${widget.weekdayName} 알림',
              style: AppTypography.h3.copyWith(
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ON/OFF 토글
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '알림 받기',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              V2Switch(
                value: _enabled,
                onChanged: (value) {
                  setState(() {
                    _enabled = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // 시간 선택 (활성화된 경우에만)
          if (_enabled) ...[
            Text(
              '알림 시간',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            InkWell(
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: isDark
                            ? ColorScheme.dark(
                                primary: widget.weekdayColor,
                                surface: AppColors.darkCard,
                              )
                            : ColorScheme.light(
                                primary: widget.weekdayColor,
                                surface: AppColors.lightCard,
                              ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null && mounted) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.weekdayColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 18,
                      color: widget.weekdayColor,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      _selectedTime.format(context),
                      style: AppTypography.h3.copyWith(
                        color: widget.weekdayColor,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '알림이 꺼져 있습니다',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            '취소',
            style: AppTypography.labelMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // 설정 저장 (weekday 숫자를 직접 사용)
            final notifier = ref.read(notificationSettingsProvider.notifier);
            notifier.updateWeekdaySetting(
              widget.weekday,
              WeekdaySetting(
                enabled: _enabled,
                hour: _selectedTime.hour,
                minute: _selectedTime.minute,
              ),
            );
            Navigator.pop(context, true);
          },
          child: Text(
            '확인',
            style: AppTypography.labelMedium.copyWith(
              color: widget.weekdayColor,
            ),
          ),
        ),
      ],
    );
  }
}
