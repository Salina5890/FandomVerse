import 'package:get/get.dart';
import '../../../data/services/seed_data_service.dart';
import '../../../data/models/event_model.dart';

class EventCalendarController extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxList<EventModel> eventsForSelectedDate = <EventModel>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    updateEventsForDate(selectedDate.value);
  }

  void previousMonth() {
    final d = selectedDate.value;
    final target = DateTime(d.year, d.month - 1, 1);
    updateEventsForDate(target);
  }

  void nextMonth() {
    final d = selectedDate.value;
    final target = DateTime(d.year, d.month + 1, 1);
    updateEventsForDate(target);
  }

  void updateEventsForDate(DateTime date) {
    selectedDate.value = date;
    
    // Very simple matcher - just matching month and day since mock data has varying years/months
    eventsForSelectedDate.value = SeedDataService.events.where((e) {
      return e.eventDate.month == date.month && e.eventDate.day == date.day;
    }).toList();
  }

  List<EventModel> getEventsForMonth(DateTime month) {
    return SeedDataService.events.where((e) => e.eventDate.month == month.month).toList();
  }
}
