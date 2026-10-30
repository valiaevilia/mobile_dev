import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class LikesDatabase {
  Database? _database;

  Future<Database> get database async {
    final currentDatabase = _database;
    if (currentDatabase != null && currentDatabase.isOpen) {
      return currentDatabase;
    }

    final databasePath = p.join(await getDatabasesPath(), 'movie_likes.db');
    final openedDatabase = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE liked_movies (movie_id INTEGER PRIMARY KEY)',
        );
      },
    );
    _database = openedDatabase;
    return openedDatabase;
  }

  Future<Set<int>> getLikedMovieIds() async {
    final db = await database;
    final rows = await db.query('liked_movies', columns: ['movie_id']);
    return rows.map((row) => row['movie_id'] as int).toSet();
  }

  Future<void> addLike(int movieId) async {
    final db = await database;
    await db.insert('liked_movies', {
      'movie_id': movieId,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> removeLike(int movieId) async {
    final db = await database;
    await db.delete(
      'liked_movies',
      where: 'movie_id = ?',
      whereArgs: [movieId],
    );
  }

  Future<bool> isLiked(int movieId) async {
    final db = await database;
    final rows = await db.query(
      'liked_movies',
      columns: ['movie_id'],
      where: 'movie_id = ?',
      whereArgs: [movieId],
      limit: 1,
    );
    return rows.isNotEmpty;
  }
}
