import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  String fullName;
  String email;
  String quizId;
  int marks;
  UserModel(
      {required this.fullName,
      required this.email,
      required this.quizId,
      required this.marks});
}

class AuthProvider with ChangeNotifier {
  Future<bool> creteNewEntry(UserModel user) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'fullName': user.fullName,
        'email': user.email,
        'quizId': user.quizId,
        'marks': user.marks,
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
