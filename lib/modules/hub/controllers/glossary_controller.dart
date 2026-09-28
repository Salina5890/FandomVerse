import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/misc_models.dart';
import '../../../data/services/seed_data_service.dart';

class GlossaryController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  final RxList<GlossaryModel> allTerms = <GlossaryModel>[].obs;
  final RxList<GlossaryModel> filteredTerms = <GlossaryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    allTerms.assignAll(SeedDataService.glossaryTerms);
    filteredTerms.assignAll(allTerms);

    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _filterTerms();
    });
  }

  void _filterTerms() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredTerms.assignAll(allTerms);
    } else {
      filteredTerms.assignAll(allTerms.where((t) =>
          t.term.toLowerCase().contains(query) ||
          t.definition.toLowerCase().contains(query) ||
          (t.fandomName?.toLowerCase().contains(query) ?? false)));
    }
  }

  GlossaryModel? getTerm(String id) {
    return allTerms.firstWhereOrNull((t) => t.id == id);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
