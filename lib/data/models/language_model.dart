/// A language the app UI can be displayed in.
class LanguageModel {
  final String code; // ISO language code, e.g. 'en'
  final String countryCode; // ISO country code, e.g. 'US'
  final String name; // English name, e.g. 'English'
  final String nativeName; // Name in that language, e.g. 'اردو'
  final String flag; // Flag emoji shown in the picker

  const LanguageModel({
    required this.code,
    required this.countryCode,
    required this.name,
    required this.nativeName,
    required this.flag,
  });

  String get localeKey => '${code}_$countryCode';
}
