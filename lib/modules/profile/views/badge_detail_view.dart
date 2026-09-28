import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../data/services/seed_data_service.dart';

class BadgeDetailView extends StatelessWidget {
  const BadgeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.parameters['id'];
    final badge = SeedDataService.badges.firstWhereOrNull((x) => x.id == id);
    return Scaffold(
      appBar: AppBar(title: const Text('Badge')),
      body: badge == null
          ? const Center(child: Text('Badge not found'))
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(badge.iconEmoji, style: const TextStyle(fontSize: 80)),
                    const SizedBox(height: 16),
                    Text(badge.name, style: AppTypography.headingLarge),
                    const SizedBox(height: 8),
                    Text(
                      badge.description,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    Chip(label: Text(badge.rarity.toUpperCase())),
                  ],
                ),
              ),
            ),
    );
  }
}
