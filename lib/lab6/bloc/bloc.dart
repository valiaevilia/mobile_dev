import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/movie_repository.dart';
import 'events.dart';
import 'state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repo;

  Timer? _debounce;

  MovieBloc(this.repo) : super(const MovieState()) {
    on<MovieLoadDataEvent>(_onLoadData);
    on<MovieSearchChangedEvent>(_onSearchChanged);
  }

  Future<void> _onLoadData(
      MovieLoadDataEvent event,
      Emitter<MovieState> emit,
      ) async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
      ),
    );

    String? error;

    final data = await repo.loadData(
      q: event.search,
      onError: (e) => error = e,
    );

    emit(
      state.copyWith(
        isLoading: false,
        data: data,
        error: error,
      ),
    );
  }

  void _onSearchChanged(
      MovieSearchChangedEvent event,
      Emitter<MovieState> emit,
      ) {
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 1000),
          () {
        add(
          MovieLoadDataEvent(
            search: event.search,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}