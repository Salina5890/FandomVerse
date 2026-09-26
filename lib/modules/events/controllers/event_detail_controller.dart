import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/cart_models.dart';
import '../../../data/services/seed_data_service.dart';
import '../../../data/services/notification_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../app/routes/app_routes.dart';

class EventDetailController extends GetxController {
  final String eventId;
  final Rx<EventModel?> event = Rx<EventModel?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isRsvped = false.obs;
  final RxBool isBookmarked = false.obs;
  final NotificationService _notifications = Get.find<NotificationService>();
  final LocalStorageService _storage = Get.find<LocalStorageService>();

  EventDetailController(this.eventId);

  @override
  void onInit() {
    super.onInit();
    _loadEvent();
  }

  void _loadEvent() {
    isLoading.value = true;
    try {
      event.value = SeedDataService.events.firstWhere(
        (e) => e.id == eventId,
      );
      isBookmarked.value = _storage.isBookmarked(eventId);
    } catch (_) {
      event.value = null;
    }
    isLoading.value = false;
  }

  void toggleBookmark() {
    final e = event.value;
    if (e == null) return;

    if (isBookmarked.value) {
      final bookmarkId = _storage.getBookmarkId(eventId);
      if (bookmarkId != null) {
        _storage.removeBookmark(bookmarkId);
      }
      isBookmarked.value = false;
      Get.snackbar('Removed', 'Bookmark removed',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      final userId = Get.find<AuthService>().currentUser.value?.id ?? 'guest';
      final bookmark = BookmarkModel(
        id: const Uuid().v4(),
        userId: userId,
        contentId: e.id,
        contentTitle: e.title,
        contentImageUrl: e.imageUrl,
        contentType: 'event',
        fandomId: e.fandomId,
        createdAt: DateTime.now(),
      );
      _storage.saveBookmark(bookmark);
      isBookmarked.value = true;
      Get.snackbar('Bookmarked', '${e.title} saved',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void toggleRsvp() {
    isRsvped.toggle();
    final status = isRsvped.value ? 'RSVP confirmed!' : 'RSVP cancelled';
    if (isRsvped.value && event.value != null) {
      final e = event.value!;
      _notifications.addIfMissing(
        dedupeKey: 'event-rsvp:${e.id}',
        type: 'event_reminder',
        title: 'Event Reminder',
        message: '${e.title} is scheduled for ${e.city}.',
        iconKey: 'calendar',
        route: AppRoutes.eventDetail.replaceFirst(':id', e.id),
        arguments: {'eventId': e.id},
      );
    }
    Get.snackbar('Event', status, snackPosition: SnackPosition.BOTTOM);
  }
}
