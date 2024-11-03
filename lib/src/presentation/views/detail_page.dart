import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../domain/models/movie.dart';

class DetailPage extends StatelessWidget {
  final Movie movie;

  const DetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (movie.posterPath != null)
                Image.network(movie.posterPath, fit: BoxFit.cover),
              Text(movie.overview,
                  style: Theme.of(context).textTheme.titleMedium),
              Text('Rating: ${movie.voteAverage}',
                  style: Theme.of(context).textTheme.titleSmall),
              Text('Votes: ${movie.voteCount}',
                  style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ),
      ),
    );
  }
}
