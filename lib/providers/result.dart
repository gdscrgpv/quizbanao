import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizbanao/providers/auth.dart';
import 'package:flutter/cupertino.dart';

class ResultProvider with ChangeNotifier {
  bool loadingQuiz = true;
  late List<UserModel> _topperData = [];
  List<UserModel> get topperData => _topperData;

  Future getResult() async {
    loadingQuiz = true;
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        Map data = element.data();
        _topperData.add(UserModel(
            fullName: data['fullName'],
            marks: data['marks'],
            quizId: data['quizId'],
            email: data['email'],
            timeTaken: data['time_taken']));
        print(data);
        print("Topperdata" + _topperData.toString());
        // _topperData.add(data);
      });
    }).then((_) {
      loadingQuiz = false;
      notifyListeners();
      _topperData.sort((a, b){
        if (b.marks == a.marks) {
          return b.timeTaken.compareTo(a.timeTaken);
        }
        return b.marks.compareTo(a.marks);
      });
      // _topperData.sort((a, b) {
      //   if (b['marks'] == a['marks']) {
      //     return b['time_taken'].compareTo(a['time_taken']);
      //   }
      //   return b['marks'].compareTo(a['marks']);
      // });
    });

    notifyListeners();
    loadingQuiz = false;
    notifyListeners();
  }
}
