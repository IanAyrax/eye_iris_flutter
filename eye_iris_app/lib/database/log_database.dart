import 'package:sqflite/sqflite.dart';
import 'package:eye_iris_app/models/log.dart';

class LogDatabase{
  static final LogDatabase instance = LogDatabase._init();

  static Database? _database;

  LogDatabase._init();

  Future<Database> get database async{
    if(_database != null) return _database!;

    _database = await _initDB('log.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    //final path = join(dbPath, filePath);
    final path = dbPath + filePath;

    return await openDatabase(path, version: 1, onCreate:  _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATED TABLE $tableLog (
        ${LogFields.id} $idType,
        ${LogFields.result} $textType,
        ${LogFields.imagePath} $textType,
        ${LogFields.time} $textType
      )
    ''');
  }

  Future<Log> create(Log log) async{
    final db = await instance.database;

    final id = await db.insert(tableLog, log.toJson());
    return log.copy(id: id);
  }

  Future<Log> read(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableLog,
      columns: LogFields.values,
      where: '${LogFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty){
      return Log.fromJson(maps.first);
    } else{
      throw Exception('ID $id not found');
    }
  }

  Future<List<Log>> readAll(int id) async {
    final db = await instance.database;

    final orderBy = '${LogFields.time} ASC';
    final maps = await db.query(tableLog, orderBy: orderBy);

    return maps.map((json) => Log.fromJson(json)).toList();
  }

  Future<int> update(Log log) async{
    final db = await instance.database;

    return db.update(
        tableLog,
        log.toJson(),
        where: '${LogFields.id} = ?',
        whereArgs: [log.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableLog,
      where: '${LogFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}