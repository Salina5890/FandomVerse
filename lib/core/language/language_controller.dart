import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/constants/app_constants.dart';
import '../../data/models/language_model.dart';
import '../storage/local_storage_service.dart';

/// Owns the app's active language. Persisted in Hive (settings box), same
/// pattern as [ThemeController] for theme.
///
/// Changing the language calls `Get.updateLocale`, which is GetX's built-in
/// mechanism for propagating a new locale to every `.tr` string and to
/// `GetMaterialApp` itself in a single app-wide rebuild.
class LanguageController extends GetxService {
  final LocalStorageService _storage = Get.find<LocalStorageService>();
  final Rx<Locale> locale = const Locale('en', 'US').obs;

  static const List<LanguageModel> supported = [
    LanguageModel(code: 'en', countryCode: 'US', name: 'English', nativeName: 'English', flag: '🇺🇸'),
    LanguageModel(code: 'ur', countryCode: 'PK', name: 'Urdu', nativeName: 'اردو', flag: '🇵🇰'),
    LanguageModel(code: 'hi', countryCode: 'IN', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳'),
    LanguageModel(code: 'ar', countryCode: 'SA', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦'),
    LanguageModel(code: 'fr', countryCode: 'FR', name: 'French', nativeName: 'Français', flag: '🇫🇷'),
    LanguageModel(code: 'ko', countryCode: 'KR', name: 'Korean', nativeName: '한국어', flag: '🇰🇷'),
  ];

  static const LanguageModel _fallback =
      LanguageModel(code: 'en', countryCode: 'US', name: 'English', nativeName: 'English', flag: '🇺🇸');

  /// Language codes that should flip the whole app to right-to-left layout.
  static const Set<String> rtlCodes = {'ar', 'ur'};

  bool get isRtl => rtlCodes.contains(locale.value.languageCode);

  LanguageModel get current =>
      supported.firstWhereOrNull((l) => l.code == locale.value.languageCode) ?? _fallback;

  LanguageController init() {
    final savedCode = _storage.getString(AppConstants.keyLanguage);
    final match = supported.firstWhereOrNull((l) => l.code == savedCode);
    locale.value = match != null ? Locale(match.code, match.countryCode) : const Locale('en', 'US');
    return this;
  }

  void changeLanguage(String code) {
    if (code == locale.value.languageCode) return;
    final lang = supported.firstWhereOrNull((l) => l.code == code) ?? _fallback;
    locale.value = Locale(lang.code, lang.countryCode);
    _storage.setString(AppConstants.keyLanguage, lang.code);
    Get.updateLocale(locale.value);
  }
}
