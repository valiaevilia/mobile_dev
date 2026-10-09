import 'package:flutter/material.dart';

import '../data/repositories/movie_api_interface.dart';
import '../data/repositories/movie_repository.dart';
import '../domain/models/movie_card.dart';

class Lab5Page extends StatefulWidget {
  const Lab5Page({super.key});

  @override
  State<Lab5Page> createState() => _Lab5PageState();
}

class _Lab5PageState extends State<Lab5Page> {
  final MovieApiInterface repository = MovieRepository();

  final TextEditingController searchController = TextEditingController();

  List<MovieCardData> movies = [];

  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies({String? search}) async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final result = await repository.loadData(
      q: search,
      onError: (message) {
        error = message;
      },
    );

    if (!mounted) {
      return;
    }

    setState(() {
      movies = result ?? [];
      isLoading = false;
    });
  }

  Widget _buildPoster(MovieCardData movie) {
    final poster = movie.poster;

    if (poster == null || poster.isEmpty) {
      return const SizedBox(
        width: 70,
        height: 100,
        child: Icon(
          Icons.movie,
          size: 40,
        ),
      );
    }

    Widget image;

    if (poster.startsWith('http')) {
      image = Image.network(
        poster,
        width: 70,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            width: 70,
            height: 100,
            child: Icon(Icons.broken_image),
          );
        },
      );
    } else if (poster.startsWith('/')) {
      image = Image.network(
        'http://127.0.0.1:8080$poster',
        width: 70,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            width: 70,
            height: 100,
            child: Icon(Icons.broken_image),
          );
        },
      );
    } else {
      image = Image.asset(
        poster,
        width: 70,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            width: 70,
            height: 100,
            child: Icon(Icons.broken_image),
          );
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
                _buildDetailsPoster(movie),
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

  Widget _buildDetailsPoster(MovieCardData movie) {
    final poster = movie.poster;

    if (poster == null || poster.isEmpty) {
      return const Icon(
        Icons.movie,
        size: 80,
      );
    }

    if (poster.startsWith('http')) {
      return Image.network(
        poster,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.broken_image,
            size: 80,
          );
        },
      );
    }

    if (poster.startsWith('/')) {
      return Image.network(
        'http://127.0.0.1:8080$poster',
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.broken_image,
            size: 80,
          );
        },
      );
    }

    return Image.asset(
      poster,
      height: 250,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.broken_image,
          size: 80,
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
        title: const Text('Лабораторная работа №5'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Поиск фильма',
                hintText: 'Например: Маяк',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _loadMovies(
                      search: searchController.text,
                    );
                  },
                ),
              ),
              onSubmitted: (value) {
                _loadMovies(search: value);
              },
            ),
          ),

          if (isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (error != null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Ошибка загрузки:\n$error',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else if (movies.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('Фильмы не найдены'),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
              ),
        ],
      ),
    );
  }
}