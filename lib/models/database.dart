import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as pth;
import 'package:tasks/models/task.dart';

import '../app_constants/app_constant.dart';

class DatabaseRepository{
  static Database? _database;

  static initDB() async{
    if(_database != null) return;

    final dbPath = await getDatabasesPath();
    final path = pth.join(dbPath, 'tasks.db');

    _database = await openDatabase(path, version: 1, onCreate: _createDB);
  }
  static Future _createDB(Database db, int version) async{
    await db.execute("""
      CREATE TABLE ${AppConstant.tableName} (
        ${AppConstant.id} TEXT PRIMARY KEY,
        ${AppConstant.title} TEXT NOT NULL,
        ${AppConstant.description} TEXT,
        ${AppConstant.isPinned} BOOLEAN NOT NULL,
        ${AppConstant.status} STRING NOT NULL,
        ${AppConstant.createdOn} STRING NOT NULL,
        ${AppConstant.expiresOn} STRING
      )
      """);
  }

  static Future query() async{
    final results = await _database!.query(AppConstant.tableName);

    return results.map((e) => Task.fromJson(e)).toList(); 
  }
  static Future insert(Task task) async{
    await _database!.insert(AppConstant.tableName, task.toMap());
  }
  static Future delete(String taskId) async{
    await _database!.delete(AppConstant.tableName, where: "id=?", whereArgs: [taskId]);
  }
  static Future update(Task task) async{
    await _database!.update(
      AppConstant.tableName,
      task.toMap(),
      where: 'id=?',
      whereArgs: [task.id]
    );
  }
}
