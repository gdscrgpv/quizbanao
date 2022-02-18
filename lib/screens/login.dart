import 'dart:developer';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:quizbanao/providers/auth.dart';
import 'package:quizbanao/providers/quiz.dart';
import 'package:quizbanao/screens/questions.dart';
import 'package:quizbanao/screens/results.dart';
import 'package:quizbanao/utils/colors.dart';
import 'package:quizbanao/utils/files.dart';
import 'package:quizbanao/utils/text.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/auth";
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _quizIdController = TextEditingController();
  TextEditingController _quizIdSearchController = TextEditingController();

  //     TextEditingController _emailController =
  //     TextEditingController(text: "test@test.co");
  // TextEditingController _nameController =
  //     TextEditingController(text: "Gustavo");
  // TextEditingController _quizIdController =
  //     TextEditingController(text: "123456");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   await Provider.of<QuizProvider>(context, listen: false)
      //       .validateQuizId("123456");

      // FirebaseFirestore.instance
      //     .collection('data')
      //     .add({'text': 'data added through app'});
      // }),
      // backgroundColor: ,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.info,
              color: Colors.grey,
            ),
            onPressed: () {
              log("message");
              // open drawer
              showAnimatedDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return ClassicGeneralDialogWidget(
                      titleText: 'Quiz Banao',
                      contentText: 'App version: v1.0',
                      positiveText: "Cool!",
                      negativeText: "Report bug",
                      actions: [
                        FlatButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ]);
                },
                animationType: DialogTransitionType.size,
                curve: Curves.fastOutSlowIn,
                duration: Duration(seconds: 1),
              );
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.leaderboard,
              color: Colors.grey,
            ),
            onPressed: () {
              log("message");
              // open drawer
              showAnimatedDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    children: [
                      TextFormField(
                        controller: _quizIdSearchController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a Quiz ID";
                          }
                        },
                        decoration: InputDecoration(
                              labelText: "Quiz ID",
                              border: OutlineInputBorder()),
                      ),
                      TextButton(
                          onPressed: () async {
                            final prov = Provider.of<QuizProvider>(context,listen: false);
                            prov.fetchQuiz(_quizIdSearchController.text);
                            bool response = await prov.validateQuizId(_quizIdSearchController.text);
                            if (response) {
                              Navigator.pushNamed(
                                  context, ResultScreen.routeName);
                            } else {
                              // If Quiz ID is incorrect then show a snackbar
                              _quizIdController.text = '';
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Quiz ID is invalid"),
                                backgroundColor: Colors.red,
                              ));
                            }
                          },
                          child: Text('Submit'))
                    ],
                  );
                },
                animationType: DialogTransitionType.size,
                curve: Curves.fastOutSlowIn,
                duration: Duration(seconds: 1),
              );
            },
          ),
        ],
      ),

      // extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                // FlutterLogo(
                //   size: 120,
                // ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("QUIZ",
                          style: GoogleFonts.lato(
                              fontSize: 50,
                              fontWeight: FontWeight.w600,
                              color: QColorScheme.blue4)),
                      Text("बनाओ",
                          style: GoogleFonts.monoton(
                              fontSize: 50,
                              fontWeight: FontWeight.w300,
                              color: QColorScheme.yellow2)),
                      // Text("An initiative by"),
                    ],
                  ),
                ),
                // Container(
                //   height: 50,
                //   child: Row(
                //     children: <Widget>[
                //       const SizedBox(width: 0.0, height: 100.0),
                //       const Text(
                //         'Be',
                //         style: TextStyle(fontSize: 43.0),
                //       ),
                //       const SizedBox(width: 20.0, height: 100.0),
                //       DefaultTextStyle(
                //         style: GoogleFonts.adventPro(
                //           fontSize: 45.0,
                //           fontWeight: FontWeight.w900,
                //           color: QColorScheme.yellow2,
                //           letterSpacing: -1.0,
                //         ),
                //         child:
                //             AnimatedTextKit(repeatForever: true, animatedTexts: [
                //           RotateAnimatedText('AWESOME'),
                //           RotateAnimatedText('OPTIMISTIC'),
                //           RotateAnimatedText('DIFFERENT'),
                //         ]
                //                 // onTap: () {
                //                 //   print("Tap Event");
                //                 // },
                //                 ),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Column(
                      children: [
                        Text("Get Started",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              // fontWeight: FontWeight.w900,
                              color: QColorScheme.black,
                              letterSpacing: -1.0,
                            )),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your name";
                            }
                          },
                          decoration: InputDecoration(
                              labelText: "Full name",
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return "Please enter a valid email";
                            }
                            // This was cool ... Copilot!
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Email", border: OutlineInputBorder()),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                            controller: _quizIdController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a Quiz ID";
                              }
                            },
                            decoration: InputDecoration(
                                labelText: "Quiz ID",
                                border: OutlineInputBorder()),
                            keyboardType: TextInputType.text),
                        SizedBox(height: 20),
                        SubmitButton(
                            formKey: _formKey,
                            quizIdController: _quizIdController,
                            nameController: _nameController,
                            emailController: _emailController)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubmitButton extends StatefulWidget {
  const SubmitButton({
    Key? key,
    required GlobalKey<FormState> formKey,
    required TextEditingController quizIdController,
    required TextEditingController nameController,
    required TextEditingController emailController,
  })  : _formKey = formKey,
        _quizIdController = quizIdController,
        _nameController = nameController,
        _emailController = emailController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController _quizIdController;
  final TextEditingController _nameController;
  final TextEditingController _emailController;

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? SpinKitThreeBounce(
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:
                      index.isEven ? QColorScheme.blue4 : QColorScheme.yellow2,
                ),
              );
            },
          )
        : ElevatedButton(
            onPressed: () async {
              // Authentication Logic
              if (widget._formKey.currentState!.validate()) {
                setState(() {
                  loading = true;
                });
                // Validate the quiz ID
                bool response =
                    await Provider.of<QuizProvider>(context, listen: false)
                        .validateQuizId(widget._quizIdController.text);

                log(response.toString());
                if (response) {
                  // If Quiz ID correct then Create a new user entry
                  bool resp =
                      await Provider.of<AuthProvider>(context, listen: false)
                          .creteNewEntry(UserModel(
                              fullName: widget._nameController.text,
                              email: widget._emailController.text,
                              quizId: widget._quizIdController.text,
                              marks: 0,
                              timeTaken: 0.0));
                  log("User created");
                  // If user is created then navigate to the questions screen
                  if (resp) {
                    Navigator.of(context).pushReplacement(PageTransition(
                        child: QuizScreen(),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 500)));
                  } else {
                    setState(() {
                      loading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Something went wrong!"),
                    ));
                  }
                } else {
                  // If Quiz ID is incorrect then show a snackbar
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Quiz ID is invalid"),
                    backgroundColor: Colors.red,
                  ));
                }
                setState(() {
                  loading = false;
                });
              }
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(QColorScheme.blue4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text("Start Quiz",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    // fontWeight: FontWeight.w900,
                    color: QColorScheme.white,
                    letterSpacing: -1.0,
                  )),
            ),
          );
  }
}
