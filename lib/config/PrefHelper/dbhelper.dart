import 'package:claimizer/config/PrefHelper/model/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static late Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    // If the database is null, initialize it
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create the table when the database is created
        await db.execute('''
          CREATE TABLE users (
            name TEXT,
            email TEXT PRIMARY KEY,
            token TEXT,
            active INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<void> activateUser(String email) async {
    final db = await database;
    // First, set all users to inactive
    await db.update(
      'users',
      {'active': 0},
    );
    // Then, set the specified user to active
    await db.update(
      'users',
      {'active': 1},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<void> deleteUser(String email) async {
    final db = await database;
    // Delete the user with the specified email
    await db.delete(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<String?> getActiveUserToken() async {
    final db = await database;

    // Query the database to retrieve the token of the active user
    final result = await db.query(
      'users',
      where: 'active = ?',
      whereArgs: [1], // 1 represents an active user
      columns: ['token'],
    );

    if (result.isNotEmpty) {
      return result.first['token'] as String;
    } else {
      return null; // No active user found
    }
  }
}
