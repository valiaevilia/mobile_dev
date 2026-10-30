import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/extensions/context_x.dart';
import '../data/database/likes_database.dart';
import '../data/repositories/movie_repository.dart';
import '../domain/models/movie_card.dart';
import '../lab6/bloc/bloc.dart';
import '../lab6/bloc/events.dart';
import '../lab6/bloc/state.dart';
import '../locale_bloc/locale_bloc.dart';
import '../locale_bloc/locale_events.dart';
import 'likes_bloc/likes_bloc.dart';
import 'likes_bloc/likes_events.dart';
import 'likes_bloc/likes_state.dart';

class Lab7Page extends StatelessWidget {
  const Lab7Page({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (context) =>
              MovieBloc(MovieRepository())..add(const MovieLoadDataEvent()),
        ),
        BlocProvider<LikesBloc>(
          create: (context) =>
              LikesBloc(LikesDatabase())..add(const LoadLikesEvent()),
        ),
      ],
      child: const Lab7View(),
    );
  }
}

class Lab7View extends StatefulWidget {
  const Lab7View({super.key});

  @override
  State<Lab7View> createState() => _Lab7ViewState();
}

class _Lab7ViewState extends State<Lab7View> {
  final TextEditingController searchController = TextEditingController();

  Future<void> _refresh() async {
    final bloc = context.read<MovieBloc>();

    final refreshFinished = bloc.stream.firstWhere((state) => !state.isLoading);

    bloc.add(MovieLoadDataEvent(search: searchController.text));

    await refreshFinished;
  }

  Widget _buildPoster(
    MovieCardData movie, {
    double width = 70,
    double height = 100,
  }) {
    final poster = movie.poster;

    if (poster == null || poster.isEmpty) {
      return SizedBox(
        width: width,
        height: height,
        child: const Icon(Icons.movie, size: 40),
      );
    }

    Widget image;

    if (poster.startsWith('http')) {
      image = Image.network(
        poster,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image);
        },
      );
    } else if (poster.startsWith('/')) {
      image = Image.network(
        'http://127.0.0.1:8080$poster',
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image);
        },
      );
    } else {
      image = Image.asset(
        poster,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image);
        },
      );
    }

    return ClipRRect(borderRadius: BorderRadius.circular(8), child: image);
  }

  void _showDetails(MovieCardData movie) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(movie.title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPoster(movie, width: 170, height: 250),
                const SizedBox(height: 16),
                Text(
                  movie.descriptionText,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(movie.details),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(context.locale.close),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LikesBloc, LikesState>(
      listenWhen: (previous, current) =>
          current.error != null && previous.error != current.error,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.locale.likesError)));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Text(context.locale.labTitle),
          actions: [
            IconButton(
              tooltip: context.locale.switchLanguage,
              onPressed: () {
                context.read<LocaleBloc>().add(const ChangeLocaleEvent());
              },
              icon: Image.asset(
                Localizations.localeOf(context).languageCode == 'ru'
                    ? 'assets/icons/ru.png'
                    : 'assets/icons/en.jpg',
                width: 32,
                height: 22,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: context.locale.search,
                  hintText: context.locale.searchHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  context.read<MovieBloc>().add(MovieSearchChangedEvent(value));
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<MovieBloc, MovieState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.error != null) {
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: 400,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  '${context.locale.loadingError}:\n${state.error}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final movies = state.data ?? [];

                  if (movies.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: 400,
                            child: Center(
                              child: Text(context.locale.moviesNotFound),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: InkWell(
                            onTap: () {
                              _showDetails(movie);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildPoster(movie),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          movie.descriptionText,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          movie.details,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  BlocBuilder<LikesBloc, LikesState>(
                                    builder: (context, likesState) {
                                      final movieId = movie.id;
                                      final isLiked = likesState.likedMovieIds
                                          .contains(movieId);

                                      return IconButton(
                                        tooltip: isLiked
                                            ? context.locale.removeLike
                                            : context.locale.addLike,
                                        onPressed:
                                            movieId == null ||
                                                likesState.isLoading
                                            ? null
                                            : () {
                                                context.read<LikesBloc>().add(
                                                  ToggleLikeEvent(movieId),
                                                );
                                              },
                                        icon: Icon(
                                          isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                        ),
                                        color: isLiked ? Colors.red : null,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
