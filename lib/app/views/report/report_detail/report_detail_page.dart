import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mep/app/core/enums/space.dart';
import 'package:mep/app/data/models/report_model.dart';
import 'package:mep/app/views/report/report_detail/buttons.dart';

class ReportDetailPage extends StatefulWidget {
  final Report report;

  const ReportDetailPage({Key? key, required this.report}) : super(key: key);

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  late Report _currentReport;

  @override
  void initState() {
    super.initState();
    _currentReport = widget.report;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentReport.reportTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Yenileme düğmesine basıldığında raporu yenile
              _refreshReport();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
  margin: EdgeInsets.all(15.0), // Her kenara 15 birimlik margin
  child: Container(
    height: 260,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0), // İstenen kenarlık yarıçapı
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12.0), // Aynı yarıçapı burada da belirtiyoruz
      child: _buildImageFromBase64(),
    ),
  ),
),
          SpaceHeight.l.value,
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Buttons(report: _currentReport),
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
                  "Details: ${_currentReport.reportDetail}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              SpaceHeight.l.value,
              Text(
                "Current Status: ${_currentReport.status}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _refreshReport() async {
    final String docId = _currentReport.id;

    // Firebase Firestore bağlantısını oluştur
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    // Belirtilen collection'daki belirli bir belgeyi al
    try {
      DocumentSnapshot snapshot =
          await firebaseFirestore.collection('report').doc(docId).get();

      // Eğer belge varsa, 'status' alanını alıp print et
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>
        if (data != null) {
          var status = data['status'];
          print('Status: $status');

          setState(() {
            _currentReport.status = status;
          });

          Fluttertoast.showToast(
            msg: "Updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xFF325A3E),
            textColor: Colors.white,
          );
        } else {
          print('Belgenin verisi null.');
        }
      } else {
        print('Belirtilen belge bulunamadı.');
      }
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  // Function to build an image widget from a base64-encoded image string
  Widget _buildImageFromBase64() {
    if (_currentReport.imageBase64Strings.isNotEmpty) {
      final String base64String = _currentReport.imageBase64Strings.first;
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
