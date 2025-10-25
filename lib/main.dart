import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_explorer/recipes/bloc/recipe_event.dart';
import 'recipes/bloc/recipe_bloc.dart';
import 'recipes/repository/recipe_repository.dart';
import 'recipes/screens/list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = RecipeRepository();
  await repo.init();
  runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  final RecipeRepository repo;
  const MyApp({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repo,
      child: BlocProvider(
        create: (_) => RecipeBloc(repo: repo)..add(RecipeLoadInitial()),
        child: MaterialApp(
          title: 'Recipe Explorer',
          theme: ThemeData(primarySwatch: Colors.teal),
          home: const ListScreen(),
        ),
      ),
    );
  }
}
