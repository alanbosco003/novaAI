import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/models/album_model.dart';
import '../../data/models/image_model.dart';

class DatabaseService {
  static Database? _database;

  static const String dbName = 'app_database.db';
  static const String albumTable = 'albums';
  static const String imageTable = 'images';
  static const String launchTable = 'launch_count';

  // Initialize Database
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Create database
  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: 2, // Increment version to trigger `onUpgrade`
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute("DROP TABLE IF EXISTS $imageTable");
        await db.execute("DROP TABLE IF EXISTS $albumTable");
        await _createTables(db);
      },
    );
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
    CREATE TABLE $albumTable (
      id INTEGER PRIMARY KEY,
      title TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE $imageTable (
      id INTEGER PRIMARY KEY,
      albumId INTEGER NOT NULL,
      title TEXT NOT NULL,
      imageBytes BLOB NOT NULL,
      FOREIGN KEY (albumId) REFERENCES albums(id)
    )
  ''');

    await db.execute('''
    CREATE TABLE $launchTable (
      id INTEGER PRIMARY KEY,
      count INTEGER NOT NULL
    )
  ''');

    // Initialize launch count
    await db.insert(launchTable, {'id': 1, 'count': 0});
  }

  // 📌 Save Albums
  static Future<void> saveAlbums(List<Album> albums) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var album in albums) {
        await txn.insert(albumTable, album.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
    print("✅ Albums cached in SQLite");
  }

  // 📌 Get Cached Albums
  static Future<List<Album>> getAlbums() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(albumTable);
    return maps.map((map) => Album.fromJson(map)).toList();
  }

  // 📌 Save Images
  static Future<void> saveImages(int albumId, List<ImageModel> images) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var image in images) {
        await txn.insert(imageTable, image.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
    print("✅ Images cached for album $albumId in SQLite");
  }

  // 📌 Get Cached Images
  static Future<List<ImageModel>> getImages(int albumId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      imageTable,
      where: 'albumId = ?',
      whereArgs: [albumId],
    );
    return maps.map((map) => ImageModel.fromJson(map)).toList();
  }

  // 📌 Get Launch Count
  static Future<int> getLaunchCount() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(launchTable);
    return result.isNotEmpty ? result.first['count'] as int : 0;
  }

  // 📌 Increment Launch Count
  static Future<void> incrementLaunchCount() async {
    final db = await database;
    int currentCount = await getLaunchCount();
    await db.update(launchTable, {'count': currentCount + 1}, where: 'id = 1');
  }

  // 📌 Reset Launch Count
  static Future<void> resetLaunchCount() async {
    final db = await database;
    await db.update(launchTable, {'count': 0}, where: 'id = 1');
    print("🔄 Launch count reset to 0");
  }
}
