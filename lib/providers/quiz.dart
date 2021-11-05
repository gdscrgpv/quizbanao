import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Question {
  String question;
  Set<String> options;
  String answer;
  Question(this.question, this.options, this.answer);
}

class QuizProvider with ChangeNotifier {
  List<Question> questions = [];

  Future validateQuizId(String quizId) async {
    if (quizId.isEmpty) {
      return false;
    }
    FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .get()
        .then((doc) {
      Map data = doc.data() as Map;
      if (doc.exists && data['active']) {
        log("Exists and is active");
        return true;
      } else {
        log("Does not exists");
        return false;
      }
    });
    return false;
  }

  // fetch questions
  void fetchQuestions() {
    questions = [
      Question('What is the capital of India?',
          {'New Delhi', 'Maharastra', 'Kolkata', 'Bihar'}, 'New Delhi'),
      Question('What is the capital of USA?',
          {'New Delhi', 'Maharastra', 'Kolkata', 'Bihar'}, 'New Delhi'),
      Question('What is the capital of UK?',
          {'New Delhi', 'Maharastra', 'Kolkata', 'Bihar'}, 'New Delhi'),
      Question('What is the capital of Australia?',
          {'New Delhi', 'Maharastra', 'Kolkata', 'Bihar'}, 'New Delhi'),
      Question('What is the capital of Canada?',
          {'New Delhi', 'Maharastra', 'Kolkata', 'Bihar'}, 'New Delhi'),
      Question('What is the capital of Germany?',
          {'New Delhi', 'Maharastra', 'Kolkata', 'Bihar'}, 'New Delhi'),
      Question('What is the capital of Italy?',
          {'New Delhi', 'Maharastra', 'Kolkata', 'Bihar'}, 'New Delhi'),
      Question('What is the capital of Japan?',
          {'New Delhi', 'Maharastra', 'Kolkata', 'Bihar'}, 'New Delhi')
    ];
    notifyListeners();
  }
}
