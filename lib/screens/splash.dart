import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quizbanao/screens/login.dart';
import 'package:quizbanao/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: LoginScreen(),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QColorScheme.blue4,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("QUIZ",
                style: GoogleFonts.lato(
                    fontSize: 50,
                    fontWeight: FontWeight.w600,
                    color: QColorScheme.white)),
            Text("बनाओ",
                style: GoogleFonts.monoton(
                    fontSize: 50,
                    fontWeight: FontWeight.w300,
                    color: QColorScheme.white)),
            // Text("An initiative by"),
          ],
        ),
      ),
    );
  }
}
