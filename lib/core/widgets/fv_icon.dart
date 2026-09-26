import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Clean, consistent Phosphor icon wrapper.
/// No artificial gradients, extrusion, or 3D effects.
class FVIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final bool dimensional;

  const FVIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
    this.textDirection,
    this.dimensional = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = size ?? IconTheme.of(context).size ?? 24;
    return Icon(
      icon,
      size: s,
      color: color ?? AppColors.textPrimary,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }
}
