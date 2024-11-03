import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/main_page/main_page_cubit.dart';
import '../../config/router/app_router.dart';
import '../../locator.dart'; // Import locator
import '../../domain/models/movie.dart'; // Import the Movie model

class MainPage extends StatelessWidget {
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
      body: BlocProvider(
        create: (_) => MainPageCubit(locator<Dio>())..fetchItems(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search Movies',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (query) =>
                    context.read<MainPageCubit>().filterItems(query),
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
                    return ListView.separated(
                      itemCount: state.items.length,
                      separatorBuilder: (_, index) => const Divider(),
                      itemBuilder: (context, index) {
                        var movie = state.items[index];
                        return ListTile(
                          leading: movie.posterPath != null
                            ? Image.network(
                                movie.posterPath,
                                width: 50,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                              )
                            : const Icon(Icons.movie, color: Colors.deepPurple),
                          title: Text(
                            movie.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            movie.overview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Rating: ${movie.voteAverage.toStringAsFixed(1)}'),
                              Text('Votes: ${movie.voteCount}'),
                            ],
                          ),
                          onTap: () => context.router.push(DetailPageRoute(movie: movie)),
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
      ),
    );
  }
}
