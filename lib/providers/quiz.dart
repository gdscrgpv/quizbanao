import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Question {
  String question;
  Set<String> options;
  String answer;
  int time;
  Question(
      {required this.question,
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
      return true;
    } else {
      log("Does not exists");
      return false;
    }
  }

  // fetch questions
  void fetchQuestions() {
    _quiz.questions = [
      // Question('What is the capital of India?',
      //     {'New Delhi', 'Maharastra', 'Kolkata', 'Bihar'}, 'New Delhi'),
      // Question('What is the capital of USA?',
      //     {'New Delhi', 'Maharastra', 'Kolkata', 'Bihar'}, 'New Delhi'),
      // Question('What is the capital of UK?',
      //     {'New Delhi', 'Maharastra', 'Kolkata', 'Bihar'}, 'New Delhi'),
      // Question('What is the capital of Australia?',
      //     {'New Delhi', 'Maharastra', 'Kolkata', 'Bihar'}, 'New Delhi'),
      // Question('What is the capital of Canada?',
      //     {'New Delhi', 'Maharastra', 'Kolkata', 'Bihar'}, 'New Delhi'),
      // Question('What is the capital of Germany?',
      //     {'New Delhi', 'Maharastra', 'Kolkata', 'Bihar'}, 'New Delhi'),
      // Question('What is the capital of Italy?',
      //     {'New Delhi', 'Maharastra', 'Kolkata', 'Bihar'}, 'New Delhi'),
      // Question('What is the capital of Japan?',
      //     {'New Delhi', 'Maharastra', 'Kolkata', 'Bihar'}, 'New Delhi')
    ];
    notifyListeners();
  }
}
