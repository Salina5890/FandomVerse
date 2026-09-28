import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/fv_logo.dart';
import '../controllers/splash_controller.dart';

/// Splash — mockup screen #1. Animated starfield + orbiting rings, glowing
/// logo, gradient title and a "Tap to Continue" pill.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late final AnimationController _motion;
  late final AnimationController _exit;
  late final SplashController controller;
  Worker? _exitWorker;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SplashController());
    _motion = AnimationController(vsync: this, duration: const Duration(seconds: 14))..repeat();
    _exit = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _exitWorker = ever<bool>(controller.isExiting, (exiting) {
      if (exiting) _exit.forward();
    });
  }

  @override
  void dispose() {
    _exitWorker?.dispose();
    _motion.dispose();
    _exit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: no Obx at the root. Only the small widgets that actually read an
    // observable (_Prompt below) are wrapped, which avoids the
    // "improper use of GetX" error.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: AppColors.isDark ? Brightness.light : Brightness.dark,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: controller.continueToApp,
        child: Scaffold(
          body: AnimatedBuilder(
            animation: Listenable.merge([_motion, _exit]),
            builder: (context, _) {
              final exit = Curves.easeInCubic.transform(_exit.value);
              return Opacity(
                opacity: 1 - exit,
                child: Transform.scale(
                  scale: 1 + exit * 0.12,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      DecoratedBox(decoration: BoxDecoration(gradient: AppColors.backdropGradient)),
                      CustomPaint(painter: _StarfieldPainter(_motion.value)),
                      _Blob(alignment: const Alignment(-1.1, -0.8), color: AppColors.primary, t: _motion.value, phase: 0),
                      _Blob(alignment: const Alignment(1.2, 0.9), color: AppColors.accent, t: _motion.value, phase: 2),
                      SafeArea(
                        child: Column(
                          children: [
                            const Spacer(flex: 3),
                            _LogoOrbit(t: _motion.value),
                            const SizedBox(height: 28),
                            _Title(),
                            const Spacer(flex: 4),
                            _Prompt(controller: controller),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (r) => AppColors.primaryGradient.createShader(r),
          child: Text(
            'Fandom Verse',
            style: GoogleFonts.outfit(fontSize: 38, fontWeight: FontWeight.w700, color: Colors.white, height: 1.05),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Pocket Edition',
          style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w400, color: AppColors.textPrimary, letterSpacing: 1.2),
        ),
        const SizedBox(height: 14),
        Text(
          'Fandom Trivia on the Go',
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, letterSpacing: 2.2),
        ),
      ],
    )
        .animate(delay: 700.ms)
        .fadeIn(duration: 700.ms)
        .slideY(begin: .25, end: 0, curve: Curves.easeOutCubic, duration: 800.ms);
  }
}

class _LogoOrbit extends StatelessWidget {
  final double t;
  const _LogoOrbit({required this.t});

  @override
  Widget build(BuildContext context) {
    final pulse = 0.5 + 0.5 * math.sin(t * math.pi * 2 * 7);
    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 190 + pulse * 20,
            height: 190 + pulse * 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppColors.primary.withOpacity(.30 + pulse * .12),
                Colors.transparent,
              ]),
            ),
          ),
          CustomPaint(size: const Size(250, 250), painter: _OrbitPainter(t)),
          const FVLogo(width: 150, showWordmark: false)
              .animate(onPlay: (c) => c.forward())
              .scale(begin: const Offset(.5, .5), end: const Offset(1, 1), duration: 1100.ms, curve: Curves.elasticOut)
              .fadeIn(duration: 500.ms),
        ],
      ),
    );
  }
}

class _Prompt extends StatelessWidget {
  final SplashController controller;
  const _Prompt({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ready = controller.isReady.value; // observable read inside Obx
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: ready
            ? Container(
                key: const ValueKey('tap'),
                padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 15),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(.45), blurRadius: 24, offset: const Offset(0, 8))],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Tap to Continue', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                    const SizedBox(width: 10),
                    FVIcon(PhosphorIconsBold.arrowRight, size: 18, color: Colors.white)
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .moveX(begin: 0, end: 6, duration: 700.ms),
                  ],
                ),
              )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1, end: 1.04, duration: 1100.ms, curve: Curves.easeInOut)
            : Row(
                key: const ValueKey('load'),
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  3,
                  (i) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true), delay: (i * 180).ms)
                      .scaleXY(begin: .5, end: 1.2, duration: 500.ms)
                      .fade(begin: .35, end: 1, duration: 500.ms),
                ),
              ),
      );
    });
  }
}

class _Blob extends StatelessWidget {
  final Alignment alignment;
  final Color color;
  final double t;
  final double phase;
  const _Blob({required this.alignment, required this.color, required this.t, required this.phase});

  @override
  Widget build(BuildContext context) {
    final dx = math.sin(t * math.pi * 2 + phase) * .08;
    final dy = math.cos(t * math.pi * 2 + phase) * .08;
    return Align(
      alignment: Alignment(alignment.x + dx, alignment.y + dy),
      child: Container(
        width: 320,
        height: 320,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color.withOpacity(AppColors.isDark ? .22 : .28), Colors.transparent]),
        ),
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  final double t;
  _StarfieldPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(7);
    final paint = Paint();
    for (var i = 0; i < 70; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final r = 0.6 + rnd.nextDouble() * 1.6;
      final tw = 0.5 + 0.5 * math.sin(t * math.pi * 2 * (3 + i % 5) + i);
      paint.color = (AppColors.isDark ? Colors.white : AppColors.primary).withOpacity(.12 + tw * .4);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter old) => old.t != t;
}

class _OrbitPainter extends CustomPainter {
  final double t;
  _OrbitPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    for (var i = 0; i < 3; i++) {
      final rx = 92.0 + i * 16;
      final ry = 44.0 + i * 12;
      final angle = t * math.pi * 2 * (i.isEven ? 1 : -1) * (1 + i) * .5 + i * 1.1;
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(angle * .3 + i * .6);
      final ring = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = AppColors.primary.withOpacity(.28 - i * .06);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2), ring);
      final a = t * math.pi * 2 * (3 - i);
      final dot = Paint()..color = (i == 0 ? AppColors.primaryLight : AppColors.accent);
      canvas.drawCircle(Offset(math.cos(a) * rx, math.sin(a) * ry), 3.2 - i * .5, dot);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter old) => old.t != t;
}
