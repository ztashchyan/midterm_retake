import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';
import '../repository/recipe_repository.dart';
import '../widgets/recipe_item.dart';
import 'details_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _scroll = ScrollController();
  final _searchCtrl = TextEditingController();
  final categories = ['All', 'Dessert', 'Main Course', 'Salad', 'Beverage'];

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 120) {
      context.read<RecipeBloc>().add(RecipeLoadMore());
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = RepositoryProvider.of<RecipeRepository>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Explorer')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search by title...'),
              onChanged: (v) => context.read<RecipeBloc>().add(RecipeSearchChanged(v)),
            ),
          ),
          SizedBox(
            height: 48,
            child: BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, i) {
                  final cat = categories[i];
                  final selected = cat == state.category;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) => context.read<RecipeBloc>().add(RecipeCategoryChanged(cat)),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: categories.length,
              );
            }),
          ),
          Expanded(
            child: BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
              if (state.items.isEmpty) {
                return const Center(child: Text('No items'));
              }
              return ListView.builder(
                controller: _scroll,
                itemCount: state.items.length + (state.hasMore ? 1 : 0),
                itemBuilder: (ctx, i) {
                  if (i >= state.items.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final item = state.items[i];
                  final isFav = repo.isFavorite(item.id);
                  return RecipeItem(
                    recipe: item,
                    isFavorite: isFav,
                    onTap: () {
                      context.read<RecipeBloc>().add(RecipeSelect(item));
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailsScreen()));
                    },
                    onToggleFav: () => context.read<RecipeBloc>().add(RecipeToggleFavorite(item.id)),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
