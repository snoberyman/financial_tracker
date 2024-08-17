import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/catgeory.dart';

class CategoriesFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // method to get all categories
  Future<List<Category>> getCategories(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('categories')
          .orderBy('order')
          .get();

      return querySnapshot.docs.map((doc) {
        return Category(
          id: doc.id,
          name: doc['name'],
          order: doc['order'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // method to add a new category
  Future<void> addCategory(String name, String userId) async {
    QuerySnapshot snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('categories')
        .orderBy('order', descending: true)
        .limit(1)
        .get();

    int newOrder = 0;
    if (snapshot.docs.isNotEmpty) {
      newOrder = snapshot.docs.first['order'] + 1;
    }

    await _db.collection('users').doc(userId).collection('categories').add({
      'name': name,
      'order': newOrder,
    });
  }

  // method to delete category
  Future<void> deleteCategory(String categoryId, String userId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('categories')
        .doc(categoryId)
        .delete();
  }

  // method to update the order of categories
  Future<void> updateCategoryOrder(
      String userId, List<Category> categories) async {
    final batch = _db.batch();

    for (int i = 0; i < categories.length; i++) {
      final categoryRef = _db
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(categories[i].id);

      batch.update(categoryRef, {'order': i});
    }

    await batch.commit();
  }
}
