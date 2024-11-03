import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../domain/models/movie.dart';
import '../../../utils/resources/config.dart';

class MainPageCubit extends Cubit<MainPageState> {
  final Dio _dio;
  List<Movie> _allItems = []; // Store all fetched items for filtering

  MainPageCubit(this._dio) : super(MainPageLoading());

  Future<void> fetchItems() async {
    emit(MainPageLoading());
    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/movie/popular',
        queryParameters: {
          'api_key': tmdbApiKey,
          'language': 'en-US',
          'page': 1,
        },
      );

      _allItems = (response.data['results'] as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList();

      emit(MainPageLoaded(_allItems)); // Emit the loaded state with all items
    } catch (error) {
      print('Error fetching movies: $error');
      emit(MainPageError('Failed to load movies. Please try again.'));
    }
  }

  void filterItems(String query) {
    final filteredItems = query.isEmpty
        ? List<Movie>.from(_allItems)
        : _allItems
            .where((movie) =>
                movie.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
    emit(MainPageLoaded(
        List<Movie>.from(filteredItems))); // Force a new list instance
  }
}

abstract class MainPageState {}

class MainPageLoading extends MainPageState {}

class MainPageLoaded extends MainPageState {
  final List<Movie> items;
  MainPageLoaded(this.items);
}

class MainPageError extends MainPageState {
  final String message;
  MainPageError(this.message);
}
