import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        print("User ID: ${userCredential.user!.uid}");
        await getUserData(userCredential.user!.uid);
      }
    } on FirebaseAuthException catch(e) {
    }
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
    } else {
      print('User document does not exist');
    }
  } catch (e) {
    print('Error getting user data: $e');
  }
}

}
