import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mep/app/views/home/admin_home_view.dart';
import 'package:mep/app/views/home/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mep/app/views/home/home_view.dart';
import 'package:mep/app/views/report/my_reports/my_reports_admin_page.dart';
import 'package:mep/app/views/report/my_reports/my_reports_page.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;





 Future<void> updateUserInformation(String newName, String newEmail) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  if (user != null) {
    try {
      // Auth'daki e-postayı güncelle
      await user.updateEmail(newEmail);

      // Kullanıcının isim ve e-posta bilgisini güncelle
      await user.updateDisplayName(newName);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? uid = prefs.getString('userId');

      // Firestore kullanarak kullanıcının bilgilerini güncelle
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference userDocRef = firestore.collection('users').doc(user.uid);

      await userDocRef.update({
        'name': newName,
        'email': newEmail,
      });

      print('Kullanıcı bilgileri başarıyla güncellendi!');
    } catch (e) {
      print('Kullanıcı bilgileri güncellenirken bir hata oluştu: $e');
    }
  }
}







 Future<void> signUp(BuildContext context, {required String name, required String email, required String password}) async {
  final navigator = Navigator.of(context);
  try {
    final QuerySnapshot nameCheck = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: name)
        .get();

    final QuerySnapshot emailCheck = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (nameCheck.docs.isNotEmpty || emailCheck.docs.isNotEmpty) {
      // Eğer veritabanında aynı isim veya e-posta ile kayıtlı bir kullanıcı varsa
      Fluttertoast.showToast(
        msg: "User with the same name or email already exists",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

   



    final UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      // Auth ile kullanıcı oluşturulduktan sonra user id'sini alıyoruz.
      String userId = userCredential.user!.uid;

      await _registerUser(userId: userId, name: name, email: email, password: password);
      Fluttertoast.showToast(
        msg: "Successfully registered",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 1, 88, 24),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  } on FirebaseAuthException catch (e) {
    Fluttertoast.showToast(
      msg: "Something went wrong",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String fullName = prefs.getString('fullName') ?? '';

      final List<String> municipalities = ['Kadıköy', 'Avcılar', 'Küçükçekmece','Select Municipality'];
      if(municipalities.contains(fullName)){
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => AdminHomePage(), // Assuming HomeView is the name of your home page widget.
        ),
      );
      }
      else
      {
        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(), // Assuming HomeView is the name of your home page widget.
          ),
        );

      }
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
