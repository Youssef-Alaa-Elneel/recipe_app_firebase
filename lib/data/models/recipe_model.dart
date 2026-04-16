class RecipeModel {
  final int id;
  final String name;
  final String image;
  final int prepTimeMinutes;
  final List<String> ingredients;
  final List<String> instructions;

  RecipeModel({
    required this.id,
    required this.name,
    required this.image,
    required this.prepTimeMinutes,
    required this.ingredients,
    required this.instructions,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      prepTimeMinutes: json['prepTimeMinutes'],
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'prepTimeMinutes': prepTimeMinutes,
      'ingredients': ingredients,
      'instructions': instructions,
    };
  }
}
