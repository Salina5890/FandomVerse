import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/models/event_model.dart';
import '../../../data/services/seed_data_service.dart';

enum EventSort { nearest, soonest, popular }

class EventsController extends GetxController {
  final RxList<EventModel> upcomingEvents = <EventModel>[].obs;
  final RxList<EventModel> pastEvents = <EventModel>[].obs;
  final RxList<EventModel> filteredEvents = <EventModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool locationLoading = false.obs;
  final Rxn<Position> userPosition = Rxn<Position>();
  final RxString locationMessage = ''.obs;
  final RxString selectedCity = 'All'.obs;
  final RxString selectedType = 'All'.obs;
  final RxString selectedFandom = 'All'.obs;
  final RxDouble maxDistanceKm = 50000.0.obs;
  final Rx<EventSort> sort = EventSort.soonest.obs;
  final Rx<EventModel?> selectedEvent = Rx<EventModel?>(null);
  final RxBool isMapExpanded = false.obs;
  final RxBool showMap = true.obs;

  void selectEvent(EventModel? event) {
    selectedEvent.value = event;
  }

  void toggleMapExpanded() {
    isMapExpanded.toggle();
  }

  void toggleShowMap() {
    showMap.toggle();
  }

  void resetFilters() {
    selectedCity.value = 'All';
    selectedType.value = 'All';
    selectedFandom.value = 'All';
    maxDistanceKm.value = 50000.0;
    sort.value = EventSort.soonest;
    applyFilters();
  }

  List<EventModel> get allEvents => [...upcomingEvents, ...pastEvents];
  List<String> get cities => ['All', ...{for (final e in allEvents) e.city}];
  List<String> get types => ['All', ...{for (final e in allEvents) e.category}];
  List<String> get fandoms => ['All', ...{for (final e in allEvents) e.fandomName ?? e.fandomId}];

  @override
  void onInit() {
    super.onInit();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final all = SeedDataService.events;
    final now = DateTime.now();
    upcomingEvents.assignAll(all.where((e) => e.eventDate.isAfter(now)));
    pastEvents.assignAll(all.where((e) => e.eventDate.isBefore(now)));
    applyFilters();
    isLoading.value = false;
  }

  Future<void> requestLocation() async {
    locationLoading.value = true;
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        locationMessage.value = 'Location services are disabled.';
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        locationMessage.value = 'Enable location to discover nearby events.';
        return;
      }
      userPosition.value = await Geolocator.getCurrentPosition();
      locationMessage.value = '';
      applyFilters();
    } catch (_) {
      locationMessage.value = 'Location unavailable';
    } finally {
      locationLoading.value = false;
    }
  }

  double? distanceKm(EventModel event) {
    final pos = userPosition.value;
    if (pos == null || !event.hasLocation) return null;
    final meters = Geolocator.distanceBetween(
      pos.latitude, pos.longitude, event.latitude!, event.longitude!,
    );
    return meters / 1000;
  }

  void applyFilters() {
    var items = allEvents.where((event) {
      final cityOk = selectedCity.value == 'All' || event.city == selectedCity.value;
      final typeOk = selectedType.value == 'All' || event.category == selectedType.value;
      final fandomOk = selectedFandom.value == 'All' || (event.fandomName ?? event.fandomId) == selectedFandom.value;
      final distance = distanceKm(event);
      final distanceOk = distance == null || distance <= maxDistanceKm.value;
      return cityOk && typeOk && fandomOk && distanceOk;
    }).toList();

    switch (sort.value) {
      case EventSort.nearest:
        items.sort((a, b) => (distanceKm(a) ?? double.infinity).compareTo(distanceKm(b) ?? double.infinity));
      case EventSort.soonest:
        items.sort((a, b) => a.eventDate.compareTo(b.eventDate));
      case EventSort.popular:
        items.sort((a, b) => (b.attendeeCount ?? 0).compareTo(a.attendeeCount ?? 0));
    }
    filteredEvents.assignAll(items);
  }

  void setCity(String value) { selectedCity.value = value; applyFilters(); }
  void setType(String value) { selectedType.value = value; applyFilters(); }
  void setFandom(String value) { selectedFandom.value = value; applyFilters(); }
  void setSort(EventSort value) { sort.value = value; applyFilters(); }
  void setMaxDistance(double value) { maxDistanceKm.value = value; applyFilters(); }
}
