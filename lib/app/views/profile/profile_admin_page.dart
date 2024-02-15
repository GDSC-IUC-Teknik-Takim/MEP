import 'package:flutter/material.dart';
import 'package:mep/app/core/constants/color_constant.dart';
import 'package:mep/app/core/enums/space.dart';
import 'package:mep/app/views/profile/profile_text_field.dart';

class ProfileAdminPage extends StatefulWidget {
  const ProfileAdminPage({super.key});

  @override
  State<ProfileAdminPage> createState() => _ProfileAdminPageState();
}

class _ProfileAdminPageState extends State<ProfileAdminPage> {
  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

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
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/profile_admin_image.png'),
              ),
              SpaceHeight.xl.value,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/images/cup_star.png"),
                  Image.asset("assets/images/cup_star.png"),
                  Image.asset("assets/images/cup_star.png"),
                ],
              ),
              SpaceHeight.xl.value,
              ProfileTextField(
                controller: _nameController,
                label: 'Belediye İsmi',
                isEditing: _isEditing,
              ),
              SpaceHeight.l.value,
              ProfileTextField(
                controller: _emailController,
                label: 'E-mail',
                isEditing: _isEditing,
              ),
              SpaceHeight.l.value,
              ProfileTextField(
                controller: _phoneController,
                label: 'Telefon Numarası',
                isEditing: _isEditing,
              ),
              SpaceHeight.l.value,
              ProfileTextField(
                controller: _aboutController,
                label: 'Hakkında',
                isEditing: _isEditing,
              ),
              SpaceHeight.xl.value,
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
    );
  }
}
