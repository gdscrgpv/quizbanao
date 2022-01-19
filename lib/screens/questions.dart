import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quizbanao/providers/auth.dart';
import 'package:quizbanao/providers/quiz.dart';
import 'package:quizbanao/screens/results.dart';
import 'package:quizbanao/utils/files.dart';
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
    // Provider.of<QuizProvider>(context, listen: false).fetchQuiz("123456");
    setState(() {
      lastIndex = Provider.of<QuizProvider>(context, listen: false)
          .quiz
          .questions
          .length;
    });
    print("last" + lastIndex.toString());
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Quiz",
          style: TextStyle(color: Colors.black),
        )),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      // floatingActionButton: Row(
      //   children: [
      //     FloatingActionButton(
      //       child: Icon(Icons.chevron_right),
      //       tooltip: "Next",
      //       onPressed: () {
      //         Provider.of<QuizProvider>(context, listen: false)
      //             .fetchQuiz("123456");
      //       },
      //     ),
      //     FloatingActionButton(
      //       child: Icon(Icons.chevron_right),
      //       tooltip: "Next",
      //       onPressed: () {
      //         _pageController.nextPage(
      //             duration: Duration(milliseconds: 500), curve: Curves.easeIn);
      //       },
      //     ),
      //   ],
      // ),
      body: Consumer<QuizProvider>(builder: (context, value, child) {
        if (value.loadingQuiz) {
          return Center(
              child: LottieBuilder.asset(QAssetsManager.lottie_loader2_blue));
        }
        return Container(
            height: MediaQuery.of(context).size.height,
            // color: Colors.grey,
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
  late Timer _timer;
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
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Progress,Question text and image
        _buildQuestionData(),

        // Options
        _buildOptionsList(),

        // Locked option
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        //   child: selectedOption != -1
        //       ? Text("Locked Answer: " +
        //           question.options["option" + (selectedOption + 1).toString()]
        //               .toString())
        //       : Container(),
        // ),
      ],
    );
  }

  Column _buildQuestionData() {
    return Column(
      children: [
        Container(
          height: 8,
          child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(getIndicatorColors),
            backgroundColor: Colors.grey,
            value: 1 - _progressValue / question.time.toDouble(),
          ),
        ),
        SizedBox(height: 20),

        // Question text
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            question.question,
            style: TextStyle(
                fontSize: 20,
                color: selectedOption != -1 ? Colors.grey : Colors.black),
          ),
        ),
        SizedBox(height: 20),

        // Image
        question.imageUrl != ""
            ? Column(
                children: [
                  Image.network(
                    question.imageUrl,
                    height: 200,
                    // width: 200,
                  ),
                  SizedBox(height: 20),
                ],
              )
            : Container(),
      ],
    );
  }

  Container _buildOptionsList() {
    return Container(
      height: 400,
      // color: Colors.amber,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color:
                        selectedOption == index ? Colors.blue : Colors.black12,
                    // border: Border.all(
                    //     color: selectedOption == index
                    //         ? Colors.green
                    //         : Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  question.options["option" + (index + 1).toString()]
                      .toString(),
                  style: TextStyle(
                      color: selectedOption == index
                          ? Colors.white
                          : Colors.black),
                ),
              ),
              onTap: () {
                if (selectedOption == -1)
                  setState(() {
                    selectedOption = index;
                    noneSelected = false;
                    print("CALLING PROVIDER");
                    Provider.of<QuizProvider>(context, listen: false).addAnswer(
                        index + 1,
                        question.answer,
                        _progressValue,
                        question.time);
                  });
              },
            );
          },
          itemCount: 4),
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
    _timer = new Timer.periodic(oneSec, (Timer t) {
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
          if (noneSelected)
            Provider.of<QuizProvider>(context, listen: false)
                .addAnswer(0, "1", 0, time);
          _pageController.nextPage(
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          return;
        }
      });
    });
  }
}
