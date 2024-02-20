/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mep/app/views/report/my_reports/report_card.dart';

import '../../../data/models/report_model.dart';
class MyReportsPageAdmin extends StatelessWidget {
  ///String UserId; //belediyenin kendi idsi
  final String municipalityId; // raporda şikayet edilen belediyenin idsi

  const MyReportsPageAdmin({Key? key, required this.municipalityId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Reports"),
      ),
      body: StreamBuilder<List<Report>>(
        stream: FirebaseFirestore.instance
            .collection('report')
            .where('MunicipalityId', isEqualTo: "a"/*UserId*/) // Filter reports by şikayetid
            .snapshots()
            .map((snapshot) => snapshot.docs
            .map((doc) => Report.fromJson(doc.data()))
            .toList()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Report> reports = snapshot.data ?? [];
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

 */