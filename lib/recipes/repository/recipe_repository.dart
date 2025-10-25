import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class RecipeRepository {
  static const _favKey = 'favorites';
  late SharedPreferences _prefs;
  final List<Recipe> _items = _makeSample();
  final Set<String> favorites = {};

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final favList = _prefs.getStringList(_favKey) ?? [];
    favorites.addAll(favList);
  }

  List<Recipe> all() => List.unmodifiable(_items);

  Future<void> toggleFavorite(String id) async {
    if (favorites.contains(id)) favorites.remove(id);
    else favorites.add(id);
    await _prefs.setStringList(_favKey, favorites.toList());
  }

  bool isFavorite(String id) => favorites.contains(id);


  List<Recipe> fetch({required int limit, required int offset, String? query, String? category}) {
    var list = _items;
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      list = list.where((r) => r.title.toLowerCase().contains(q)).toList();
    }
    if (category != null && category != 'All') {
      list = list.where((r) => r.category == category).toList();
    }
    final start = offset;
    if (start >= list.length) return [];
    final end = (start + limit) > list.length ? list.length : (start + limit);
    return list.sublist(start, end);
  }

  static List<Recipe> _makeSample() {
    final categories = ['Dessert', 'Main Course', 'Salad', 'Beverage'];
    final list = <Recipe>[];
    for (var i = 1; i <= 24; i++) {
      final cat = categories[i % categories.length];
      list.add(Recipe(
        id: 'r$i',
        title: '${cat} Recipe $i',
        category: cat,
        description: 'A delicious $cat-style dish number $i. Perfect for any occasion.',
        ingredients: List.generate(4, (idx) => 'Ingredient ${idx + 1} for $i'),
      ));
    }
    return list;
  }
}
