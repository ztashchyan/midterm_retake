import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeItem extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onToggleFav;
  final bool isFavorite;

  const RecipeItem({Key? key, required this.recipe, required this.onTap, required this.onToggleFav, required this.isFavorite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text(recipe.title),
        subtitle: Text(recipe.category),
        trailing: IconButton(
          icon: Icon(isFavorite ? Icons.star : Icons.star_border),
          onPressed: onToggleFav,
        ),
      ),
    );
  }
}
