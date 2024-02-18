import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:mep/app/data/database/database_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mep/app/data/database/Reports_DB.dart';

class Report {
  final int? id;
  final String reportTitle;
  final String imageUrl;
  final String status;
  final String reportDetail;
  final String reportType;
  final String municipality;
  final String date;

  Report({
    this.id,
    required this.reportTitle,
    required this.imageUrl,
    required this.status,
    required this.reportDetail,
    required this.reportType,
    required this.municipality,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reportTitle': reportTitle,
      'imageUrl': imageUrl,
      'status': status,
      'reportDetail': reportDetail,
      'reportType': reportType,
      'municipality': municipality,
      'date': date,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'],
      reportTitle: map['reportTitle'],
      imageUrl: map['imageUrl'],
      status: map['status'],
      reportDetail: map['reportDetail'],
      reportType: map['reportType'],
      municipality: map['municipality'],
      date: map['date'],
    );
  }
}

