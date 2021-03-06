import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:quizbanao/providers/quiz.dart';
import 'package:quizbanao/providers/result.dart';
import 'package:quizbanao/screens/login.dart';
import 'package:quizbanao/utils/colors.dart';
import 'package:quizbanao/utils/files.dart';

class ResultScreen extends StatelessWidget {
  static const routeName = "/leaderboard";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   var qId = Provider.of<QuizProvider>(context, listen: false).quiz.id;
        //   Provider.of<ResultProvider>(context, listen: false).getResult(qId);
        // }),
        body: SafeArea(
      child: LeaderBoard(),
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
  String qId = '';
  @override
  void initState() {
    super.initState();
    qId = Provider.of<QuizProvider>(context, listen: false).quiz.id;
    Provider.of<ResultProvider>(context, listen: false).getResult(qId);
  }

  @override
  Widget build(BuildContext context) {
    // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>(debugLabel: '_LoginFormState');
    Future _refresh() {
      return Provider.of<ResultProvider>(context, listen: false).getResult(qId);
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacement(PageTransition(
          type: PageTransitionType.rightToLeft,
          child: LoginScreen(),
        ));
        return Future.value(false);
      },
      child: Consumer<ResultProvider>(
          builder: (context, value, child) => value.loadingQuiz
              ? Center(child: CircularProgressIndicator())
              : value.topperData.length == 0
                  ? SpinKitThreeBounce(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: index.isEven
                                ? QColorScheme.blue4
                                : QColorScheme.yellow2,
                          ),
                        );
                      },
                    )
                  : Column(children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LottieBuilder.asset(
                            QAssetsManager.star,
                            height: 100,
                          ),
                          Text(
                            'Leaderboard',
                            style: GoogleFonts.poppins(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                          LottieBuilder.asset(
                            QAssetsManager.star,
                            height: 100,
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),

                      // SizedBox(height: 30),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     Container(
                      //       height: 100,
                      //       width: 100,
                      //       child: Neumorphic(
                      //         style: NeumorphicStyle(depth: 10),
                      //       ),
                      //     ),
                      //     Container(
                      //       height: 100,
                      //       width: 100,
                      //       child: Neumorphic(
                      //         style: NeumorphicStyle(depth: 10),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: 30),
                      Expanded(
                          child: RefreshIndicator(
                        key: new GlobalKey<RefreshIndicatorState>(),
                        onRefresh: _refresh,
                        child: ListView.builder(
                          itemCount: value.topperData.length,
                          itemBuilder: (context, index) {
                            if (index < 3) {
                              return _buildWinnerTile(
                                  value.topperData[index], index);
                            }
                            return Card(
                              child: ListTile(
                                leading: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                                title: Text(value.topperData[index].email,
                                    style: TextStyle(fontSize: 15),
                                    overflow: TextOverflow.ellipsis),
                                subtitle: Text("Points: " +
                                    value.topperData[index].marks.toString() +
                                    " Time: " +
                                    value.topperData[index].timeTaken
                                        .toStringAsFixed(1) +
                                    's'),
                                trailing: Text(
                                  value.topperData[index].fullName.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ))
                    ])),
    );
  }

  Card _buildWinnerTile(value, int index) {
    Widget leading;
    if (index == 0) {
      leading = LottieBuilder.asset(
        QAssetsManager.crown2,
        height: 100,
      );
    } else if (index == 1) {
      leading = LottieBuilder.asset(
        QAssetsManager.crown1,
        height: 130,
      );
    } else {
      leading = LottieBuilder.asset(
        QAssetsManager.star,
        height: 100,
      );
    }
    return Card(
      child: ExpansionTile(
        children: [
          ListTile(
            title: Text(
              'Points: ' +
                  value.marks.toString() +
                  ' | Time: ' +
                  value.timeTaken.toStringAsFixed(1) +
                  's',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w400),
            ),
            subtitle: Text(
              value.email,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
            trailing: Text(
              (index + 1).toString(),
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ],
        leading: leading,
        title: Text(
          value.fullName,
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
