import '../models/recipe.dart';

class RecipeState {
  final List<Recipe> items;
  final bool hasMore;
  final String query;
  final String category;
  final Recipe? selected;

  RecipeState({
    required this.items,
    required this.hasMore,
    required this.query,
    required this.category,
    required this.selected,
  });

  factory RecipeState.initial() => RecipeState(items: [], hasMore: true, query: '', category: 'All', selected: null);

  RecipeState copyWith({List<Recipe>? items, bool? hasMore, String? query, String? category, Recipe? selected}) {
    return RecipeState(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      query: query ?? this.query,
      category: category ?? this.category,
      selected: selected ?? this.selected,
    );
  }
}
