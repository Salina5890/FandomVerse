import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';

/// Fandom Verse Admin Design System.
///
/// Keeps the existing AdminTheme API so existing CRUD screens continue
/// working, while all visual styling follows the global Fandom Verse theme.
///
/// Design direction:
/// - Fandom Verse purple identity
/// - subtle holographic depth
/// - clean normal typography
/// - no green/cyan/orange AI-dashboard palette
/// - responsive hover/press feedback
/// - global Light/Dark theme compatible
class AdminTheme {
  AdminTheme._();

  // ---------------------------------------------------------------------------
  // SURFACES
  // ---------------------------------------------------------------------------

  static Color get bgDeep => AppColors.background;

  static Color get bgPanel => AppColors.card;

  static Color get bgPanelRaised => AppColors.cardElevated;

  static Color get hairline => AppColors.borderSubtle;

  // ---------------------------------------------------------------------------
  // FANDOM VERSE PURPLE SYSTEM
  //
  // Legacy names are intentionally preserved because existing Admin CRUD
  // screens already use them.
  // ---------------------------------------------------------------------------

  static Color get cyan => AppColors.primary;

  static Color get violet => AppColors.primary;

  static Color get magenta => AppColors.primaryLight;

  static Color get amber => AppColors.primaryLight;

  static Color get green => AppColors.primary;

  static Color get red => AppColors.error;

  static Color get primary => AppColors.primary;

  static Color get primaryLight => AppColors.primaryLight;

  static Color get rose => AppColors.rose;

  static Color get warning => AppColors.warning;

  static Color get success => AppColors.success;

  static Color get error => AppColors.error;

  // ---------------------------------------------------------------------------
  // TEXT
  // ---------------------------------------------------------------------------

  static Color get textPrimary => AppColors.textPrimary;

  static Color get textSecondary => AppColors.textSecondary;

  static Color get textFaint => AppColors.textTertiary;

  static Color get textTertiary => AppColors.textTertiary;

  // ---------------------------------------------------------------------------
  // GRADIENTS
  // ---------------------------------------------------------------------------

  /// Main Fandom Verse purple gradient.
  static LinearGradient get holoBorder => AppColors.primaryGradient;

  /// Very subtle holographic surface gradient.
  static LinearGradient get holoBorderSoft {
    return LinearGradient(
      colors: [
        AppColors.primary.withValues(alpha: .18),
        AppColors.primaryLight.withValues(alpha: .12),
        AppColors.primary.withValues(alpha: .06),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient get scanBackdrop => AppColors.backdropGradient;

  // ---------------------------------------------------------------------------
  // TYPOGRAPHY
  //
  // Do NOT use Orbitron / JetBrains Mono here.
  // Admin now follows the normal Fandom Verse typography.
  // ---------------------------------------------------------------------------

  static TextStyle display({
    double size = 20,
    Color? color,
    FontWeight w = FontWeight.w700,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: w,
      letterSpacing: 0,
      color: color ?? textPrimary,
      height: 1.15,
    );
  }

  static TextStyle mono({
    double size = 12,
    Color? color,
    FontWeight w = FontWeight.w500,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: w,
      letterSpacing: 0,
      color: color ?? textSecondary,
      height: 1.25,
    );
  }

  static TextStyle body({
    double size = 14,
    Color? color,
    FontWeight w = FontWeight.w500,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: w,
      color: color ?? textPrimary,
      height: 1.3,
    );
  }

  // ---------------------------------------------------------------------------
  // SUBTLE PURPLE GLOW
  // ---------------------------------------------------------------------------

  static List<BoxShadow> glow(
    Color c, {
    double blur = 18,
    double alpha = .18,
    double spread = -3,
  }) {
    return [
      BoxShadow(
        color: c.withValues(alpha: alpha),
        blurRadius: blur,
        spreadRadius: spread,
      ),
    ];
  }
}

// ===========================================================================
// HOLO PANEL
// ===========================================================================

class HoloPanel extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? glowColor;
  final Gradient? borderGradient;
  final VoidCallback? onTap;

  const HoloPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 18,
    this.glowColor,
    this.borderGradient,
    this.onTap,
  });

  @override
  State<HoloPanel> createState() => _HoloPanelState();
}

class _HoloPanelState extends State<HoloPanel> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.glowColor ?? AdminTheme.primary;

    final active = _hovered || _pressed;

    final panel = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      transform: Matrix4.identity()
        ..translate(
          0.0,
          _pressed
              ? 1.5
              : _hovered
              ? -1.5
              : 0.0,
        )
        ..scale(_pressed ? .992 : 1.0),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
        gradient: widget.borderGradient ?? AdminTheme.holoBorderSoft,
        boxShadow: AdminTheme.glow(
          accent,
          alpha: active ? .25 : .12,
          blur: active ? 26 : 18,
        ),
      ),
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius - 1),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: AdminTheme.bgPanel.withValues(alpha: .92),
              borderRadius: BorderRadius.circular(widget.radius - 1),
            ),
            child: widget.child,
          ),
        ),
      ),
    );

    if (widget.onTap == null) {
      return panel;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: panel,
      ),
    );
  }
}

// ===========================================================================
// ICON BOX
// ===========================================================================

class HoloIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const HoloIconBox({
    super.key,
    required this.icon,
    required this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withValues(alpha: .30)),
        boxShadow: AdminTheme.glow(color, alpha: .10, blur: 14),
      ),
      child: Icon(icon, size: size, color: color),
    );
  }
}

// ===========================================================================
// BADGE
// ===========================================================================

class HoloBadge extends StatelessWidget {
  final String text;
  final Color color;

  const HoloBadge({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: .30)),
      ),
      child: Text(
        text,
        style: AdminTheme.body(size: 11, color: color, w: FontWeight.w700),
      ),
    );
  }
}

// ===========================================================================
// BUTTON
// ===========================================================================

enum HoloButtonStyle { solid, outline, danger }

class HoloButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final HoloButtonStyle style;
  final bool fullWidth;

  const HoloButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.style = HoloButtonStyle.solid,
    this.fullWidth = true,
  });

  @override
  State<HoloButton> createState() => _HoloButtonState();
}

class _HoloButtonState extends State<HoloButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDanger = widget.style == HoloButtonStyle.danger;
    final isOutline = widget.style == HoloButtonStyle.outline;

    final accent = isDanger ? AdminTheme.red : AdminTheme.primary;

    final labelColor = isOutline ? accent : Colors.white;

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translate(0.0, _pressed ? 1.0 : 0.0)
          ..scale(_pressed ? .985 : 1.0),
        width: widget.fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: isOutline
              ? null
              : LinearGradient(
                  colors: isDanger
                      ? [AdminTheme.red, AdminTheme.primaryLight]
                      : [AdminTheme.primary, AdminTheme.primaryLight],
                ),
          color: isOutline ? AdminTheme.bgPanelRaised : null,
          border: Border.all(
            color: isOutline
                ? accent.withValues(alpha: .55)
                : Colors.transparent,
            width: 1.2,
          ),
          boxShadow: widget.onPressed == null
              ? null
              : AdminTheme.glow(accent, alpha: .22, blur: 18),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, size: 19, color: labelColor),
              const SizedBox(width: 9),
            ],
            Text(
              widget.label,
              style: AdminTheme.body(w: FontWeight.w700, color: labelColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// ICON ACTION
// ===========================================================================

class HoloIconAction extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String? tooltip;

  const HoloIconAction({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.tooltip,
  });

  @override
  State<HoloIconAction> createState() => _HoloIconActionState();
}

class _HoloIconActionState extends State<HoloIconAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? '',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.identity()..scale(_hovered ? 1.06 : 1.0),
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: _hovered ? .18 : .10),
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.color.withValues(alpha: _hovered ? .35 : .20),
            ),
            boxShadow: _hovered
                ? AdminTheme.glow(widget.color, alpha: .18, blur: 16)
                : null,
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: widget.onPressed,
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Icon(widget.icon, size: 20, color: widget.color),
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// TEXT FIELD
// ===========================================================================

class HoloTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;

  const HoloTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AdminTheme.hairline),
    );

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: AdminTheme.body(color: AdminTheme.textPrimary),
      cursorColor: AdminTheme.primary,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AdminTheme.body(size: 13, color: AdminTheme.textSecondary),
        filled: true,
        fillColor: AdminTheme.bgPanelRaised,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: AdminTheme.primary, width: 1.5),
        ),
      ),
    );
  }
}

// ===========================================================================
// SCAFFOLD
// ===========================================================================

class HoloScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;

  const HoloScaffold({
    super.key,
    required this.title,
    required this.body,
    this.leading,
    this.actions,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminTheme.bgDeep,
      appBar: AppBar(
        backgroundColor: AdminTheme.bgDeep.withValues(alpha: .92),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: leading,
        title: Text(
          title,
          style: AdminTheme.display(size: 18, w: FontWeight.w700),
        ),
        actions: actions,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(gradient: AdminTheme.holoBorder),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AdminTheme.scanBackdrop),
        child: SafeArea(child: body),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

// ===========================================================================
// BOTTOM SHEET
// ===========================================================================

Future<T?> showHoloSheet<T>({
  required BuildContext context,
  required String title,
  required List<Widget> children,
}) {
  return Get.bottomSheet<T>(
    Container(
      decoration: BoxDecoration(
        color: AdminTheme.bgPanel,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AdminTheme.primary, width: 1.2)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: AdminTheme.holoBorder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 10),
                Text(title, style: AdminTheme.display(size: 17)),
              ],
            ),
            const SizedBox(height: 18),
            ...children,
          ],
        ),
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

// ===========================================================================
// CONFIRM DIALOG
// ===========================================================================

void showHoloConfirm({
  required String title,
  required String message,
  required VoidCallback onConfirm,
  String confirmLabel = 'Confirm',
}) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      child: HoloPanel(
        glowColor: AdminTheme.red,
        borderGradient: LinearGradient(
          colors: [
            AdminTheme.red.withValues(alpha: .55),
            AdminTheme.primary.withValues(alpha: .55),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AdminTheme.display(size: 17, color: AdminTheme.red),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: AdminTheme.body(color: AdminTheme.textSecondary),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: HoloButton(
                    label: 'Cancel',
                    style: HoloButtonStyle.outline,
                    onPressed: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HoloButton(
                    label: confirmLabel,
                    style: HoloButtonStyle.danger,
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
