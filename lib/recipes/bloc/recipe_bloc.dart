import 'package:flutter_bloc/flutter_bloc.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';
import '../repository/recipe_repository.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository repo;
  static const _pageSize = 5;
  int _offset = 0;

  RecipeBloc({required this.repo}) : super(RecipeState.initial()) {
    on<RecipeLoadInitial>(_onInitial);
    on<RecipeSearchChanged>(_onSearchChanged);
    on<RecipeCategoryChanged>(_onCategoryChanged);
    on<RecipeLoadMore>(_onLoadMore);
    on<RecipeSelect>(_onSelect);
    on<RecipeToggleFavorite>(_onToggleFav);
  }

  Future<void> _onInitial(RecipeLoadInitial e, Emitter<RecipeState> emit) async {
    _offset = 0;
    final fetched = repo.fetch(limit: _pageSize, offset: _offset, query: state.query, category: state.category);
    _offset += fetched.length;
    emit(state.copyWith(items: fetched, hasMore: fetched.length == _pageSize));
  }

  Future<void> _onSearchChanged(RecipeSearchChanged e, Emitter<RecipeState> emit) async {
    _offset = 0;
    final q = e.query;
    final fetched = repo.fetch(limit: _pageSize, offset: 0, query: q, category: state.category);
    _offset += fetched.length;
    emit(state.copyWith(query: q, items: fetched, hasMore: fetched.length == _pageSize));
  }

  Future<void> _onCategoryChanged(RecipeCategoryChanged e, Emitter<RecipeState> emit) async {
    _offset = 0;
    final cat = e.category;
    final fetched = repo.fetch(limit: _pageSize, offset: 0, query: state.query, category: cat);
    _offset += fetched.length;
    emit(state.copyWith(category: cat, items: fetched, hasMore: fetched.length == _pageSize));
  }

  Future<void> _onLoadMore(RecipeLoadMore e, Emitter<RecipeState> emit) async {
    if (!state.hasMore) return;
    final fetched = repo.fetch(limit: _pageSize, offset: _offset, query: state.query, category: state.category);
    _offset += fetched.length;
    final combined = List.of(state.items)..addAll(fetched);
    emit(state.copyWith(items: combined, hasMore: fetched.length == _pageSize));
  }

  Future<void> _onSelect(RecipeSelect e, Emitter<RecipeState> emit) async {
    emit(state.copyWith(selected: e.recipe));
  }

  Future<void> _onToggleFav(RecipeToggleFavorite e, Emitter<RecipeState> emit) async {
    await repo.toggleFavorite(e.id);
    emit(state.copyWith());
  }
}
