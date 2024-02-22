import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mep/app/views/auth/login/login_view.dart';
import 'package:mep/app/views/auth/register/register_view.dart';
import 'package:mep/app/views/home/admin_home_view.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // 3 saniye sonra ana ekrana yönlendirme işlemini gerçekleştir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/meplogo2.png'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
