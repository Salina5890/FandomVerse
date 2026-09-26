class AppRoutes {
  AppRoutes._();

  // ── Auth ──────────────────────────────────────────────────
  static const String splash = '/';
  static const String userType = '/auth/user-type';
  static const String fanLogin = '/auth/fan-login';
  static const String fanRegister = '/auth/fan-register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String fandomSelection = '/auth/fandom-selection';
  static const String badgeSelection = '/auth/badge-selection';
  static const String adminLogin = '/auth/admin-login';

  // ── Fan — Bottom Nav ──────────────────────────────────────
  static const String fanMain = '/fan/main';        // shell with bottom nav
  static const String fanHome = '/fan/home';
  static const String fanExplore = '/fan/explore';
  static const String fanEvents = '/fan/events';
  static const String fanStore = '/fan/store';
  static const String fanProfile = '/fan/profile';

  // ── Fan — Home ────────────────────────────────────────────
  static const String notifications = '/fan/notifications';

  // ── Fan — Explore / Content ───────────────────────────────
  static const String search = '/fan/search';
  static const String searchResults = '/fan/search/results';
  static const String fandomDetail = '/fan/fandom/:id';
  static const String contentDetail = '/fan/content/:id';
  static const String characterProfiles = '/fan/characters';
  static const String characterDetail = '/fan/character/:id';
  static const String fandomIntro = '/fan/fandom-intro/:id';

  // ── Fan — Fan Hub ─────────────────────────────────────────
  static const String fanHub = '/fan/hub';
  static const String hubTopics = '/fan/hub/topics';
  static const String hubTopicDetail = '/fan/hub/topic/:id';
  static const String glossary = '/fan/glossary';
  static const String glossaryDetail = '/fan/glossary/:id';

  // ── Fan — Deep Dive ───────────────────────────────────────
  static const String deepDive = '/fan/deep-dive';
  static const String deepDiveDetail = '/fan/deep-dive/:id';
  static const String deepDiveCategory = '/fan/deep-dive/:type';
  static const String hiddenTrivia = '/fan/trivia';
  static const String advancedLore = '/fan/lore';
  static const String behindScenes = '/fan/behind-scenes';
  static const String behindStand = '/fan/behind-stand';

  // ── Fan — Bookmarks / Saved ───────────────────────────────
  static const String bookmarks = '/fan/bookmarks';
  static const String savedContent = '/fan/saved';
  static const String offlineContent = '/fan/offline';

  // ── Fan — Events ──────────────────────────────────────────
  static const String eventDetail = '/fan/event/:id';
  static const String nearbyEvents = '/fan/events/nearby';
  static const String eventCalendar = '/fan/events/calendar';
  static const String eventCategories = '/fan/events/categories';

  // ── Fan — Store ───────────────────────────────────────────
  static const String storeCategories = '/fan/store/categories';
  static const String storeSearch = '/fan/store/search';
  static const String productDetail = '/fan/product/:id';
  static const String wishlist = '/fan/wishlist';
  static const String cart = '/fan/cart';
  static const String checkout = '/fan/checkout';
  static const String orderConfirmation = '/fan/order-confirmation';
  static const String purchaseHistory = '/fan/purchase-history';

  // ── Fan — AI Helper ───────────────────────────────────────
  static const String aiHelper = '/fan/ai-helper';

  // ── Fan — Profile ─────────────────────────────────────────
  static const String editProfile = '/fan/profile/edit';
  static const String editAvatar = '/fan/profile/avatar';
  static const String editBio = '/fan/profile/bio';
  static const String myFandoms = '/fan/profile/fandoms';
  static const String fanIdentity = '/fan/profile/identity';
  static const String badges = '/fan/profile/badges';
  static const String badgeDetail = '/fan/profile/badge/:id';
  static const String activity = '/fan/profile/activity';
  static const String settings = '/fan/profile/settings';
  static const String about = '/fan/profile/about';
  static const String contact = '/fan/profile/contact';

  // Backward-compatible aliases used by profile views.
  static const String BADGES = badges;
  static const String BADGE_DETAIL = badgeDetail;
  static const String MY_FANDOMS = myFandoms;

  // ── Admin ─────────────────────────────────────────────────
  static const String adminMain = '/admin/main';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminContent = '/admin/content';
  static const String adminContentAdd = '/admin/content/add';
  static const String adminContentEdit = '/admin/content/edit/:id';
  static const String adminFandoms = '/admin/fandoms';
  static const String adminFandomAdd = '/admin/fandoms/add';
  static const String adminFandomEdit = '/admin/fandoms/edit/:id';
  static const String adminEvents = '/admin/events';
  static const String adminEventAdd = '/admin/events/add';
  static const String adminEventEdit = '/admin/events/edit/:id';
  static const String adminProducts = '/admin/products';
  static const String adminProductAdd = '/admin/products/add';
  static const String adminProductEdit = '/admin/products/edit/:id';
  static const String adminCategories = '/admin/categories';
  static const String adminCategoryAdd = '/admin/categories/add';
  static const String adminCategoryEdit = '/admin/categories/edit/:id';
  static const String adminUsers = '/admin/users';
  static const String adminUserDetail = '/admin/users/:id';
}
