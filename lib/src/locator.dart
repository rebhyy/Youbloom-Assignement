import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data/datasources/local/app_database.dart';
import 'data/datasources/remote/news_api_service.dart';
import 'data/repositories/api_repository_impl.dart';
import 'data/repositories/database_repository_impl.dart';
import 'domain/repositories/api_repository.dart';
import 'domain/repositories/database_repository.dart';
import 'utils/constants/strings.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies() async {
  try {
    // Initialize and register dependencies
    final db = await $FloorAppDatabase.databaseBuilder(databaseName).build();
    locator.registerSingleton<AppDatabase>(db);
    print('Database initialized');

    final dio = Dio();
    dio.interceptors.add(AwesomeDioInterceptor());
    locator.registerSingleton<Dio>(dio);
    print('Dio instance registered');

    locator.registerSingleton<NewsApiService>(
      NewsApiService(locator<Dio>()),
    );
    print('NewsApiService registered');

    locator.registerSingleton<ApiRepository>(
      ApiRepositoryImpl(locator<NewsApiService>()),
    );
    locator.registerSingleton<DatabaseRepository>(
      DatabaseRepositoryImpl(locator<AppDatabase>()),
    );
    print('All dependencies registered');
  } catch (e) {
    print('Failed to initialize dependencies: $e');
  }
}
