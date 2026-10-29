import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/movie_repository.dart';
import '../domain/models/movie_card.dart';
import 'bloc/bloc.dart';
import 'bloc/events.dart';
import 'bloc/state.dart';

class Lab6Page extends StatelessWidget {
  const Lab6Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieBloc(
        MovieRepository(),
      )..add(
        const MovieLoadDataEvent(),
      ),
      child: const Lab6View(),
    );
  }
}

class Lab6View extends StatefulWidget {
  const Lab6View({super.key});

  @override
  State<Lab6View> createState() => _Lab6ViewState();
}

class _Lab6ViewState extends State<Lab6View> {
  final TextEditingController searchController = TextEditingController();

  Future<void> _refresh() async {
    final bloc = context.read<MovieBloc>();

    final refreshFinished = bloc.stream.firstWhere(
          (state) => !state.isLoading,
    );

    bloc.add(
      MovieLoadDataEvent(
        search: searchController.text,
      ),
    );

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
        child: const Icon(
          Icons.movie,
          size: 40,
        ),
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: image,
    );
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
                _buildPoster(
                  movie,
                  width: 170,
                  height: 250,
                ),
                const SizedBox(height: 16),
                Text(
                  movie.descriptionText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
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
              child: const Text('Закрыть'),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Лабораторная работа №6'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Поиск фильма',
                hintText: 'Например: Маяк',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                context.read<MovieBloc>().add(
                  MovieSearchChangedEvent(value),
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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
                                'Ошибка загрузки:\n${state.error}',
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
                      children: const [
                        SizedBox(
                          height: 400,
                          child: Center(
                            child: Text(
                              'Фильмы не найдены',
                            ),
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
    );
  }
}