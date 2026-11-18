import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ImageDatabase {
  /// To holding database instance .Using static allows it to be shared across entire app .
  static Database? _db;

  /// getter method for database
  static Future<Database> getDB() async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath(); // Get path to database directory
    final path = join(dbPath, 'images.db'); // Full path to 'images.db'
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE images (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            path TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertImage(String name, String path) async {
    final db = await getDB();
    await db.insert('images', {'name': name, 'path': path});
  }

  static Future<List<Map<String, dynamic>>> getAllImages() async {
    final db = await getDB();
    return await db.query(
      'images',
      orderBy: 'id DESC',
    ); //Results are ordered by id in descending order (newest first).
  }

  /// this method is used for delete a specific image by its path .
  // static Future<void> deleteImage(String path) async{
  //   final db = await getDB();
  //   await db.delete('images',where: 'path = ?',whereArgs: [path]);
  // }

  static Future<void> clearAllImages() async {
    final db = await getDB();
    await db.delete('images');
  }
}
