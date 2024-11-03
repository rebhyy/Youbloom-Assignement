import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../../utils/resources/config.dart';

class MainPageCubit extends Cubit<MainPageState> {
  final Dio _dio;

  MainPageCubit(this._dio) : super(MainPageLoading());

  Future<void> fetchItems() async {
    emit(MainPageLoading()); // Show loading state initially
    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/movie/popular',
        queryParameters: {
          'api_key': tmdbApiKey,
          'language': 'en-US',
          'page': 1,
        },
      );

      final items = (response.data['results'] as List)
          .map((movie) => movie['title'] as String)
          .toList();

      emit(MainPageLoaded(items));
    } catch (error) {
      print('Error fetching movies: $error');
      emit(MainPageError('Failed to load movies. Please try again.'));
    }
  }

  void filterItems(String query) {
    if (state is MainPageLoaded) {
      final items = (state as MainPageLoaded).items;
      final filteredItems = query.isEmpty
          ? items
          : items
              .where((item) => item.toLowerCase().contains(query.toLowerCase()))
              .toList();
      emit(MainPageLoaded(filteredItems));
    }
  }
}

// Define the MainPageState abstract class and its subclasses

abstract class MainPageState {}

class MainPageLoading extends MainPageState {}

class MainPageLoaded extends MainPageState {
  final List<String> items;
  MainPageLoaded(this.items);
}

class MainPageError extends MainPageState {
  final String message;
  MainPageError(this.message);
}
