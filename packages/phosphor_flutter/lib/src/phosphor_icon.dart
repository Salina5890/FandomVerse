library phosphor_flutter;

import 'package:flutter/material.dart';

/// Thin convenience wrapper kept for API compatibility.
class PhosphorIcon extends Icon {
  const PhosphorIcon(
    IconData icon, {
    super.key,
    super.size,
    super.fill,
    super.weight,
    super.grade,
    super.opticalSize,
    super.color,
    super.shadows,
    super.semanticLabel,
    super.textDirection,
  }) : super(icon);
}
