import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';
import '../repository/recipe_repository.dart';

class DetailsScreen extends StatelessWidget {
  DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repo = RepositoryProvider.of<RecipeRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
        final item = state.selected;
        if (item == null) return const Center(child: Text('No item selected'));
        final isFav = repo.isFavorite(item.id);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(item.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                  IconButton(
                    icon: Icon(isFav ? Icons.star : Icons.star_border),
                    onPressed: () => context.read<RecipeBloc>().add(RecipeToggleFavorite(item.id)),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text('Category: ${item.category}'),
              const SizedBox(height: 12),
              Text(item.description),
              const SizedBox(height: 12),
              const Text('Ingredients', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...item.ingredients.map((ing) => Text('- $ing')),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
