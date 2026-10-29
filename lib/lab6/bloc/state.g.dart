// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MovieStateCWProxy {
  MovieState data(List<MovieCardData>? data);

  MovieState isLoading(bool isLoading);

  MovieState error(String? error);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `MovieState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MovieState(...).copyWith(id: 12, name: "My name")
  /// ```
  MovieState call({List<MovieCardData>? data, bool isLoading, String? error});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfMovieState.copyWith(...)` or call `instanceOfMovieState.copyWith.fieldName(value)` for a single field.
class _$MovieStateCWProxyImpl implements _$MovieStateCWProxy {
  const _$MovieStateCWProxyImpl(this._value);

  final MovieState _value;

  @override
  MovieState data(List<MovieCardData>? data) => call(data: data);

  @override
  MovieState isLoading(bool isLoading) => call(isLoading: isLoading);

  @override
  MovieState error(String? error) => call(error: error);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `MovieState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MovieState(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  MovieState call({
    Object? data = const $CopyWithPlaceholder(),
    Object? isLoading = const $CopyWithPlaceholder(),
    Object? error = const $CopyWithPlaceholder(),
  }) {
    return MovieState(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<MovieCardData>?,
      isLoading: isLoading == const $CopyWithPlaceholder() || isLoading == null
          ? _value.isLoading
          // ignore: cast_nullable_to_non_nullable
          : isLoading as bool,
      error: error == const $CopyWithPlaceholder()
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as String?,
    );
  }
}

extension $MovieStateCopyWith on MovieState {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfMovieState.copyWith(...)` or `instanceOfMovieState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MovieStateCWProxy get copyWith => _$MovieStateCWProxyImpl(this);
}
