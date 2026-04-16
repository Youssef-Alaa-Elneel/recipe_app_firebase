import 'package:flutter/material.dart';
import '../data/models/recipe_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<RecipeModel> _favoriteItems = [];

  List<RecipeModel> get items => _favoriteItems;

  CartProvider() {
    loadFavorites();
  }
  void clearFavorites() {
    _favoriteItems = []; // بنخلي اللستة فاضية تماماً
    notifyListeners(); // بنعرف الـ UI إن الداتا اتمسحت
  }

  Future<void> toggleFavorite(RecipeModel recipe) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final isExist = _favoriteItems.any((item) => item.id == recipe.id);

    // 2. بنحدد مسار الملف بتاع اليوزر ده في فايربيز
    DocumentReference userDoc = _firestore.collection('users').doc(user.uid);

    if (isExist) {
      _favoriteItems.removeWhere((item) => item.id == recipe.id);

      await userDoc.update({
        'favorites': FieldValue.arrayRemove([recipe.toJson()]),
      });
    } else {
      _favoriteItems.add(recipe);

      await userDoc.update({
        'favorites': FieldValue.arrayUnion([recipe.toJson()]),
      });
    }
    notifyListeners();
  }

  bool isFavorite(int recipeId) {
    return _favoriteItems.any((item) => item.id == recipeId);
  }

  Future<void> loadFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    // 1. بنروح فايربيز نجيب الملف بتاع اليوزر
    DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    // 2. لو الملف موجود، بنسحب الداتا اللي جواه
    if (doc.exists && doc.data() != null) {
      List<dynamic> data =
          (doc.data() as Map<String, dynamic>)['favorites'] ?? [];

      // 3.بنحول الداتا دي لشكل الموديل
      _favoriteItems = data.map((item) => RecipeModel.fromJson(item)).toList();
      notifyListeners();
    }
  }
}
