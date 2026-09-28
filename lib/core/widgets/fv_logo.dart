import 'package:flutter/material.dart';
import 'fv_icon.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme/app_colors.dart';

/// Fandom Verse brand mark (the "FV" triangle + orbit) with an optional
/// wordmark that adapts to light / dark mode.
class FVLogo extends StatelessWidget {
  final double width;
  final bool showWordmark;
  final BoxFit fit;
  final double opacity;

  const FVLogo({
    super.key,
    this.width = 180,
    this.showWordmark = true,
    this.fit = BoxFit.contain,
    this.opacity = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/fandom_verse_mark.png',
              width: showWordmark ? width * 0.72 : width,
              fit: fit,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) =>
                  FVIcon(Icons.change_history, size: width * .5, color: AppColors.primary),
            ),
            if (showWordmark) ...[
              SizedBox(height: width * 0.05),
              Text(
                'FANDOM VERSE',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: AppColors.primaryLight,
                  fontSize: width * 0.085,
                  fontWeight: FontWeight.w500,
                  letterSpacing: width * 0.02,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
