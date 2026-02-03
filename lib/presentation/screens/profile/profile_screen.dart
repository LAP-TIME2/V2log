import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../../domain/providers/user_provider.dart';
import '../../widgets/atoms/v2_button.dart';
import '../../widgets/atoms/v2_card.dart';

/// 프로필 화면
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userStatsAsync = ref.watch(userStatsProvider);

    // 디버그 로그
    print('=== ProfileScreen: authState=$authState ===');

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: Text(
          '프로필',
          style: AppTypography.h3.copyWith(color: AppColors.darkText),
        ),
        elevation: 0,
      ),
      body: authState.when(
        data: (user) {
          print('=== ProfileScreen: user=$user, nickname=${user?.nickname} ===');
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              children: [
                // 프로필 카드
                _buildProfileCard(user),
                const SizedBox(height: AppSpacing.xl),

                // 통계 카드
                userStatsAsync.when(
                  data: (stats) => _buildStatsCard(stats),
                  loading: () => const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primary500),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: AppSpacing.xl),

                // 설정 섹션
                _buildSettingsSection(context, ref),
                const SizedBox(height: AppSpacing.xxl),

                // 로그아웃 버튼
                V2Button.secondary(
                  text: '로그아웃',
                  icon: Icons.logout,
                  onPressed: () => _handleLogout(context, ref),
                  fullWidth: true,
                ),
                const SizedBox(height: AppSpacing.lg),

                // 앱 버전
                Text(
                  'V2log v1.0.0',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.darkTextTertiary,
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary500),
        ),
        error: (error, _) {
          print('=== ProfileScreen: 에러=$error ===');
          return Center(
            child: Text(
              '프로필을 불러오는데 실패했습니다',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(user) {
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          // 프로필 이미지
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.primary500.withValues(alpha: 0.15),
            backgroundImage: user?.profileImageUrl != null
                ? NetworkImage(user!.profileImageUrl!)
                : null,
            child: user?.profileImageUrl == null
                ? Icon(
                    Icons.person,
                    size: 48,
                    color: AppColors.primary500,
                  )
                : null,
          ),
          const SizedBox(height: AppSpacing.lg),

          // 닉네임
          Text(
            user?.nickname ?? '사용자',
            style: AppTypography.h3.copyWith(color: AppColors.darkText),
          ),
          const SizedBox(height: AppSpacing.xs),

          // 이메일
          Text(
            user?.email ?? '',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 목표 & 경험 수준
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadge(
                _getFitnessGoalLabel(user?.fitnessGoal),
                AppColors.primary500,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildBadge(
                _getExperienceLevelLabel(user?.experienceLevel),
                AppColors.secondary500,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // 가입일
          if (user?.createdAt != null)
            Text(
              '${Formatters.monthDay(user!.createdAt)} 가입',
              style: AppTypography.caption.copyWith(
                color: AppColors.darkTextTertiary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: color),
      ),
    );
  }

  Widget _buildStatsCard(UserStats stats) {
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 기록',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.fitness_center,
                  label: '총 운동',
                  value: '${stats.totalWorkouts}회',
                  color: AppColors.primary500,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.local_fire_department,
                  label: '총 볼륨',
                  value: Formatters.number(stats.totalVolume, decimals: 0),
                  unit: 'kg',
                  color: AppColors.secondary500,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.timer,
                  label: '총 시간',
                  value: Formatters.duration(stats.totalDuration),
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    String? unit,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.darkText,
              ),
            ),
            if (unit != null) ...[
              const SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: Text(
                  unit,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.darkTextTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
    return V2Card(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.person_outline,
            title: '프로필 수정',
            onTap: () {
              // TODO: 프로필 수정 화면
            },
          ),
          const Divider(color: AppColors.darkBorder, height: 1),
          _buildSettingItem(
            icon: Icons.notifications_outlined,
            title: '알림 설정',
            onTap: () {
              // TODO: 알림 설정 화면
            },
          ),
          const Divider(color: AppColors.darkBorder, height: 1),
          _buildSettingItem(
            icon: Icons.help_outline,
            title: '도움말',
            onTap: () {
              // TODO: 도움말 화면
            },
          ),
          const Divider(color: AppColors.darkBorder, height: 1),
          _buildSettingItem(
            icon: Icons.info_outline,
            title: '앱 정보',
            onTap: () {
              _showAppInfoDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.darkTextSecondary),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.darkText,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.darkTextTertiary,
            ),
          ],
        ),
      ),
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: Text(
          'V2log',
          style: AppTypography.h3.copyWith(color: AppColors.darkText),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '버전: 1.0.0',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '전문가 루틴으로 시작하고, 기록은 10초 만에',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.darkTextTertiary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '확인',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: Text(
          '로그아웃',
          style: AppTypography.h4.copyWith(color: AppColors.darkText),
        ),
        content: Text(
          '정말 로그아웃 하시겠습니까?',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              '취소',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              '로그아웃',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(authProvider.notifier).signOut();
        if (context.mounted) {
          context.go('/auth/login');
        }
      } catch (e) {
        print('=== 로그아웃 실패: $e ===');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그아웃에 실패했습니다: $e')),
          );
        }
      }
    }
  }

  String _getFitnessGoalLabel(fitnessGoal) {
    switch (fitnessGoal?.value ?? fitnessGoal) {
      case 'STRENGTH':
        return '근력 향상';
      case 'HYPERTROPHY':
        return '근비대';
      case 'ENDURANCE':
        return '지구력';
      case 'WEIGHT_LOSS':
        return '체중 감량';
      default:
        return '근비대';
    }
  }

  String _getExperienceLevelLabel(experienceLevel) {
    switch (experienceLevel?.value ?? experienceLevel) {
      case 'BEGINNER':
        return '초보자';
      case 'INTERMEDIATE':
        return '중급자';
      case 'ADVANCED':
        return '고급자';
      default:
        return '초보자';
    }
  }
}
