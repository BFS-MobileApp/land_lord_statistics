import 'package:claimizer/feature/useraccounts/data/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }


  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'my_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }


  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
            name TEXT,
            email TEXT PRIMARY KEY,
            token TEXT,
            active INTEGER
          )
    ''');
  }


  Future<void> insertUser(UserModel user) async {
    final db = await database;
    // Check if the email already exists in the database
    final existingUsers = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [user.email],
    );
    if (existingUsers.isEmpty) {
      // Email doesn't exist, proceed with insertion
      await db.insert('users', user.toMap());
    }
  }

  Future<List<UserModel>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
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

  Future<void> deleteAllActiveUsers() async {
    final db = await database;
    // Delete all users with active status set to true (1)
    await db.delete(
      'users',
      where: 'active = ?',
      whereArgs: [1], // 1 represents an active user
    );
  }
}