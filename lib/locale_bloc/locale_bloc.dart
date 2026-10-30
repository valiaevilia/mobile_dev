import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/app_locale.dart';
import 'locale_events.dart';
import 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc(Locale initialLocale)
    : super(LocaleState(currentLocale: initialLocale)) {
    on<ChangeLocaleEvent>((event, emit) {
      final locales = AppLocale.supportedLocales;
      final currentIndex = locales.indexOf(state.currentLocale);

      emit(
        state.copyWith(
          currentLocale: locales[(currentIndex + 1) % locales.length],
        ),
      );
    });
  }
}
