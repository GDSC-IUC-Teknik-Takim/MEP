import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mep/app/data/database/Reports_DB.dart';

class DatabaseService
{
  Database? _database;
  Future<Database> get database async
  {
    if (_database != null)
    {
      return _database!;
    }

    _database = await _initialize();
    return _database!;
  }
  Future<String> get fullpath async{
    const name= 'reports.db';
    final path = await getDatabasesPath();
    return join(path,name);
  }
  Future<Database>_initialize() async
  {
    final path = await fullpath;
    var database = await openDatabase(
      path,
    version: 1,
    onCreate: create,
    singleInstance: true,);
    return database;
  }
  Future<void> create (Database database, int version) async =>
      await ReportsDB().createTable(database);

}