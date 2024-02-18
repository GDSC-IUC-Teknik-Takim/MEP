import 'package:flutter/material.dart';
import 'package:mep/app/data/models/report_model.dart';
import 'package:mep/app/data/database/Reports_DB.dart';
import 'package:mep/app/views/report/my_reports/report_card.dart';

class MyReportsPage extends StatefulWidget {
  const MyReportsPage({Key? key}) : super(key: key);

  @override
  _MyReportsPageState createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  late Future<List<Report>> futureReports;

  @override
  void initState() {
    super.initState();
    futureReports = ReportsDB().fetchAllReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Reports")),
      body: FutureBuilder<List<Report>>(
        future: futureReports,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Report>? reports = snapshot.data;
            return ListView.builder(
              itemCount: reports!.length,
              itemBuilder: (context, index) {
                return ReportCard(report: reports[index]);
              },
            );
          }
        },
      ),
    );
  }
}
