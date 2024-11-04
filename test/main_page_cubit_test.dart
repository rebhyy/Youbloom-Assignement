import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:youbloom/src/domain/models/movie.dart';
import 'package:youbloom/src/presentation/cubits/main_page/main_page_cubit.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late MainPageCubit cubit;

  setUp(() {
    mockDio = MockDio();
    cubit = MainPageCubit(mockDio);
  });

  tearDown(() {
    cubit.close();
  });

  group('MainPageCubit', () {
    test('initial state is MainPageLoading', () {
      expect(cubit.state, isA<MainPageLoading>());
    });

    blocTest<MainPageCubit, MainPageState>(
      'emits [MainPageLoading, MainPageLoaded] when fetchItems is successful',
      build: () {
        when(() => mockDio.get(any(),
            queryParameters: any(named: 'queryParameters'))).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: {
              'results': [
                {
                  'title': 'Movie 1',
                  'overview': 'Overview of Movie 1',
                  'poster_path': '/path1.jpg',
                  'vote_average': 7.8,
                  'vote_count': 100,
                },
                {
                  'title': 'Movie 2',
                  'overview': 'Overview of Movie 2',
                  'poster_path': '/path2.jpg',
                  'vote_average': 6.5,
                  'vote_count': 200,
                },
              ],
            },
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.fetchItems(),
      expect: () => [
        isA<MainPageLoading>(),
        isA<MainPageLoaded>().having((s) => s.items.length, 'items length', 2),
      ],
    );

    blocTest<MainPageCubit, MainPageState>(
      'emits [MainPageLoading, MainPageError] when fetchItems fails',
      build: () {
        when(() => mockDio.get(any(),
            queryParameters: any(named: 'queryParameters'))).thenThrow(
          DioError(requestOptions: RequestOptions(path: '')),
        );
        return cubit;
      },
      act: (cubit) => cubit.fetchItems(),
      expect: () => [
        isA<MainPageLoading>(),
        isA<MainPageError>().having((s) => s.message, 'message',
            'Failed to load movies. Please try again.'),
      ],
    );

    blocTest<MainPageCubit, MainPageState>(
      'emits [MainPageLoading, MainPageLoaded (initial items), MainPageLoaded (more items)] when pagination is successful',
      build: () {
        when(() => mockDio.get(any(),
                queryParameters: any(named: 'queryParameters')))
            .thenAnswer((invocation) async {
          final page = invocation
              .namedArguments[const Symbol('queryParameters')]['page'];
          return Response(
            requestOptions: RequestOptions(path: ''),
            data: {
              'results': page == 1
                  ? [
                      {
                        'title': 'Movie 1',
                        'overview': 'Overview of Movie 1',
                        'poster_path': '/path1.jpg',
                        'vote_average': 7.8,
                        'vote_count': 100,
                      },
                    ]
                  : [
                      {
                        'title': 'Movie 2',
                        'overview': 'Overview of Movie 2',
                        'poster_path': '/path2.jpg',
                        'vote_average': 6.5,
                        'vote_count': 200,
                      },
                    ],
            },
          );
        });
        return cubit;
      },
      act: (cubit) async {
        await cubit.fetchItems(); // Initial fetch
        await cubit.fetchItems(isPagination: true); // Pagination fetch
      },
      expect: () => [
        isA<MainPageLoading>(),
        isA<MainPageLoaded>()
            .having((s) => s.items.length, 'items length after first fetch', 1),
        isA<MainPageLoaded>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', true),
        isA<MainPageLoaded>()
            .having((s) => s.items.length, 'items length after pagination', 2),
      ],
    );

    blocTest<MainPageCubit, MainPageState>(
      'emits filtered items in MainPageLoaded when filterItems is called',
      build: () {
        final cubit = MainPageCubit(mockDio);
        // Directly initialize the `_allItems` list to ensure data is available for filtering.
        cubit.emit(MainPageLoaded([
          Movie(
              title: 'Movie 1',
              overview: 'Overview',
              posterPath: '/path1.jpg',
              voteAverage: 7.8,
              voteCount: 100),
          Movie(
              title: 'Another Movie',
              overview: 'Overview',
              posterPath: '/path2.jpg',
              voteAverage: 6.5,
              voteCount: 200),
        ]));
        return cubit;
      },
      act: (cubit) => cubit.filterItems('Movie'),
      expect: () => [
        isA<MainPageLoaded>()
            .having((s) => s.items.length, 'filtered items length', 1),
      ],
    );
  });
}



