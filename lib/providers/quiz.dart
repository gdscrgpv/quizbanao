import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizbanao/providers/auth.dart';

class Question {
  String question;
  Map<String, dynamic> options;
  String imageUrl;
  String answer;
  int time;
  Question(
      {required this.question,
      required this.imageUrl,
      required this.options,
      required this.answer,
      required this.time});
}

class Quiz {
  String id;
  List<Question> questions;
  Quiz({required this.id, required this.questions});
}

class QuizProvider with ChangeNotifier {
  Quiz _quiz = Quiz(id: '', questions: []);
  Quiz get quiz => _quiz;
  bool loadingQuiz = true;
  int _marks = 0;
  int get marks => _marks;
  double _timeTaken = 0;
  double get timeTaken => _timeTaken;

  Future<bool> validateQuizId(String quizId) async {
    if (quizId.isEmpty) {
      return false;
    }
    var doc = await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .get();
    if (doc.data() == null) {
      return false;
    }
    Map data = doc.data() as Map;

    if (doc.exists && data['active']) {
      log("Exists and is active!");
      fetchQuiz(quizId);
      return true;
    } else {
      log("Does not exists");
      return false;
    }
    return false;
  }

  //submit responses
  Future addAnswer(
      int index, String answer, double timeTaken, int maxTime) async {
    //print("MAKING SURE THIS RUN 3 TIME");
    //print("index: $index");
    //print("answer: $answer");
    //print("timeTaken: $timeTaken");
    //print("maxTime: $maxTime");
    if (timeTaken > maxTime) {
      timeTaken = maxTime.toDouble();
    }
    if ("option" + index.toString() == answer) {
      _marks++;
      _timeTaken += timeTaken;
      //print("MARKS" + _marks.toString());
      //print("TIME" + _timeTaken.toString());
    } else {
      _timeTaken += maxTime;
      //print("TIME" + _timeTaken.toString());
    }
  }

  Future<void> submitQuiz(String uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'marks': _marks, 'time_taken': _timeTaken});
  }

  // fetch questions
  void fetchQuiz(String id) async {
    //print("******* " + id.toString());
    loadingQuiz = true;
    notifyListeners();
    var doc =
        await FirebaseFirestore.instance.collection('quizzes').doc(id).get();
    if (doc == null) {
      loadingQuiz = false;
      notifyListeners();
      return;
    }
    if (doc.exists) {
      Map data = doc.data() as Map<String, dynamic>;
      // //print(data.toString());
      // //print(data['questions']['question'].toString());

      _quiz = Quiz(
          id: id,
          questions: List.castFrom((data['questions'].values.map((q) {
            // log(q.toString());
            return Question(
              question: q['text'],
              imageUrl: q['imageUrl'],
              options: q['options'] as Map<String, dynamic>,
              answer: q['answer'],
              time: q['time'],
            );
          })).toList()));
      // //print(_quiz.questions.length.toString());

    }
    await Future.delayed(Duration(seconds: 2), () {
      loadingQuiz = false;
      notifyListeners();
    });
    // notifyListeners();
  }
}
