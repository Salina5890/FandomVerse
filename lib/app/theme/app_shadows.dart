import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get primaryGlow => [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.4),
          blurRadius: 12,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get cyanGlow => [
        BoxShadow(
          color: AppColors.cyan.withOpacity(0.4),
          blurRadius: 12,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
      ];
}
