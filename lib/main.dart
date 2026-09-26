import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/app.dart';
import 'core/storage/local_storage_service.dart';
import 'data/services/auth_service.dart';
import 'data/services/seed_data_service.dart';
import 'data/services/notification_service.dart';
import 'data/services/firestore_service.dart';
import 'data/services/ai_service.dart';
import 'core/theme/theme_controller.dart';
import 'core/language/language_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase for supported platforms
  try {
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint('Firebase init note: $e');
  }

  // Core local storage and seed services
  await Get.putAsync<LocalStorageService>(
    () => LocalStorageService().init(),
    permanent: true,
  );

  Get.put(SeedDataService(), permanent: true);

  // Backend & AI services
  await Get.putAsync<FirestoreService>(() => FirestoreService().init(), permanent: true);
  await Get.putAsync<AiService>(() => AiService().init(), permanent: true);

  // App theme and localization controllers
  Get.put<ThemeController>(ThemeController().init(), permanent: true);
  Get.put<LanguageController>(LanguageController().init(), permanent: true);

  // User auth and local notifications
  await Future.wait([
    Get.putAsync<AuthService>(() => AuthService().init(), permanent: true),
    Get.putAsync<NotificationService>(
      () => NotificationService().init(),
      permanent: true,
    ),
  ]);

  runApp(const FandomVerseApp());
}
