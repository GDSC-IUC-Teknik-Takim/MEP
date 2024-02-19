import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mep/app/data/models/report_model.dart';
import '../report_detail/report_detail_page.dart';

class ReportCard extends StatelessWidget {
  final List<Report> reports;

  const ReportCard({
    Key? key,
    required this.reports,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReportDetailPage(report: report),
              ),
            );
            // Handle onTap as needed
          },
          child: Card(
            color: Colors.white, // Adjust color as needed
            child: Column(
              children: [
                // Displaying the first image from the list of base64-encoded images
                _buildImageFromBase64(report.imageBase64Strings.first),
                ListTile(
                  title: Text(report.reportTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.date_range),
                          Text(report.date),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_city),
                          Text(report.municipality),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.warning),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to build an image widget from a base64-encoded image string
  Widget _buildImageFromBase64(String base64String) {
    // Decode the base64 string to bytes
    final List<int> bytes = base64.decode(base64String);
    // Convert List<int> to Uint8List
    final Uint8List uint8List = Uint8List.fromList(bytes);
    // Create an image widget from the bytes
    return Image.memory(uint8List, fit: BoxFit.cover);
  }
}
