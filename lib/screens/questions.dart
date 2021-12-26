import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizbanao/providers/quiz.dart';

class QuizScreen extends StatefulWidget {
  static const routeName = "/quiz-screen";

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
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
            children: [
              QuestionWidget(),
              QuestionWidget(),
              QuestionWidget(),
              QuestionWidget(),
              QuestionWidget(),
            ],
          ),
        );
      }),
    );
  }
}

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Text("Question Here"),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  value: true,
                  onChanged: (value) {},

                  title: Text("Answer $index"),
                  // onTap: () {
                  //   // Navigator.of(context).pushNamed(ResultScreen.routeName);
                  // },
                );
              },
              itemCount: 10),
        ),
      ],
    );
  }
}
