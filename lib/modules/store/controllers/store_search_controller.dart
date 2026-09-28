import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/seed_data_service.dart';
import '../../../data/models/product_model.dart';

class StoreSearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  
  RxList<ProductModel> searchResults = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with all products or featured
    searchResults.value = SeedDataService.products;
    
    searchController.addListener(() {
      performSearch(searchController.text);
    });
  }

  void performSearch(String query) {
    if (query.isEmpty) {
      searchResults.value = SeedDataService.products;
      return;
    }

    final lowerQuery = query.toLowerCase();
    searchResults.value = SeedDataService.products.where((p) {
      return p.name.toLowerCase().contains(lowerQuery) ||
             (p.fandomName ?? '').toLowerCase().contains(lowerQuery) ||
             p.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
