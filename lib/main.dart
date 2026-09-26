import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/app.dart';
import 'core/storage/local_storage_service.dart';
import 'data/services/auth_service.dart';
import 'data/services/seed_data_service.dart';
import 'data/services/notification_service.dart';
import 'core/theme/theme_controller.dart';
import 'core/language/language_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Make status bar transparent
  // ── Pre-initialize ALL critical services BEFORE runApp ────
  // This prevents "AuthService not found" GetX errors.
  await Get.putAsync<LocalStorageService>(
    () => LocalStorageService().init(),
    permanent: true,
  );

  Get.put(SeedDataService(), permanent: true);

  // Theme (light / dark) — must exist before the first frame so AppColors
  // resolves to the saved mode.
  Get.put<ThemeController>(ThemeController().init(), permanent: true);

  // Language — must exist before the first frame so GetMaterialApp's
  // `locale` resolves to the saved language immediately.
  Get.put<LanguageController>(LanguageController().init(), permanent: true);

  // AuthService and NotificationService only depend on LocalStorageService
  // (already ready above), not on each other, so initialize them
  // concurrently instead of one after the other.
  await Future.wait([
    Get.putAsync<AuthService>(() => AuthService().init(), permanent: true),
    Get.putAsync<NotificationService>(
      () => NotificationService().init(),
      permanent: true,
    ),
  ]);

  runApp(const FandomVerseApp());
}
