import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

/// V2log 텍스트 필드
class V2TextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffix;
  final VoidCallback? onSuffixTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;

  const V2TextField({
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.suffix,
    this.onSuffixTap,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.autovalidateMode,
    super.key,
  });

  /// 이메일 입력 필드
  factory V2TextField.email({
    TextEditingController? controller,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? Function(String?)? validator,
    bool enabled = true,
    Key? key,
  }) {
    return V2TextField(
      label: '이메일',
      hint: 'example@email.com',
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: Icons.email_outlined,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      enabled: enabled,
      key: key,
    );
  }

  /// 비밀번호 입력 필드
  static Widget password({
    TextEditingController? controller,
    FocusNode? focusNode,
    String label = '비밀번호',
    String hint = '8자 이상, 영문 + 숫자',
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? Function(String?)? validator,
    bool enabled = true,
    Key? key,
  }) {
    return _PasswordTextField(
      label: label,
      hint: hint,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      enabled: enabled,
      key: key,
    );
  }

  /// 숫자 입력 필드
  factory V2TextField.number({
    String? label,
    String? hint,
    String? suffix,
    TextEditingController? controller,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? Function(String?)? validator,
    bool allowDecimal = true,
    bool enabled = true,
    Key? key,
  }) {
    return V2TextField(
      label: label,
      hint: hint,
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.numberWithOptions(
        decimal: allowDecimal,
        signed: false,
      ),
      textInputAction: TextInputAction.done,
      inputFormatters: [
        if (allowDecimal)
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
        else
          FilteringTextInputFormatter.digitsOnly,
      ],
      suffix: suffix != null
          ? Builder(
              builder: (context) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return Text(
                  suffix,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                );
              },
            )
          : null,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      enabled: enabled,
      key: key,
    );
  }

  /// 검색 필드
  static Widget search({
    TextEditingController? controller,
    FocusNode? focusNode,
    String hint = '검색',
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onClear,
    bool enabled = true,
    Key? key,
  }) {
    return _SearchTextField(
      hint: hint,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onClear: onClear,
      enabled: enabled,
      key: key,
    );
  }

  @override
  State<V2TextField> createState() => _V2TextFieldState();
}

class _V2TextFieldState extends State<V2TextField> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.labelMedium.copyWith(
              color: textColor,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: widget.obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          autovalidateMode: widget.autovalidateMode,
          style: AppTypography.bodyLarge.copyWith(color: textColor),
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            helperText: widget.helperText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, size: 20)
                : null,
            suffixIcon: _buildSuffix(),
            counterText: '',
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffix() {
    if (widget.suffix != null) {
      return Padding(
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        child: widget.suffix,
      );
    }

    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(widget.suffixIcon, size: 20),
        onPressed: widget.onSuffixTap,
      );
    }

    return null;
  }
}

/// 비밀번호 필드 (토글 가능)
class _PasswordTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final bool enabled;

  const _PasswordTextField({
    required this.label,
    required this.hint,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    super.key,
  });

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return V2TextField(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      obscureText: _obscureText,
      prefixIcon: Icons.lock_outlined,
      suffixIcon: _obscureText ? Icons.visibility_off : Icons.visibility,
      onSuffixTap: () => setState(() => _obscureText = !_obscureText),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      validator: widget.validator,
      enabled: widget.enabled,
    );
  }
}

/// 검색 필드
class _SearchTextField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool enabled;

  const _SearchTextField({
    required this.hint,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.enabled = true,
    super.key,
  });

  @override
  State<_SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<_SearchTextField> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return V2TextField(
      hint: widget.hint,
      controller: _controller,
      focusNode: widget.focusNode,
      textInputAction: TextInputAction.search,
      prefixIcon: Icons.search,
      suffixIcon: _hasText ? Icons.close : null,
      onSuffixTap: _hasText
          ? () {
              _controller.clear();
              widget.onClear?.call();
              widget.onChanged?.call('');
            }
          : null,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      enabled: widget.enabled,
    );
  }
}
