import 'package:get/get.dart';

class FanMainController extends GetxController {
  final RxInt currentIndex = 0.obs;

  // Tracks which bottom-nav tabs have been opened at least once, so the
  // shell only builds (and only initializes each tab's controller/data for)
  // tabs the user has actually visited, instead of all of them at startup.
  final RxSet<int> visitedTabs = <int>{0}.obs;

  void changePage(int index) {
    currentIndex.value = index;
    visitedTabs.add(index);
  }
}
