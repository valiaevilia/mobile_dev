abstract class MovieEvent {
  const MovieEvent();
}

class MovieLoadDataEvent extends MovieEvent {
  final String? search;

  const MovieLoadDataEvent({
    this.search,
  });
}

class MovieSearchChangedEvent extends MovieEvent {
  final String search;

  const MovieSearchChangedEvent(this.search);
}