import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/main_page/main_page_cubit.dart';
import '../../config/router/app_router.dart';
import '../../locator.dart';
import '../../domain/models/movie.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<MainPageCubit>().fetchItems(); // Initial fetch
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<MainPageCubit>().filterItems(_searchController.text);
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // Trigger pagination fetch
      context.read<MainPageCubit>().fetchItems(isPagination: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<MainPageCubit>().fetchItems(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Movies',
                hintText: 'Enter movie title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withAlpha(235),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<MainPageCubit, MainPageState>(
              builder: (context, state) {
                if (state is MainPageLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MainPageError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (state is MainPageLoaded) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.isLoadingMore
                        ? state.items.length + 1
                        : state.items.length,
                    itemBuilder: (context, index) {
                      if (index >= state.items.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      var movie = state.items[index];
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: movie.posterPath != null
                              ? Image.network(
                                  movie.posterPath,
                                  width: 50,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error),
                                )
                              : const Icon(Icons.movie,
                                  color: Colors.deepPurple),
                          title: Text(movie.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(movie.overview,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                  'Rating: ${movie.voteAverage.toStringAsFixed(1)}'),
                              Text('Votes: ${movie.voteCount}'),
                            ],
                          ),
                          onTap: () => context.router
                              .push(DetailPageRoute(movie: movie)),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text('No movies found'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
