import '../models/recipe.dart';

abstract class RecipeEvent {}

class RecipeLoadInitial extends RecipeEvent {}
class RecipeSearchChanged extends RecipeEvent { final String query; RecipeSearchChanged(this.query); }
class RecipeCategoryChanged extends RecipeEvent { final String category; RecipeCategoryChanged(this.category); }
class RecipeLoadMore extends RecipeEvent {}
class RecipeSelect extends RecipeEvent { final Recipe recipe; RecipeSelect(this.recipe); }
class RecipeToggleFavorite extends RecipeEvent { final String id; RecipeToggleFavorite(this.id); }
