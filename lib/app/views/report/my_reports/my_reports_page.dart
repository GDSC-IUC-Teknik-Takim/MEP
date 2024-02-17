import 'package:flutter/material.dart';
import 'package:mep/app/data/models/report_model.dart';
import 'package:mep/app/views/report/my_reports/report_card.dart';

class MyReportsPage extends StatefulWidget {
  const MyReportsPage({super.key});

  @override
  State<MyReportsPage> createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {

   List<Report> reports = [
    Report(
        imageUrl:
            "https://sifiratik.co/wp-content/uploads/2018/07/kapak-10.jpg",
        reportTitle: "Su Kirliliği",
        reportDetail:
            "Deepwater Horizon oil spill dumped over 200 million gallons of crude oil into the Gulf of Mexico, causing extensive harm to marine life and coastal ecosystems.",
        reportType: "Su Kirliliği",
        municipality: "Avcılar",
        date: "15.02.24",
        status: 'beklemede'),
    Report(
        imageUrl:
            "https://im.haberturk.com/l/2020/07/31/ver1596173589/2760348/jpg/640x360",
        reportTitle: "Su Kirliliği",
        reportDetail:
            "Deepwater Horizon oil spill dumped over 200 million gallons of crude oil into the Gulf of Mexico, causing extensive harm to marine life and coastal ecosystems.",
        reportType: "Su Kirliliği",
        municipality: "Avcılar",
        date: "15.02.24",
        status: 'beklemede'),
    Report(
        imageUrl:
            "https://sifiratik.co/wp-content/uploads/2018/07/kapak-10.jpg",
        reportTitle: "Su Kirliliği",
        reportDetail:
            "Deepwater Horizon oil spill dumped over 200 million gallons of crude oil into the Gulf of Mexico, causing extensive harm to marine life and coastal ecosystems.",
        reportType: "Su Kirliliği",
        municipality: "Avcılar",
        date: "15.02.24",
        status: 'beklemede'),
    Report(
        imageUrl:
            "https://sifiratik.co/wp-content/uploads/2018/07/kapak-10.jpg",
        reportTitle: "Su Kirliliği",
        reportDetail:
            "Deepwater Horizon oil spill dumped over 200 million gallons of crude oil into the Gulf of Mexico, causing extensive harm to marine life and coastal ecosystems.",
        reportType: "Su Kirliliği",
        municipality: "Avcılar",
        date: "15.02.24",
        status: 'beklemede'),
    // Diğer ihbarlar buraya eklenebilir
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("My Reports")),
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          return ReportCard(report: reports[index]);
        },
      ),
    );
  }
}
