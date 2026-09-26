import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/language/language_controller.dart';
import '../../../data/models/language_model.dart';
import '../../../core/widgets/fv_animations.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final language = Get.find<LanguageController>();
    return Scaffold(
      appBar: AppBar(title: Text('settings_title'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Appearance — Rose Quartz light / dark
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Obx(() {
              final dark = theme.isDark.value; // observable read inside Obx
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('settings_appearance'.tr, style: AppTypography.headingSmall),
                  const SizedBox(height: 4),
                  Text('settings_appearance_subtitle'.tr, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(child: _ModeChip(label: 'settings_light'.tr, icon: PhosphorIconsRegular.sun, selected: !dark, onTap: () => theme.setDark(false))),
                    const SizedBox(width: 12),
                    Expanded(child: _ModeChip(label: 'settings_dark'.tr, icon: PhosphorIconsRegular.moon, selected: dark, onTap: () => theme.setDark(true))),
                  ]),
                ],
              );
            }),
          ).fvIn(0),
          const SizedBox(height: 14),
          // Language
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Obx(() {
              final activeCode = language.locale.value.languageCode; // observable read inside Obx
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('settings_language'.tr, style: AppTypography.headingSmall),
                  const SizedBox(height: 4),
                  Text('settings_language_subtitle'.tr, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 14),
                  for (final lang in LanguageController.supported) ...[
                    _LanguageRow(
                      lang: lang,
                      selected: lang.code == activeCode,
                      onTap: () => language.changeLanguage(lang.code),
                    ),
                    if (lang != LanguageController.supported.last) const SizedBox(height: 8),
                  ],
                ],
              );
            }),
          ).fvIn(1),
          const SizedBox(height: 14),
          SwitchListTile(
            value: true,
            onChanged: null,
            title: Text('settings_notifications_title'.tr),
            subtitle: Text('settings_notifications_subtitle'.tr),
          ).fvIn(2),
          ListTile(
            leading: FVIcon(PhosphorIconsRegular.info, color: AppColors.primary),
            title: Text('settings_about_title'.tr),
            subtitle: Text('settings_about_subtitle'.tr),
          ).fvIn(3),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final LanguageModel lang;
  final bool selected;
  final VoidCallback onTap;
  const _LanguageRow({required this.lang, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.primaryGradient : null,
          color: selected ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? Colors.transparent : AppColors.border),
        ),
        child: Row(
          children: [
            Text(lang.flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                lang.nativeName,
                style: AppTypography.labelLarge.copyWith(color: selected ? Colors.white : AppColors.textPrimary),
              ),
            ),
            if (selected) const FVIcon(PhosphorIconsRegular.check, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _ModeChip({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.primaryGradient : null,
          color: selected ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? Colors.transparent : AppColors.border),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          FVIcon(icon, size: 18, color: selected ? Colors.white : AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(label, style: AppTypography.labelLarge.copyWith(color: selected ? Colors.white : AppColors.textSecondary)),
        ]),
      ),
    );
  }
}
