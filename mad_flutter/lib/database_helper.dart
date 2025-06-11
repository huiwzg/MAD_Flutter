import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  Map<int, String> migrationScripts = {
    1: ';',
    2: 'ALTER TABLE sets ADD COLUMN lastAccessed TEXT;',
  };

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'demo.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        for (int i = oldVersion; i < newVersion; i++) {
          final migrationScript = migrationScripts[i+1];
          if (migrationScript != null) {
            await db.execute(migrationScript);
          }
        }
      }
    );
  }

  Future _onCreate(Database db, int version) async {
    Logger().i('DATABASE: Creating database...');
    await db.execute('''
      CREATE TABLE sets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        data TEXT NOT NULL,
        lastAccessed INTEGER
      )
    ''');
  }

  // Future<int> insertItem(String name) async {
  //   final db = await database;
  //   return await db.insert('sets', {'name': name});
  // }

  // Future<List<Map<String, dynamic>>> getAllSets() async {
  //   final db = await database;
  //   return await db.query('sets');
  // }

  Future<List<Map<String, String>>> getSummary() async {
    final db = await database;
    final result = await db.query('sets', columns: ['id', 'name']);
    return result
      .map((map) => map.map((key, value) => MapEntry(key, value?.toString() ?? '')))
      .toList();
  }

  Future<void> saveSet(String title, List<Map<String, String>> flashcards) async {
    final db = await database;
    final jsonString = jsonEncode(flashcards); // List<Map<String, String>>
    String id = await db.insert('sets', {
      'name': title,
      'data': jsonString,
    }).toString();

    touchSet(id);
  }

  Future<Map<String, String>> getSet(String id) async {
    final db = await database;
    final result = await db.query('sets', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      print("DATABASE: raw json: ${result.first['data']}");
      var combined = {"name": result.first['name'].toString(), "data": result.first['data'].toString()};
      touchSet(id);
      return combined;
    } else {
      throw Exception('No data found for the given ID');
    }
  }

  Future<void> deleteSet(String id) async {
    final db = await database;
    await db.delete('sets', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateSet(String id, String name, String data) async {
    final db = await database;
    await db.update(
      'sets',
      {'name': name, 'data': data},
      where: 'id = ?',
      whereArgs: [id],
    );
    touchSet(id);
  }

  Future<List<Map<String, String>>> getRecents(int limit) async {
    final db = await database;

    final result = await db.query('sets', columns: ['id', 'name'], orderBy: 'lastAccessed DESC', limit: limit);
    // cast <String, Object> maps to <String, String>
    return result
      .map((map) => map.map((key, value) => MapEntry(key, value?.toString() ?? '')))
      .toList();
  }

  Future<void> touchSet(String id) async {
    final db = await database;
    await db.update(
      'sets',
      {'lastAccessed': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

