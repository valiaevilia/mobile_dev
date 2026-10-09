import 'package:json_annotation/json_annotation.dart';

part 'movie_dto.g.dart';

@JsonSerializable(createToJson: false)
class MovieDto {
  final int? id;
  final String? title;
  final int? genreId;
  final int? directorId;
  final int? year;
  final double? rating;
  final String? country;
  final int? duration;
  final String? ageLimit;
  final String? poster;
  final bool? featured;
  final List<String>? cast;
  final String? description;

  const MovieDto({
    this.id,
    this.title,
    this.genreId,
    this.directorId,
    this.year,
    this.rating,
    this.country,
    this.duration,
    this.ageLimit,
    this.poster,
    this.featured,
    this.cast,
    this.description,
  });

  factory MovieDto.fromJson(Map<String, dynamic> json) =>
      _$MovieDtoFromJson(json);
}