import 'package:get/get.dart';
import 'app_routes.dart';

// Auth
import '../../modules/auth/views/splash_view.dart';
import '../../modules/auth/views/user_type_selection_view.dart';
import '../../modules/auth/views/fan_login_view.dart';
import '../../modules/auth/views/fan_registration_view.dart';
import '../../modules/auth/views/forgot_password_view.dart';
import '../../modules/auth/views/admin_login_view.dart';
import '../../modules/auth/views/fandom_selection_view.dart';
import '../../modules/auth/views/badge_selection_view.dart';

// Home / Shell
import '../../modules/home/views/fan_main_view.dart';
import '../../modules/home/views/fan_home_view.dart';
import '../../modules/notifications/views/notifications_view.dart';

// Explore / Content
import '../../modules/home/views/explore_view.dart';
import '../../modules/explore/views/search_view.dart';
import '../../modules/explore/views/fandom_detail_view.dart';
import '../../modules/content/views/content_detail_view.dart';
import '../../modules/explore/views/character_profiles_view.dart';
import '../../modules/explore/views/character_detail_view.dart';

// Hub
import '../../modules/hub/views/fan_hub_view.dart';
import '../../modules/hub/views/glossary_view.dart';
import '../../modules/hub/views/glossary_detail_view.dart';
import '../../modules/hub/views/deep_dive_view.dart';
import '../../modules/hub/views/deep_dive_category_view.dart';

// Bookmarks
import '../../modules/bookmarks/views/bookmarks_view.dart';

// Events
import '../../modules/events/views/events_view.dart';
import '../../modules/events/views/event_detail_view.dart';
import '../../modules/events/views/nearby_events_view.dart';
import '../../modules/events/views/event_calendar_view.dart';
import '../../modules/events/views/event_categories_view.dart';

// Store
import '../../modules/store/views/store_view.dart';
import '../../modules/store/views/store_categories_view.dart';
import '../../modules/store/views/store_search_view.dart';
import '../../modules/store/views/product_detail_view.dart';
import '../../modules/store/views/wishlist_view.dart';
import '../../modules/store/views/cart_view.dart';
import '../../modules/store/views/checkout_view.dart';
import '../../modules/store/views/order_confirmation_view.dart';
import '../../modules/store/views/purchase_history_view.dart';

// AI
import '../../modules/ai_helper/views/ai_helper_view.dart';

// Profile
import '../../modules/profile/views/profile_view.dart';
import '../../modules/profile/views/edit_profile_view.dart';
import '../../modules/profile/views/edit_avatar_view.dart';
import '../../modules/profile/views/edit_bio_view.dart';
import '../../modules/profile/views/my_fandoms_view.dart';
import '../../modules/profile/views/fan_identity_view.dart';
import '../../modules/profile/views/badges_view.dart';
import '../../modules/profile/views/badge_detail_view.dart';
import '../../modules/profile/views/activity_view.dart';
import '../../modules/profile/views/settings_view.dart';
import '../../modules/profile/views/about_view.dart';
import '../../modules/profile/views/contact_view.dart';

// Admin
import '../../modules/admin/views/admin_dashboard_view.dart';
import '../../modules/admin/views/admin_moderation_view.dart';
import '../../modules/admin/views/admin_users_view.dart';
import '../../modules/admin/views/admin_categories_view.dart';

// Controllers needed by route bindings (fixes GetX "controller not found")
import '../../modules/store/controllers/cart_controller.dart';
import '../../modules/store/controllers/checkout_controller.dart';
import '../../modules/store/controllers/product_detail_controller.dart';
import '../../modules/store/controllers/purchase_history_controller.dart';
import '../../modules/store/controllers/store_search_controller.dart';
import '../../modules/store/controllers/wishlist_controller.dart';
import '../../modules/events/controllers/event_calendar_controller.dart';
import '../../modules/hub/controllers/glossary_controller.dart';
import '../../modules/explore/controllers/character_controller.dart';

class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    // ── Auth ──────────────────────────────────────────────────
    GetPage(name: AppRoutes.splash, page: () => const SplashView()),
    GetPage(name: AppRoutes.userType, page: () => const UserTypeSelectionView()),
    GetPage(name: AppRoutes.fanLogin, page: () => const FanLoginView()),
    GetPage(name: AppRoutes.fanRegister, page: () => const FanRegistrationView()),
    GetPage(name: AppRoutes.forgotPassword, page: () => const ForgotPasswordView()),
    GetPage(name: AppRoutes.adminLogin, page: () => const AdminLoginView()),
    GetPage(name: AppRoutes.fandomSelection, page: () => const FandomSelectionView()),
    GetPage(name: AppRoutes.badgeSelection, page: () => const BadgeSelectionView()),

    // ── Fan Shell & Home ──────────────────────────────────────
    GetPage(name: AppRoutes.fanMain, page: () => const FanMainView()),
    GetPage(name: AppRoutes.fanHome, page: () => const FanHomeView()),
    GetPage(name: AppRoutes.notifications, page: () => const NotificationsView()),

    // ── Explore & Content ─────────────────────────────────────
    GetPage(name: AppRoutes.fanExplore, page: () => const ExploreView()),
    GetPage(name: AppRoutes.gallery, page: () => const ExploreView()),
    GetPage(name: AppRoutes.search, page: () => const SearchView()),
    GetPage(name: AppRoutes.searchResults, page: () => const SearchView()),
    GetPage(name: AppRoutes.fandomDetail, page: () => const FandomDetailView()),
    GetPage(name: AppRoutes.fandomIntro, page: () => const FandomDetailView()),
    GetPage(name: AppRoutes.contentDetail, page: () => const ContentDetailView()),
    GetPage(name: AppRoutes.characterProfiles, page: () => const CharacterProfilesView()),
    GetPage(
      name: AppRoutes.characterDetail,
      page: () => const CharacterDetailView(),
      binding: BindingsBuilder(() => Get.lazyPut<CharacterController>(() => CharacterController())),
    ),

    // ── Fan Hub & Deep Dive ───────────────────────────────────
    GetPage(name: AppRoutes.fanHub, page: () => const FanHubView()),
    GetPage(name: AppRoutes.glossary, page: () => const GlossaryView()),
    GetPage(
      name: AppRoutes.glossaryDetail,
      page: () => const GlossaryDetailView(),
      binding: BindingsBuilder(() => Get.lazyPut<GlossaryController>(() => GlossaryController())),
    ),
    GetPage(name: AppRoutes.deepDive, page: () => const DeepDiveView()),
    // Used by Get.toNamed(AppRoutes.deepDiveCategory.replaceFirst(':type', ...))
    // in Fan Hub + Deep Dive screens. It was never registered => "unknown route".
    GetPage(name: AppRoutes.deepDiveCategory, page: () => const DeepDiveCategoryView()),
    GetPage(name: AppRoutes.hiddenTrivia, page: () => const DeepDiveCategoryView()),
    GetPage(name: AppRoutes.advancedLore, page: () => const DeepDiveCategoryView()),
    GetPage(name: AppRoutes.behindScenes, page: () => const DeepDiveCategoryView()),
    GetPage(name: AppRoutes.behindStand, page: () => const DeepDiveCategoryView()),

    // ── Bookmarks ─────────────────────────────────────────────
    GetPage(name: AppRoutes.bookmarks, page: () => const BookmarksView()),
    GetPage(name: AppRoutes.savedContent, page: () => const BookmarksView()),
    GetPage(name: AppRoutes.offlineContent, page: () => const BookmarksView()),

    // ── Events ────────────────────────────────────────────────
    GetPage(name: AppRoutes.fanEvents, page: () => const EventsView()),
    GetPage(name: AppRoutes.eventDetail, page: () => const EventDetailView()),
    GetPage(name: AppRoutes.nearbyEvents, page: () => const NearbyEventsView()),
    GetPage(
      name: AppRoutes.eventCalendar,
      page: () => const EventCalendarView(),
      binding: BindingsBuilder(() => Get.lazyPut<EventCalendarController>(() => EventCalendarController())),
    ),
    GetPage(name: AppRoutes.eventCategories, page: () => const EventCategoriesView()),

    // ── Store ─────────────────────────────────────────────────
    GetPage(name: AppRoutes.fanStore, page: () => const StoreView()),
    GetPage(name: AppRoutes.storeCategories, page: () => const StoreCategoriesView()),
    GetPage(
      name: AppRoutes.storeSearch,
      page: () => const StoreSearchView(),
      binding: BindingsBuilder(() => Get.lazyPut<StoreSearchController>(() => StoreSearchController())),
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailView(),
      binding: BindingsBuilder(() => Get.lazyPut<ProductDetailController>(() => ProductDetailController())),
    ),
    GetPage(
      name: AppRoutes.wishlist,
      page: () => const WishlistView(),
      binding: BindingsBuilder(() => Get.lazyPut<WishlistController>(() => WishlistController())),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartView(),
      binding: BindingsBuilder(() => Get.lazyPut<CartController>(() => CartController())),
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutView(),
      binding: BindingsBuilder(() {
        // CheckoutController does Get.find<CartController>(), so make sure it exists first.
        Get.lazyPut<CartController>(() => CartController());
        Get.lazyPut<CheckoutController>(() => CheckoutController());
      }),
    ),
    GetPage(name: AppRoutes.orderConfirmation, page: () => const OrderConfirmationView()),
    GetPage(
      name: AppRoutes.purchaseHistory,
      page: () => const PurchaseHistoryView(),
      binding: BindingsBuilder(() => Get.lazyPut<PurchaseHistoryController>(() => PurchaseHistoryController())),
    ),

    // ── AI Helper ─────────────────────────────────────────────
    GetPage(name: AppRoutes.aiHelper, page: () => const AiHelperView()),

    // ── Profile ───────────────────────────────────────────────
    GetPage(name: AppRoutes.fanProfile, page: () => const ProfileView()),
    GetPage(name: AppRoutes.editProfile, page: () => const EditProfileView()),
    GetPage(name: AppRoutes.editAvatar, page: () => const EditAvatarView()),
    GetPage(name: AppRoutes.editBio, page: () => const EditBioView()),
    GetPage(name: AppRoutes.myFandoms, page: () => const MyFandomsView()),
    GetPage(name: AppRoutes.fanIdentity, page: () => const FanIdentityView()),
    GetPage(name: AppRoutes.badges, page: () => const BadgesView()),
    GetPage(name: AppRoutes.badgeDetail, page: () => const BadgeDetailView()),
    GetPage(name: AppRoutes.activity, page: () => const ActivityView()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsView()),
    GetPage(name: AppRoutes.about, page: () => const AboutView()),
    GetPage(name: AppRoutes.contact, page: () => const ContactView()),

    // ── Admin ─────────────────────────────────────────────────
    GetPage(name: AppRoutes.adminDashboard, page: () => const AdminDashboardView()),
    GetPage(name: AppRoutes.adminContent, page: () => const AdminModerationView()),
    GetPage(name: AppRoutes.adminUsers, page: () => const AdminUsersView()),
    GetPage(name: AppRoutes.adminCategories, page: () => const AdminCategoriesView()),
  ];
}
