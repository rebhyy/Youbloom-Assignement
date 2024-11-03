class Movie {
  final String title;
  final String overview;
  final String posterPath; // Assuming you will eventually use images
  final double voteAverage;
  final int voteCount;

  Movie({
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'] as int,
    );
  }
}
