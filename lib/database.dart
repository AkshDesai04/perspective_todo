import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS my_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER
      )
    ''');
  }

  Future<int> insertData(String name, int age) async {
    final db = await instance.database;
    final data = {
      'name': name,
      'age': age,
    };

    return await db.insert('my_table', data);
  }

  Future<List<Map<String, dynamic>>> selectData() async {
    final db = await instance.database;
    return await db.query('my_table');
  }

  Future<int> deleteData(int id) async {
    final db = await instance.database;
    return await db.delete('my_table', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateData(int id, String name, int age) async {
    final db = await instance.database;
    final data = {
      'name': name,
      'age': age,
    };

    return await db.update('my_table', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> printAllData() async {
    final db = await instance.database;
    final data = await db.query('my_table');
    print(data);
  }
}
