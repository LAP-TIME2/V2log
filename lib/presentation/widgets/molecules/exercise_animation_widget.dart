import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/animation_config.dart';
import '../../../data/models/exercise_model.dart';

/// 운동 애니메이션 위젯
/// 우선순위 폴백 체인:
/// 1. animationUrl + thumbnailUrl → 2장 이미지 교대 플립 애니메이션
/// 2. animationUrl만 있음 → 정적 이미지
/// 3. animationUrl이 .json → Lottie.network
/// 4. URL 없음 → 근육 컬러 배경 + 아이콘 호흡 애니메이션
class ExerciseAnimationWidget extends StatelessWidget {
  final ExerciseModel exercise;
  final double size;

  const ExerciseAnimationWidget({
    required this.exercise,
    this.size = 80,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final url = exercise.animationUrl;
    final thumbUrl = exercise.thumbnailUrl;

    if (url != null && url.isNotEmpty) {
      if (url.endsWith('.json')) {
        return _LottieAnimation(url: url, size: size);
      }
      // 2장 이미지 플립 애니메이션
      if (thumbUrl != null && thumbUrl.isNotEmpty) {
        return _FlipAnimation(
          url1: url,
          url2: thumbUrl,
          size: size,
          muscleColor: exercise.primaryMuscle.color,
        );
      }
      // 1장 정적 이미지
      return _StaticImage(
        url: url,
        size: size,
        muscleColor: exercise.primaryMuscle.color,
      );
    }

    // 폴백: 호흡하는 근육색 아이콘
    return _BreathingIcon(
      muscleColor: exercise.primaryMuscle.color,
      size: size,
    );
  }
}

/// Lottie 네트워크 애니메이션
class _LottieAnimation extends StatelessWidget {
  final String url;
  final double size;

  const _LottieAnimation({required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _BreathingIcon(
            muscleColor: AppColors.primary500,
            size: size,
          );
        },
      ),
    );
  }
}

/// 2장 이미지 교대 플립 애니메이션 (시작 자세 ↔ 끝 자세)
class _FlipAnimation extends StatefulWidget {
  final String url1;
  final String url2;
  final double size;
  final Color muscleColor;

  const _FlipAnimation({
    required this.url1,
    required this.url2,
    required this.size,
    required this.muscleColor,
  });

  @override
  State<_FlipAnimation> createState() => _FlipAnimationState();
}

class _FlipAnimationState extends State<_FlipAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.65, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AnimationConfig.shouldAnimate(context)) {
      return _StaticImage(
        url: widget.url1,
        size: widget.size,
        muscleColor: widget.muscleColor,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.size * 0.15),
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return Stack(
              children: [
                // 이미지 1 (시작 자세)
                Positioned.fill(
                  child: Opacity(
                    opacity: 1.0 - _animation.value,
                    child: CachedNetworkImage(
                      imageUrl: widget.url1,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _BreathingIcon(
                        muscleColor: widget.muscleColor,
                        size: widget.size,
                      ),
                      errorWidget: (context, url, error) => _BreathingIcon(
                        muscleColor: widget.muscleColor,
                        size: widget.size,
                      ),
                    ),
                  ),
                ),
                // 이미지 2 (끝 자세)
                Positioned.fill(
                  child: Opacity(
                    opacity: _animation.value,
                    child: CachedNetworkImage(
                      imageUrl: widget.url2,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const SizedBox.shrink(),
                      errorWidget: (context, url, error) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// 정적 이미지 (1장만)
class _StaticImage extends StatelessWidget {
  final String url;
  final double size;
  final Color muscleColor;

  const _StaticImage({
    required this.url,
    required this.size,
    required this.muscleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.15),
      child: CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => _BreathingIcon(
          muscleColor: muscleColor,
          size: size,
        ),
        errorWidget: (context, url, error) => _BreathingIcon(
          muscleColor: muscleColor,
          size: size,
        ),
      ),
    );
  }
}

/// 호흡하는 근육색 아이콘 (폴백)
class _BreathingIcon extends StatefulWidget {
  final Color muscleColor;
  final double size;

  const _BreathingIcon({required this.muscleColor, required this.size});

  @override
  State<_BreathingIcon> createState() => _BreathingIconState();
}

class _BreathingIconState extends State<_BreathingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shouldAnimate = AnimationConfig.shouldAnimate(context);

    Widget icon = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.muscleColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(widget.size * 0.2),
      ),
      child: Icon(
        Icons.fitness_center,
        color: widget.muscleColor,
        size: widget.size * 0.45,
      ),
    );

    if (!shouldAnimate) return icon;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: icon,
    );
  }
}
