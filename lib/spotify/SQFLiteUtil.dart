import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQFLiteUtil {
  static SQFLiteUtil _instance;
  static Database _db;

  SQFLiteUtil._();

  static Future<SQFLiteUtil> get instance async {
    return await getInstance();
  }

  static Future<SQFLiteUtil> getInstance() async {
    if (_instance == null) {
      _instance = SQFLiteUtil._();
    }
    if (_db == null) {
      await _instance._initDB();
    }

    return _instance;
  }

  Future _initDB() async {
    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, "freemusic.db");
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int newVersion) async {
    await db.transaction((txn) async {
      await txn.execute('''
        CREATE TABLE IF NOT EXISTS `gedan` (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          gd_name TEXT,
          picture TEXT,
          description TEXT,
          created TEXT
        );
      ''');
      await txn.execute('''
        CREATE TABLE IF NOT EXISTS `song` (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          hash TEXT,
          songid INTEGER,
          albummid TEXT,
          playUrl TEXT,
          img TEXT,
          timeLength INTEGER,
          singerName TEXT,
          songName TEXT,
          type TEXT,
          platform TEXT
        );
      ''');
      await txn.execute('''
        CREATE TABLE IF NOT EXISTS `gedan_song` (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          gd_id INTEGER,
          song_hash TEXT
        );
      ''');
    });
  }

  Database open() {
    return _db;
  }

}