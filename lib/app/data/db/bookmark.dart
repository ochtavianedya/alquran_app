import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  DatabaseManager._private();

  static final DatabaseManager instance = DatabaseManager._private();
  Database? _db;

  Future<Database> get db async {
    _db ??= await _initDB();

    return _db!;
  }

  Future<Database> _initDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, 'bookmark.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE bookmark (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            surah TEXT NOT NULL,
            ayat INTEGER NOT NULL,
            juz INTEGER NOT NULL,
            via TEXT NOT NULL,
            index_ayat TEXT NOT NULL,
            last_read INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future closeDB() async {
    _db = await instance.db;
    _db!.close();
  }
}
