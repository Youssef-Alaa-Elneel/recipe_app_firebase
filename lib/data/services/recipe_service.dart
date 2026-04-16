import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RecipeModel>> getRecipes() async {
    try {
      // بنجيب الداتا من الكوليكشن
      QuerySnapshot snapshot = await _firestore.collection('recipes').get();

      return snapshot.docs.map((doc) {
        // بنحول الـ Document لـ Map
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // " بنستخدم نفس الـ fromJson اللي الموديل بتاعك شغال بيه
        return RecipeModel.fromJson(data);
      }).toList();
    } catch (e) {
      print("Error fetching recipes: $e");
      return [];
    }
  }
}
