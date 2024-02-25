import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Core ekledik
import 'package:mep/app/views/home/admin_home_view.dart';
import 'package:shared_preferences/shared_preferences.dart'; // shared_preferences ekledik
import 'package:mep/app/views/auth/splash/splash_page.dart';
import 'package:mep/app/views/home/home_view.dart';
import 'package:mep/app/views/home/navigation_bar/admin_navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId'); // shared preferences'tan userId'i al
  String fullName = prefs.getString('fullName') ?? '';

  final List<String> municipalities = ['Kadıköy', 'Avcılar', 'Küçükçekmece','Select Municipality'];
  if(municipalities.contains(fullName)){
    Widget homePage = userId != null ? NavigationBarPage_admin() : SplashPage();
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: homePage,
      ),
    );
  }
  else
  {
    Widget homePage = userId != null ? HomePage() : SplashPage();
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: homePage,
      ),
    );
  }



}
