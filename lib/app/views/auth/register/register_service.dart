import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mep/app/views/home/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp(BuildContext context, {required String name, required String email, required String password}) async {
  final navigator = Navigator.of(context);
  try {
    final UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null )  {
      // Auth ile kullanıcı oluşturulduktan sonra user id'sini alıyoruz.
      String userId = userCredential.user!.uid;
      
      // Oluşturulan kullanıcı için Firestore'a kayıt yapılıyor.
      await _registerUser(userId: userId, name: name, email: email, password: password);
    }
  } on FirebaseAuthException catch (e) {
    // Hata durumunda buraya düşebilirsiniz.
    // Hata işlemlerini burada yapabilirsiniz.
  }
}

  Future<void> signIn(BuildContext context, {required String email, required String password}) async {
  final navigator = Navigator.of(context);
  try {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      print("User ID: ${userCredential.user!.uid}");

      // Kullanıcı kimliğini shared preferences'e kaydet
      await saveUserId(userCredential.user!.uid);

      await getUserData(userCredential.user!.uid);
      
      // Do the navigation to home_view.dart
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(), // Assuming HomeView is the name of your home page widget.
        ),
      );
    }
  } on FirebaseAuthException catch (e) {
    String errorMessage = 'Username or password is incorrect';
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

// Kullanıcı kimliğini shared preferences'e kaydeden fonksiyon
Future<void> saveUserId(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
}

Future<String?> UserIDdondur() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}

// Kullanıcı kimliğini shared preferences'ten alıp döndüren fonksiyon
Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}

  Future<void> _registerUser({required String userId, required String name, required String email, required String password}) async {
    await userCollection.doc(userId).set({
      "email" : email,
      "name": name,
      "password": password
    });
  }

  Future<void> getUserData(String userId) async {
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      String fullName = userDoc['name'];
      String email = userDoc['email'];

      print('Full Name: $fullName');
      print('Email: $email');


      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullName', fullName);
      await prefs.setString('email', email);
      
      print('Name and Email saved to SharedPreferences.');
    } else {
      print('User document does not exist');
    }
  } catch (e) {
    print('Error getting user data: $e');
  }
}
}
