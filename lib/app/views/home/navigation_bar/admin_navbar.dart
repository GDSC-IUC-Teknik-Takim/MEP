import 'package:flutter/material.dart';
import 'package:mep/app/views/home/home_view.dart';
import 'package:mep/app/views/home/maps.dart';
import 'package:mep/app/views/profile/profile_page.dart';
import 'package:mep/app/views/profile/profile_admin_page.dart';
import 'package:mep/app/views/report/my_reports/my_reports_page.dart';
import 'package:mep/app/views/report/my_reports/my_reports_admin_page.dart';
import 'package:mep/app/views/report/create_report/create_report_view.dart';
import 'package:mep/app/views/home/admin_home_view.dart';

class NavigationBarPage_admin extends StatefulWidget {
  const NavigationBarPage_admin({Key? key}) : super(key: key);

  @override
  State<NavigationBarPage_admin> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage_admin> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _selectedIndex == 0
            ? const Text("Reports sent to you")
            : _selectedIndex == 1
            ? const Text("Home")
            : const Text("Profile"),
      ),
      body: _pages[_selectedIndex],
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

  final List<Widget> _pages = [
    const MyReportsAdminPage(),
    const AdminHomePage(),
    const AdminProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
