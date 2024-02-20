import 'package:flutter/material.dart';
import 'package:mep/app/views/home/home_view.dart';
import 'package:mep/app/views/profile/profile_page.dart';
import 'package:mep/app/views/report/my_reports/my_reports_page.dart';

import 'package:flutter/material.dart';

class NavigationBarPage extends StatefulWidget {
  final Widget content;

  const NavigationBarPage({Key? key, required this.content}) : super(key: key);

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.content,
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
    const MyReportsPage(),
    const HomePage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
