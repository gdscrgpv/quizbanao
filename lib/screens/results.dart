import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizbanao/providers/quiz.dart';

class ResultScreen extends StatelessWidget {
  static const routeName = "/results-screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Consumer<QuizProvider>(builder: (context, value, child) {
          double timetaken = 0;
          value.quiz.questions.forEach((element) {timetaken+=element.time;});
          print(timetaken);
          return Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text('You answered '+value.marks.toString()+' out of '+value.quiz.questions.length.toString()+' questions correctly'),
                  Text('You took '+value.timeTaken.toString()+' time out of '+timetaken.toString()+' total time to answer each questions.'),
                ],
              ),
            ),
          );
        }));
  }
}
