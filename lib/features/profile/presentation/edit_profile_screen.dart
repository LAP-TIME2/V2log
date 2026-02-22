import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/extensions/context_extension.dart';
import 'package:v2log/shared/models/user_model.dart';
import 'package:v2log/features/auth/domain/auth_provider.dart';
import 'package:v2log/features/profile/domain/user_provider.dart';
import 'package:v2log/shared/widgets/atoms/v2_button.dart';
import 'package:v2log/shared/widgets/atoms/v2_card.dart';
import 'package:v2log/shared/widgets/atoms/v2_text_field.dart';

/// 프로필 수정 화면
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nicknameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  Gender? _selectedGender;
  DateTime? _selectedBirthDate;
  ExperienceLevel _selectedExperienceLevel = ExperienceLevel.beginner;
  FitnessGoal _selectedFitnessGoal = FitnessGoal.hypertrophy;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _initializeFromUser(UserModel user) {
    if (_isInitialized) return;
    _isInitialized = true;

    _nicknameController.text = user.nickname;
    _heightController.text = user.height?.toString() ?? '';
    _weightController.text = user.weight?.toString() ?? '';
    _selectedGender = user.gender;
    _selectedBirthDate = user.birthDate;
    _selectedExperienceLevel = user.experienceLevel;
    _selectedFitnessGoal = user.fitnessGoal;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final profileState = ref.watch(userProfileProvider);
    final isDark = context.isDarkMode;

    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          '프로필 수정',
          style: AppTypography.h3.copyWith(color: textColor),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Text(
                '로그인이 필요합니다',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            );
          }

          _initializeFromUser(user);

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 기본 정보 섹션
                  _buildSectionTitle('기본 정보', isDark),
                  const SizedBox(height: AppSpacing.md),
                  _buildBasicInfoCard(isDark),
                  const SizedBox(height: AppSpacing.xl),

                  // 신체 정보 섹션
                  _buildSectionTitle('신체 정보', isDark),
                  const SizedBox(height: AppSpacing.md),
                  _buildBodyInfoCard(isDark),
                  const SizedBox(height: AppSpacing.xl),

                  // 운동 설정 섹션
                  _buildSectionTitle('운동 설정', isDark),
                  const SizedBox(height: AppSpacing.md),
                  _buildFitnessSettingsCard(isDark),
                  const SizedBox(height: AppSpacing.xxl),

                  // 저장 버튼
                  V2Button.primary(
                    text: '저장하기',
                    icon: Icons.check,
                    isLoading: profileState.isLoading,
                    onPressed: profileState.isLoading ? null : () => _saveProfile(context),
                    fullWidth: true,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary500),
        ),
        error: (error, _) => Center(
          child: Text(
            '프로필을 불러오는데 실패했습니다',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: AppTypography.h4.copyWith(
        color: isDark ? AppColors.darkText : AppColors.lightText,
      ),
    );
  }

  Widget _buildBasicInfoCard(bool isDark) {
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // 닉네임
          V2TextField(
            label: '닉네임',
            hint: '닉네임을 입력하세요',
            controller: _nicknameController,
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '닉네임을 입력해주세요';
              }
              if (value.trim().length < 2) {
                return '2자 이상 입력해주세요';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // 성별
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '성별',
                style: AppTypography.labelMedium.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: Gender.values.map((gender) {
                  final isSelected = _selectedGender == gender;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: gender != Gender.values.last ? AppSpacing.sm : 0,
                      ),
                      child: _SelectableChip(
                        label: gender.label,
                        isSelected: isSelected,
                        isDark: isDark,
                        onTap: () => setState(() => _selectedGender = gender),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // 생년월일
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '생년월일',
                style: AppTypography.labelMedium.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              InkWell(
                onTap: () => _selectBirthDate(context),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: secondaryColor,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        _selectedBirthDate != null
                            ? '${_selectedBirthDate!.year}.${_selectedBirthDate!.month.toString().padLeft(2, '0')}.${_selectedBirthDate!.day.toString().padLeft(2, '0')}'
                            : '생년월일을 선택하세요',
                        style: AppTypography.bodyLarge.copyWith(
                          color: _selectedBirthDate != null
                              ? (isDark ? AppColors.darkText : AppColors.lightText)
                              : secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBodyInfoCard(bool isDark) {
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          // 키
          Expanded(
            child: V2TextField.number(
              label: '키',
              hint: '170',
              suffix: 'cm',
              controller: _heightController,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          // 몸무게
          Expanded(
            child: V2TextField.number(
              label: '몸무게',
              hint: '70',
              suffix: 'kg',
              controller: _weightController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFitnessSettingsCard(bool isDark) {
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 운동 경험
          Text(
            '운동 경험',
            style: AppTypography.labelMedium.copyWith(
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: ExperienceLevel.values.map((level) {
              final isSelected = _selectedExperienceLevel == level;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: level != ExperienceLevel.values.last ? AppSpacing.sm : 0,
                  ),
                  child: _SelectableChip(
                    label: level.label,
                    subtitle: level.description,
                    isSelected: isSelected,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedExperienceLevel = level),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),

          // 운동 목표
          Text(
            '운동 목표',
            style: AppTypography.labelMedium.copyWith(
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: FitnessGoal.values.map((goal) {
              final isSelected = _selectedFitnessGoal == goal;
              return _SelectableChip(
                label: goal.label,
                isSelected: isSelected,
                isDark: isDark,
                onTap: () => setState(() => _selectedFitnessGoal = goal),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _selectBirthDate(BuildContext context) {
    final isDark = context.isDarkMode;
    final now = DateTime.now();
    DateTime tempDate = _selectedBirthDate ?? DateTime(now.year - 25, 1, 1);

    final bgColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SizedBox(
          height: 340,
          child: Column(
            children: [
              // 상단 바
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(bottomSheetContext).pop(),
                      child: Text(
                        '취소',
                        style: AppTypography.bodyMedium.copyWith(
                          color: secondaryColor,
                        ),
                      ),
                    ),
                    Text(
                      '생년월일',
                      style: AppTypography.labelLarge.copyWith(
                        color: textColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => _selectedBirthDate = tempDate);
                        Navigator.of(bottomSheetContext).pop();
                      },
                      child: Text(
                        '확인',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.primary500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              // 휠 피커
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    brightness: isDark ? Brightness.dark : Brightness.light,
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: AppTypography.bodyLarge.copyWith(
                        color: textColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: tempDate,
                    minimumDate: DateTime(1940),
                    maximumDate: now,
                    onDateTimeChanged: (date) {
                      tempDate = date;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveProfile(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final nickname = _nicknameController.text.trim();
    final height = double.tryParse(_heightController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());

    try {
      await ref.read(userProfileProvider.notifier).updateProfile(
            nickname: nickname,
            gender: _selectedGender,
            birthDate: _selectedBirthDate,
            height: height,
            weight: weight,
            experienceLevel: _selectedExperienceLevel,
            fitnessGoal: _selectedFitnessGoal,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('프로필이 저장되었습니다'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장에 실패했습니다: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

/// 선택 가능한 칩 위젯
class _SelectableChip extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _SelectableChip({
    required this.label,
    this.subtitle,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedBg = AppColors.primary500.withValues(alpha: 0.15);
    final unselectedBg = isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated;
    final selectedBorder = AppColors.primary500;
    final unselectedBorder = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final selectedText = AppColors.primary500;
    final unselectedText = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : unselectedBg,
          border: Border.all(
            color: isSelected ? selectedBorder : unselectedBorder,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? selectedText : unselectedText,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: AppTypography.caption.copyWith(
                  color: isSelected
                      ? selectedText.withValues(alpha: 0.7)
                      : unselectedText,
                  fontSize: 9,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
