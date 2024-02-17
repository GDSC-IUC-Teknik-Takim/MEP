import 'package:flutter/material.dart';
import 'package:mep/app/core/constants/color_constant.dart';
import 'package:mep/app/data/models/report_model.dart';
import 'package:mep/app/views/report/report_detail/report_detail_page.dart';

class ReportCard extends StatelessWidget {
  final Report report;

  const ReportCard({
    Key? key,
    required this.report,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReportDetailPage(
                    report: report,
                  )),
        );
      },
      child: Card(
        color: ColorConstant.backgroundColor,
        child: Column(
          children: [
            Image.network(
              report.imageUrl,
              fit: BoxFit.cover,
            ),
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
  }
}
