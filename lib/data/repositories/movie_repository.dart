import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../domain/models/movie_card.dart';
import '../dtos/movie_dto.dart';
import '../mappers/movie_mapper.dart';
import 'movie_api_interface.dart';

class MovieRepository extends MovieApiInterface {
  static final Dio _dio = Dio()
    ..interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
      ),
    );

  static const String _baseUrl = 'http://127.0.0.1:8080';

  @override
  Future<List<MovieCardData>?> loadData({
    OnErrorCallback? onError,
    String? q,
  }) async {
    try {
      const String url = '$_baseUrl/api/1.0/movies';

      final Response<dynamic> response =
      await _dio.get<List<dynamic>>(
        url,
        queryParameters: {
          if (q != null && q.isNotEmpty)
            'search': q,
        },
      );

      final List<dynamic> jsonList =
          response.data as List<dynamic>? ?? [];

      final List<MovieDto> dtoList = jsonList
          .map(
            (json) => MovieDto.fromJson(
          json as Map<String, dynamic>,
        ),
      )
          .toList();

      final List<MovieCardData> movies =
      dtoList.map((dto) => dto.toDomain()).toList();

      return movies;
    } on DioException catch (e) {
      onError?.call(e.message);
      return null;
    }
  }
}