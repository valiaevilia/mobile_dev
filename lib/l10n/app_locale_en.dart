// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_locale.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocaleEn extends AppLocale {
  AppLocaleEn([String locale = 'en']) : super(locale);

  @override
  String get labTitle => 'Laboratory work №7';

  @override
  String get search => 'Movie search';

  @override
  String get searchHint => 'For example: The Lighthouse';

  @override
  String get moviesNotFound => 'Movies not found';

  @override
  String get loadingError => 'Loading error';

  @override
  String get close => 'Close';

  @override
  String get switchLanguage => 'Switch to Russian';

  @override
  String get addLike => 'Like';

  @override
  String get removeLike => 'Remove like';

  @override
  String get likesError => 'Could not load or save likes';
}
