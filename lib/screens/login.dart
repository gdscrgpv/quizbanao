import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizbanao/providers/auth.dart';
import 'package:quizbanao/providers/quiz.dart';
import 'package:quizbanao/screens/questions.dart';
import 'package:quizbanao/utils/colors.dart';
import 'package:quizbanao/utils/text.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/auth";

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    TextEditingController _emailController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _quizIdController = TextEditingController();

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
        title: Text(QTextData.app_name,
            style: TextStyle(fontSize: 20, wordSpacing: 6)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // FlutterLogo(
              //   size: 120,
              // ),
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    const SizedBox(width: 0.0, height: 100.0),
                    const Text(
                      'Be',
                      style: TextStyle(fontSize: 43.0),
                    ),
                    const SizedBox(width: 20.0, height: 100.0),
                    DefaultTextStyle(
                      style: GoogleFonts.adventPro(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                        color: QColorScheme.yellow2,
                        letterSpacing: -1.0,
                      ),
                      child:
                          AnimatedTextKit(repeatForever: true, animatedTexts: [
                        RotateAnimatedText('AWESOME'),
                        RotateAnimatedText('OPTIMISTIC'),
                        RotateAnimatedText('DIFFERENT'),
                      ]
                              // onTap: () {
                              //   print("Tap Event");
                              // },
                              ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                },
                decoration: InputDecoration(
                    labelText: "Full name", border: OutlineInputBorder()),
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
                      labelText: "Quiz ID", border: OutlineInputBorder()),
                  keyboardType: TextInputType.number),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Authentication Logic
                  if (_formKey.currentState!.validate()) {
                    // Validate the quiz ID
                    bool response =
                        await Provider.of<QuizProvider>(context, listen: false)
                            .validateQuizId(_quizIdController.text);
                    log(response.toString());
                    if (response) {
                      // If Quiz ID correct then Create a new user entry
                      bool resp = await Provider.of<AuthProvider>(context,
                              listen: false)
                          .creteNewEntry(UserModel(
                              fullName: _nameController.text,
                              email: _emailController.text,
                              quizId: _quizIdController.text,
                              marks: 0,
                              timeTaken: 0.0));
                      log("User created");
                      // If user is created then navigate to the questions screen
                      if (resp) {
                        Navigator.of(context)
                            .pushReplacementNamed(QuizScreen.routeName);
                      } else {
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
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(QColorScheme.blue4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Start Quiz"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
