import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cash_track/models/users.dart';

class DatabaseHelper {
  final databaseName = "cash_track.db";
  String users =
      "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE, password TEXT)";

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 2, onCreate: (db, version) async {
      await db.execute(users);
    });
  }

  Future<bool> login(User user) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        "select * from users where name = '${user.name}' AND password = '${user.password}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> signup(User user) async {
    final Database db = await initDB();

    return db.insert('users', user.toMap());
  }

  Future<int> deleteIncome(int id) async {
    final Database db = await initDB();
    return db.delete('incomes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteExpense(int id) async {
    final Database db = await initDB();
    return db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  // Add other methods for managing incomes and expenses as needed

}
