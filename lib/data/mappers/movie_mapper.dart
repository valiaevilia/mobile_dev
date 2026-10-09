import '../dtos/movie_dto.dart';
import '../../domain/models/movie_card.dart';

extension MovieDtoToModel on MovieDto {
  MovieCardData toDomain() {
    return MovieCardData(
      id: id,
      title: title ?? 'Без названия',

      descriptionText: _makeDescriptionText(
        year,
        rating,
      ),

      details: description ?? 'Описание отсутствует',

      poster: poster,
      year: year,
      rating: rating,
    );
  }

  String _makeDescriptionText(
      int? year,
      double? rating,
      ) {
    if (year != null && rating != null) {
      return '$year • рейтинг: $rating';
    }

    if (year != null) {
      return '$year';
    }

    if (rating != null) {
      return 'Рейтинг: $rating';
    }

    return '';
  }
}