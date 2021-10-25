import 'package:flutter/material.dart';

class Question {
  String question;
  Set<String> options;
  String answer;
  Question(this.question, this.options, this.answer);
}

class QuizProvider with ChangeNotifier {
  List<Question> questions = [];

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
