// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LocaleStateCWProxy {
  LocaleState currentLocale(Locale currentLocale);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `LocaleState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LocaleState(...).copyWith(id: 12, name: "My name")
  /// ```
  LocaleState call({Locale currentLocale});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfLocaleState.copyWith(...)` or call `instanceOfLocaleState.copyWith.fieldName(value)` for a single field.
class _$LocaleStateCWProxyImpl implements _$LocaleStateCWProxy {
  const _$LocaleStateCWProxyImpl(this._value);

  final LocaleState _value;

  @override
  LocaleState currentLocale(Locale currentLocale) =>
      call(currentLocale: currentLocale);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `LocaleState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LocaleState(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  LocaleState call({Object? currentLocale = const $CopyWithPlaceholder()}) {
    return LocaleState(
      currentLocale:
          currentLocale == const $CopyWithPlaceholder() || currentLocale == null
          ? _value.currentLocale
          // ignore: cast_nullable_to_non_nullable
          : currentLocale as Locale,
    );
  }
}

extension $LocaleStateCopyWith on LocaleState {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfLocaleState.copyWith(...)` or `instanceOfLocaleState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LocaleStateCWProxy get copyWith => _$LocaleStateCWProxyImpl(this);
}
