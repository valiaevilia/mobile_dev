import '../../domain/models/movie_card.dart';

typedef OnErrorCallback = void Function(String? error);

abstract class MovieApiInterface {
  Future<List<MovieCardData>?> loadData({
    OnErrorCallback? onError,
    String? q,
  });
}