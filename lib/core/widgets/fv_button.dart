import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_shadows.dart';

enum FVButtonVariant { primary, secondary, outline, text }

class FVButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final FVButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;

  const FVButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = FVButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(text),
            ],
          );

    Widget button;
    switch (variant) {
      case FVButtonVariant.primary:
        button = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.button),
            gradient: onPressed == null ? null : AppColors.primaryGradient,
            boxShadow: onPressed == null ? null : AppShadows.primaryGlow,
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: AppColors.surface,
              disabledForegroundColor: AppColors.textDisabled,
            ),
            child: content,
          ),
        );
        break;
      case FVButtonVariant.secondary:
        button = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.button),
            gradient: onPressed == null ? null : AppColors.cyanGradient,
            boxShadow: onPressed == null ? null : AppShadows.cyanGlow,
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: AppColors.surface,
              disabledForegroundColor: AppColors.textDisabled,
            ),
            child: content,
          ),
        );
        break;
      case FVButtonVariant.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: content,
        );
        break;
      case FVButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          child: content,
        );
        break;
    }

    final sized = isFullWidth
        ? SizedBox(width: double.infinity, height: 52, child: button)
        : SizedBox(height: 52, child: button);
    return PressScale(child: sized);
  }
}

/// Subtle press-down scale used by buttons, cards and chips.
class PressScale extends StatefulWidget {
  final Widget child;
  final double scale;
  const PressScale({super.key, required this.child, this.scale = 0.96});

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      onPointerCancel: (_) => setState(() => _down = false),
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
