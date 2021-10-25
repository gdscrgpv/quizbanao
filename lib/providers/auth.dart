import 'package:flutter/foundation.dart';

class UserModel {
  String fullName;
  String email;
  String quizId;
  String marks;
  UserModel(
      {required this.fullName,
      required this.email,
      required this.quizId,
      required this.marks});
}

class AuthProvider with ChangeNotifier {
  Future postUserData() async {}
}
