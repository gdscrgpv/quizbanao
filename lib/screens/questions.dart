import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizbanao/providers/quiz.dart';
import 'package:quizbanao/screens/results.dart';
import 'package:timer_builder/timer_builder.dart';

class QuizScreen extends StatefulWidget {
  static const routeName = "/quiz-screen";
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

PageController _pageController = PageController(
  initialPage: 0,
);
late int lastIndex = 100;

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<QuizProvider>(context, listen: false).fetchQuiz("123456");
    setState(() {
      lastIndex = Provider.of<QuizProvider>(context, listen: false)
          .quiz
          .questions
          .length;
    });
    print("last" + lastIndex.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chevron_right),
        tooltip: "Next",
        onPressed: () {
          Provider.of<QuizProvider>(context, listen: false).fetchQuiz("123456");
        },
      ),
      body: Consumer<QuizProvider>(builder: (context, value, child) {
        if (value.loadingQuiz) {
          return Center(child: CircularProgressIndicator());
        }
        return Container(
            height: MediaQuery.of(context).size.height,
            child: PageView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for (var i = 0; i < value.quiz.questions.length; i++)
                    QuestionWidget(value.quiz.questions[i])
                ],
                controller: _pageController));
      }),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final Question question;
  QuestionWidget(this.question);
  @override
  _QueScreenState createState() => _QueScreenState(this.question);
}

class _QueScreenState extends State<QuestionWidget> {
  final Question question;
  _QueScreenState(this.question);
  var selectedOption = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          question.question,
          style: TextStyle(
              color: selectedOption != -1 ? Colors.grey : Colors.black),
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    question.options["option" + (index + 1).toString()]
                        .toString(),
                    style: TextStyle(
                        color:
                            selectedOption != -1 ? Colors.grey : Colors.black),
                  ),
                  onTap: () {
                    if (selectedOption == -1)
                      setState(() {
                        selectedOption = index;
                      });
                  },
                );
              },
              itemCount: 4),
        ),
        ShowTimer(DateTime.now(), question.time.toInt()),
        selectedOption != -1
            ? Text("Locked Answer: " +
                question.options["option" + (selectedOption + 1).toString()]
                    .toString())
            : Container(),
        Spacer(),
      ],
    );
  }
}

class ShowTimer extends StatelessWidget {
  ShowTimer(this.workStart, this.time);
  final DateTime workStart;
  final int time;

  @override
  Widget build(BuildContext context) {
    //Need to navigate when last question
    //  Navigator.of(context)
    //                         .pushReplacementNamed(ResultScreen.routeName);

    return DateTime.now().difference(workStart) <= Duration(seconds: time)
        ? TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
            print(_pageController.page.toString());
            DateTime.now().difference(workStart) >= Duration(seconds: time) &&
                    _pageController.page != lastIndex + 1
                ? _pageController.nextPage(
                    duration: Duration(milliseconds: 500), curve: Curves.easeIn)
                : null;
            return DateTime.now().difference(workStart) >=
                    Duration(seconds: time)
                ? Container()
                : Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "Time Left: " +
                          (time -
                                  (DateTime.now()
                                      .difference(workStart)
                                      .inSeconds))
                              .toString(),
                      style: TextStyle(color: Colors.black),
                    ));
          })
        : Container();
  }
}
