import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimatedWidgets {
  static Widget animatedButton({
    required Widget child,
    required VoidCallback onTap,
    Duration duration = const Duration(milliseconds: 150),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.0),
      duration: duration,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTapDown: (_) {
              // Scale down on press
            },
            onTapUp: (_) {
              onTap();
            },
            onTapCancel: () {
              // Scale back on cancel
            },
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  static Widget bounceButton({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return _BounceButton(onTap: onTap, child: child);
  }

  // 3. Fade In Widget
  static Widget fadeIn({
    required Widget child,
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: child,
    );
  }

  // 4. Slide In Widget
  static Widget slideIn({
    required Widget child,
    SlideDirection direction = SlideDirection.left,
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    Offset begin;
    switch (direction) {
      case SlideDirection.left:
        begin = const Offset(-1.0, 0.0);
        break;
      case SlideDirection.right:
        begin = const Offset(1.0, 0.0);
        break;
      case SlideDirection.top:
        begin = const Offset(0.0, -1.0);
        break;
      case SlideDirection.bottom:
        begin = const Offset(0.0, 1.0);
        break;
    }

    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: begin, end: Offset.zero),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: Offset(
            offset.dx * MediaQuery.of(context).size.width,
            offset.dy * MediaQuery.of(context).size.height,
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  // 5. Scale In Widget
  static Widget scaleIn({
    required Widget child,
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: child,
    );
  }

  // 6. Animated List (Staggered)
  static Widget animatedList({
    required List<Widget> children,
    Duration delay = const Duration(milliseconds: 50),
  }) {
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 375),
          delay: delay,
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: children,
        ),
      ),
    );
  }

  // 7. Animated Grid (Staggered)
  static Widget animatedGrid({
    required int itemCount,
    required Widget Function(int index) itemBuilder,
    int crossAxisCount = 2,
  }) {
    return AnimationLimiter(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: crossAxisCount,
            child: ScaleAnimation(
              child: FadeInAnimation(child: itemBuilder(index)),
            ),
          );
        },
      ),
    );
  }

  // 8. Pulse Animation
  static Widget pulse({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    return _PulseAnimation(duration: duration, child: child);
  }

  // 9. Shake Animation
  static Widget shake({required Widget child, bool trigger = false}) {
    return _ShakeAnimation(trigger: trigger, child: child);
  }
}

// Bounce Button Implementation
class _BounceButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _BounceButton({required this.child, required this.onTap});

  @override
  State<_BounceButton> createState() => _BounceButtonState();
}

class _BounceButtonState extends State<_BounceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

// Pulse Animation Implementation
class _PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const _PulseAnimation({required this.child, required this.duration});

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}

// Shake Animation Implementation
class _ShakeAnimation extends StatefulWidget {
  final Widget child;
  final bool trigger;

  const _ShakeAnimation({required this.child, required this.trigger});

  @override
  State<_ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<_ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offset;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _offset = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn));
  }

  @override
  void didUpdateWidget(_ShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offset,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offset.value * (_controller.value * 2 - 1), 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

enum SlideDirection { left, right, top, bottom }
