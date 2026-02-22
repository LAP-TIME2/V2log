import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/extensions/context_extension.dart';
import 'package:v2log/core/utils/validators.dart';
import 'package:v2log/features/auth/domain/auth_provider.dart';
import 'package:v2log/shared/widgets/atoms/v2_button.dart';
import 'package:v2log/shared/widgets/atoms/v2_text_field.dart';

/// 회원가입 화면
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 다시 입력해주세요';
    }
    if (value != _passwordController.text) {
      return '비밀번호가 일치하지 않습니다';
    }
    return null;
  }

  String? _validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return '닉네임을 입력해주세요';
    }
    if (value.length < 2) {
      return '닉네임은 2자 이상이어야 합니다';
    }
    if (value.length > 20) {
      return '닉네임은 20자 이하여야 합니다';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이용약관에 동의해주세요'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).signUpWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            nickname: _nicknameController.text.trim(),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('회원가입이 완료되었습니다!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = '회원가입 실패';
        if (e.toString().contains('already registered')) {
          errorMessage = '이미 등록된 이메일입니다';
        } else if (e.toString().contains('invalid')) {
          errorMessage = '유효하지 않은 이메일 형식입니다';
        } else if (e.toString().contains('weak')) {
          errorMessage = '비밀번호가 너무 약합니다';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.textColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 헤더
                Text(
                  '회원가입',
                  style: AppTypography.h1.copyWith(
                    color: context.textColor,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '건강한 운동 습관을 시작해보세요',
                  style: AppTypography.bodyLarge.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // 닉네임 입력
                V2TextField(
                  controller: _nicknameController,
                  label: '닉네임',
                  hint: '2-20자 사이로 입력해주세요',
                  prefixIcon: Icons.person_outline,
                  validator: _validateNickname,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: AppSpacing.lg),

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
                  label: '비밀번호',
                  hint: '8자 이상 입력해주세요',
                  validator: Validators.password,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: AppSpacing.lg),

                // 비밀번호 확인
                V2TextField.password(
                  controller: _confirmPasswordController,
                  label: '비밀번호 확인',
                  hint: '비밀번호를 다시 입력해주세요',
                  validator: _validateConfirmPassword,
                  enabled: !_isLoading,
                ),

                const SizedBox(height: AppSpacing.xl),

                // 이용약관 동의
                Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: _isLoading
                          ? null
                          : (value) {
                              setState(() => _agreedToTerms = value ?? false);
                            },
                      activeColor: AppColors.primary500,
                      checkColor: Colors.white,
                      side: BorderSide(color: context.borderColor),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () {
                                setState(() => _agreedToTerms = !_agreedToTerms);
                              },
                        child: Text.rich(
                          TextSpan(
                            text: '이용약관',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primary500,
                              decoration: TextDecoration.underline,
                            ),
                            children: [
                              TextSpan(
                                text: ' 및 ',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: context.textSecondaryColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: '개인정보처리방침',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.primary500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: '에 동의합니다',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: context.textSecondaryColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),

                // 회원가입 버튼
                V2Button.primary(
                  text: '회원가입',
                  onPressed: _isLoading ? null : _handleRegister,
                  isLoading: _isLoading,
                  fullWidth: true,
                ),

                const SizedBox(height: AppSpacing.xl),

                // 로그인 링크
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '이미 계정이 있으신가요?',
                      style: AppTypography.bodyMedium.copyWith(
                        color: context.textSecondaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: _isLoading ? null : () => context.pop(),
                      child: Text(
                        '로그인',
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
