import 'package:flutter/material.dart';
import 'package:mep/app/core/enums/space.dart';
import 'package:mep/app/data/models/report_model.dart';
import 'package:mep/app/views/report/report_detail/buttons.dart';

class ReportDetailAdminPage extends StatefulWidget {
  final Report report;

  const ReportDetailAdminPage({super.key, required this.report});

  @override
  State<ReportDetailAdminPage> createState() => _ReportDetailAdminPageState();
}

class _ReportDetailAdminPageState extends State<ReportDetailAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.report.reportTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            width: 330,
            height: 260,
            child: Image.network(
              widget.report.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SpaceHeight.l.value,
          const Buttons(),
          SpaceHeight.l.value,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Details: ${widget.report.reportDetail}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              SpaceHeight.l.value,
              Text(
                "Current Status: ${widget.report.status}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
