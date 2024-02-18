import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("users");

  Future<bool> registerUser({
    required String fullname,
    required String email,
    required String password,
  }) async {
    try {
      await userCollection.add({
        "fullname": fullname,
        "email": email,
        "password": password,
      });
      print("Kaydoldun");
      return true; 
      
    } catch (e) {
      print("Error registering user: $e");
      return false; 
    }
  }
}
