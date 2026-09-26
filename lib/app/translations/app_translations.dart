import 'package:get/get.dart';

/// App-wide translation table, wired into `GetMaterialApp(translations: ...)`.
///
/// Every widget that renders text through the `.tr` extension (e.g.
/// `'nav_home'.tr`) re-resolves automatically whenever the active locale
/// changes via `LanguageController` / `Get.updateLocale`, so this is the
/// single place new strings get added as more screens are migrated to `.tr`.
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': _en,
        'ur_PK': _ur,
        'hi_IN': _hi,
        'ar_SA': _ar,
        'fr_FR': _fr,
        'ko_KR': _ko,
      };

  static const Map<String, String> _en = {
    // Bottom navigation
    'nav_home': 'Home',
    'nav_explore': 'Explore',
    'nav_events': 'Events',
    'nav_store': 'Store',
    'nav_profile': 'Profile',

    // Settings / Profile Setup screen
    'settings_title': 'Settings',
    'settings_appearance': 'Appearance',
    'settings_appearance_subtitle': 'Rose Quartz theme',
    'settings_light': 'Light',
    'settings_dark': 'Dark',
    'settings_language': 'Language',
    'settings_language_subtitle': 'Choose the language the app is shown in',
    'settings_notifications_title': 'Notifications',
    'settings_notifications_subtitle': 'Receive updates about your fandoms',
    'settings_about_title': 'About',
    'settings_about_subtitle': 'Fandom Verse Pocket Edition',

    // Language names
    'language_english': 'English',
    'language_urdu': 'Urdu',
    'language_hindi': 'Hindi',

    // Profile screen
    'profile_title': 'Profile',
    'profile_settings': 'Settings',
    'profile_edit_profile': 'Edit Profile',
    'profile_my_fandoms': 'My Fandoms',
    'profile_badges': 'Badges',
    'profile_activity': 'Activity',
    'profile_logout': 'Log Out',

    // Home / section headers used app-wide
    'section_discover': 'Discover',
    'section_trending_fandoms': 'Trending fandoms',
    'section_explore_all': 'Explore all',
    'section_saved': 'Saved',
    'section_fan_hub': 'Fan Hub',
    'section_nearby': 'Nearby',

    // Common actions
    'action_add_to_cart': 'Add to Cart',
    'action_out_of_stock': 'Out of Stock',
    'action_save': 'Save',
    'action_cancel': 'Cancel',
    'action_go_back': 'Go Back',
    'action_see_all': 'See All',
  };

  static const Map<String, String> _ur = {
    'nav_home': 'ہوم',
    'nav_explore': 'دریافت کریں',
    'nav_events': 'ایونٹس',
    'nav_store': 'اسٹور',
    'nav_profile': 'پروفائل',

    'settings_title': 'ترتیبات',
    'settings_appearance': 'ظاہری شکل',
    'settings_appearance_subtitle': 'روز کوارٹز تھیم',
    'settings_light': 'لائٹ',
    'settings_dark': 'ڈارک',
    'settings_language': 'زبان',
    'settings_language_subtitle': 'وہ زبان منتخب کریں جس میں ایپ دکھائی جائے',
    'settings_notifications_title': 'اطلاعات',
    'settings_notifications_subtitle': 'اپنی فینڈمز کے بارے میں اپڈیٹس حاصل کریں',
    'settings_about_title': 'تعارف',
    'settings_about_subtitle': 'فینڈم ورس پاکٹ ایڈیشن',

    'language_english': 'انگریزی',
    'language_urdu': 'اردو',
    'language_hindi': 'ہندی',

    'profile_title': 'پروفائل',
    'profile_settings': 'ترتیبات',
    'profile_edit_profile': 'پروفائل میں ترمیم کریں',
    'profile_my_fandoms': 'میری فینڈمز',
    'profile_badges': 'بیجز',
    'profile_activity': 'سرگرمی',
    'profile_logout': 'لاگ آؤٹ',

    'section_discover': 'دریافت کریں',
    'section_trending_fandoms': 'رجحان ساز فینڈمز',
    'section_explore_all': 'سب دیکھیں',
    'section_saved': 'محفوظ شدہ',
    'section_fan_hub': 'فین ہب',
    'section_nearby': 'قریب',

    'action_add_to_cart': 'کارٹ میں شامل کریں',
    'action_out_of_stock': 'اسٹاک ختم',
    'action_save': 'محفوظ کریں',
    'action_cancel': 'منسوخ کریں',
    'action_go_back': 'واپس جائیں',
    'action_see_all': 'سب دیکھیں',
  };

  static const Map<String, String> _hi = {
    'nav_home': 'होम',
    'nav_explore': 'एक्सप्लोर',
    'nav_events': 'इवेंट्स',
    'nav_store': 'स्टोर',
    'nav_profile': 'प्रोफ़ाइल',

    'settings_title': 'सेटिंग्स',
    'settings_appearance': 'दिखावट',
    'settings_appearance_subtitle': 'रोज़ क्वार्ट्ज़ थीम',
    'settings_light': 'लाइट',
    'settings_dark': 'डार्क',
    'settings_language': 'भाषा',
    'settings_language_subtitle': 'वह भाषा चुनें जिसमें ऐप दिखाई दे',
    'settings_notifications_title': 'सूचनाएं',
    'settings_notifications_subtitle': 'अपनी फैंडम की जानकारी पाएं',
    'settings_about_title': 'ऐप के बारे में',
    'settings_about_subtitle': 'फैंडम वर्स पॉकेट एडिशन',

    'language_english': 'अंग्रेज़ी',
    'language_urdu': 'उर्दू',
    'language_hindi': 'हिन्दी',

    'profile_title': 'प्रोफ़ाइल',
    'profile_settings': 'सेटिंग्स',
    'profile_edit_profile': 'प्रोफ़ाइल संपादित करें',
    'profile_my_fandoms': 'मेरी फैंडम',
    'profile_badges': 'बैज',
    'profile_activity': 'गतिविधि',
    'profile_logout': 'लॉग आउट',

    'section_discover': 'खोजें',
    'section_trending_fandoms': 'ट्रेंडिंग फैंडम',
    'section_explore_all': 'सभी देखें',
    'section_saved': 'सेव किए गए',
    'section_fan_hub': 'फैन हब',
    'section_nearby': 'आस-पास',

    'action_add_to_cart': 'कार्ट में जोड़ें',
    'action_out_of_stock': 'स्टॉक खत्म',
    'action_save': 'सेव करें',
    'action_cancel': 'रद्द करें',
    'action_go_back': 'वापस जाएं',
    'action_see_all': 'सभी देखें',
  };

  static const Map<String, String> _ar = {
    'nav_home': 'الرئيسية',
    'nav_explore': 'استكشف',
    'nav_events': 'الفعاليات',
    'nav_store': 'المتجر',
    'nav_profile': 'الملف الشخصي',

    'settings_title': 'الإعدادات',
    'settings_appearance': 'المظهر',
    'settings_appearance_subtitle': 'سمة روز كوارتز',
    'settings_light': 'فاتح',
    'settings_dark': 'داكن',
    'settings_language': 'اللغة',
    'settings_language_subtitle': 'اختر اللغة التي يظهر بها التطبيق',
    'settings_notifications_title': 'الإشعارات',
    'settings_notifications_subtitle': 'احصل على تحديثات حول عوالمك المفضلة',
    'settings_about_title': 'حول التطبيق',
    'settings_about_subtitle': 'فاندوم فيرس - النسخة المحمولة',

    'language_english': 'الإنجليزية',
    'language_urdu': 'الأردية',
    'language_hindi': 'الهندية',

    'profile_title': 'الملف الشخصي',
    'profile_settings': 'الإعدادات',
    'profile_edit_profile': 'تعديل الملف الشخصي',
    'profile_my_fandoms': 'عوالمي',
    'profile_badges': 'الأوسمة',
    'profile_activity': 'النشاط',
    'profile_logout': 'تسجيل الخروج',

    'section_discover': 'اكتشف',
    'section_trending_fandoms': 'العوالم الرائجة',
    'section_explore_all': 'عرض الكل',
    'section_saved': 'المحفوظات',
    'section_fan_hub': 'مركز المعجبين',
    'section_nearby': 'بالقرب منك',

    'action_add_to_cart': 'أضف إلى السلة',
    'action_out_of_stock': 'غير متوفر',
    'action_save': 'حفظ',
    'action_cancel': 'إلغاء',
    'action_go_back': 'رجوع',
    'action_see_all': 'عرض الكل',
  };

  static const Map<String, String> _fr = {
    'nav_home': 'Accueil',
    'nav_explore': 'Explorer',
    'nav_events': 'Événements',
    'nav_store': 'Boutique',
    'nav_profile': 'Profil',

    'settings_title': 'Paramètres',
    'settings_appearance': 'Apparence',
    'settings_appearance_subtitle': 'Thème Rose Quartz',
    'settings_light': 'Clair',
    'settings_dark': 'Sombre',
    'settings_language': 'Langue',
    'settings_language_subtitle': "Choisissez la langue d'affichage de l'application",
    'settings_notifications_title': 'Notifications',
    'settings_notifications_subtitle': 'Recevez des mises à jour sur vos fandoms',
    'settings_about_title': 'À propos',
    'settings_about_subtitle': 'Fandom Verse Édition Pocket',

    'language_english': 'Anglais',
    'language_urdu': 'Ourdou',
    'language_hindi': 'Hindi',

    'profile_title': 'Profil',
    'profile_settings': 'Paramètres',
    'profile_edit_profile': 'Modifier le profil',
    'profile_my_fandoms': 'Mes fandoms',
    'profile_badges': 'Badges',
    'profile_activity': 'Activité',
    'profile_logout': 'Déconnexion',

    'section_discover': 'Découvrir',
    'section_trending_fandoms': 'Fandoms tendances',
    'section_explore_all': 'Tout explorer',
    'section_saved': 'Enregistrés',
    'section_fan_hub': 'Espace fans',
    'section_nearby': 'À proximité',

    'action_add_to_cart': 'Ajouter au panier',
    'action_out_of_stock': 'Rupture de stock',
    'action_save': 'Enregistrer',
    'action_cancel': 'Annuler',
    'action_go_back': 'Retour',
    'action_see_all': 'Tout voir',
  };

  static const Map<String, String> _ko = {
    'nav_home': '홈',
    'nav_explore': '탐색',
    'nav_events': '이벤트',
    'nav_store': '스토어',
    'nav_profile': '프로필',

    'settings_title': '설정',
    'settings_appearance': '테마',
    'settings_appearance_subtitle': '로즈 쿼츠 테마',
    'settings_light': '라이트',
    'settings_dark': '다크',
    'settings_language': '언어',
    'settings_language_subtitle': '앱에 표시할 언어를 선택하세요',
    'settings_notifications_title': '알림',
    'settings_notifications_subtitle': '즐겨찾는 팬덤 소식을 받아보세요',
    'settings_about_title': '앱 정보',
    'settings_about_subtitle': '팬덤 버스 포켓 에디션',

    'language_english': '영어',
    'language_urdu': '우르두어',
    'language_hindi': '힌디어',

    'profile_title': '프로필',
    'profile_settings': '설정',
    'profile_edit_profile': '프로필 수정',
    'profile_my_fandoms': '내 팬덤',
    'profile_badges': '배지',
    'profile_activity': '활동',
    'profile_logout': '로그아웃',

    'section_discover': '둘러보기',
    'section_trending_fandoms': '인기 팬덤',
    'section_explore_all': '전체 보기',
    'section_saved': '저장됨',
    'section_fan_hub': '팬 허브',
    'section_nearby': '내 주변',

    'action_add_to_cart': '장바구니에 담기',
    'action_out_of_stock': '품절',
    'action_save': '저장',
    'action_cancel': '취소',
    'action_go_back': '뒤로 가기',
    'action_see_all': '전체 보기',
  };
}
