import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'constants/app_constants.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'translations/app_translations.dart';
import 'bindings/initial_binding.dart';
import '../core/language/language_controller.dart';
import '../core/widgets/fv_animations.dart';

class FandomVerseApp extends StatelessWidget {
  const FandomVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      // AppColors.isDark is already set from storage in main().
      theme: AppTheme.build(),
      translations: AppTranslations(),
      // LanguageController.init() already loaded the saved language (or
      // English by default) before this widget is built. Later changes go
      // through Get.updateLocale(), which GetMaterialApp picks up itself.
      locale: Get.find<LanguageController>().locale.value,
      fallbackLocale: const Locale('en', 'US'),
      // Arabic/Urdu need right-to-left layout — GetMaterialApp doesn't infer
      // this from `locale` alone without `flutter_localizations`, so we set
      // it explicitly here and it updates on every locale change.
      builder: (context, child) {
        final isRtl = Get.find<LanguageController>().isRtl;
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        );
      },
      customTransition: FVPageTransition(),
      transitionDuration: const Duration(milliseconds: 420),
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
