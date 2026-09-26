import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_button.dart';
import '../../../core/widgets/fv_logo.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/widgets/fv_animations.dart';

class UserTypeSelectionView extends StatelessWidget {
  const UserTypeSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backdropGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 44, 24, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: FVLogo(width: 190),
                ).fvPop(),
                const SizedBox(height: 38),
                Text(
                  'CHOOSE YOUR SPACE',
                  style: AppTypography.overline.copyWith(
                    color: AppColors.primaryLight,
                    letterSpacing: 3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Where do you want to go?',
                  style: AppTypography.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Enter the fan universe or access the administration portal.',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 34),
                _PortalCard(
                  icon: PhosphorIconsRegular.sparkle,
                  title: 'Fan Universe',
                  subtitle: 'Explore fandoms, stories, events, collections and more.',
                  accent: AppColors.primary,
                  onTap: () => Get.toNamed(AppRoutes.fanLogin),
                ).fvIn(3),
                const SizedBox(height: 14),
                _PortalCard(
                  icon: PhosphorIconsRegular.squaresFour,
                  title: 'Admin Portal',
                  subtitle: 'Manage the platform and its content.',
                  accent: AppColors.cyan,
                  onTap: () => Get.toNamed(AppRoutes.adminLogin),
                ).fvIn(4),
                const SizedBox(height: 34),
                Text(
                  'FANDOM VERSE • POCKET EDITION',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PortalCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  const _PortalCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      scale: 0.98,
      child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.card.withOpacity(.82),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: accent.withOpacity(.24)),
            boxShadow: [
              BoxShadow(color: accent.withOpacity(.10), blurRadius: 28, offset: const Offset(0, 12)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accent.withOpacity(.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accent.withOpacity(.24)),
                ),
                child: FVIcon(icon, color: accent, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.headingSmall),
                    const SizedBox(height: 5),
                    Text(subtitle, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              FVIcon(PhosphorIconsRegular.arrowRight, color: accent),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
