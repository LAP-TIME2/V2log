import 'package:flutter/material.dart';

import '../../../core/utils/animation_config.dart';

/// 리스트 아이템 순차 등장 (fade + 위로 슬라이드)
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration? duration;
  final double offsetY;

  const FadeSlideIn({
    required this.child,
    this.index = 0,
    this.duration,
    this.offsetY = 20,
    super.key,
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? AnimationConfig.normal,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.defaultCurve,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.offsetY),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.defaultCurve,
    ));

    // stagger 딜레이 후 시작
    final delay = AnimationConfig.staggerDelay(widget.index);
    if (delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // reduce-motion이면 애니메이션 없이 바로 표시
    if (!AnimationConfig.shouldAnimate(context)) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _slideAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// 카드/버튼 누를 때 스케일 반응
class ScaleTapWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleDown;

  const ScaleTapWrapper({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scaleDown = 0.96,
    super.key,
  });

  @override
  State<ScaleTapWrapper> createState() => _ScaleTapWrapperState();
}

class _ScaleTapWrapperState extends State<ScaleTapWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AnimationConfig.tapDuration,
      lowerBound: 0,
      upperBound: 1,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleDown,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (!AnimationConfig.shouldAnimate(context)) {
      return GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: widget.child,
      );
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// 숫자 카운트 업 애니메이션
class CountUpText extends StatefulWidget {
  final double endValue;
  final String? prefix;
  final String? suffix;
  final int decimals;
  final TextStyle? style;
  final Duration? duration;

  const CountUpText({
    required this.endValue,
    this.prefix,
    this.suffix,
    this.decimals = 0,
    this.style,
    this.duration,
    super.key,
  });

  @override
  State<CountUpText> createState() => _CountUpTextState();
}

class _CountUpTextState extends State<CountUpText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? AnimationConfig.slower,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.endValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.defaultCurve,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(CountUpText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endValue != widget.endValue) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.endValue,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: AnimationConfig.defaultCurve,
      ));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AnimationConfig.shouldAnimate(context)) {
      return Text(
        '${widget.prefix ?? ''}${widget.endValue.toStringAsFixed(widget.decimals)}${widget.suffix ?? ''}',
        style: widget.style,
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final value = _animation.value.toStringAsFixed(widget.decimals);
        return Text(
          '${widget.prefix ?? ''}$value${widget.suffix ?? ''}',
          style: widget.style,
        );
      },
    );
  }
}

/// 시머 로딩 스켈레톤
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8,
    super.key,
  });

  /// 카드 형태 스켈레톤
  factory ShimmerLoading.card({
    double height = 80,
    double borderRadius = 12,
    Key? key,
  }) {
    return ShimmerLoading(
      height: height,
      borderRadius: borderRadius,
      key: key,
    );
  }

  /// 원형 스켈레톤
  factory ShimmerLoading.circle({
    required double size,
    Key? key,
  }) {
    return ShimmerLoading(
      width: size,
      height: size,
      borderRadius: size / 2,
      key: key,
    );
  }

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);
    final highlightColor = isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(-1.0 + 2.0 * _controller.value + 1.0, 0),
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// 시머 로딩 리스트 (여러 줄 스켈레톤)
class ShimmerLoadingList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final double spacing;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const ShimmerLoadingList({
    this.itemCount = 3,
    this.itemHeight = 80,
    this.spacing = 12,
    this.borderRadius = 12,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 가용 높이에 맞는 아이템 수만 표시 (overflow 방지)
          int visibleCount = itemCount;
          if (constraints.maxHeight.isFinite) {
            final itemTotalHeight = itemHeight + spacing;
            visibleCount = (constraints.maxHeight / itemTotalHeight).floor().clamp(1, itemCount);
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(visibleCount, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: index < visibleCount - 1 ? spacing : 0),
                child: ShimmerLoading(
                  height: itemHeight,
                  borderRadius: borderRadius,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

/// 세트 완료 체크마크 애니메이션
class AnimatedCheckmark extends StatefulWidget {
  final double size;
  final Color color;
  final Duration? duration;

  const AnimatedCheckmark({
    this.size = 20,
    this.color = const Color(0xFF22C55E),
    this.duration,
    super.key,
  });

  @override
  State<AnimatedCheckmark> createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? AnimationConfig.normal,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AnimationConfig.shouldAnimate(context)) {
      return Icon(Icons.check_circle, color: widget.color, size: widget.size);
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _CheckmarkPainter(
            progress: CurvedAnimation(
              parent: _controller,
              curve: AnimationConfig.defaultCurve,
            ).value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

/// PR 달성 트로피 아이콘 (반짝이는 펄스)
class AnimatedTrophy extends StatefulWidget {
  final double size;
  final Color color;

  const AnimatedTrophy({
    this.size = 20,
    this.color = const Color(0xFFF59E0B),
    super.key,
  });

  @override
  State<AnimatedTrophy> createState() => _AnimatedTrophyState();
}

class _AnimatedTrophyState extends State<AnimatedTrophy>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.9), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AnimationConfig.shouldAnimate(context)) {
      return Icon(Icons.emoji_events, color: widget.color, size: widget.size);
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.4 * _glowAnimation.value),
                  blurRadius: 8 * _glowAnimation.value,
                  spreadRadius: 2 * _glowAnimation.value,
                ),
              ],
            ),
            child: Icon(
              Icons.emoji_events,
              color: widget.color,
              size: widget.size,
            ),
          ),
        );
      },
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CheckmarkPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 원 배경
    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.2 * progress)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * progress, bgPaint);

    // 체크마크
    if (progress > 0.3) {
      final checkProgress = ((progress - 0.3) / 0.7).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      final path = Path();
      final startX = size.width * 0.25;
      final startY = size.height * 0.50;
      final midX = size.width * 0.42;
      final midY = size.height * 0.67;
      final endX = size.width * 0.75;
      final endY = size.height * 0.35;

      path.moveTo(startX, startY);

      if (checkProgress <= 0.5) {
        // 첫 번째 선
        final t = checkProgress * 2;
        path.lineTo(
          startX + (midX - startX) * t,
          startY + (midY - startY) * t,
        );
      } else {
        // 첫 번째 선 + 두 번째 선
        path.lineTo(midX, midY);
        final t = (checkProgress - 0.5) * 2;
        path.lineTo(
          midX + (endX - midX) * t,
          midY + (endY - midY) * t,
        );
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
