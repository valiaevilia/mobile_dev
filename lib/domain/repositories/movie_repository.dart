import '../models/movie_card.dart';

abstract interface class MovieRepository {
  Future<List<MovieCardData>> getMovies({
    String? search,
  });
}