import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contato.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'agenda.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contatos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            telefone TEXT,
            email TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<int> addContato(Contato contato) async {
    Database dbClient = await db;
    return await dbClient.insert('contatos', contato.toMap());
  }

  Future<int> updateContato(Contato contato) async {
    Database dbClient = await db;
    return await dbClient.update('contatos', contato.toMap(),
        where: 'id = ?', whereArgs: [contato.id]);
  }

  Future<int> deleteContato(int id) async {
    Database dbClient = await db;
    return await dbClient.delete('contatos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Contato>> getContatos() async {
    Database dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('contatos');
    return List.generate(maps.length, (i) {
      return Contato.fromMap(maps[i]);
    });
  }

  Future<int> register(User user) async {
    Database dbClient = await db;
    return await dbClient.insert('users', user.toMap());
  }

  Future<User?> login(String username, String password) async {
    Database dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
