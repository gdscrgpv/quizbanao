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
        LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          backgroundColor: Colors.grey,
          value: _progressValue / question.time.toDouble(),
        ),
        Text('${(_progressValue * 100).round()}%'),
        selectedOption != -1
            ? Text("Locked Answer: " +
                question.options["option" + (selectedOption + 1).toString()]
                    .toString())
            : Container(),
        Spacer(),
      ],
    );
  }

  void _updateProgress(int time) {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(oneSec, (Timer t) {
      setState(() {
        _progressValue += 1;
        print(_progressValue);
        print("PGC" + _pageController.page.toString());
        print("LI" + lastIndex.toString());
        if (_progressValue >= time && _pageController.page == lastIndex - 1) {
          t.cancel();
          Provider.of<QuizProvider>(context, listen: false).submitQuiz(
              Provider.of<AuthProvider>(context, listen: false).userId);
          Navigator.of(context).pushReplacementNamed(ResultScreen.routeName);
        }
        // if(_pageController.page == lastIndex && _progressValue == time){
        //   t.cancel();
        //   Navigator.of(context)
        //                     .pushReplacementNamed(ResultScreen.routeName);
        // }
        if (_progressValue == time) {
          t.cancel();
          _pageController.nextPage(
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          return;
        }
      });
    });
  }
}
// }

// class ShowTimer extends StatelessWidget {
//   ShowTimer(this.workStart, this.time);
//   final DateTime workStart;
//   final int time;

//   @override
//   Widget build(BuildContext context) {
//     final _myTimer;
//     //Need to navigate when last question
//     //  Navigator.of(context)
//     //                         .pushReplacementNamed(ResultScreen.routeName);

//     return DateTime.now().difference(workStart) <= Duration(seconds: time)
//         ? TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
//             print(_pageController.page.toString());
//             DateTime.now().difference(workStart) >= Duration(seconds: time) &&
//                     _pageController.page != lastIndex + 1
//                 ? _pageController.nextPage(
//                     duration: Duration(milliseconds: 500), curve: Curves.easeIn)
//                 : Container();
//             return DateTime.now().difference(workStart) >=
//                     Duration(seconds: time)
//                 ? Container()
//                 : Container(
//                     padding: EdgeInsets.all(8.0),
//                     decoration: BoxDecoration(
//                         color: Colors.yellow,
//                         borderRadius: BorderRadius.circular(5)),
//                     child: Text(
//                       "Time Left: " +
//                           (time -
//                                   (DateTime.now()
//                                       .difference(workStart)
//                                       .inSeconds))
//                               .toString(),
//                       style: TextStyle(color: Colors.black),
//                     ));
//           })
//         : Container();
//   }
// }
