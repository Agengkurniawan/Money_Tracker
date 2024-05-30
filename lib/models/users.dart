//user.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  final String name;
  final String password;

  User({
    required this.name,
    required this.password,
  });

  static late Database _database;

  static Future<Database> get database async {
    if (_database.isOpen) {
      return _database;
    } else {
      _database = await initDatabase();
      return _database;
    }
  }

  static Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT UNIQUE, password TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> addUser(User user) async {
    final db = await database;

    // Periksa apakah nama pengguna sudah ada
    final result = await db.query(
      'users',
      where: 'name = ?',
      whereArgs: [user.name],
    );

    // Jika tidak ada baris yang dikembalikan, tambahkan pengguna baru
    if (result.isEmpty) {
      await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      throw Exception('Username already exists');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'password': password,
    };
  }
}
