import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "GameData.db";
  static const _databaseVersion = 1;

  static const table = 'endless_game_data';

  static const columnId = '_id';
  static const columnName = 'name';
  static const columnScore = 'score';
  static const columnGameMode = 'gameMode';
  static const columnTimeElapsed = 'timeElapsed';

  // Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnScore INTEGER NOT NULL,
            $columnGameMode TEXT NOT NULL,
            $columnTimeElapsed TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<int> update(int id, Map<String, dynamic> row) async {
    Database db = await instance.database;

    return await db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }


  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryRowsByGameMode(String selectedMode) async {
    Database db = await instance.database;
    return await db.query(
      table,
      where: 'gameMode = ?',
      whereArgs: [selectedMode],
    );
  }


  Future<int?> queryHighestScore(String gameMode) async {
    Database db = await instance.database;

    final result = await db.query(
      table,
      columns: ['MAX($columnScore) as highest_score'],
      where: '$columnGameMode = ?',
      whereArgs: [gameMode],
    );

    if (result.isNotEmpty) {
      return result.first['highest_score'] as int?;
    }
    return null;
  }

}