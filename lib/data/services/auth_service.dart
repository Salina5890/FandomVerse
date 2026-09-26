import 'package:get/get.dart';
import '../../app/constants/app_constants.dart';
import '../../core/storage/local_storage_service.dart';
import '../models/user_model.dart';
import 'seed_data_service.dart';
import 'package:uuid/uuid.dart';
import 'oauth_service.dart';

class AuthService extends GetxService {
  final LocalStorageService _storage = Get.find<LocalStorageService>();
  
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final OAuthService _oauth = OAuthService();
  
  bool get isLoggedIn => _storage.isLoggedIn;
  bool get isAdmin => currentUser.value?.isAdmin ?? false;

  Future<AuthService> init() async {
    // Load user if logged in
    if (isLoggedIn) {
      final userId = _storage.userId;
      if (userId != null) {
        currentUser.value = _storage.getUser(userId);
      }
    }
    return this;
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500)); // Simulate network

    // Admin Demo Check
    if (email == AppConstants.adminDemoEmail && password == AppConstants.adminDemoPassword) {
      final admin = SeedDataService.demoAdmin;
      _storage.saveUser(admin);
      _storage.saveAuthState(userId: admin.id, role: admin.role, email: admin.email);
      currentUser.value = admin;
      return true;
    }

    // Demo Fan Check
    if (email == SeedDataService.demoFan.email && password == 'password') {
      final fan = SeedDataService.demoFan;
      _storage.saveUser(fan);
      _storage.saveAuthState(userId: fan.id, role: fan.role, email: fan.email);
      currentUser.value = fan;
      return true;
    }

    // Generic fallback for any other email/password (Mock behavior)
    if (email.isNotEmpty && password.isNotEmpty) {
      final newUser = UserModel(
        id: const Uuid().v4(),
        email: email,
        name: email.split('@').first,
        role: 'fan',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _storage.saveUser(newUser);
      _storage.saveAuthState(userId: newUser.id, role: newUser.role, email: newUser.email);
      currentUser.value = newUser;
      return true;
    }

    return false;
  }

  Future<UserModel> _upsertOAuthUser(OAuthIdentity identity) async {
    final existing = _storage.findUserByEmail(identity.email);
    final user = existing ?? UserModel(
      id: const Uuid().v4(),
      email: identity.email,
      name: identity.displayName,
      avatarUrl: identity.photoUrl,
      role: 'fan',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final updated = existing == null
        ? user
        : user.copyWith(
            name: identity.displayName.isEmpty ? user.name : identity.displayName,
            avatarUrl: identity.photoUrl ?? user.avatarUrl,
            updatedAt: DateTime.now(),
          );
    await _storage.saveUser(updated);
    _storage.saveAuthState(userId: updated.id, role: updated.role, email: updated.email);
    currentUser.value = updated;
    return updated;
  }

  Future<UserModel?> loginWithGoogle() async {
    final identity = await _oauth.signInWithGoogle();
    if (identity == null) return null;
    return _upsertOAuthUser(identity);
  }

  Future<UserModel?> loginWithApple() async {
    final identity = await _oauth.signInWithApple();
    if (identity == null) return null;
    return _upsertOAuthUser(identity);
  }

  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    final newUser = UserModel(
      id: const Uuid().v4(),
      email: email,
      name: name,
      role: 'fan',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _storage.saveUser(newUser);
    _storage.saveAuthState(userId: newUser.id, role: newUser.role, email: newUser.email);
    currentUser.value = newUser;
    return true;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _storage.clearAuthState();
    currentUser.value = null;
    Get.offAllNamed(AppConstants.roleFan == 'admin' ? '/auth/admin-login' : '/auth/user-type');
  }

  /// Mock password change — this demo build has no real password store, so
  /// it just validates input shape and simulates a network round trip.
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    if (currentPassword.isEmpty || newPassword.length < 6) return false;
    await Future.delayed(const Duration(milliseconds: 900));
    return true;
  }

  Future<void> deleteAccount() async {
    final user = currentUser.value;
    if (user == null) return;
    await Future.delayed(const Duration(milliseconds: 700));
    await _storage.clearAllUserData(user.id);
    currentUser.value = null;
    Get.offAllNamed('/auth/user-type');
  }

  Future<void> updateFandoms(List<String> fandomIds) async {
    if (currentUser.value != null) {
      final updated = currentUser.value!.copyWith(selectedFandomIds: fandomIds);
      _storage.saveUser(updated);
      currentUser.value = updated;
      _storage.setStringList(AppConstants.keySelectedFandoms, fandomIds);
    }
  }
}
