import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user_account.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();
  static Database? _database;

  UserDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user_accounts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<UserAccount> create(UserAccount account) async {
    final db = await instance.database;
    final id = await db.insert('accounts', account.toMap());
    return account.copyWith(id: id);
  }

  Future<UserAccount?> readAccount(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'accounts',
      columns: ['id', 'username', 'email', 'password'],
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return UserAccount.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<UserAccount>> readAllAccounts() async {
    final db = await instance.database;
    final result = await db.query('accounts');
    return result.map((json) => UserAccount.fromMap(json)).toList();
  }

  Future<int> update(UserAccount account) async {
    final db = await instance.database;
    return db.update(
      'accounts',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'accounts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
