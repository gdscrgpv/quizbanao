import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  String fullName;
  String email;
  String quizId;
  int marks;
  double timeTaken;
  UserModel(
      {required this.fullName,
      required this.email,
      required this.quizId,
      required this.marks,
      required this.timeTaken});
}

class AuthProvider with ChangeNotifier {
  late String userId;
  Future<bool> creteNewEntry(UserModel user) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'fullName': user.fullName,
        'email': user.email,
        'quizId': user.quizId,
        'marks': user.marks,
        'time_taken': user.timeTaken
      }).then((value) => userId = value.id);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
