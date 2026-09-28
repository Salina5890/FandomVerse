import 'package:get/get.dart';

/// InitialBinding is now a no-op because all critical services
/// (LocalStorageService, SeedDataService, AuthService) are
/// pre-initialized in main.dart before runApp() is called.
///
/// Kept as a placeholder so GetMaterialApp's initialBinding param
/// still resolves. Additional non-critical bindings can be added here.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // All critical services already registered in main().
    // Add any additional lazy bindings here if needed.
  }
}
