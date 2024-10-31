import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../presentation/views/login_page.dart';
import '../../presentation/views/main_page.dart';
import '../../presentation/views/detail_page.dart';

part 'app_router.gr.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(
        page: LoginPage, initial: true), // Set LoginPage as the initial route
    AutoRoute(page: MainPage, path: '/main'), // MainPage for main content
    AutoRoute(page: DetailPage, path: '/detail'), // DetailPage for item details
  ],
)
class AppRouter extends _$AppRouter {}

// Instantiate the router to use in your app
final appRouter = AppRouter();
