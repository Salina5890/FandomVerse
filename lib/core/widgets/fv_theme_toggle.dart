import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../theme/theme_controller.dart';

/// Compact animated Light/Dark switch for the top App Bar.
///
/// Deliberately NOT a moon/sun IconButton — this is a small horizontal
/// pill-track switch (like a premium iOS-style toggle) whose track colour,
/// thumb gradient and thumb position all animate together, so the current
/// state ("dark" thumb parked right on a night-purple track, "light" thumb
/// parked left on a soft blush track) reads at a glance.
class FVThemeToggle extends StatefulWidget {
  const FVThemeToggle({super.key});

  static const double width = 52;
  static const double height = 28;

  @override
  State<FVThemeToggle> createState() => _FVThemeToggleState();
}

class _FVThemeToggleState extends State<FVThemeToggle> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    return Obx(() {
      final dark = theme.isDark.value;
      return Semantics(
        button: true,
        toggled: dark,
        label: dark ? 'Switch to light mode' : 'Switch to dark mode',
        child: GestureDetector(
          onTap: theme.toggle,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          behavior: HitTestBehavior.opaque,
          child: AnimatedScale(
            scale: _pressed ? 0.94 : 1.0,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              width: FVThemeToggle.width,
              height: FVThemeToggle.height,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(FVThemeToggle.height / 2),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: dark
                      ? const [Color(0xFF241F3D), Color(0xFF120E1E)]
                      : const [Color(0xFFF8E6EE), Color(0xFFFCF3F6)],
                ),
                border: Border.all(
                  color: dark
                      ? AppColors.primary.withOpacity(.35)
                      : AppColors.border,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(dark ? .22 : .12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(dark ? .22 : .06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Faint inset track texture for a subtle "recessed" depth,
                  // not a realistic hardware bevel.
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(FVThemeToggle.height / 2),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(dark ? .14 : .03),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    alignment:
                        dark ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: FVThemeToggle.height - 6,
                      height: FVThemeToggle.height - 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: dark
                              ? const [Color(0xFFE2A6E8), Color(0xFF9B62C2)]
                              : const [Colors.white, Color(0xFFF3DED2)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (dark ? AppColors.primary : AppColors.accent)
                                .withOpacity(.55),
                            blurRadius: 6,
                            spreadRadius: -0.5,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(.18),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      // Tiny top-left highlight for a soft 3D pop — no
                      // literal hardware-knob rendering.
                      child: Align(
                        alignment: const Alignment(-0.4, -0.5),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(dark ? .35 : .75),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
