import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizbanao/providers/auth.dart';
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
      appBar: AppBar(title: Center(child: Text("Quiz",style: TextStyle(color: Colors.black),)),backgroundColor: Colors.white,elevation: 0,),
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
  bool noneSelected = true;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _updateProgress(question.time);
    lastIndex =
        Provider.of<QuizProvider>(context, listen: false).quiz.questions.length;
    print("LASTINDEC" + lastIndex.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(getIndicatorColors),
          backgroundColor: Colors.grey,
          value: _progressValue / question.time.toDouble(),
        ),
        SizedBox(height: 20),
        Container(
          child: Text(
            question.question,
            style: TextStyle(
              fontSize: 20,
                color: selectedOption != -1 ? Colors.grey : Colors.black),
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                        border: Border.all(
                            color: selectedOption == index
                                ? Colors.green
                                : Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      question.options["option" + (index + 1).toString()]
                          .toString(),
                      style: TextStyle(
                          color:
                              selectedOption != -1 ? Colors.grey : Colors.black),
                    ),
                  ),
                  onTap: () {
                    if (selectedOption == -1)
                      setState(() {
                        selectedOption = index;
                        noneSelected = false;
                        print("CALLING PROVIDER");
                        Provider.of<QuizProvider>(context,listen: false)
                        .addAnswer(index + 1, question.answer, _progressValue, question.time);
                      });
                  },
                );
              },
              itemCount: 4),
        ),
        // ShowTimer(DateTime.now(), question.time.toInt()),
        selectedOption != -1
            ? Text("Locked Answer: " +
                question.options["option" + (selectedOption + 1).toString()]
                    .toString())
            : Container(),
        Spacer(),
      ],
    );
  }

  get getIndicatorColors {
    double timeLeft = 1 - _progressValue / question.time.toDouble();
    if (timeLeft > 0.75) {
      return Colors.green;
    } else if (timeLeft > 0.35 && timeLeft <= 0.75) {
      return Colors.yellow;
    } else if (timeLeft > 0.15 && timeLeft <= 0.35) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  void _updateProgress(int time) {
    const oneSec = const Duration(milliseconds: 200);
    new Timer.periodic(oneSec, (Timer t) {
      setState(() {
        _progressValue += 0.2;
        // print(_progressValue);
        // print("PGC" + _pageController.page.toString());
        // print("LI" + lastIndex.toString());
        if (_progressValue >= time && _pageController.page == lastIndex - 1) {
          t.cancel();
          Provider.of<QuizProvider>(context, listen: false).submitQuiz(
              Provider.of<AuthProvider>(context, listen: false).userId);
          Navigator.of(context).pushReplacementNamed(ResultScreen.routeName);
        }
        if (_progressValue >= time) {
          t.cancel();
          if(noneSelected)
            Provider.of<QuizProvider>(context, listen: false).addAnswer(0, "1", 0, time);
          _pageController.nextPage(
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          return;
        }
      });
    });
  }
}