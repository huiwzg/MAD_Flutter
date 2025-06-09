import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';

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
    Logger().i('DATABASE: Creating database...');
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

  // Future<List<Map<String, dynamic>>> getAllSets() async {
  //   final db = await database;
  //   return await db.query('sets');
  // }

  Future<List<Map<String, dynamic>>> getSummary() async {
    final db = await database;
    return await db.query('sets', columns: ['id', 'name']);
  }

  Future<List<String>>

  Future<void> saveSet(String title, List<Map<String, String>> flashcards) async {
    final db = await database;
    final jsonString = jsonEncode(flashcards); // List<Map<String, String>>
    await db.insert('sets', {
      'name': title,
      'data': jsonString,
    });
  }

  Future<Map<String, String>> getSet(String id) async {
    final db = await database;
    final result = await db.query('sets', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      print("DATABASE: raw json: ${result.first['data']}");
      var combined = {"name": result.first['name'].toString(), "data": result.first['data'].toString()};
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
  }
}

