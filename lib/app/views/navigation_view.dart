
import 'package:flutter/material.dart';


void main() {
  runApp(Navigation());
}

class Navigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _pages[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
        items: [
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
        selectedItemColor: Color(0xFF325A3E), 
        unselectedItemColor: Colors.black, 
        onTap: _onItemTapped, 
      ),
    );
  }

  // Sayfaların listesi
  final List<Widget> _pages = [
    Container(color: Colors.white, child: Center(child: Text('Raporlar'))),
    Container(color: Colors.white, child: Center(child: Text('Ana Sayfa'))),
    Container(color: Colors.white, child: Center(child: Text('Profil'))),
  ];

  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

 
  }
}

