import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizbanao/providers/auth.dart';
import 'package:quizbanao/providers/quiz.dart';
import 'package:quizbanao/screens/login.dart';
import 'package:quizbanao/screens/questions.dart';
import 'package:quizbanao/screens/results.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          QuizScreen.routeName: (context) => QuizScreen(),
          ResultScreen.routeName: (context) => ResultScreen(),
        },
      ),
    );
  }
}
