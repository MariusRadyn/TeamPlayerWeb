import 'dart:io';
import 'package:teamplayerwebapp/utils/global_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void dbDeleteDatabase() async {
  Directory directory = await getApplicationDocumentsDirectory();
  String dbPath = join(directory.path, DB_LOCAL);
  deleteDatabase(dbPath);
  print('LOCAL DATABASE DELETED!!!');
}

Future<void> dbInsert(String table, var data) async {
  final Database db = await SQLHelper().database;

  await db.insert(
    table,
    data.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  print(data.toString());
}

// Read all items
Future<List<Map<String, dynamic>>> dbReadTable(String table) async {
  final Database db = await SQLHelper().database;
  return db.query(table, orderBy: "id");
}

// Read a single item by id
Future<List<Map<String, dynamic>>> dbGetItemById(int id) async {
  final db = await SQLHelper().database;
  return db.query(DB_TABLE_SONGS_LIB,
    where: "id = ?",
    whereArgs: [id],
    limit: 1);
}

// Delete
Future<void> dbDeleteItem(String table, int id) async {
  final db = await SQLHelper().database;
  try {
    await db.delete(
      table,
      where: "id = ?",
      whereArgs: [id]);
  }
  catch (err) {
      print("ERROR Deleting Database item: $err");
  }
}
// Songs Library DB
class SQLHelper {
  // Make it a Singleton Class
  SQLHelper._();
  static final SQLHelper _instance = SQLHelper._();

  factory SQLHelper() {
    return _instance;
  }

  Future<Database> get database async{
  return await init();
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, DB_LOCAL);

    Future<Database> database = openDatabase(dbPath, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    print('Opened DB: $dbPath');
    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
    CREATE TABLE $DB_TABLE_SONGS_LIB(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      songName TEXT,
      author TEXT,
      genre TEXT,
      dateCreated TEXT,
      dateModified TEXT,
      dateLastViewed TEXT,
      isActive INTEGER)
    ''');

    db.execute('''
    CREATE TABLE $DB_TABLE_PLAYLIST_ITEMS(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      songName TEXT,
      author TEXT,
      genre TEXT)
    ''');

    db.execute('''
    CREATE TABLE $DB_TABLE_PLAYLIST_LIB(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      description TEXT,
      dateCreated TEXT,
      dateModified TEXT,
      nrOfItems INTEGER)
    ''');

    print("Table created: $DB_TABLE_SONGS_LIB, $DB_TABLE_PLAYLIST_LIB, $DB_TABLE_PLAYLIST_ITEMS");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }
  // Update an item by id
  static Future<int> updateItem(int id, String songName, String author) async {
    final db = await SQLHelper().database;

    final data = {
      'songName': songName,
      'author': author,
      'dateModified': DateTime.now().toString()
    };

    final result =
    await db.update(
        DB_TABLE_SONGS_LIB,
        data,
        where: "id = ?",
        whereArgs: [id]);
    return result;
  }
}

