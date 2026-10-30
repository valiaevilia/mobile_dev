import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_dev_labs/data/database/likes_database.dart';
import 'package:mobile_dev_labs/data/repositories/movie_api_interface.dart';
import 'package:mobile_dev_labs/data/repositories/movie_repository.dart';
import 'package:mobile_dev_labs/domain/models/movie_card.dart';
import 'package:mobile_dev_labs/l10n/app_locale.dart';
import 'package:mobile_dev_labs/lab6/bloc/bloc.dart';
import 'package:mobile_dev_labs/lab6/bloc/events.dart';
import 'package:mobile_dev_labs/lab7/lab7_page.dart';
import 'package:mobile_dev_labs/lab7/likes_bloc/likes_bloc.dart';
import 'package:mobile_dev_labs/lab7/likes_bloc/likes_events.dart';
import 'package:mobile_dev_labs/lab7/likes_bloc/likes_state.dart';
import 'package:mobile_dev_labs/locale_bloc/locale_bloc.dart';
import 'package:mobile_dev_labs/locale_bloc/locale_state.dart';

class _LikesDatabase extends LikesDatabase {
  final Set<int> stored;
  final List<String> writes = [];
  Completer<void>? loadGate;
  bool failLoad = false;
  bool failWrites = false;

  _LikesDatabase([Set<int> initialIds = const {}])
    : stored = Set.of(initialIds);

  @override
  Future<Set<int>> getLikedMovieIds() async {
    await loadGate?.future;
    if (failLoad) throw StateError('load failed');
    return Set.of(stored);
  }

  @override
  Future<void> addLike(int movieId) async {
    await Future<void>.delayed(Duration.zero);
    if (failWrites) throw StateError('write failed');
    stored.add(movieId);
    writes.add('add:$movieId');
  }

  @override
  Future<void> removeLike(int movieId) async {
    await Future<void>.delayed(Duration.zero);
    if (failWrites) throw StateError('write failed');
    stored.remove(movieId);
    writes.add('remove:$movieId');
  }
}

class _MovieRepository extends MovieRepository {
  final List<String?> queries = [];

  @override
  Future<List<MovieCardData>?> loadData({
    OnErrorCallback? onError,
    String? q,
  }) async {
    queries.add(q);
    const movies = [
      MovieCardData(
        id: 1,
        title: 'Маяк',
        descriptionText: 'Краткое описание',
        details: 'Подробности фильма с backend',
      ),
      MovieCardData(
        title: 'Фильм без ID',
        descriptionText: 'Описание',
        details: 'Подробности',
      ),
    ];
    return movies
        .where((movie) => q == null || movie.title.contains(q))
        .toList();
  }
}

Future<LikesState> _dispatch(LikesBloc bloc, LikesEvent event) {
  final finished = bloc.stream.firstWhere((state) => !state.isLoading);
  bloc.add(event);
  return finished;
}

Widget _testApp(_LikesDatabase database, _MovieRepository repository) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => LocaleBloc(const Locale('ru'))),
      BlocProvider(
        create: (_) => MovieBloc(repository)..add(const MovieLoadDataEvent()),
      ),
      BlocProvider(
        create: (_) => LikesBloc(database)..add(const LoadLikesEvent()),
      ),
    ],
    child: BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) => MaterialApp(
        locale: state.currentLocale,
        localizationsDelegates: AppLocale.localizationsDelegates,
        supportedLocales: AppLocale.supportedLocales,
        home: const Lab7View(),
      ),
    ),
  );
}

void main() {
  test('loading and rapid toggles share one ordered database queue', () async {
    final database = _LikesDatabase({1})..loadGate = Completer<void>();
    final bloc = LikesBloc(database);
    addTearDown(bloc.close);
    final finishedStates = bloc.stream
        .where((state) => !state.isLoading)
        .take(4)
        .toList();

    bloc
      ..add(const LoadLikesEvent())
      ..add(const ToggleLikeEvent(1))
      ..add(const ToggleLikeEvent(2))
      ..add(const ToggleLikeEvent(2));
    await Future<void>.delayed(Duration.zero);
    expect(database.writes, isEmpty);
    database.loadGate!.complete();

    final states = await finishedStates;
    expect(states.map((state) => state.likedMovieIds), [
      {1},
      <int>{},
      {2},
      <int>{},
    ]);
    expect(database.writes, ['remove:1', 'add:2', 'remove:2']);
    expect(database.stored, isEmpty);
    expect(states.every((state) => state.error == null), isTrue);
  });

  for (final initiallyLiked in [false, true]) {
    test(
      'failed ${initiallyLiked ? 'delete' : 'insert'} preserves likes',
      () async {
        final initialIds = initiallyLiked ? {1} : <int>{};
        final database = _LikesDatabase(initialIds);
        final bloc = LikesBloc(database);
        addTearDown(bloc.close);
        await _dispatch(bloc, const LoadLikesEvent());
        database.failWrites = true;

        final state = await _dispatch(bloc, const ToggleLikeEvent(1));

        expect(state.error, contains('write failed'));
        expect(state.isLoading, isFalse);
        expect(state.likedMovieIds, initialIds);
        expect(database.stored, initialIds);
      },
    );
  }

  test('failed reload preserves previously loaded likes', () async {
    final database = _LikesDatabase({1, 3});
    final bloc = LikesBloc(database);
    addTearDown(bloc.close);
    await _dispatch(bloc, const LoadLikesEvent());
    database.failLoad = true;

    final state = await _dispatch(bloc, const LoadLikesEvent());

    expect(state.error, contains('load failed'));
    expect(state.likedMovieIds, {1, 3});
    expect(state.isLoading, isFalse);
  });

  testWidgets('hearts work with RU/EN, search, debounce, refresh and details', (
    tester,
  ) async {
    final database = _LikesDatabase();
    final repository = _MovieRepository();
    await tester.pumpWidget(_testApp(database, repository));
    await tester.pumpAndSettle();

    expect(find.byType(Card), findsNWidgets(2));
    final buttons = tester
        .widgetList<IconButton>(find.byType(IconButton))
        .where((button) => button.tooltip == 'Поставить лайк');
    expect(buttons.where((button) => button.onPressed == null), hasLength(1));

    await tester.tap(find.byTooltip('Поставить лайк').first);
    await tester.pumpAndSettle();
    expect(database.stored, {1});
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    final viewContext = tester.element(find.byType(Lab7View));
    final movieBloc = viewContext.read<MovieBloc>();
    final likesBloc = viewContext.read<LikesBloc>();
    await tester.tap(find.byTooltip('Переключить на английский'));
    await tester.pumpAndSettle();
    expect(find.text('Laboratory work №7'), findsOneWidget);
    expect(find.byTooltip('Remove like'), findsOneWidget);
    expect(find.text('Маяк'), findsOneWidget);
    expect(viewContext.read<MovieBloc>(), same(movieBloc));
    expect(viewContext.read<LikesBloc>(), same(likesBloc));
    expect(repository.queries, [null]);

    await tester.enterText(find.byType(TextField), 'Ма');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.enterText(find.byType(TextField), 'Маяк');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 999));
    expect(repository.queries, [null]);
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();
    expect(repository.queries, [null, 'Маяк']);
    expect(find.byType(Card), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 400));
    await tester.pumpAndSettle();
    expect(repository.queries, [null, 'Маяк', 'Маяк']);
    expect(database.stored, {1});

    await tester.tap(
      find.descendant(of: find.byType(Card), matching: find.text('Маяк')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
    expect(find.text('Подробности фильма с backend'), findsNWidgets(2));
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Remove like'));
    await tester.pumpAndSettle();
    expect(database.stored, isEmpty);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    await tester.tap(find.byTooltip('Switch to Russian'));
    await tester.pumpAndSettle();
    expect(find.text('Лабораторная работа №7'), findsOneWidget);
    expect(find.byTooltip('Поставить лайк'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Маяк',
    );
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets(
    'write failure keeps the heart empty and shows a localized error',
    (tester) async {
      final database = _LikesDatabase()..failWrites = true;
      await tester.pumpWidget(_testApp(database, _MovieRepository()));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Поставить лайк').first);
      await tester.pumpAndSettle();

      expect(
        find.text('Не удалось загрузить или сохранить лайки'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.favorite), findsNothing);
      expect(database.stored, isEmpty);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );
}
