import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mep/app/core/enums/space.dart';
import 'package:mep/app/data/models/report_model.dart';
import 'package:mep/app/views/report/report_detail/admin_buttons.dart';
import 'package:mep/app/views/report/report_detail/buttons.dart';

class ReportDetailAdminPage extends StatefulWidget {
  final Report report;

  const ReportDetailAdminPage({Key? key, required this.report})
      : super(key: key);

  @override
  State<ReportDetailAdminPage> createState() => _ReportDetailAdminPageState();
}

class _ReportDetailAdminPageState extends State<ReportDetailAdminPage> {
  bool _isRefreshing = false;

  Future<void> _refreshPage() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate some data fetching process
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.report.reportTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshPage,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal:
                        15.0), // Sağ ve sol kenarlara 15 birimlik margin
                child: Container(
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        12.0), // İstenen kenarlık yarıçapı
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        12.0), // Aynı yarıçapı burada da belirtiyoruz
                    child: _buildImageFromBase64(),
                  ),
                ),
              ),
              SpaceHeight.l.value,
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AdminButtons(report: widget.report),
                  ],
                ),
              ),
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
        ),
      ),
    );
  }

  // Function to build an image widget from a base64-encoded image string
  Widget _buildImageFromBase64() {
    if (widget.report.imageBase64Strings.isNotEmpty) {
      final String base64String = widget.report.imageBase64Strings.first;
      final List<int> bytes = base64.decode(base64String);
      final Uint8List uint8List =
          Uint8List.fromList(bytes); // Convert List<int> to Uint8List
      return Image.memory(uint8List, fit: BoxFit.cover);
    } else {
      // Return a placeholder widget if no images are available
      return Placeholder();
    }
  }
}
