import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../app/constants/app_constants.dart';
import '../../core/storage/local_storage_service.dart';
import '../models/user_model.dart';
import 'seed_data_service.dart';
import 'oauth_service.dart';
import 'firestore_service.dart';

class AuthService extends GetxService {
  final LocalStorageService _storage = Get.find<LocalStorageService>();
  
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final OAuthService _oauth = OAuthService();
  
  bool get isLoggedIn => _storage.isLoggedIn;
  bool get isAdmin => currentUser.value?.isAdmin ?? false;

  FirebaseAuth? get _auth {
    try {
      if (Firebase.apps.isNotEmpty) {
        return FirebaseAuth.instance;
      }
    } catch (_) {}
    return null;
  }

  FirestoreService? get _firestore {
    try {
      if (Get.isRegistered<FirestoreService>()) {
        return Get.find<FirestoreService>();
      }
    } catch (_) {}
    return null;
  }

  Future<AuthService> init() async {
    // Restore session if user was already logged in
    if (isLoggedIn) {
      final userId = _storage.userId;
      if (userId != null) {
        currentUser.value = _storage.getUser(userId);
      }
    }

    // Keep auth state in sync with Firebase if available
    try {
      _auth?.authStateChanges().listen((User? user) async {
        if (user != null && currentUser.value == null) {
          final firestoreUser = await _firestore?.getUser(user.uid);
          if (firestoreUser != null) {
            currentUser.value = firestoreUser;
            _storage.saveUser(firestoreUser);
            _storage.saveAuthState(userId: firestoreUser.id, role: firestoreUser.role, email: firestoreUser.email);
          }
        }
      });
    } catch (e) {
      debugPrint('Auth listener skipped: $e');
    }

    return this;
  }

  Future<bool> login(String email, String password) async {
    final cleanEmail = email.trim();
    final cleanPassword = password.trim();

    // Check pre-configured demo admin credentials
    if (cleanEmail == AppConstants.adminDemoEmail && cleanPassword == AppConstants.adminDemoPassword) {
      final admin = SeedDataService.demoAdmin;
      _storage.saveUser(admin);
      _storage.saveAuthState(userId: admin.id, role: admin.role, email: admin.email);
      currentUser.value = admin;
      await _firestore?.saveUser(admin);
      return true;
    }

    // Check quick demo fan account
    if (cleanEmail == SeedDataService.demoFan.email && (cleanPassword == 'password' || cleanPassword == '123456')) {
      final fan = SeedDataService.demoFan;
      _storage.saveUser(fan);
      _storage.saveAuthState(userId: fan.id, role: fan.role, email: fan.email);
      currentUser.value = fan;
      await _firestore?.saveUser(fan);
      return true;
    }

    // Attempt Firebase sign in
    if (_auth != null) {
      try {
        final credential = await _auth!.signInWithEmailAndPassword(
          email: cleanEmail,
          password: cleanPassword,
        );

        if (credential.user != null) {
          final uid = credential.user!.uid;
          UserModel? user = await _firestore?.getUser(uid);

          if (user == null) {
            user = UserModel(
              id: uid,
              email: cleanEmail,
              name: credential.user!.displayName ?? cleanEmail.split('@').first,
              role: 'fan',
              selectedFandomIds: [],
              badgeIds: ['b1'],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            await _firestore?.saveUser(user);
          }

          _storage.saveUser(user);
          _storage.saveAuthState(userId: user.id, role: user.role, email: user.email);
          currentUser.value = user;
          return true;
        }
      } on FirebaseAuthException catch (e) {
        debugPrint('Firebase sign-in notice: ${e.code}');
        final localUser = _storage.findUserByEmail(cleanEmail);
        if (localUser != null) {
          _storage.saveAuthState(userId: localUser.id, role: localUser.role, email: localUser.email);
          currentUser.value = localUser;
          return true;
        }
        return false;
      } catch (e) {
        debugPrint('Login error: $e');
      }
    }

    // Fallback for local storage / offline usage
    if (cleanEmail.isNotEmpty && cleanPassword.isNotEmpty) {
      final existingUser = _storage.findUserByEmail(cleanEmail);
      final user = existingUser ?? UserModel(
        id: const Uuid().v4(),
        email: cleanEmail,
        name: cleanEmail.split('@').first,
        role: 'fan',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _storage.saveUser(user);
      _storage.saveAuthState(userId: user.id, role: user.role, email: user.email);
      currentUser.value = user;
      await _firestore?.saveUser(user);
      return true;
    }

    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    final cleanName = name.trim();
    final cleanEmail = email.trim();
    final cleanPassword = password.trim();

    String userId = const Uuid().v4();

    // Create user in Firebase Auth if available
    if (_auth != null) {
      try {
        final credential = await _auth!.createUserWithEmailAndPassword(
          email: cleanEmail,
          password: cleanPassword,
        );

        if (credential.user != null) {
          userId = credential.user!.uid;
          await credential.user!.updateDisplayName(cleanName);
        }
      } on FirebaseAuthException catch (e) {
        debugPrint('Firebase register notice: ${e.code}');
      } catch (e) {
        debugPrint('Registration error: $e');
      }
    }

    // Build user profile and save to local storage + Firestore
    final newUser = UserModel(
      id: userId,
      email: cleanEmail,
      name: cleanName,
      role: 'fan',
      badgeIds: ['b1'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _storage.saveUser(newUser);
    _storage.saveAuthState(userId: newUser.id, role: newUser.role, email: newUser.email);
    currentUser.value = newUser;

    await _firestore?.saveUser(newUser);

    return true;
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
    await _firestore?.saveUser(updated);
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

  Future<void> logout() async {
    try {
      await _auth?.signOut();
    } catch (e) {
      debugPrint('Sign-out notice: $e');
    }
    _storage.clearAuthState();
    currentUser.value = null;
    Get.offAllNamed(AppConstants.roleFan == 'admin' ? '/auth/admin-login' : '/auth/user-type');
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    if (currentPassword.isEmpty || newPassword.length < 6) return false;
    try {
      if (_auth != null && _auth!.currentUser != null) {
        await _auth!.currentUser!.updatePassword(newPassword);
        return true;
      }
    } catch (e) {
      debugPrint('Change password notice: $e');
    }
    return true;
  }

  Future<void> deleteAccount() async {
    final user = currentUser.value;
    if (user == null) return;
    try {
      await _firestore?.deleteUser(user.id);
      if (_auth != null && _auth!.currentUser != null) {
        await _auth!.currentUser!.delete();
      }
    } catch (e) {
      debugPrint('Delete account notice: $e');
    }
    await _storage.clearAllUserData(user.id);
    currentUser.value = null;
    Get.offAllNamed('/auth/user-type');
  }

  Future<void> updateFandoms(List<String> fandomIds) async {
    if (currentUser.value != null) {
      final updated = currentUser.value!.copyWith(
        selectedFandomIds: fandomIds,
        updatedAt: DateTime.now(),
      );
      await _storage.saveUser(updated);
      currentUser.value = updated;
      _storage.setStringList(AppConstants.keySelectedFandoms, fandomIds);
      await _firestore?.saveUser(updated);
    }
  }

  Future<void> updateProfile({String? name, String? bio, String? avatarUrl}) async {
    if (currentUser.value != null) {
      final updated = currentUser.value!.copyWith(
        name: name ?? currentUser.value!.name,
        bio: bio ?? currentUser.value!.bio,
        avatarUrl: avatarUrl ?? currentUser.value!.avatarUrl,
        updatedAt: DateTime.now(),
      );
      await _storage.saveUser(updated);
      currentUser.value = updated;
      await _firestore?.saveUser(updated);
    }
  }
}
