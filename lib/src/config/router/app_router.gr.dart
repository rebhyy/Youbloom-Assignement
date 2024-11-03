// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    LoginPageRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    MainPageRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: MainPage(),
      );
    },
    DetailPageRoute.name: (routeData) {
      final args = routeData.argsAs<DetailPageRouteArgs>();
      return AdaptivePage<Movie>(
        routeData: routeData,
        child: DetailPage(
          key: args.key,
          movie: args.movie,
        ),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          LoginPageRoute.name,
          path: '/',
        ),
        RouteConfig(
          MainPageRoute.name,
          path: '/main',
        ),
        RouteConfig(
          DetailPageRoute.name,
          path: '/detail',
        ),
      ];
}

/// generated route for
/// [LoginPage]
class LoginPageRoute extends PageRouteInfo<void> {
  const LoginPageRoute()
      : super(
          LoginPageRoute.name,
          path: '/',
        );

  static const String name = 'LoginPageRoute';
}

/// generated route for
/// [MainPage]
class MainPageRoute extends PageRouteInfo<void> {
  const MainPageRoute()
      : super(
          MainPageRoute.name,
          path: '/main',
        );

  static const String name = 'MainPageRoute';
}

/// generated route for
/// [DetailPage]
class DetailPageRoute extends PageRouteInfo<DetailPageRouteArgs> {
  DetailPageRoute({
    Key? key,
    required Movie movie,
  }) : super(
          DetailPageRoute.name,
          path: '/detail',
          args: DetailPageRouteArgs(
            key: key,
            movie: movie,
          ),
        );

  static const String name = 'DetailPageRoute';
}

class DetailPageRouteArgs {
  const DetailPageRouteArgs({
    this.key,
    required this.movie,
  });

  final Key? key;

  final Movie movie;

  @override
  String toString() {
    return 'DetailPageRouteArgs{key: $key, movie: $movie}';
  }
}
