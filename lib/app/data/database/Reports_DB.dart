import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mep/app/data/models/report_model.dart';
import 'package:mep/app/data/database/database_service.dart';

class ReportsDB {
  final String tableName = 'reports';

  Future<void> createTable(Database database) async {
    await database.execute('''CREATE TABLE IF NOT EXISTS $tableName(
    id INTEGER PRIMARY KEY,
    reportTitle TEXT NOT NULL,
    imageUrl TEXT,
    status TEXT NOT NULL,
    reportDetail TEXT NOT NULL,
    reportType TEXT NOT NULL,
    municipality TEXT NOT NULL,
    date TEXT NOT NULL
  )''');
  }


  Future<int> createReport(Report report) async {
    final database = await DatabaseService().database;
    return await database.insert(tableName, report.toMap());
  }

  Future<List<Report>> fetchAllReports() async {
    final database = await DatabaseService().database;
    final reports = await database.query(tableName);
    return reports.map((map) => Report.fromMap(map)).toList();
  }
}
