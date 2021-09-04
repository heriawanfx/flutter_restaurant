import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblFavorite = "tbl_favorite";

  final String _createQuery = '''CREATE TABLE $_tblFavorite (
             id TEXT PRIMARY KEY,
             name TEXT,
             description TEXT
             city TEXT,
             address TEXT,
             pictureId TEXT,
             rating TEXT
           )
        ''';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurant.db',
      onCreate: (db, version) async {
        await db.execute(_createQuery);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        final batch = db.batch();

        if (oldVersion != newVersion) {
          _migrateFavorite(batch);
          await batch.commit();
        }
      },
      version: 1,
    );

    return db;
  }

  void _migrateFavorite(Batch batch) {
    batch.execute("ALTER TABLE $_tblFavorite RENAME TO ${_tblFavorite}_old");
    batch.execute(_createQuery);
    batch.execute(
        '''INSERT INTO $_tblFavorite(id, name, description, city, address, rating, pictureId, rating)
          SELECT * FROM ${_tblFavorite}_old
          ''');
    batch.execute("DROP TABLE ${_tblFavorite}_old");
  }

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database;
  }

  Future<bool> insertFavorite(Restaurant restaurant) async {
    final db = await database;
    int insertedId = await db!.insert(_tblFavorite, restaurant.toDatabase());
    return insertedId != 0;
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblFavorite);
    Iterable<Restaurant> iterable = results.map((res) {
      return Restaurant.fromDatabase(res);
    });
    return iterable.toList();
  }

  Future<Map> getFavorited(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<bool> removeFavorite(String id) async {
    final db = await database;

    int deleted = await db!.delete(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );

    return deleted > 0;
  }
}
