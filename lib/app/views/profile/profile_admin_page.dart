import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mep/app/core/constants/color_constant.dart';
import 'package:mep/app/core/enums/space.dart';
import 'package:mep/app/views/profile/profile_text_field.dart';
import '../home/home_view.dart';
import 'package:mep/app/views/auth/login/login_view.dart';
import '../report/my_reports/my_reports_page.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  State<AdminProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<AdminProfilePage> {
  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

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

  Widget _buildClearSharedPreferencesButton() {
  return IconButton(
    onPressed: () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    },
    icon: Icon(Icons.exit_to_app), // Exit icon
    tooltip: 'Logout',
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 90,
                backgroundImage: AssetImage('assets/images/corporate.png'),
              ),
              SizedBox(
                height: 20,
              ),
              SpaceHeight.xl.value,
              Column(
                children: [
                  Container(
                    height: 50,
                    width: 350,
                    child: ProfileTextField(
                      controller: _nameController,
                      label: 'Nickname',
                      isEditing: _isEditing,
                    ),
                  ),
                  SpaceHeight.l.value,
                  Container(
                    height: 50,
                    width: 350,
                    child: ProfileTextField(
                      controller: _emailController,
                      label: 'E-mail',
                      isEditing: _isEditing,
                    ),
                  ),
                  SpaceHeight.l.value,
                ],
              ),
              SpaceHeight.xl.value,
              SizedBox(
                height: 20,
              ),
              _buildClearSharedPreferencesButton(),
            ],
          ),
        ),
      ),
    );
  }
}
