import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mep/app/core/constants/color_constant.dart';
import 'package:mep/app/core/enums/space.dart';
import 'package:mep/app/views/profile/profile_text_field.dart';
import '../home/home_view.dart';
import 'package:mep/app/views/auth/login/login_view.dart';
import '../report/my_reports/my_reports_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  int _selectedIndex = 2; // ProfilePage için index

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _saveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullname', _nameController.text);
    await prefs.setString('email', _emailController.text);
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('fullName') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.clear();

              // Veriler temizlendikten sonra login sayfasına yönlendirme işlemi
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 90,
                backgroundImage: AssetImage('assets/images/glogo2.png'),
              ),
              SizedBox(
                height: 20,
              ),
              SpaceHeight.xl.value,
              Column(
                children: [
                  Container(
                    child: ProfileTextField(
                      controller: _nameController,
                      label: 'Nickname',
                      isEditing: _isEditing,
                    ),
                    height: 50,
                    width: 350,
                  ),
                  SpaceHeight.l.value,
                  Container(
                    child: ProfileTextField(
                      controller: _emailController,
                      label: 'E-mail',
                      isEditing: _isEditing,
                    ),
                    height: 50,
                    width: 350,
                  ),
                  SpaceHeight.l.value,
                  
                  SpaceHeight.l.value,
                 
                ],
              ),
              SpaceHeight.xl.value,
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                
       
                ],
              ),
            ],
          ),
        ),
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
      // 'Reports' sayfasına yönlendirme
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyReportsPage()),
      );
    } else if (index == 1) {
      // 'Home' sayfasına yönlendirme
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }
}
