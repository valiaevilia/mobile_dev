import '../../domain/models/movie_card.dart';
import 'movie_api_interface.dart';

class MockRepository extends MovieApiInterface {
  @override
  Future<List<MovieCardData>?> loadData({
    OnErrorCallback? onError,
    String? q,
  }) async {
    final movies = [
      const MovieCardData(
        id: 1,
        title: 'Маяк',
        descriptionText: '2019 • рейтинг: 7.4',
        details:
        'Два смотрителя маяка пытаются сохранить рассудок, '
            'живя на отдалённом острове.',
        poster: 'image/45ea3b3c78d89d0e7b8e6b71284e75c4.jpg',
        year: 2019,
        rating: 7.4,
      ),
      const MovieCardData(
        id: 2,
        title: 'Ноябрь',
        descriptionText: '2017',
        details:
        'Мрачная история, действие которой происходит '
            'в эстонской деревне.',
        poster: 'image/nov2.png',
        year: 2017,
      ),
    ];

    if (q == null || q.trim().isEmpty) {
      return movies;
    }

    final query = q.toLowerCase();

    return movies
        .where(
          (movie) => movie.title.toLowerCase().contains(query),
    )
        .toList();
  }
}