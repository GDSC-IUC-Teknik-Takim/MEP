import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Core ekledik
import 'package:shared_preferences/shared_preferences.dart'; // shared_preferences ekledik
import 'package:mep/app/views/auth/splash/splash_page.dart';
import 'package:mep/app/views/home/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId'); // shared preferences'tan userId'i al

  Widget homePage = userId != null ? HomePage() : SplashPage();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homePage,
    ),
  );
}
