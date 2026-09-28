import 'package:flutter/material.dart';

/// Rose Quartz palette — colours sampled directly from the approved mockup
/// (light + dark). Every getter resolves against [isDark], so the whole app
/// re-skins when [ThemeController] flips the flag.
class AppColors {
  AppColors._();

  /// Flipped by ThemeController. Dark is the default (matches splash mockup).
  static bool isDark = true;

  static Color _p(int light, int dark) => Color(isDark ? dark : light);

  // ── Surfaces ──────────────────────────────────────────────
  static Color get background => _p(0xFFFDF4F5, 0xFF0E0B17);
  static Color get surface => _p(0xFFFFFBFB, 0xFF14101F);
  static Color get card => _p(0xFFFFFFFF, 0xFF1B1428);
  static Color get cardElevated => _p(0xFFF8EBF1, 0xFF24182F);
  static Color get border => _p(0xFFEBD8E2, 0xFF3A2A44);
  static Color get borderSubtle => _p(0xFFF4E6EC, 0xFF251B31);
  static Color get overlay => _p(0xD9FDF4F5, 0xD90E0B17);

  // ── Brand ─────────────────────────────────────────────────
  // Light: rose quartz #AB7392 / orchid #9E71B4 / plum #6E4D74 / peach #CD9476
  // Dark : mauve #81506D / indigo #241F3D / violet #402D5A / orchid #634277
  static Color get primary => _p(0xFF9E71B4, 0xFFC27FCB);
  static Color get primaryLight => _p(0xFFC38FC0, 0xFFF1B4F7);
  static Color get primaryDark => _p(0xFF6E4D74, 0xFF634277);
  static Color get rose => _p(0xFFAB7392, 0xFF81506D);
  static Color get accent => _p(0xFFCD9476, 0xFFE0A58A);
  static Color get accentLight => _p(0xFFF3DED2, 0xFF3A2A44);
  static Color get cyan => _p(0xFFAB7392, 0xFFD594DC); // legacy name: secondary
  static Color get cyanDim => _p(0xFF81506D, 0xFF81506D);
  static Color get secondary => rose;
  static Color get plum => _p(0xFF6E4D74, 0xFF402D5A);
  static Color get indigo => _p(0xFF8F86B8, 0xFF241F3D);

  // ── Text ──────────────────────────────────────────────────
  static Color get textPrimary => _p(0xFF402B4A, 0xFFF7F1FA);
  static Color get textSecondary => _p(0xFF7A6883, 0xFFB8A9C4);
  static Color get textTertiary => _p(0xFFA898B0, 0xFF7D6E8A);
  static Color get textOnAccent => const Color(0xFFFFFFFF);
  static Color get textDisabled => _p(0xFFC9BCD0, 0xFF4A3F57);

  // ── Status ────────────────────────────────────────────────
  static Color get success => _p(0xFF4FAF86, 0xFF67D7A4);
  static Color get warning => _p(0xFFD9A05B, 0xFFE7B86B);
  static Color get error => _p(0xFFD1587A, 0xFFE8758C);
  static Color get info => _p(0xFF6F9FD1, 0xFF7FB8E8);

  // ── Gradients ─────────────────────────────────────────────
  static LinearGradient get primaryGradient => LinearGradient(
        colors: isDark
            ? const [Color(0xFFD594DC), Color(0xFF9B62C2)]
            : const [Color(0xFFC38FC0), Color(0xFF9E71B4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get heroGradient => LinearGradient(
        colors: [background, Colors.transparent],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  static LinearGradient get cardGradient => LinearGradient(
        colors: [cardElevated, card],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get cyanGradient => LinearGradient(
        colors: isDark
            ? const [Color(0xFF81506D), Color(0xFF634277)]
            : const [Color(0xFFAB7392), Color(0xFF6E4D74)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get accentGradient => LinearGradient(
        colors: [primaryLight, primary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Peach → rose call-to-action gradient ("Add to Bookmark", "Add to Cart").
  static LinearGradient get peachGradient => const LinearGradient(
        colors: [Color(0xFFE0A58A), Color(0xFFCD8C8C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Full-screen ambience behind auth / splash screens.
  static LinearGradient get backdropGradient => LinearGradient(
        colors: isDark
            ? const [Color(0xFF241F3D), Color(0xFF0E0B17), Color(0xFF14101F)]
            : const [Color(0xFFF8E6EE), Color(0xFFFDF4F5), Color(0xFFF1E6F6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static RadialGradient get glowPrimary => RadialGradient(
        colors: [primary.withOpacity(isDark ? 0.28 : 0.22), Colors.transparent],
        radius: 0.8,
      );

  static Color get shimmerBase => _p(0xFFF1E4EA, 0xFF1B1428);
  static Color get shimmerHighlight => _p(0xFFFFFFFF, 0xFF2E2140);
}
