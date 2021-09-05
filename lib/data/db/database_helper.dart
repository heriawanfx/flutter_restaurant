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
             description TEXT,
             city TEXT,
             address TEXT,
             pictureId TEXT,
             rating DOUBLE
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
      onDowngrade: (db, oldVersion, newVersion) async {
        final batch = db.batch();

        if (oldVersion != newVersion) {
          _migrateFavorite(batch);
          await batch.commit();
        }
      },
      version: 2,
    );

    return db;
  }

  void _migrateFavorite(Batch batch) {
    batch.execute("DROP TABLE $_tblFavorite");
    batch.execute(_createQuery);
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
    print('getFavorites ' + results[0].toString());
    Iterable<Restaurant> iterable = results.map((res) {
      return Restaurant.fromDatabase(res);
    });
    print('getFavorites iterable' + iterable.toString());
    return iterable.toList();
  }

  Future<Map> getFavorited(Restaurant restaurant) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: [restaurant.id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<bool> removeFavorite(Restaurant restaurant) async {
    final db = await database;

    int deleted = await db!.delete(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: [restaurant.id],
    );

    return deleted > 0;
  }
}
