import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../widgets/atoms/v2_button.dart';
import '../../widgets/atoms/v2_text_field.dart';

/// 로그인 화면
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).signInWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 실패: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleGuestLogin() {
    // 게스트 모드로 홈 화면 이동
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xxxl),

                // 로고
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusLg),
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'V2log',
                        style: AppTypography.h1.copyWith(
                          color: context.textColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xxxl * 2),

                // 이메일 입력
                V2TextField.email(
                  controller: _emailController,
                  validator: Validators.email,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: AppSpacing.lg),

                // 비밀번호 입력
                V2TextField.password(
                  controller: _passwordController,
                  validator: Validators.password,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: AppSpacing.sm),

                // 비밀번호 찾기
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading ? null : () {},
                    child: Text(
                      '비밀번호를 잊으셨나요?',
                      style: AppTypography.bodySmall.copyWith(
                        color: context.textSecondaryColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // 로그인 버튼
                V2Button.primary(
                  text: '로그인',
                  onPressed: _isLoading ? null : _handleLogin,
                  isLoading: _isLoading,
                  fullWidth: true,
                ),

                const SizedBox(height: AppSpacing.lg),

                // 구분선
                Row(
                  children: [
                    Expanded(child: Divider(color: context.borderColor)),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Text(
                        '또는',
                        style: AppTypography.bodySmall.copyWith(
                          color: context.textTertiaryColor,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: context.borderColor)),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // 소셜 로그인
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialButton(
                      icon: Icons.g_mobiledata,
                      onTap: () =>
                          ref.read(authProvider.notifier).signInWithGoogle(),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    _SocialButton(
                      icon: Icons.apple,
                      onTap: () =>
                          ref.read(authProvider.notifier).signInWithApple(),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    _SocialButton(
                      icon: Icons.chat_bubble,
                      onTap: () =>
                          ref.read(authProvider.notifier).signInWithKakao(),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // 게스트 로그인
                Center(
                  child: TextButton(
                    onPressed: _isLoading ? null : _handleGuestLogin,
                    child: Text(
                      '게스트로 둘러보기',
                      style: AppTypography.bodyMedium.copyWith(
                        color: context.textSecondaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // 회원가입
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '계정이 없으신가요?',
                      style: AppTypography.bodyMedium.copyWith(
                        color: context.textSecondaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => context.push('/auth/register'),
                      child: Text(
                        '회원가입',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primary500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.cardColor,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: context.textColor,
            size: 28,
          ),
        ),
      ),
    );
  }
}
