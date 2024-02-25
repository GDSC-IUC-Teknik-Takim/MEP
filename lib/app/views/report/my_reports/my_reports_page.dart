import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mep/app/views/report/my_reports/report_card.dart';
import 'package:mep/app/data/models/report_model.dart'; // Report modelini buradan al

class MyReportsPage extends StatelessWidget {
  const MyReportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const MyReports(),
    );
  }
}

class MyReports extends StatefulWidget {
  const MyReports({Key? key}) : super(key: key);

  @override
  _MyReportsState createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {
  final Stream<QuerySnapshot> _reportsStream =
  FirebaseFirestore.instance.collection('report').snapshots();

  List<Report> _buildReportsList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Report.fromJson(doc.id, data); // Report modelini kullan
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: _reportsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final reports = _buildReportsList(snapshot.data!);
            return reports.isEmpty
                ? const Center(child: Text('No reports available.'))
                : ReportCard(reports: reports); // Report listesini gönder
          } else {
            return const Center(child: Text('Something went wrong.'));
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
