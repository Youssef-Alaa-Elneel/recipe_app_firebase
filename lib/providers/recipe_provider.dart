import 'package:flutter/material.dart';
import '../data/services/recipe_service.dart';
import '../data/models/recipe_model.dart';

class RecipeProvider extends ChangeNotifier {
  final RecipeService _recipeService = RecipeService();
  List<RecipeModel> recipes = [];

  bool isLoading = false;
  bool isFetchingMore = false; // لتحميل الدفعة الجديدة لما ننزل لتحت
  bool hasMore = true; // عشان نعرف في داتا لسه ولا خلصت

  int limit = 10;
  int skip = 0;

  Future<void> fetchRecipes({bool isRefresh = false}) async {
    // لو بنعمل ريفريش أو دي أول مرة
    if (isRefresh) {
      skip = 0;
      hasMore = true;
      recipes.clear();
      isLoading = true;
      notifyListeners();
    } else {
      if (isFetchingMore || !hasMore) return;
      isFetchingMore = true;
      notifyListeners();
    }

    try {
      // 1. بنادي على الفايربيز ونسجل النتيجة في newRecipes عشان الكود اللي تحت مايضربش
      final newRecipes = await _recipeService.getRecipes();

      hasMore = false;

      // 3. بنضيف الداتا للستة الأساسية
      recipes.addAll(newRecipes);
    } catch (e) {
      debugPrint("Error fetching recipes: $e");
    }

    isLoading = false;
    isFetchingMore = false;
    notifyListeners();
  }
}
