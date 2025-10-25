class Recipe {
  final String id;
  final String title;
  final String category;
  final String description;
  final List<String> ingredients;

  Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.ingredients,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'description': description,
    'ingredients': ingredients,
  };

  factory Recipe.fromJson(Map<String, dynamic> j) => Recipe(
    id: j['id'],
    title: j['title'],
    category: j['category'],
    description: j['description'],
    ingredients: List<String>.from(j['ingredients'] ?? []),
  );
}
