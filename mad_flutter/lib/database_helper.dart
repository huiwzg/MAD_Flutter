import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

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
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        data TEXT NOT NULL
      )
    ''');
  }

  // Future<int> insertItem(String name) async {
  //   final db = await database;
  //   return await db.insert('sets', {'name': name});
  // }

  // Future<List<Map<String, dynamic>>> getItems() async {
  //   final db = await database;
  //   return await db.query('sets');
  // }

  Future<void> saveSet(String title, List<Map<String, String>> flashcards) async {
    final db = await database;
    final jsonString = jsonEncode(flashcards); // List<Map<String, String>>
    await db.insert('sets', {
      'name': title,
      'data': jsonString,
    });
  }

  Future<List<Map<String, String>>> getSet(String title) async {
    final db = await database;
    final result = await db.query('sets', where: 'name = ?', whereArgs: [title]);
    String jsonString = result.first['data'] as String;
    return jsonDecode(jsonString) as List<Map<String, String>>;
  }
}

