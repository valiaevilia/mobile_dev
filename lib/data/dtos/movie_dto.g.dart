// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDto _$MovieDtoFromJson(Map<String, dynamic> json) => MovieDto(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  genreId: (json['genreId'] as num?)?.toInt(),
  directorId: (json['directorId'] as num?)?.toInt(),
  year: (json['year'] as num?)?.toInt(),
  rating: (json['rating'] as num?)?.toDouble(),
  country: json['country'] as String?,
  duration: (json['duration'] as num?)?.toInt(),
  ageLimit: json['ageLimit'] as String?,
  poster: json['poster'] as String?,
  featured: json['featured'] as bool?,
  cast: (json['cast'] as List<dynamic>?)?.map((e) => e as String).toList(),
  description: json['description'] as String?,
);
