import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizbanao/providers/quiz.dart';
import 'package:quizbanao/providers/result.dart';

class ResultScreen extends StatelessWidget {
  static const routeName = "/results-screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Results'),
        ),
        body: PageView(
          children: [LeaderBoard(), AnswerContainer()],
        ));
  }
}

class AnswerContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(builder: (context, value, child) {
      double timetaken = 0;
      value.quiz.questions.forEach((element) {
        timetaken += element.time;
      });
      return Column(
        children: [
          SizedBox(height: 20),
          Text('You answered ' +
              value.marks.toString() +
              ' out of ' +
              value.quiz.questions.length.toString() +
              ' questions correctly'),
          Text('You took ' +
              value.timeTaken.toString() +
              ' time out of ' +
              timetaken.toString() +
              ' total time to answer each questions.'),
        ],
      );
    });
  }
}

class LeaderBoard extends StatefulWidget {
  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  void initState() {
    super.initState();
    Provider.of<ResultProvider>(context, listen: false).getResult();
  }

  @override
  Widget build(BuildContext context) {
    // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>(debugLabel: '_LoginFormState');
    Future _refresh() {
  return Provider.of<ResultProvider>(context, listen: false).getResult();
}

    return Consumer<ResultProvider>(
        builder: (context, value, child) => value.loadingQuiz
            ? Center(child: CircularProgressIndicator())
            : value.topperData.length == 0
                ? Center(child: Text('No results yet'))
                : Column(children: [
                  SizedBox(height: 10,),
                    Text('Leaderboard',style: TextStyle(fontSize: 20),),
                    SizedBox(height: 10,),
                    Expanded(
                      child: RefreshIndicator(
                            key: new GlobalKey<RefreshIndicatorState>(),
                            onRefresh: _refresh,
                            child:  ListView.builder(
                        itemCount: value.topperData.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: Text(
                                (index + 1).toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                              title: Text(value.topperData[index].email,style: TextStyle(fontSize: 15,overflow: TextOverflow.ellipsis),),
                              subtitle:
                                  Text("Points: "+value.topperData[index].marks.toString()+" Time: "+value.topperData[index].timeTaken.toString()),
                              trailing:
                                  Text(value.topperData[index].fullName.toString(),style: TextStyle(fontSize: 15,overflow: TextOverflow.ellipsis),),
                            ),
                          );
                        },
                      ),
                    )
     ) ]));
  }
}
