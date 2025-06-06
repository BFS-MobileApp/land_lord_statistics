import 'package:LandlordStatistics/config/arguments/routes_arguments.dart';
import 'package:LandlordStatistics/config/routes/app_routes.dart';
import 'package:LandlordStatistics/core/api/end_points.dart';
import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:LandlordStatistics/feature/setting/data/models/user_model.dart';
import 'package:LandlordStatistics/widgets/message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
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
    await db.execute('''
    CREATE TABLE url (
      savedUrl TEXT
    )
  ''');
  }

  Future<void> insertUrl(String savedUrl) async {
    final db = await database;
    await db.rawInsert('''
    INSERT OR REPLACE INTO url (savedUrl)
    VALUES (?)
  ''', [savedUrl]);
  }

  Future<bool> hasDataInUrlTable() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery('SELECT * FROM url');
    return results.isNotEmpty;
  }

  Future<String> getSavedUrl() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT savedUrl FROM url LIMIT 1');
    if (maps.isNotEmpty) {
      return maps[0]['savedUrl'] as String;
    } else {
      return EndPoints.liveUrl;
    }
  }

  Future<void> deleteAllSavedUrls() async {
    final db = await database;
    await db.rawDelete('DELETE FROM url');
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

  Future<int> getUsersNums() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps.length;
  }

  Future<void> activateUser(String email) async {
    final db = await database;
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

  Future<String> getActiveUserToken() async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'active = ?',
      whereArgs: [1], // 1 represents an active user
      columns: ['token'],
    );
    if(result.isEmpty){
      return '';
    }
    return result.first['token'].toString();
  }

  Future<String> getActiveUserName() async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'active = ?',
      whereArgs: [1], // 1 represents an active user
      columns: ['name'],
    );
    return result.first['name'].toString();
  }

  Future<String> getActiveMail() async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'active = ?',
      whereArgs: [1], // 1 represents an active user
      columns: ['email'],
    );
    return result.first['email'].toString();
  }

  Future<void> deleteAllActiveUsers() async {
    final db = await database;
    // Delete all users with active status set to true (1)
    await db.delete(
      'users',
      where: 'active = ?',
      whereArgs: [1], // 1 represents an active user
    );
    final remainingUsers = await db.query('users');
    if(remainingUsers.isNotEmpty){
      await db.update(
        'users',
        {'active': 1},
        where: 'email = ?',
        whereArgs: [remainingUsers.first['email']],
      );
    }
  }

  Future<void> deleteUserAndCheckLast(String email, bool isActive , BuildContext context) async {
    final db = await database;

    await db.delete(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    MessageWidget.showSnackBar('deletedAccountSuccessfully'.tr, AppColors.green);
    final remainingUsers = await db.query('users');
    if (isActive && remainingUsers.isNotEmpty) {
      // Make the first remaining user active
      await db.update(
        'users',
        {'active': 1},
        where: 'email = ?',
        whereArgs: [remainingUsers.first['email']],
      );
      final result = await db.query(
        'users',
        where: 'active = ?',
        whereArgs: [1], // 1 represents an active user
        columns: ['email'],
      );
      MessageWidget.showSnackBar('signedInPhase'.tr+result.first['email'].toString(), AppColors.green);
      moveToNextScreen(context, Routes.statisticRoutes);
    } else if(isActive && remainingUsers.isEmpty){
      moveToNextScreen(context, Routes.loginRoutes);
    }
  }

  moveToNextScreen(BuildContext context , String routes){
    if(routes == Routes.statisticRoutes){
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.statisticRoutes, (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.loginRoutes,arguments: LoginRoutesArguments(addOtherMail: false , isThereExistingUsers: false), (Route<dynamic> route) => false);
    }
  }

  Future<bool> hasAnyUsers() async {
    final db = await database;
    final usersCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM users'));
    return usersCount! > 0;
  }

  Future<bool> isEmailAlreadyAdded(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      columns: ['email'],
    );
    return result.isNotEmpty;
  }
}