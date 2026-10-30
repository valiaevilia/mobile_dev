import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/database/likes_database.dart';
import 'likes_events.dart';
import 'likes_state.dart';

class LikesBloc extends Bloc<LikesEvent, LikesState> {
  final LikesDatabase database;

  LikesBloc(this.database) : super(LikesState()) {
    // Load and toggle events share one queue so database writes cannot overlap.
    on<LikesEvent>(
      _onEvent,
      transformer: (events, mapper) => events.asyncExpand(mapper),
    );
  }

  Future<void> _onEvent(LikesEvent event, Emitter<LikesState> emit) async {
    emit(LikesState(likedMovieIds: state.likedMovieIds, isLoading: true));

    try {
      if (event is LoadLikesEvent) {
        final likedMovieIds = await database.getLikedMovieIds();
        emit(LikesState(likedMovieIds: likedMovieIds));
      } else if (event is ToggleLikeEvent) {
        final likedMovieIds = Set<int>.of(state.likedMovieIds);
        if (likedMovieIds.contains(event.movieId)) {
          await database.removeLike(event.movieId);
          likedMovieIds.remove(event.movieId);
        } else {
          await database.addLike(event.movieId);
          likedMovieIds.add(event.movieId);
        }
        emit(LikesState(likedMovieIds: likedMovieIds));
      }
    } catch (error) {
      emit(
        LikesState(likedMovieIds: state.likedMovieIds, error: error.toString()),
      );
    }
  }
}
