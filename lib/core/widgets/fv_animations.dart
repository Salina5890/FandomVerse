import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

/// Shared entrance animations so every screen moves the same way.
extension FVAnimateX on Widget {
  /// Fade + rise. [index] staggers siblings (70 ms apart, capped).
  Widget fvIn([int index = 0]) => animate(delay: (70 * index.clamp(0, 10)).ms)
      .fadeIn(duration: 480.ms, curve: Curves.easeOut)
      .slideY(begin: .12, end: 0, duration: 620.ms, curve: Curves.easeOutCubic);

  /// Fade + slide in from the right — for horizontal carousels.
  Widget fvInX([int index = 0]) => animate(delay: (60 * index.clamp(0, 8)).ms)
      .fadeIn(duration: 420.ms)
      .slideX(begin: .18, end: 0, duration: 560.ms, curve: Curves.easeOutCubic);

  /// Springy pop — badges, success states, FABs.
  Widget fvPop([int delayMs = 0]) => animate(delay: delayMs.ms)
      .scale(begin: const Offset(.6, .6), end: const Offset(1, 1), duration: 520.ms, curve: Curves.elasticOut)
      .fadeIn(duration: 250.ms);

  /// Slow shimmer sweep — highlights premium / CTA elements.
  Widget fvShine() => animate(onPlay: (c) => c.repeat(period: 2600.ms))
      .shimmer(duration: 1600.ms, color: Colors.white.withOpacity(.35));
}

/// Page transition applied to every GetX route: fade + gentle rise + scale.
class FVPageTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, .04), end: Offset.zero).animate(curved),
        child: ScaleTransition(scale: Tween<double>(begin: .985, end: 1).animate(curved), child: child),
      ),
    );
  }
}
