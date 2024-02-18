import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Core ekledik
import 'package:mep/app/views/auth/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    ),
  );
}
