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
        await _registerUser(userId: userCredential.user!.uid, name: name, email: email, password: password);
      }
    } on FirebaseAuthException catch (e) {
      // Handle sign up errors
    }
  }

  Future<void> signIn(BuildContext context, {required String email, required String password}) async {
    final navigator = Navigator.of(context);
    try {
      final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        print("User ID: ${userCredential.user!.uid}"); // Print user ID
        await getUserData(userCredential.user!.uid);
      }
    } on FirebaseAuthException catch(e) {
      // Handle sign in errors
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
      String fullName = userDoc['fullname'];
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
