import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../domain/models/movie.dart';
import '../../presentation/views/login_page.dart';
import '../../presentation/views/main_page.dart';
import '../../presentation/views/detail_page.dart';

part 'app_router.gr.dart';

@AdaptiveAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: LoginPage, initial: true),
    AutoRoute(page: MainPage, path: '/main'),
    AutoRoute<Movie>(
      page: DetailPage,
      path: '/detail',
    ), // Ensure the generic type is Movie
  ],
)
class AppRouter extends _$AppRouter {}

// Instantiate the router to use in your app
final appRouter = AppRouter();
