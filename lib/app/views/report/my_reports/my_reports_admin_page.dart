import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mep/app/views/home/admin_home_view.dart';
import 'package:mep/app/views/report/my_reports/admin_report_card.dart';
import 'package:mep/app/views/report/my_reports/report_card.dart';
import '../../../data/models/report_model.dart';

import '../../profile/profile_admin_page.dart';


class MyReportsAdminPage extends StatefulWidget {
  const MyReportsAdminPage({Key? key}) : super(key: key);

  @override
  _MyReportsAdminPageState createState() => _MyReportsAdminPageState();
}

class _MyReportsAdminPageState extends State<MyReportsAdminPage> {
  int _selectedIndex = 0;
  String _userName = ''; // Initialize with a default value

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch user's full name from Firestore based on their UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['name']; // Update _userName with fetched value
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // Geri butonunu kaldırır
        title: Center(
          child: Text("Reports sent to you"),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Üç nokta butonuna tıklandığında yapılacak işlemler
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('report').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<QueryDocumentSnapshot> documents = snapshot.data!.docs.toList();
            final List<ReportData> reportDataList = documents.map((doc) {
              final String id = doc.id; // Get the document ID
              final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return ReportData(id: id, data: data); // Create a custom object containing ID and data
            }).toList();

            List<Report> reports = reportDataList.map((reportData) {
              // Convert the custom object to a Report object
              return Report.fromJson(reportData.id, reportData.data);
            }).toList();

            // Filter reports based on municipality field matching user's name
            reports = reports.where((report) => report.municipality == _userName).toList();

            if (reports.isEmpty) {
              return Center(child: Text('No reports available.'));
            } else {
              return AdminReportCard(reports: reports);
            }
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF325A3E),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // 'Reports' sayfasına yönlendirme yapılabilir (şu anda 'MyReportsPage' zaten aktif olduğundan bir şey yapmaya gerek yok)
    } else if (index == 1) {
      // 'Home' sayfasına yönlendirme yapılabilir
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminHomePage()),
      );
    } else if (index == 2) {
      // 'Profile' sayfasına yönlendirme yapılabilir
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminProfilePage()),
      );
    }
  }
}

class ReportData {
  final String id;
  final Map<String, dynamic> data;

  ReportData({required this.id, required this.data});
}
