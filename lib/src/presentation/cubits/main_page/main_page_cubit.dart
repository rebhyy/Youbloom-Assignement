import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../domain/models/movie.dart';
import '../../../utils/resources/config.dart';

class MainPageCubit extends Cubit<MainPageState> {
  final Dio _dio;
  List<Movie> _allItems = [];
  int _currentPage = 1;
  bool _isLoadingMore = false; // Flag to prevent duplicate requests

  MainPageCubit(this._dio) : super(MainPageLoading());

  Future<void> fetchItems({bool isPagination = false}) async {
    if (_isLoadingMore && isPagination)
      return; // Prevent duplicate pagination requests
    if (isPagination) _isLoadingMore = true;

    emit(isPagination
        ? MainPageLoaded(_allItems, isLoadingMore: true)
        : MainPageLoading());

    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/movie/popular',
        queryParameters: {
          'api_key': tmdbApiKey,
          'language': 'en-US',
          'page': _currentPage,
        },
      );

      final newItems = (response.data['results'] as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList();

      _allItems.addAll(newItems);
      _currentPage++; // Increment page for the next fetch

      emit(MainPageLoaded(_allItems));
    } catch (error) {
      emit(MainPageError('Failed to load movies. Please try again.'));
    } finally {
      _isLoadingMore = false;
    }
  }

  void filterItems(String query) {
    final filteredItems = query.isEmpty
        ? List<Movie>.from(_allItems)
        : _allItems
            .where((movie) =>
                movie.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
    emit(MainPageLoaded(filteredItems));
  }
}

class MainPageLoaded extends MainPageState {
  final List<Movie> items;
  final bool isLoadingMore;
  MainPageLoaded(this.items, {this.isLoadingMore = false});
}

abstract class MainPageState {}

class MainPageLoading extends MainPageState {}

class MainPageError extends MainPageState {
  final String message;
  MainPageError(this.message);
}
