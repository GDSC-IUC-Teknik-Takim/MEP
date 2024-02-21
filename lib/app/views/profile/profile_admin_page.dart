import 'package:flutter/material.dart';
import 'package:mep/app/core/constants/color_constant.dart';
import 'package:mep/app/core/enums/space.dart';
import 'package:mep/app/views/home/admin_home_view.dart';
import 'package:mep/app/views/profile/profile_text_field.dart';
import 'package:mep/app/views/report/my_reports/my_reports_admin_page.dart';

import '../home/home_view.dart';
import '../report/my_reports/my_reports_page.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  int _selectedIndex = 2; // ProfilePage için index

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
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
                backgroundImage: AssetImage('assets/images/profile_image.png'),
              ),
              SizedBox(height: 20,),
              SpaceHeight.xl.value,
              Column(
                children: [
                  Container(
                    child:
                    ProfileTextField(
                      controller: _nameController,
                      label: 'Ad Soyad',
                      isEditing: _isEditing,
                    ),
                    height:50,
                    width: 350,
                  ),
                  SpaceHeight.l.value,
                  Container(
                    child:ProfileTextField(
                      controller: _emailController,
                      label: 'E-mail',
                      isEditing: _isEditing,
                    ), height: 50,
                    width: 350,),
                  SpaceHeight.l.value,
                  Container(
                    child:
                    ProfileTextField(
                      controller: _phoneController,
                      label: 'Telefon Numarası',
                      isEditing: _isEditing,
                    ),height: 50,
                    width: 350,),
                  SpaceHeight.l.value,
                  Container(
                    width: 350,
                    height: 50,
                    child:ProfileTextField(
                      controller: _aboutController,
                      label: 'Hakkında',
                      isEditing: _isEditing,
                    ),)
                ],
              ),
              SpaceHeight.xl.value,
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.buttonColor,
                    ),
                    child: Text(
                      _isEditing ? 'Düzenlemeyi Bitir' : 'Düzenle',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Örnek: saveProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.buttonColor,
                    ),
                    child: const Text(
                      'Kaydet',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
        MaterialPageRoute(builder: (context) => MyReportsAdminPage()),
      );
    } else if (index == 1) {
      // 'Home' sayfasına yönlendirme
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminHomePage()),
      );
    }
  }

}
