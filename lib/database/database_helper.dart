import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "GameData.db";
  static final _databaseVersion = 1;

  static final table = 'endless_game_data';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnScore = 'score';
  static final columnGameMode = 'gameMode';
  static final columnTimeElapsed = 'timeElapsed';

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

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
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