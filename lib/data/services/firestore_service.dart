import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import '../models/content_model.dart';
import '../models/event_model.dart';
import '../models/product_model.dart';
import '../models/misc_models.dart';
import 'seed_data_service.dart';

class FirestoreService extends GetxService {
  static FirestoreService get to => Get.find<FirestoreService>();

  FirebaseFirestore? _firestore;

  bool get isConnected => _firestore != null;

  Future<FirestoreService> init() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        _firestore = FirebaseFirestore.instance;
        // Seed default collections if empty so the database has initial data
        _seedIfEmpty();
      }
    } catch (e) {
      debugPrint('Firestore initialization skipped: $e');
    }
    return this;
  }

  // --- Users ---

  Future<void> saveUser(UserModel user) async {
    if (_firestore == null) return;
    try {
      await _firestore!
          .collection('users')
          .doc(user.id)
          .set(user.toMap(), SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving user to Firestore: $e');
    }
  }

  Future<UserModel?> getUser(String userId) async {
    if (_firestore == null) return null;
    try {
      final doc = await _firestore!.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
    } catch (e) {
      debugPrint('Error fetching user: $e');
    }
    return null;
  }

  Future<List<UserModel>> getAllUsers() async {
    if (_firestore == null) return [];
    try {
      final snapshot = await _firestore!
          .collection('users')
          .get()
          .timeout(const Duration(seconds: 6));
      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint('Error fetching users: $e');
      return [];
    }
  }

  Future<void> deleteUser(String userId) async {
    if (_firestore == null) return;
    try {
      await _firestore!.collection('users').doc(userId).delete();
    } catch (e) {
      debugPrint('Error deleting user: $e');
    }
  }

  // --- Content & Posts ---

  Future<void> saveContent(ContentModel item) async {
    if (_firestore == null) return;
    try {
      await _firestore!
          .collection('posts')
          .doc(item.id)
          .set(item.toMap(), SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving post: $e');
    }
  }

  Future<List<ContentModel>> getAllContent() async {
    if (_firestore == null) return [];
    try {
      final snapshot = await _firestore!
          .collection('posts')
          .get()
          .timeout(const Duration(seconds: 6));
      return snapshot.docs
          .map((doc) => ContentModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error fetching posts: $e');
      return [];
    }
  }

  Future<void> deleteContent(String id) async {
    if (_firestore == null) return;
    try {
      await _firestore!.collection('posts').doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting post: $e');
    }
  }

  // --- Events ---

  Future<void> saveEvent(EventModel item) async {
    if (_firestore == null) return;
    try {
      await _firestore!
          .collection('events')
          .doc(item.id)
          .set(item.toMap(), SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving event: $e');
    }
  }

  Future<List<EventModel>> getAllEvents() async {
    if (_firestore == null) return [];
    try {
      final snapshot = await _firestore!
          .collection('events')
          .get()
          .timeout(const Duration(seconds: 6));
      return snapshot.docs
          .map((doc) => EventModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error fetching events: $e');
      return [];
    }
  }

  Future<void> deleteEvent(String id) async {
    if (_firestore == null) return;
    try {
      await _firestore!.collection('events').doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting event: $e');
    }
  }

  // --- Merchandise ---

  Future<void> saveProduct(ProductModel item) async {
    if (_firestore == null) return;
    try {
      await _firestore!
          .collection('merchandise')
          .doc(item.id)
          .set(item.toMap(), SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving merchandise: $e');
    }
  }

  Future<List<ProductModel>> getAllProducts() async {
    if (_firestore == null) return [];
    try {
      final snapshot = await _firestore!
          .collection('merchandise')
          .get()
          .timeout(const Duration(seconds: 6));
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error fetching merchandise: $e');
      return [];
    }
  }

  Future<void> deleteProduct(String id) async {
    if (_firestore == null) return;
    try {
      await _firestore!.collection('merchandise').doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting merchandise: $e');
    }
  }

  // --- Categories ---

  Future<void> saveCategory(Map<String, dynamic> category) async {
    if (_firestore == null) return;
    try {
      final id =
          category['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString();
      await _firestore!
          .collection('categories')
          .doc(id)
          .set(category, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving category: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    if (_firestore == null) return [];
    try {
      final snapshot = await _firestore!
          .collection('categories')
          .get()
          .timeout(const Duration(seconds: 6));
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return [];
    }
  }

  Future<void> deleteCategory(String id) async {
    if (_firestore == null) return;
    try {
      await _firestore!.collection('categories').doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting category: $e');
    }
  }

  // --- Discussions ---

  Future<void> saveDiscussion(Map<String, dynamic> discussion) async {
    if (_firestore == null) return;
    try {
      final id =
          discussion['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString();
      await _firestore!
          .collection('discussions')
          .doc(id)
          .set(discussion, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving discussion: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getDiscussions({String? fandomId}) async {
    if (_firestore == null) return [];
    try {
      Query query = _firestore!.collection('discussions');
      if (fandomId != null) {
        query = query.where('fandomId', isEqualTo: fandomId);
      }
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      debugPrint('Error fetching discussions: $e');
      return [];
    }
  }

  // --- Wishlist ---

  Future<void> addToWishlist(String userId, String productId) async {
    if (_firestore == null) return;
    try {
      final docId = '${userId}_$productId';
      await _firestore!.collection('wishlists').doc(docId).set({
        'id': docId,
        'user_id': userId,
        'product_id': productId,
        'saved_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Error saving to wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(String userId, String productId) async {
    if (_firestore == null) return;
    try {
      final docId = '${userId}_$productId';
      await _firestore!.collection('wishlists').doc(docId).delete();
    } catch (e) {
      debugPrint('Error deleting from wishlist: $e');
    }
  }

  Future<List<String>> getWishlistProductIds(String userId) async {
    if (_firestore == null) return [];
    try {
      final snapshot = await _firestore!
          .collection('wishlists')
          .where('user_id', isEqualTo: userId)
          .get();
      return snapshot.docs
          .map((doc) => doc.data()['product_id'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    } catch (e) {
      debugPrint('Error loading wishlist: $e');
      return [];
    }
  }

  // --- Inquiries ---

  Future<void> submitInquiry(Map<String, dynamic> inquiry) async {
    if (_firestore == null) return;
    try {
      final id =
          inquiry['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString();
      await _firestore!.collection('inquiries').doc(id).set(inquiry);
    } catch (e) {
      debugPrint('Error submitting inquiry: $e');
    }
  }

  // --- FAQs ---

  Future<List<FaqModel>> getAllFaqs() async {
    if (_firestore == null) return [];
    try {
      final snapshot = await _firestore!.collection('faqs').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => FaqModel.fromMap(doc.data()))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading FAQs: $e');
    }
    return [];
  }

  Future<void> saveFaq(FaqModel faq) async {
    if (_firestore == null) return;
    try {
      await _firestore!
          .collection('faqs')
          .doc(faq.id)
          .set(faq.toMap(), SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving FAQ: $e');
    }
  }

  // --- Helper to seed data if remote database is empty ---

  Future<void> _seedIfEmpty() async {
    if (_firestore == null) return;
    try {
      // Check if posts need initial data
      final postsCheck = await _firestore!.collection('posts').limit(1).get();
      if (postsCheck.docs.isEmpty) {
        final batch = _firestore!.batch();
        for (final item in SeedDataService.contentItems) {
          batch.set(_firestore!.collection('posts').doc(item.id), item.toMap());
        }
        await batch.commit();
      }

      // Check events
      final eventsCheck = await _firestore!.collection('events').limit(1).get();
      if (eventsCheck.docs.isEmpty) {
        final batch = _firestore!.batch();
        for (final item in SeedDataService.events) {
          batch.set(
            _firestore!.collection('events').doc(item.id),
            item.toMap(),
          );
        }
        await batch.commit();
      }

      // Check merchandise
      final merchCheck = await _firestore!
          .collection('merchandise')
          .limit(1)
          .get();
      if (merchCheck.docs.isEmpty) {
        final batch = _firestore!.batch();
        for (final item in SeedDataService.products) {
          batch.set(
            _firestore!.collection('merchandise').doc(item.id),
            item.toMap(),
          );
        }
        await batch.commit();
      }

      // Check categories
      final catCheck = await _firestore!
          .collection('categories')
          .limit(1)
          .get();
      if (catCheck.docs.isEmpty) {
        final batch = _firestore!.batch();
        for (final item in SeedDataService.categories) {
          final id = item['id'].toString();
          batch.set(_firestore!.collection('categories').doc(id), item);
        }
        await batch.commit();
      }

      // Check FAQs
      final faqsCheck = await _firestore!.collection('faqs').limit(1).get();
      if (faqsCheck.docs.isEmpty) {
        final batch = _firestore!.batch();
        for (final item in SeedDataService.faqs) {
          batch.set(_firestore!.collection('faqs').doc(item.id), item.toMap());
        }
        await batch.commit();
      }

      // Check demo admin and demo fan
      final adminCheck = await _firestore!
          .collection('users')
          .doc(SeedDataService.demoAdmin.id)
          .get();
      if (!adminCheck.exists) {
        await _firestore!
            .collection('users')
            .doc(SeedDataService.demoAdmin.id)
            .set(SeedDataService.demoAdmin.toMap());
      }
      final fanCheck = await _firestore!
          .collection('users')
          .doc(SeedDataService.demoFan.id)
          .get();
      if (!fanCheck.exists) {
        await _firestore!
            .collection('users')
            .doc(SeedDataService.demoFan.id)
            .set(SeedDataService.demoFan.toMap());
      }
    } catch (e) {
      debugPrint('Firestore seed notice: $e');
    }
  }
}
