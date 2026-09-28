import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/fv_logo.dart';
import '../../../core/widgets/fv_animations.dart';
import '../../../app/constants/app_constants.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('About Us')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            const FVLogo(width: 140).fvPop(),
            const SizedBox(height: 28),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Fandom Verse Pocket Edition brings news, lore, events and official '
                'merchandise for every fandom — anime, gaming, movies, comics and music — '
                'into a single, mobile-friendly space, so fans spend less time searching '
                'across scattered sites and more time enjoying what they love.',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
              ),
            ).fvIn(1),
            const SizedBox(height: AppSpacing.xl),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Project information', style: AppTypography.headingSmall),
            ).fvIn(2),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Fandom Verse Pocket Edition is a multi-platform fandom companion project. '
                'Team/developer contact details are intentionally sourced from project configuration rather than invented here.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ).fvIn(3),
          ],
        ),
      ),
    );
  }
}
