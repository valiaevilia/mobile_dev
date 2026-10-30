// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_locale.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocaleRu extends AppLocale {
  AppLocaleRu([String locale = 'ru']) : super(locale);

  @override
  String get labTitle => 'Лабораторная работа №7';

  @override
  String get search => 'Поиск фильма';

  @override
  String get searchHint => 'Например: Маяк';

  @override
  String get moviesNotFound => 'Фильмы не найдены';

  @override
  String get loadingError => 'Ошибка загрузки';

  @override
  String get close => 'Закрыть';

  @override
  String get switchLanguage => 'Переключить на английский';

  @override
  String get addLike => 'Поставить лайк';

  @override
  String get removeLike => 'Убрать лайк';

  @override
  String get likesError => 'Не удалось загрузить или сохранить лайки';
}
