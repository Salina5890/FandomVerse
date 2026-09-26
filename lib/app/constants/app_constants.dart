class AppConstants {
  AppConstants._();

  static const String appName = 'Fandom Verse';
  static const String appTagline = 'Your Universe, Unlocked.';
  static const String appVersion = '1.0.0';

  // ── Role Keys ─────────────────────────────────────────────
  static const String roleFan = 'fan';
  static const String roleAdmin = 'admin';

  // ── Storage Keys ──────────────────────────────────────────
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyUserEmail = 'user_email';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keySelectedFandoms = 'selected_fandoms';
  static const String keyTheme = 'theme';
  static const String keyLanguage = 'language';

  // ── Hive Boxes ────────────────────────────────────────────
  static const String boxUsers = 'users';
  static const String boxFandoms = 'fandoms';
  static const String boxContent = 'content';
  static const String boxEvents = 'events';
  static const String boxProducts = 'products';
  static const String boxCategories = 'categories';
  static const String boxBookmarks = 'bookmarks';
  static const String boxSaved = 'saved_content';
  static const String boxWishlist = 'wishlist';
  static const String boxCart = 'cart';
  static const String boxOrders = 'orders';
  static const String boxFaq = 'faq';
  static const String boxGlossary = 'glossary';
  static const String boxBadges = 'badges';
  static const String boxSettings = 'settings';
  static const String boxNotifications = 'notifications';
  static const String boxInquiries = 'inquiries';

  // ── Pagination ────────────────────────────────────────────
  static const int pageSize = 20;
  static const int searchPageSize = 15;

  // ── Image Dimensions ──────────────────────────────────────
  static const double heroImageHeight = 280.0;
  static const double cardImageHeight = 180.0;
  static const double thumbnailSize = 80.0;
  static const double avatarSizeLarge = 96.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeSmall = 32.0;

  // ── Placeholder Images (unsplash-based URLs, safe for demos) ─
  static const String placeholderBanner =
      'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800&q=80';
  static const String placeholderPortrait =
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80';
  static const String placeholderProduct =
      'https://images.unsplash.com/photo-1614680376573-df3480f0c6ff?w=400&q=80';
  static const String placeholderEvent =
      'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&q=80';
  static const String placeholderAvatar =
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80';

  // ── Admin Demo ────────────────────────────────────────────
  static const String adminDemoEmail = 'admin@fandomverse.app';
  static const String adminDemoPassword = 'Admin@2024!';

  // ── Maps ──────────────────────────────────────────────────
  static const String googleMapsApiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: 'YOUR_GOOGLE_MAPS_API_KEY');
  static const String googleWebClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID', defaultValue: 'YOUR_GOOGLE_WEB_CLIENT_ID');
  static const double? officeLatitude = null;
  static const double? officeLongitude = null;
  static const String officeAddress = 'OFFICE_ADDRESS_NOT_CONFIGURED';

  // ── AI Helper ─────────────────────────────────────────────
  static const int aiResponseDelayMs = 800;

  // ── Animation Durations ───────────────────────────────────
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 350);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 3);
}
