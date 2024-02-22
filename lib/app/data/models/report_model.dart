import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String id;
  final String reportTitle;
  final List<String> imageBase64Strings;
  final String status;
  final String reportDetail;
  final String reportType;
  final String municipality;
  final String date;
  final double latitude;
  final double longitude;

  Report({
    required this.id,
    required this.reportTitle,
    required this.imageBase64Strings,
    required this.status,
    required this.reportDetail,
    required this.reportType,
    required this.municipality,
    required this.date,
    required this.latitude,
    required this.longitude,
  });

  static Report fromJson(String id, Map<String, dynamic> json) {
    List<String> imageBase64Strings = [];
    if (json['imageBase64Strings'] != null) {
      for (var imageBase64String in json['imageBase64Strings']) {
        imageBase64Strings.add(imageBase64String as String);
      }
    }

    return Report(
      id: id,
      reportTitle: json['reportTitle'] ?? '',
      imageBase64Strings: List<String>.from(json['imageBase64Strings'] ?? []),
      status: json['status'] ?? '',
      reportDetail: json['reportDetail'] ?? '',
      reportType: json['reportType'] ?? '',
      municipality: json['municipality'] ?? '',
      date: json['date'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
    );
  }

  static Report fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Report.fromJson(snapshot.id, data);
  }
}
