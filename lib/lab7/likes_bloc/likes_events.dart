abstract class LikesEvent {
  const LikesEvent();
}

class LoadLikesEvent extends LikesEvent {
  const LoadLikesEvent();
}

class ToggleLikeEvent extends LikesEvent {
  final int movieId;

  const ToggleLikeEvent(this.movieId);
}
