import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mep/app/views/report/my_reports/report_card.dart';
import '../../../data/models/report_model.dart';

class MyReportsPage extends StatelessWidget {
  final String userId; // Assuming you have a way to get the current user's ID

  const MyReportsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Reports"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('report')
            .where('senderId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            final List<Report> reports = documents.map((doc) {
              final String id = doc.id; // Get the document ID
              final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return Report.fromJson(id, data); // Pass the ID to your Report.fromJson constructor
            }).toList();

            if (reports.isEmpty) {
              return Center(child: Text('No reports available.'));
            } else {
              return ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return ListTile(
                    title: Text(report.reportTitle),
                    // Add other report details as needed
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
