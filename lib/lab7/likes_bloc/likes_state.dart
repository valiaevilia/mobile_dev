import 'package:equatable/equatable.dart';

class LikesState extends Equatable {
  final Set<int> likedMovieIds;
  final bool isLoading;
  final String? error;

  LikesState({
    Set<int> likedMovieIds = const {},
    this.isLoading = false,
    this.error,
  }) : likedMovieIds = Set.unmodifiable(likedMovieIds);

  @override
  List<Object?> get props => [likedMovieIds, isLoading, error];
}
