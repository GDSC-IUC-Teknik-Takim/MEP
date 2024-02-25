import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mep/app/views/report/my_reports/report_card.dart';
import '../../../data/models/report_model.dart';
import '../../home/home_view.dart';
import '../../profile/profile_page.dart';

class MyReportsPage extends StatelessWidget {
  const MyReportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyReports(),
    );
  }
}

class MyReports extends StatefulWidget {
  const MyReports({Key? key}) : super(key: key);

  @override
  _MyReportsState createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {
  final Stream<QuerySnapshot> _reportsStream = FirebaseFirestore.instance.collection('report').snapshots();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: _reportsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<QueryDocumentSnapshot> documents = snapshot.data!.docs.toList();
            final List<ReportData> reportDataList = documents.map((doc) => ReportData.fromDocument(doc)).toList();
            final List<Report> reports = reportDataList.map((reportData) => Report.fromJson(reportData.id, reportData.data)).toList();

            if (reports.isEmpty) {
              return Center(child: Text('No reports available.'));
            } else {
              return ReportCard(reports: reports);
            }
          }
        },
      ),
    );
  }
}

class ReportData {
  final String id;
  final Map<String, dynamic> data;

  ReportData({required this.id, required this.data});

  factory ReportData.fromDocument(DocumentSnapshot doc) {
    return ReportData(
      id: doc.id,
      data: doc.data() as Map<String, dynamic>,
    );
  }
}
