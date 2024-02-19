class Report {
  final int? id;
  final String reportTitle;
  final List<String> imageBase64Strings; // New field to store base64-encoded image strings
  final String status;
  final String reportDetail;
  final String reportType;
  final String municipality;
  final String date;

  Report({
    this.id,
    required this.reportTitle,
    required this.imageBase64Strings,
    required this.status,
    required this.reportDetail,
    required this.reportType,
    required this.municipality,
    required this.date,
  });

  static Report fromJson(Map<String, dynamic> json) {
    // Convert image base64 strings from dynamic to List<String>
    List<String> imageBase64Strings = [];
    if (json['imageBase64Strings'] != null) {
      for (var imageBase64String in json['imageBase64Strings']) {
        imageBase64Strings.add(imageBase64String as String);
      }
    }

    return Report(
      reportTitle: json['reportTitle'] ?? '',
      imageBase64Strings: List<String>.from(json['imageBase64Strings'] ?? []),      status: json['status'] ?? '',
      reportDetail: json['reportDetail'] ?? '',
      reportType: json['reportType'] ?? '',
      municipality: json['municipality'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
